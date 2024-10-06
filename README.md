# opencl-test-sm

## 简介

多种算法移植到opencl，包含国密sm234、后量子kyber/dilithium、标准ecc-256k1等算法。

测试使用nvidia-teslaP4显卡，如非nvidia显卡可能代码需要适配。

性能如下图，如果您有任何建议，请发送电子邮件至 mr.linux@foxmail.com

## 测试

compile:
cargo build 或 cargo build --release

run：

cargo run + args或 cargo run --release + args

前者为debug模式运行，可打印样本数据运算结果；后者release模式运行仅会打印性能结果。

- ### kyber512算法移植自kyber3.0，密钥对计算100万次/秒

![](https://github.com/mrcuck/opencl-test-sm/blob/main/kyber.png)

- ### dilithium算法移植自dilithium3.1，密钥对计算25万次/秒

![](https://github.com/mrcuck/opencl-test-sm/blob/main/dilithium.png)

- ### sm2算法移植自openssl，密钥对计算21万次/秒

![](https://github.com/mrcuck/opencl-test-sm/blob/main/sm2-256v1.png)

- ### sm3算法 40G/秒

![](https://github.com/mrcuck/opencl-test-sm/blob/main/sm3.png)

- ### sm4算法 40G/秒

![](https://github.com/mrcuck/opencl-test-sm/blob/main/sm4.png)

- ### ecc算法提取自hashcat，特定的SECP256K1曲线高效实现，密钥对计算80万次/秒

![](https://github.com/mrcuck/opencl-test-sm/blob/main/ecc-256k1.png)



## thank to:

 * - secp256k1 by Pieter Wuille (https://github.com/bitcoin-core/secp256k1/, MIT)
 * - secp256k1-cl by hhanh00 (https://github.com/hhanh00/secp256k1-cl/, MIT)
 * - ec_pure_c by masterzorag (https://github.com/masterzorag/ec_pure_c/)
 * - ecc-gmp by leivaburto (https://github.com/leivaburto/ecc-gmp)
 * - micro-ecc by Ken MacKay (https://github.com/kmackay/micro-ecc/, BSD)
 * - curve_example by willem (https://gist.github.com/nlitsme/c9031c7b9bf6bb009e5a)
 * - py_ecc by Vitalik Buterin (https://github.com/ethereum/py_ecc/, MIT)
