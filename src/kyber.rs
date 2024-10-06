use crate::opencl;

pub fn kyber(args: &[&str]) {
    let combined = args.join(" ");
    println!(">>> kyber kepair {}", combined);

    let kernel_source = std::fs::read_to_string("./src/kyber_kernel.cl").unwrap();
    let b: [u32; 8] = [0, 0, 0, 0, 0, 0, 0, 0]; //as random later
    let size_in_u32 = 8 * 4096 * 10;

    // 尾部数据初始化
    let mut bb: Vec<u32> = Vec::with_capacity(size_in_u32);
    bb.extend(vec![0; size_in_u32 - b.len()]);
    bb.extend(&b);

    let mut cc: Vec<u32> = vec![0; size_in_u32 * 76]; //kyber-512 keylen 2432/4 (size_in_u32÷8×608) eg: size_in_u32=8
    let mut opencl_wrapper = opencl::OpenCLWrapper::new(0, 0, &kernel_source, "compute")
        .unwrap_or_else(|err| opencl::handle_opencl_error(err));

    let sizes = vec![size_in_u32, size_in_u32 * 76];
    let flags = vec![
        opencl3::memory::CL_MEM_READ_WRITE,
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
    opencl::print_first_and_last_n(&cc, 608);
    println!("cc.len(): {}", cc.len());
    opencl::print_throughput_stats(10 * size_in_u32 * 76, total_data_op, total_duration);
    match opencl::write_to_binary_file(&cc) {
        Ok(()) => println!("文件写入成功"),
        Err(e) => println!("文件写入失败: {:?}", e),
    }
}

pub fn kyber_enc(args: &[&str]) {
    let combined = args.join(" ");
    println!(">>> kyber_enc {}", combined);

    let keydata = match opencl::read_from_binary_file() {
        Ok(data) => data,
        Err(e) => {
            eprintln!("Error reading from file: {}", e);
            return;
        }
    };

    let mut ingroup: Vec<u32> = Vec::with_capacity(400);
    ingroup.extend(vec![0; 200]);
    ingroup.extend(&keydata[..200]); //public key
    for (i, val) in ingroup.iter().enumerate() {
        println!("ingroup[{}] = 0x{:08X}", i, val);
    }

    let size_in_u32 = 400 * 4096 * 10;
    let kernel_source = std::fs::read_to_string("./src/kyber.cl").unwrap();
    let mut bb: Vec<u32> = ingroup.iter().copied().cycle().take(size_in_u32).collect();
    let mut cc: Vec<u32> = vec![0; size_in_u32 / 50]; //ksize_in_u32 / 400 * 8

    let mut opencl_wrapper = opencl::OpenCLWrapper::new(0, 0, &kernel_source, "compute_enc")
        .unwrap_or_else(|err| opencl::handle_opencl_error(err));

    let sizes = vec![size_in_u32, size_in_u32 / 50];
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
        400,
        256, //arm is 8, cuda 256
    );
    opencl::print_throughput_stats(total_data_processed, total_data_op, total_duration);
    opencl::print_first_and_last_n(&cc, 8);
}

pub fn kyber_dec(args: &[&str]) {
    let combined = args.join(" ");
    println!(">>> kyber_dec {}", combined);

    let keydata = match opencl::read_from_binary_file() {
        Ok(data) => data,
        Err(e) => {
            eprintln!("Error reading from file: {}", e);
            return;
        }
    };

    let mut ingroup: Vec<u32> = Vec::with_capacity(608);
    ingroup.extend(vec![0; 200]);
    ingroup.extend(&keydata[200..]); //secret key
    for (i, val) in ingroup.iter().enumerate() {
        println!("ingroup[{}] = 0x{:08X}", i, val);
    }
    let size_in_u32 = 608 * 4096 * 10;
    let kernel_source = std::fs::read_to_string("./src/kyber.cl").unwrap();
    let mut bb: Vec<u32> = ingroup.iter().copied().cycle().take(size_in_u32).collect();
    let mut cc: Vec<u32> = vec![0; size_in_u32 / 76]; //ksize_in_u32 / 608 * 8

    let mut opencl_wrapper = opencl::OpenCLWrapper::new(0, 0, &kernel_source, "compute_dec")
        .unwrap_or_else(|err| opencl::handle_opencl_error(err));

    let sizes = vec![size_in_u32, size_in_u32 / 76];
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
        608,
        256, //arm is 8, cuda 256
    );
    opencl::print_throughput_stats(total_data_processed, total_data_op, total_duration);
    opencl::print_first_and_last_n(&cc, 8);
}
