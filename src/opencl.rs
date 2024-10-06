use opencl3::command_queue::CommandQueue;
use opencl3::context::Context;
use opencl3::device::Device;
use opencl3::kernel::ExecuteKernel;
use opencl3::kernel::Kernel;
use opencl3::memory::Buffer;
use opencl3::program::Program;
use opencl3::types::{cl_command_queue_properties, cl_uint};

use std::fs::File;
use std::io::{self, Read, Write};

#[allow(dead_code)]
pub fn read_from_binary_file() -> io::Result<Vec<u32>> {
    let mut file = File::open("kyber512key.bin")?;
    let mut buffer = vec![0u8; 608 * 4]; // 每个 `u32` 占 4 个字节
    file.read_exact(&mut buffer)?;

    let mut cc = Vec::new();
    for chunk in buffer.chunks_exact(4) {
        let val = u32::from_le_bytes([chunk[0], chunk[1], chunk[2], chunk[3]]);
        cc.push(val);
    }

    Ok(cc)
}

#[allow(dead_code)]
pub fn write_to_binary_file(cc: &[u32]) -> io::Result<()> {
    let mut file = File::create("kyber512key.bin")?;
    for val in cc.iter().take(608) {
        file.write_all(&val.to_le_bytes())?; // 以小端序写入
    }
    Ok(())
}

pub struct BufferWithFlags {
    buffer: Buffer<cl_uint>,
    flag: u64,
}

pub struct OpenCLWrapper {
    context: Context,
    command_queue: CommandQueue,
    kernel: Kernel,
}

impl OpenCLWrapper {
    pub fn new(
        platform_index: usize,
        device_index: usize,
        kernel_source: &str,
        kernel_name: &str, // 新增的参数，指定内核名称
    ) -> Result<Self, String> {
        // Get platforms
        let platforms =
            opencl3::platform::get_platforms().map_err(|_| "Failed to get platforms.")?;
        let platform = platforms
            .get(platform_index)
            .ok_or("Invalid platform index")?;
        println!("Using platform: {}", platform.name().unwrap());

        // Get devices
        let devices = platform
            .get_devices(opencl3::device::CL_DEVICE_TYPE_ALL)
            .map_err(|_| "Failed to get devices.")?;
        let device = Device::new(devices[device_index]);
        println!("Using device: {}", device.name().unwrap());

        // Create context
        let context = Context::from_device(&device).map_err(|_| "Failed to create context.")?;

        // Create program
        let mut program = Program::create_from_source(&context, kernel_source)
            .map_err(|_| "Failed to create program.")?;

        let build_time = std::time::Instant::now();
        if let Err(_) = program.build(&devices, "") {
            let build_log = program
                .get_build_log(device.id())
                .unwrap_or_else(|_| "Failed to retrieve build log.".to_string());

            // println!("{}", build_log);
            return Err(format!(
                "Failed to build program. Build log:\n{}",
                build_log
            ));
        }
        let duration = build_time.elapsed();
        println!("Building executed in: {:?}", duration);

        // Create kernel
        let kernel =
            Kernel::create(&program, kernel_name).map_err(|_| "Failed to create kernel.")?;

        let properties: cl_command_queue_properties =
            opencl3::command_queue::CL_QUEUE_PROFILING_ENABLE as u64;
        let command_queue =
            CommandQueue::create_with_properties(&context, device.id(), properties, 0)
                .map_err(|_| "Unable to create command queue")?;

        Ok(Self {
            context,
            command_queue,
            kernel,
        })
    }

    pub fn initialize_buffers(
        &self,
        sizes: &[usize],
        flags: &[u64],
    ) -> Result<Vec<BufferWithFlags>, String> {
        if sizes.len() != flags.len() {
            return Err("Sizes and flags lengths must be equal.".to_string());
        }

        let mut buffers = Vec::with_capacity(sizes.len());

        for (i, &size) in sizes.iter().enumerate() {
            let buffer =
                Buffer::<cl_uint>::create(&self.context, flags[i], size, std::ptr::null_mut())
                    .map_err(|_| format!("Failed to create buffer {}.", i))?;
            buffers.push(BufferWithFlags {
                buffer,
                flag: flags[i],
            });
        }

        Ok(buffers)
    }

    // Run kernel with a variable number of arguments
    fn run(
        &mut self,
        buffers: &mut [BufferWithFlags],
        buffer_user: &mut [&mut [u32]],
        global_size: usize,
        local_size: usize,
    ) -> Result<u128, String> {
        let kernel_event;

        // Record start time
        let start_time = std::time::Instant::now();

        let buffer_count = buffers.len();

        // Write data to buffers
        for (i, buffer_with_flags) in buffers.iter_mut().take(buffer_count).enumerate() {
            // Check the flags for the buffer
            if buffer_with_flags.flag == opencl3::memory::CL_MEM_READ_WRITE
                || buffer_with_flags.flag == opencl3::memory::CL_MEM_READ_ONLY
            {
                self.command_queue
                    .enqueue_write_buffer(
                        &mut buffer_with_flags.buffer, // Access the mutable reference here
                        opencl3::types::CL_TRUE,
                        0,
                        buffer_user[i],
                        &[],
                    )
                    .map_err(|_| format!("Failed to write buffer {}.", i))?;
            } else {
                /*
                #[cfg(debug_assertions)] // This will only compile in debug mode
                println!(
                    "Skipping write buffer {} due to flag: {:?}",
                    i, buffer_with_flags.flag
                );
                */
            }
        }

        let mut kernel_execution = ExecuteKernel::new(&self.kernel);

        for buffer_with_flags in buffers.iter() {
            kernel_execution.set_arg(&buffer_with_flags.buffer);
        }

        kernel_event = kernel_execution
            .set_global_work_size(global_size)
            .set_local_work_size(local_size)
            .set_global_work_offset(0)
            .enqueue_nd_range(&self.command_queue)
            .map_err(|_| "Failed to enqueue kernel execution.")?;

        kernel_event.wait()?;
        for (i, buffer_with_flags) in buffers.iter_mut().take(buffer_count).enumerate() {
            if buffer_with_flags.flag == opencl3::memory::CL_MEM_READ_WRITE
                || buffer_with_flags.flag == opencl3::memory::CL_MEM_WRITE_ONLY
            {
                // println!("read buffer {} flag: {:?}", i, buffer_with_flags.flag);
                self.command_queue
                    .enqueue_read_buffer(
                        &mut buffer_with_flags.buffer, // Use buffer from BufferWithFlags
                        opencl3::types::CL_TRUE,
                        0,
                        buffer_user[i],
                        &[kernel_event.get()],
                    )
                    .map_err(|_| format!("Failed to write buffer {}.", i))?;
            } else {
                /*
                #[cfg(debug_assertions)]
                println!(
                    "Skipping read buffer {} due to flag: {:?}",
                    i, buffer_with_flags.flag
                );
                */
            }
        }
        let duration = start_time.elapsed();
        Ok(duration.as_micros()) // 返回持续时间（以微秒为单位）
    }
}

/// 计算并打印吞吐量和其他统计信息
pub fn print_throughput_stats(
    total_data_processed: usize,
    total_data_op: usize,
    total_duration: u128,
) {
    // 计算总数据量的比特数
    let total_bits: u64 = total_data_processed as u64 * 32; // 每个 u32 占用 32 比特

    // 将总时间转换为秒
    let total_time_seconds = total_duration as f64 / 1000000.0;

    // 计算每秒的比特传输速率 (bit/s) 并转换为 (Gb/s)
    let throughput_bps = total_bits as f64 / total_time_seconds;
    let throughput_gbps = throughput_bps / 1_073_741_824.0;
    let throughput_hz = total_data_op as f64 / total_time_seconds;

    // 打印总流量和每秒传输速率
    println!("Total execution time: {} us", total_duration);
    println!(
        "Total data processed: {} bytes ({} bits)",
        total_data_processed * 4,
        total_bits
    );
    println!(
        "Throughput: {:.3} Gb/s {:.0} ops",
        throughput_gbps, throughput_hz
    );
}

#[allow(dead_code)]
pub fn print_first_and_last_n(cc: &[u32], n: usize) {
    let len = cc.len();

    // 打印前 n 个数
    for (i, val) in cc.iter().take(n).enumerate() {
        println!("cc[{}] = 0x{:08X}", i, val);
    }

    // 打印最后 n 个数
    if len >= n {
        for (i, val) in cc.iter().skip(len - n).enumerate() {
            println!("cc[{}] = 0x{:08X}", i + len - n, val);
        }
    } else {
        println!("cc 长度不足以打印最后 {} 个数", n);
    }
}

pub fn test_opencl_kernel(
    opencl_wrapper: &mut OpenCLWrapper,
    buffers: &mut [BufferWithFlags],
    buffer_user: &mut [&mut [u32]],
    size_in_u32: usize,
    size_group: usize,
    size_local: usize,
) -> (u128, usize, usize) {
    // Preheat operation
    opencl_wrapper
        .run(buffers, buffer_user, size_group, 1)
        .expect("Failed to run kernel");

    let mut total_duration: u128 = 0;
    let mut total_data_processed: usize = 0;
    let mut total_data_op: usize = 0;

    for i in 0..10 {
        match opencl_wrapper.run(buffers, buffer_user, size_in_u32 / size_group, size_local) {
            Ok(duration) => {
                println!(
                    "Iteration {}: Kernel execution time: {} us",
                    i + 1,
                    duration
                );
                total_duration += duration;
                total_data_processed += size_in_u32;
                total_data_op += size_in_u32 / size_group;
            }
            Err(e) => eprintln!("Failed to run kernel: {}", e),
        }
    }

    (total_duration, total_data_processed, total_data_op)
}

#[allow(dead_code)]
pub fn handle_opencl_error(err: String) -> OpenCLWrapper {
    println!("Failed to initialize OpenCL wrapper:\n{}", err);
    std::process::exit(1);
}
