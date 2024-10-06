use crate::opencl;

pub fn sm4(args: &[&str]) {
    let combined = args.join(" ");
    println!(">>> sm4 {}", combined);
    let kernel_source = std::fs::read_to_string("./src/sm4_kernel.cl").unwrap();
    let mut a: [u32; 32] = [
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

    let mut opencl_wrapper = opencl::OpenCLWrapper::new(0, 0, &kernel_source, "compute")
        .expect("Failed to initialize OpenCL wrapper");

    let sizes = vec![32, size_in_u32, size_in_u32];
    let flags = vec![
        opencl3::memory::CL_MEM_READ_ONLY,
        opencl3::memory::CL_MEM_READ_ONLY,
        opencl3::memory::CL_MEM_WRITE_ONLY,
    ];

    let mut buffers: Vec<opencl::BufferWithFlags> = opencl_wrapper
        .initialize_buffers(&sizes, &flags)
        .expect("Failed to initialize buffers.");

    let (total_duration, total_data_processed, total_data_op) = opencl::test_opencl_kernel(
        &mut opencl_wrapper,
        &mut buffers,
        &mut [&mut a, &mut bb, &mut cc],
        size_in_u32,
        4,
        128, //android is 8, arm 128, cuda 256
    );

    opencl::print_throughput_stats(total_data_processed, total_data_op, total_duration);
    #[cfg(debug_assertions)] // This will only compile in debug mode
    opencl::print_first_and_last_n(&cc, 8);
}
