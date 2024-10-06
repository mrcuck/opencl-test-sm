/**
 * License.....: MIT
 */
use std::collections::HashMap;
use std::env;
mod dilithium;
mod ecc;
mod kyber;
mod opencl;
mod sm2;
mod sm3;
mod sm4;
mod vadd;

fn test(args: &[&str]) {
    let combined = args.join(" ");
    let count = args.len();
    println!("test function called with {} args. {}", count, combined);
    for (i, arg) in args.iter().enumerate() {
        println!("Argument {}: {}", i + 1, arg);
    }
}

fn main() {
    let mut functions: HashMap<&str, fn(&[&str])> = HashMap::new();
    functions.insert("test", test);
    functions.insert("vadd", vadd::vadd);
    functions.insert("ecc", ecc::ecc);
    functions.insert("sm3", sm3::sm3);
    functions.insert("sm4", sm4::sm4);
    functions.insert("kyber", kyber::kyber);
    functions.insert("kyber_enc", kyber::kyber_enc);
    functions.insert("kyber_dec", kyber::kyber_dec);
    functions.insert("dilithium", dilithium::keypair);
    functions.insert("sm2", sm2::keypair);

    let args: Vec<String> = env::args().collect();

    if args.len() < 2 {
        println!("Usage: {} <function_name> <args...>", args[0]);
        return;
    }

    let function_name = &args[1];
    let function_args = &args[2..].iter().map(|s| s.as_str()).collect::<Vec<&str>>();

    if let Some(&func) = functions.get(function_name.as_str()) {
        func(function_args);
    } else {
        println!("Function '{}' not found.", function_name);
    }
}
