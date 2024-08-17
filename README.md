# opencl-test-sm

compile:
cargo build

run test: ecc/sm3/sm4

target/debug/rust_cl 2
target/debug/rust_cl 3
target/debug/rust_cl 4

thank to:
 * - secp256k1 by Pieter Wuille (https://github.com/bitcoin-core/secp256k1/, MIT)
 * - secp256k1-cl by hhanh00 (https://github.com/hhanh00/secp256k1-cl/, MIT)
 * - ec_pure_c by masterzorag (https://github.com/masterzorag/ec_pure_c/)
 * - ecc-gmp by leivaburto (https://github.com/leivaburto/ecc-gmp)
 * - micro-ecc by Ken MacKay (https://github.com/kmackay/micro-ecc/, BSD)
 * - curve_example by willem (https://gist.github.com/nlitsme/c9031c7b9bf6bb009e5a)
 * - py_ecc by Vitalik Buterin (https://github.com/ethereum/py_ecc/, MIT)

---------------------------------------------------------------

opencl 算法测试通用小程序：

支持算法任意参数个数，方便算法工程师专注于测试算法性能、或评估gpu平台性能。

当前示例为ecc、sm3、sm4核心算子性能，sm3/sm4 40G+，ecc 85万次+，详见内附测试截图。

