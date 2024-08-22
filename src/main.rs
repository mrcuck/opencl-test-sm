/**
 * License.....: MIT
 */
use opencl3::command_queue::CommandQueue;
use opencl3::context::Context;
use opencl3::device::Device;
use opencl3::kernel::ExecuteKernel;
use opencl3::kernel::Kernel;
use opencl3::memory::Buffer;
use opencl3::program::Program;
use opencl3::types::{cl_command_queue_properties, cl_uint};

struct OpenCLWrapper {
    context: Context,
    command_queue: CommandQueue,
    kernel: Kernel,
}

impl OpenCLWrapper {
    fn new(
        platform_index: usize,
        device_index: usize,
        kernel_source: &str,
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

        // Build program
        program
            .build(&devices, "")
            .map_err(|_| "Failed to build program.")?;

        // Create kernel
        let kernel = Kernel::create(&program, "compute").map_err(|_| "Failed to create kernel.")?;

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

    fn initialize_buffers(
        &self,
        sizes: &[usize],
        flags: &[u64],
    ) -> Result<Vec<Buffer<cl_uint>>, String> {
        if sizes.len() != flags.len() {
            return Err("Sizes and flags lengths must be equal.".to_string());
        }

        let mut buffers = Vec::with_capacity(sizes.len());

        for (i, &size) in sizes.iter().enumerate() {
            let buffer =
                Buffer::<cl_uint>::create(&self.context, flags[i], size, std::ptr::null_mut())
                    .map_err(|_| format!("Failed to create buffer {}.", i))?;
            buffers.push(buffer);
        }

        Ok(buffers)
    }

    // Run kernel with a variable number of arguments
    fn run(
        &mut self,
        buffers: &mut [Buffer<cl_uint>],
        buffer_data: &[&[u32]],
        output: &mut [u32],
        global_size: usize,
        local_size: usize,
    ) -> Result<u128, String> {
        let kernel_event;

        // Record start time
        let start_time = std::time::Instant::now();

        // 计算要处理的缓冲区数量（不包括最后一个）
        let buffer_count = buffers.len() - 1;

        // 将数据写入缓冲区，最后一个除外
        for (i, buffer) in buffers.iter_mut().take(buffer_count).enumerate() {
            self.command_queue
                .enqueue_write_buffer(buffer, opencl3::types::CL_TRUE, 0, buffer_data[i], &[])
                .map_err(|_| format!("Failed to write buffer {}.", i))?;
        }
        // Create command queue
        let mut kernel_execution = ExecuteKernel::new(&self.kernel);

        // 将每个缓冲区作为内核参数
        for buffer in buffers.iter() {
            kernel_execution.set_arg(buffer);
        }

        kernel_event = kernel_execution
            .set_global_work_size(global_size) // 假设所有缓冲区的长度相同
            .set_local_work_size(local_size)
            .set_global_work_offset(0)
            .enqueue_nd_range(&self.command_queue)
            .map_err(|_| "Failed to enqueue kernel execution.")?;

        // 读取输出缓冲区
        self.command_queue
            .enqueue_read_buffer(
                &buffers.last().unwrap(), // 假设最后一个缓冲区是输出缓冲区
                opencl3::types::CL_TRUE,
                0,
                output,
                &[kernel_event.get()],
            )
            .map_err(|_| "Failed to read output buffer.")?;

        // Record end time
        let duration = start_time.elapsed();
        // println!("Kernel execution time: {:?}", duration);
        Ok(duration.as_micros()) // 返回持续时间（以微秒为单位）
    }
}

/// 计算并打印吞吐量和其他统计信息
fn print_throughput_stats(total_data_processed: usize, total_data_op: usize, total_duration: u128) {
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
fn print_first_and_last_8(cc: &[u32]) {
    // 打印前 8 个数
    for (i, val) in cc.iter().take(8).enumerate() {
        println!("cc[{}] = 0x{:08X}", i, val);
    }

    // 打印最后 8 个数
    for (i, val) in cc.iter().skip(cc.len() - 8).enumerate() {
        println!("cc[{}] = 0x{:08X}", i + cc.len() - 8, val);
    }
}

fn test_opencl_kernel(
    opencl_wrapper: &mut OpenCLWrapper,
    buffers: &mut [Buffer<cl_uint>],
    buffer_data: &[&[u32]],
    size_in_u32: usize,
    size_group: usize,
    size_local: usize,
    cc: &mut [u32],
) -> (u128, usize, usize) {
    // 预热操作
    opencl_wrapper
        .run(
            buffers,
            buffer_data,
            cc,
            size_in_u32 / size_group,
            size_local,
        )
        .expect("Failed to run kernel");

    let mut total_duration: u128 = 0; // 累积时间变量
    let mut total_data_processed: usize = 0; // 累积处理的数据量
    let mut total_data_op: usize = 0; // 累积处理的次数

    for i in 0..10 {
        // 执行 run 方法并获取执行时间
        match opencl_wrapper.run(
            buffers,
            buffer_data,
            cc,
            size_in_u32 / size_group,
            size_local,
        ) {
            Ok(duration) => {
                println!(
                    "Iteration {}: Kernel execution time: {} us",
                    i + 1,
                    duration
                );
                total_duration += duration; // 累积时间
                total_data_processed += size_in_u32; // 累积流量
                total_data_op += size_in_u32 / size_group; // 累积次数
            }
            Err(e) => eprintln!("Failed to run kernel: {}", e),
        }
    }

    (total_duration, total_data_processed, total_data_op)
}

use std::env;
fn main() {
    let args: Vec<String> = env::args().collect();
    let arg: u32;

    if args.len() < 2 {
        eprintln!("Usage: {} SM <NUM>", args[0]);
        arg = 0;
    } else {
        arg = args[1].parse().expect("Invalid number for arg");
    }

    match arg {
        0 => {
            println!("vadd...");
            let kernel_source = std::fs::read_to_string("./src/vadd.cl").unwrap();
            let a: [u32; 16] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
            let b: [u32; 16] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
            let mut c: [u32; 16] = [0; 16];
            let size_in_u32 = 16;
            let mut opencl_wrapper = OpenCLWrapper::new(0, 0, &kernel_source)
                .expect("Failed to initialize OpenCL wrapper");

            // 定义缓冲区的大小和标志
            let sizes = vec![size_in_u32, size_in_u32, size_in_u32];
            let flags = vec![
                opencl3::memory::CL_MEM_READ_ONLY,
                opencl3::memory::CL_MEM_READ_ONLY,
                opencl3::memory::CL_MEM_WRITE_ONLY,
            ];

            // 初始化缓冲区
            let mut buffers: Vec<Buffer<cl_uint>> = opencl_wrapper
                .initialize_buffers(&sizes, &flags)
                .expect("Failed to initialize buffers.");

            // 调用测试函数
            let (total_duration, total_data_processed, total_data_op) = test_opencl_kernel(
                &mut opencl_wrapper,
                &mut buffers,
                &[&a, &b],
                size_in_u32,
                1,
                16,
                &mut c,
            );

            print_throughput_stats(total_data_processed, total_data_op, total_duration);
            // print_first_and_last_8(&c);
        }
        2 => {
            println!("ECC test");
            let kernel_source = std::fs::read_to_string("./src/ecc-kernel.cl").unwrap();
            let b: [u32; 8] = [
                0xb61cf540, 0x381e846e, 0x24830dd7, 0xea8195ec, 0xa6cd2f37, 0xcb1378a1, 0xf84d059d,
                0x2d5dc2a3,
            ];
            let size_in_u32 = 1024 * 1024; // sm2_kernel.cl - 1024 * 4 right but super slow

            let bb: Vec<u32> = b.iter().copied().cycle().take(size_in_u32).collect();
            let mut cc: Vec<u32> = vec![0; size_in_u32 * 2];
            let mut opencl_wrapper = OpenCLWrapper::new(0, 0, &kernel_source)
                .expect("Failed to initialize OpenCL wrapper");

            // 定义缓冲区的大小和标志
            let sizes = vec![size_in_u32, size_in_u32 * 2];
            let flags = vec![
                opencl3::memory::CL_MEM_READ_ONLY,
                opencl3::memory::CL_MEM_WRITE_ONLY,
            ];
            // 初始化缓冲区
            let mut buffers: Vec<Buffer<cl_uint>> = opencl_wrapper
                .initialize_buffers(&sizes, &flags)
                .expect("Failed to initialize buffers.");
            // 调用测试函数
            let (total_duration, total_data_processed, total_data_op) = test_opencl_kernel(
                &mut opencl_wrapper,
                &mut buffers,
                &[&bb],
                size_in_u32,
                8,
                128, //android is 8, arm 128, cuda 256(IS_NV)
                &mut cc,
            );
            print_throughput_stats(total_data_processed, total_data_op, total_duration);
            print_first_and_last_8(&cc);
        }
        3 => {
            println!("SM {} test", arg);
            let kernel_source = std::fs::read_to_string("./src/sm3_kernel.cl").unwrap();
            let b: [u32; 16] = [0x61626380, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x18];
            let size_in_u32 = 1024 * 1024 * 32;

            // 尾部数据初始化
            let mut bb: Vec<u32> = Vec::with_capacity(size_in_u32);
            bb.extend(vec![0; size_in_u32 - b.len()]);
            bb.extend(&b);

            let mut cc: Vec<u32> = vec![0; size_in_u32 / 2];
            let mut opencl_wrapper = OpenCLWrapper::new(0, 0, &kernel_source)
                .expect("Failed to initialize OpenCL wrapper");

            // 定义缓冲区的大小和标志
            let sizes = vec![size_in_u32, size_in_u32 / 2];
            let flags = vec![
                opencl3::memory::CL_MEM_READ_ONLY,
                opencl3::memory::CL_MEM_WRITE_ONLY,
            ];
            // 初始化缓冲区
            let mut buffers: Vec<Buffer<cl_uint>> = opencl_wrapper
                .initialize_buffers(&sizes, &flags)
                .expect("Failed to initialize buffers.");
            // 调用测试函数
            let (total_duration, total_data_processed, total_data_op) = test_opencl_kernel(
                &mut opencl_wrapper,
                &mut buffers,
                &[&bb],
                size_in_u32,
                16,
                128, //android is 8, arm 128, cuda 256
                &mut cc,
            );
            print_throughput_stats(total_data_processed, total_data_op, total_duration);
            print_first_and_last_8(&cc);
        }
        4 => {
            println!("SM {} test", arg);
            let kernel_source = std::fs::read_to_string("./src/sm4_kernel.cl").unwrap();
            let a: [u32; 32] = [
                0xf12186f9, 0x41662b61, 0x5a6ab19a, 0x7ba92077, 0x367360f4, 0x776a0c61, 0xb6bb89b3,
                0x24763151, 0xa520307c, 0xb7584dbd, 0xc30753ed, 0x7ee55b57, 0x6988608c, 0x30d895b7,
                0x44ba14af, 0x104495a1, 0xd120b428, 0x73b55fa3, 0xcc874966, 0x92244439, 0xe89e641f,
                0x98ca015a, 0xc7159060, 0x99e1fd2e, 0xb79bd80c, 0x1d2115b0, 0x0e228aeb, 0xf1780c81,
                0x428d3654, 0x62293496, 0x01cf72e5, 0x9124a012,
            ];
            let size_in_u32 = 1024 * 1024 * 16;
            let b: [u32; 4] = [0x01234567, 0x89abcdef, 0xfedcba98, 0x76543210];

            // 尾部数据初始化
            let mut bb: Vec<u32> = Vec::with_capacity(size_in_u32);
            bb.extend(vec![0; size_in_u32 - b.len()]);
            bb.extend(&b);

            let mut cc: Vec<u32> = vec![0; size_in_u32];

            let mut opencl_wrapper = OpenCLWrapper::new(0, 0, &kernel_source)
                .expect("Failed to initialize OpenCL wrapper");

            // 定义缓冲区的大小和标志
            let sizes = vec![32, size_in_u32, size_in_u32];
            let flags = vec![
                opencl3::memory::CL_MEM_READ_ONLY,
                opencl3::memory::CL_MEM_READ_ONLY,
                opencl3::memory::CL_MEM_WRITE_ONLY,
            ];

            // 初始化缓冲区
            let mut buffers: Vec<Buffer<cl_uint>> = opencl_wrapper
                .initialize_buffers(&sizes, &flags)
                .expect("Failed to initialize buffers.");

            // 调用测试函数
            let (total_duration, total_data_processed, total_data_op) = test_opencl_kernel(
                &mut opencl_wrapper,
                &mut buffers,
                &[&a, &bb],
                size_in_u32,
                4,
                128, //android is 8, arm 128, cuda 256
                &mut cc,
            );

            print_throughput_stats(total_data_processed, total_data_op, total_duration);
            print_first_and_last_8(&cc);
        }
        512 => {
            println!("kyber {} test", arg);
            let kernel_source = std::fs::read_to_string("./src/kyber.cl").unwrap();
            let b: [u32; 8] = [0, 0, 0, 0, 0, 0, 0, 0]; //as random later
            let size_in_u32 = 8 * 4096 * 10;

            // 尾部数据初始化
            let mut bb: Vec<u32> = Vec::with_capacity(size_in_u32);
            bb.extend(vec![0; size_in_u32 - b.len()]);
            bb.extend(&b);

            let mut cc: Vec<u32> = vec![0; size_in_u32 * 76]; //kyber-512 keylen 2432/4
            let mut opencl_wrapper = OpenCLWrapper::new(0, 0, &kernel_source)
                .expect("Failed to initialize OpenCL wrapper");

            // 定义缓冲区的大小和标志
            let sizes = vec![size_in_u32, size_in_u32 * 76];
            let flags = vec![
                opencl3::memory::CL_MEM_READ_ONLY,
                opencl3::memory::CL_MEM_WRITE_ONLY,
            ];
            // 初始化缓冲区
            let mut buffers: Vec<Buffer<cl_uint>> = opencl_wrapper
                .initialize_buffers(&sizes, &flags)
                .expect("Failed to initialize buffers.");
            // 调用测试函数
            let (total_duration, _total_data_processed, total_data_op) = test_opencl_kernel(
                &mut opencl_wrapper,
                &mut buffers,
                &[&bb],
                size_in_u32,
                8,
                8, //arm is 8, cuda 256
                &mut cc,
            );
            print_throughput_stats(10 * size_in_u32 * 76, total_data_op, total_duration);
            /*
            for (i, val) in cc.iter().take(608).enumerate() {
                println!("cc[{}] = 0x{:08X}", i, val);
            }
            for (i, val) in cc.iter().skip(cc.len() - 608).enumerate() {
                println!("cc[{}] = 0x{:08X}", i + cc.len() - 608, val);
            }
            */
            println!("cc.len(): {}", cc.len());
        }
        _ => {
            println!("Invalid day...");
            std::process::exit(1);
        }
    }
}
