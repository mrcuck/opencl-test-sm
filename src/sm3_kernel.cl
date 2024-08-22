/**
 * License.....: MIT
 */

__constant unsigned int T[64] = {
    0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519,
    0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519,
    0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519,
    0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519,
    0x7A879D8A, 0x7A879D8A, 0x7A879D8A, 0x7A879D8A,
    0x7A879D8A, 0x7A879D8A, 0x7A879D8A, 0x7A879D8A,
    0x7A879D8A, 0x7A879D8A, 0x7A879D8A, 0x7A879D8A,
    0x7A879D8A, 0x7A879D8A, 0x7A879D8A, 0x7A879D8A,
    0x7A879D8A, 0x7A879D8A, 0x7A879D8A, 0x7A879D8A,
    0x7A879D8A, 0x7A879D8A, 0x7A879D8A, 0x7A879D8A,
    0x7A879D8A, 0x7A879D8A, 0x7A879D8A, 0x7A879D8A,
    0x7A879D8A, 0x7A879D8A, 0x7A879D8A, 0x7A879D8A,
    0x7A879D8A, 0x7A879D8A, 0x7A879D8A, 0x7A879D8A,
    0x7A879D8A, 0x7A879D8A, 0x7A879D8A, 0x7A879D8A,
    0x7A879D8A, 0x7A879D8A, 0x7A879D8A, 0x7A879D8A,
    0x7A879D8A, 0x7A879D8A, 0x7A879D8A, 0x7A879D8A
};

unsigned int rotate_left(unsigned int x, int n) {
    return (x << n) | (x >> (32 - n));
}

unsigned int P0(unsigned int x) {
    return x ^ rotate_left(x, 9) ^ rotate_left(x, 17);
}

unsigned int P1(unsigned int x) {
    return x ^ rotate_left(x, 15) ^ rotate_left(x, 23);
}

unsigned int FF(unsigned int x, unsigned int y, unsigned int z) {
    return (x ^ y ^ z);
}

unsigned int GG(unsigned int x, unsigned int y, unsigned int z) {
    return (x ^ y ^ z);
}

unsigned int FF16(unsigned int x, unsigned int y, unsigned int z) {
    return ((x & y) | (x & z) | (y & z));
}

unsigned int GG16(unsigned int x, unsigned int y, unsigned int z) {
    return ((x & y) | (~x & z));
}

__kernel void compute(__global const unsigned int* input, __global unsigned int* hash) {
    int gid = get_global_id(0);

    // 使用寄存器存储初始哈希值，减少内存访问
    unsigned int A = 0x7380166f, B = 0x4914b2b9, C = 0x172442d7, D = 0xda8a0600;
    unsigned int E = 0xa96f30bc, F = 0x163138aa, G = 0xe38dee4d, H = 0xb0fb0e4e;

    // W1 数组可以被省略，直接在使用的地方计算而不是预先计算并存储
    // 这样可以减少局部内存的使用，减轻内存压力
    unsigned int W[68];

    __global const unsigned int* currentInput = input + gid * 16;
    __global unsigned int* currentHash = hash + gid * 8;

    // 使用vload4加载数据，每次加载4个unsigned int
    for (int i = 0; i < 16; i += 4) {
        uint4 temp = vload4(0, &currentInput[i]); // 加载4个unsigned int
        W[i] = temp.s0;
        W[i + 1] = temp.s1;
        W[i + 2] = temp.s2;
        W[i + 3] = temp.s3;
    }

    for (int i = 16; i < 68; i++) {
        unsigned int temp = W[i - 16] ^ W[i - 9] ^ rotate_left(W[i - 3], 15);
        W[i] = P1(temp) ^ rotate_left(W[i - 13], 7) ^ W[i - 6];
    }

    // 减少FF,GG分支预测的开销，增加执行效率
    for (int j = 0; j < 16; j++) {
        unsigned int rotatedA12 = rotate_left(A, 12);
        unsigned int SS1 = rotate_left((rotatedA12 + E + rotate_left(T[j], j % 32)), 7);
        unsigned int SS2 = SS1 ^ rotatedA12;
        unsigned int TT1 = FF(A, B, C) + D + SS2 + (W[j] ^ W[j + 4]);
        unsigned int TT2 = GG(E, F, G) + H + SS1 + W[j];
        D = C;
        C = rotate_left(B, 9);
        B = A;
        A = TT1;
        H = G;
        G = rotate_left(F, 19);
        F = E;
        E = P0(TT2);
    }
    for (int j = 16; j < 64; j++) {
        unsigned int rotatedA12 = rotate_left(A, 12);
        unsigned int SS1 = rotate_left((rotatedA12 + E + rotate_left(T[j], j % 32)), 7);
        unsigned int SS2 = SS1 ^ rotatedA12;
        unsigned int TT1 = FF16(A, B, C) + D + SS2 + (W[j] ^ W[j + 4]);
        unsigned int TT2 = GG16(E, F, G) + H + SS1 + W[j];
        D = C;
        C = rotate_left(B, 9);
        B = A;
        A = TT1;
        H = G;
        G = rotate_left(F, 19);
        F = E;
        E = P0(TT2);
    }

    // 最后更新哈希值，减少内存访问
    currentHash[0] = A ^ 0x7380166f;
    currentHash[1] = B ^ 0x4914b2b9;
    currentHash[2] = C ^ 0x172442d7;
    currentHash[3] = D ^ 0xda8a0600;
    currentHash[4] = E ^ 0xa96f30bc;
    currentHash[5] = F ^ 0x163138aa;
    currentHash[6] = G ^ 0xe38dee4d;
    currentHash[7] = H ^ 0xb0fb0e4e;
}
