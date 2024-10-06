use crate::opencl;

pub fn keypair(args: &[&str]) {
    let combined = args.join(" ");
    println!(">>> dilithium keypair {}", combined);

    let kernel_source = std::fs::read_to_string("./src/dilithium_kernel.cl").unwrap();
    let b: [u32; 8] = [0, 0, 0, 0, 0, 0, 0, 0]; //as random seed later
    let size_in_u32 = 8 * 4096 * 10;

    // 尾部数据初始化
    let mut bb: Vec<u32> = Vec::with_capacity(size_in_u32);
    bb.extend(vec![0; size_in_u32 - b.len()]);
    bb.extend(&b);

    let mut cc: Vec<u32> = vec![0; size_in_u32 * 120]; //dilithium-2 3840(keylen)/32(seed) = 120
    let mut opencl_wrapper = opencl::OpenCLWrapper::new(0, 0, &kernel_source, "keypair")
        .unwrap_or_else(|err| opencl::handle_opencl_error(err));

    let sizes = vec![size_in_u32, size_in_u32 * 120];
    let flags = vec![
        opencl3::memory::CL_MEM_READ_ONLY,
        opencl3::memory::CL_MEM_WRITE_ONLY,
    ];
    let mut buffers: Vec<opencl::BufferWithFlags> = opencl_wrapper
        .initialize_buffers(&sizes, &flags)
        .expect("Failed to initialize buffers.");

    let (total_duration, _total_data_processed, total_data_op) = opencl::test_opencl_kernel(
        &mut opencl_wrapper,
        &mut buffers,
        &mut [&mut bb, &mut cc],
        size_in_u32,
        8,
        256, //arm is 8, cuda 256
    );
    #[cfg(debug_assertions)] // This will only compile in debug mode
    opencl::print_first_and_last_n(&cc, 960);
    println!("cc.len(): {}", cc.len());
    opencl::print_throughput_stats(10 * size_in_u32 * 120, total_data_op, total_duration);
}
