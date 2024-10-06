use crate::opencl;

pub fn sm3(args: &[&str]) {
    let combined = args.join(" ");
    println!(">>> sm3 {}", combined);
    let kernel_source = std::fs::read_to_string("./src/sm3_kernel.cl").unwrap();
    let b: [u32; 16] = [0x61626380, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x18];
    let size_in_u32 = 1024 * 1024 * 32;

    // 尾部数据初始化
    let mut bb: Vec<u32> = Vec::with_capacity(size_in_u32);
    bb.extend(vec![0; size_in_u32 - b.len()]);
    bb.extend(&b);

    let mut cc: Vec<u32> = vec![0; size_in_u32 / 2];
    let mut opencl_wrapper = opencl::OpenCLWrapper::new(0, 0, &kernel_source, "compute")
        .expect("Failed to initialize OpenCL wrapper");

    let sizes = vec![size_in_u32, size_in_u32 / 2];
    let flags = vec![
        opencl3::memory::CL_MEM_READ_ONLY,
        opencl3::memory::CL_MEM_WRITE_ONLY,
    ];
    let mut buffers: Vec<opencl::BufferWithFlags> = opencl_wrapper
        .initialize_buffers(&sizes, &flags)
        .expect("Failed to initialize buffers.");

    let (total_duration, total_data_processed, total_data_op) = opencl::test_opencl_kernel(
        &mut opencl_wrapper,
        &mut buffers,
        &mut [&mut bb, &mut cc],
        size_in_u32,
        16,
        256, //android is 8, arm 128, cuda 256
    );
    opencl::print_throughput_stats(total_data_processed, total_data_op, total_duration);
    #[cfg(debug_assertions)] // This will only compile in debug mode
    opencl::print_first_and_last_n(&cc, 8);
}
