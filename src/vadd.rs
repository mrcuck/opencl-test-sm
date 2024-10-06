use crate::opencl;

pub fn vadd(args: &[&str]) {
    let combined = args.join(" ");
    println!(">>> vadd {}", combined);

    let kernel_source = std::fs::read_to_string("./src/vadd.cl").unwrap();
    let mut a: [u32; 16] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
    let mut b: [u32; 16] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
    let mut c: [u32; 16] = [0; 16];
    let size_in_u32 = 16;
    let mut opencl_wrapper = opencl::OpenCLWrapper::new(0, 0, &kernel_source, "compute")
        .expect("Failed to initialize OpenCL wrapper");

    let sizes = vec![size_in_u32, size_in_u32, size_in_u32];
    let flags = vec![
        opencl3::memory::CL_MEM_READ_ONLY,
        opencl3::memory::CL_MEM_READ_ONLY,
        opencl3::memory::CL_MEM_WRITE_ONLY,
    ];

    // Initialize buffers
    let mut buffers: Vec<opencl::BufferWithFlags> = opencl_wrapper
        .initialize_buffers(&sizes, &flags)
        .expect("Failed to initialize buffers.");

    // Call test function
    let (total_duration, total_data_processed, total_data_op) = opencl::test_opencl_kernel(
        &mut opencl_wrapper,
        &mut buffers,
        &mut [&mut a, &mut b, &mut c],
        size_in_u32,
        1,
        16,
    );

    opencl::print_throughput_stats(total_data_processed, total_data_op, total_duration);
    #[cfg(debug_assertions)] // This will only compile in debug mode
    opencl::print_first_and_last_n(&c, 8);
}
