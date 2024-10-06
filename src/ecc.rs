use crate::opencl;

pub fn ecc(args: &[&str]) {
    let combined = args.join(" ");
    println!(">>> ecc SECP256K1 kepair {}", combined);

    let kernel_source = std::fs::read_to_string("./src/ecc-kernel.cl").unwrap();
    let b: [u32; 8] = [
        0xb61cf540, 0x381e846e, 0x24830dd7, 0xea8195ec, 0xa6cd2f37, 0xcb1378a1, 0xf84d059d,
        0x2d5dc2a3,
    ];
    let size_in_u32 = 1024 * 1024; // sm2_kernel.cl - 1024 * 4 right but super slow

    let mut bb: Vec<u32> = b.iter().copied().cycle().take(size_in_u32).collect();
    let mut cc: Vec<u32> = vec![0; size_in_u32 * 2];
    let mut opencl_wrapper = opencl::OpenCLWrapper::new(0, 0, &kernel_source, "compute")
        .expect("Failed to initialize OpenCL wrapper");

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
    opencl::print_first_and_last_n(&cc, 8);
}
