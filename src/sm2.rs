use crate::opencl;

pub fn keypair(args: &[&str]) {
    let combined = args.join(" ");
    println!(">>> sm2 keypair {}", combined);

    let kernel_source = std::fs::read_to_string("./src/sm2.cl").unwrap();
    let b: [u32; 8] = [
        0xa3c25d2d, 0x9d054df8, 0xa17813cb, 0x372fcda6, 0xec9581ea, 0xd70d8324, 0x6e841e38,
        0x40f51cb6,
    ];
    let size_in_u32 = 8 * 4096 * 10;
    let mut bb: Vec<u32> = b.iter().copied().cycle().take(size_in_u32).collect();
    let mut cc: Vec<u32> = vec![0; size_in_u32 * 2];
    let mut opencl_wrapper = opencl::OpenCLWrapper::new(0, 0, &kernel_source, "keypair")
        .unwrap_or_else(|err| opencl::handle_opencl_error(err));

    let sizes = vec![size_in_u32, size_in_u32 * 2];
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
        8,
        256, //android is 8, arm 128, cuda 256(IS_NV)
    );
    opencl::print_throughput_stats(total_data_processed, total_data_op, total_duration);
    #[cfg(debug_assertions)] // This will only compile in debug mode
    opencl::print_first_and_last_n(&cc, 16);
}
