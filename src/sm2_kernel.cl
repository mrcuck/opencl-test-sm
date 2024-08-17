/**
 * License.....: MIT
 */

typedef int wordcount_t;
typedef int cmpresult_t;
typedef unsigned int bitcount_t;
typedef unsigned int uECC_word_t; //uint32_t
typedef unsigned long uECC_dword_t; //uint64_t

#define HIGH_BIT_SET 0x80000000
#define uECC_MAX_WORDS 8
#define uECC_WORD_BITS_SHIFT 5
#define uECC_WORD_BITS_MASK 0x01F

/* Currently only support 256-bit SM2 */
#define uECC_WORD_BITS 32

typedef struct EccPoint
{
    uECC_word_t x[uECC_MAX_WORDS];
    uECC_word_t y[uECC_MAX_WORDS];
} EccPoint;

uECC_word_t curve_p[] = {0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFE};
uECC_word_t curve_n[] = {0x39D54123, 0x53BBF409, 0x21C6052B, 0x7203DF6B, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFE};
EccPoint curve_G = {
    {0x334C74C7, 0x715A4589, 0xF2660BE1, 0x8FE30BBF, 0x6A39C994, 0x5F990446, 0x1F198119, 0x32C4AE2C},
    {0x2139F0A0, 0x02DF32E5, 0xC62A4740, 0xD0A9877C, 0x6B692153, 0x59BDCEE3, 0xF4F6779C, 0xBC3736A2}
};

void uECC_vli_clear(uECC_word_t *vli, wordcount_t num_words) {
    wordcount_t i;
    for (i = 0; i < num_words; ++i) {
        vli[i] = 0;
    }
}

/* Constant-time comparison to zero - secure way to compare long integers */
/* Returns 1 if vli == 0, 0 otherwise. */
uECC_word_t uECC_vli_isZero(const uECC_word_t *vli, wordcount_t num_words) {
    uECC_word_t bits = 0;
    wordcount_t i;
    for (i = 0; i < num_words; ++i) {
        bits |= vli[i];
    }
    return (bits == 0);
}

/* Returns nonzero if bit 'bit' of vli is set. */
uECC_word_t uECC_vli_testBit(const uECC_word_t *vli, bitcount_t bit) {
    return (vli[bit >> uECC_WORD_BITS_SHIFT] & ((uECC_word_t)1 << (bit & uECC_WORD_BITS_MASK)));
}

/* Counts the number of words in vli. */
wordcount_t vli_numDigits(const uECC_word_t *vli, const wordcount_t max_words) {
    wordcount_t i;
    /* Search from the end until we find a non-zero digit.
       We do it in reverse because we expect that most digits will be nonzero. */
    for (i = max_words - 1; i >= 0 && vli[i] == 0; --i) {
    }

    return (i + 1);
}

/* Counts the number of bits required to represent vli. */
bitcount_t uECC_vli_numBits(const uECC_word_t *vli, const wordcount_t max_words) {
    uECC_word_t i;
    uECC_word_t digit;

    wordcount_t num_digits = vli_numDigits(vli, max_words);
    if (num_digits == 0) {
        return 0;
    }

    digit = vli[num_digits - 1];
    for (i = 0; digit; ++i) {
        digit >>= 1;
    }

    return (((bitcount_t)(num_digits - 1) << uECC_WORD_BITS_SHIFT) + i);
}


/* Sets p_dest = p_src. */
void uECC_vli_set(uECC_word_t *dest, const uECC_word_t *src, wordcount_t num_words) {
    wordcount_t i;
    for (i = 0; i < num_words; ++i) {
        dest[i] = src[i];
    }
}

/* Returns sign of p_left - p_right. */
cmpresult_t uECC_vli_cmp_unsafe(const uECC_word_t *left,
                                       const uECC_word_t *right,
                                       wordcount_t num_words) {
    wordcount_t i;
    for (i = num_words - 1; i >= 0; --i) {
        if (left[i] > right[i]) {
            return 1;
        } else if (left[i] < right[i]) {
            return -1;
        }
    }
    return 0;
}

/* Computes p_result = p_in << c, returning carry. Can modify in place (if p_result == p_in). 0 < p_shift < 8. */

uECC_word_t uECC_vli_lshift(uECC_word_t *p_result, uECC_word_t *p_in, uECC_word_t p_shift) {
    uECC_word_t carry = 0;
    for (uECC_word_t i = 0; i < uECC_MAX_WORDS; ++i) {
        uECC_word_t temp = p_in[i];
        p_result[i] = (temp << p_shift) | carry;
        carry = temp >> (uECC_WORD_BITS - p_shift);
    }
    return carry;
}

/* Computes p_vli = p_vli >> 1. */
void uECC_vli_rshift1(uECC_word_t *vli, wordcount_t num_words) {
    uECC_word_t *end = vli;
    uECC_word_t carry = 0;

    vli += num_words;
    while (vli-- > end) {
        uECC_word_t temp = *vli;
        *vli = (temp >> 1) | carry;
        carry = temp << (uECC_WORD_BITS - 1);
    }
}

/* Computes p_result = p_left + p_right, returning carry. Can modify in place. */
uECC_word_t uECC_vli_add(uECC_word_t *result,
                                      const uECC_word_t *left,
                                      const uECC_word_t *right,
                                      wordcount_t num_words) {
    uECC_word_t carry = 0;
    wordcount_t i;
    for (i = 0; i < num_words; ++i) {
        uECC_word_t sum = left[i] + right[i] + carry;
        if (sum != left[i]) {
            carry = (sum < left[i]);
        }
        result[i] = sum;
    }
    return carry;
}
/* Computes p_result = p_left - p_right, returning borrow. Can modify in place. */
uECC_word_t uECC_vli_sub(uECC_word_t *result,
                                      const uECC_word_t *left,
                                      const uECC_word_t *right,
                                      wordcount_t num_words) {
    uECC_word_t borrow = 0;
    wordcount_t i;
    for (i = 0; i < num_words; ++i) {
        uECC_word_t diff = left[i] - right[i] - borrow;
        if (diff != left[i]) {
            borrow = (diff > left[i]);
        }
        result[i] = diff;
    }
    return borrow;
}

void muladd(uECC_word_t a,
                   uECC_word_t b,
                   uECC_word_t *r0,
                   uECC_word_t *r1,
                   uECC_word_t *r2) {
    uECC_dword_t p = (uECC_dword_t)a * b;
    uECC_dword_t r01 = ((uECC_dword_t)(*r1) << uECC_WORD_BITS) | *r0;
    r01 += p;
    *r2 += (r01 < p);
    *r1 = r01 >> uECC_WORD_BITS;
    *r0 = (uECC_word_t)r01;
}

/******************* speed up **********************/
/* Computes p_result = p_left * p_right. */
void uECC_vli_mult(uECC_word_t *result,
                                const uECC_word_t *left,
                                const uECC_word_t *right,
                                wordcount_t num_words) {
    uECC_word_t r0 = 0;
    uECC_word_t r1 = 0;
    uECC_word_t r2 = 0;
    wordcount_t i, k;

    /* Compute each digit of result in sequence, maintaining the carries. */
    for (k = 0; k < num_words; ++k) {
        for (i = 0; i <= k; ++i) {
            muladd(left[i], right[k - i], &r0, &r1, &r2);
        }
        result[k] = r0;
        r0 = r1;
        r1 = r2;
        r2 = 0;
    }
    for (k = num_words; k < num_words * 2 - 1; ++k) {
        for (i = (k + 1) - num_words; i < num_words; ++i) {
            muladd(left[i], right[k - i], &r0, &r1, &r2);
        }
        result[k] = r0;
        r0 = r1;
        r1 = r2;
        r2 = 0;
    }
    result[num_words * 2 - 1] = r0;
}
/* Computes p_result = (p_left + p_right) % p_mod.
   Assumes that p_left < p_mod and p_right < p_mod, p_result != p_mod. */
void uECC_vli_modAdd(uECC_word_t *result,
                                  const uECC_word_t *left,
                                  const uECC_word_t *right,
                                  const uECC_word_t *mod,
                                  wordcount_t num_words) {
    uECC_word_t carry = uECC_vli_add(result, left, right, num_words);
    if (carry || uECC_vli_cmp_unsafe(mod, result, num_words) != 1) {
        /* result > mod (result = mod + remainder), so subtract mod to get remainder. */
        uECC_vli_sub(result, result, mod, num_words);
    }
}

/* Computes p_result = (p_left - p_right) % p_mod.
   Assumes that p_left < p_mod and p_right < p_mod, p_result != p_mod. */
void uECC_vli_modSub(uECC_word_t *result,
                                  const uECC_word_t *left,
                                  const uECC_word_t *right,
                                  const uECC_word_t *mod,
                                  wordcount_t num_words) {
    uECC_word_t l_borrow = uECC_vli_sub(result, left, right, num_words);
    if (l_borrow) {
        /* In this case, result == -diff == (max int) - diff. Since -x % d == d - x,
           we can get the correct result from result + mod (with overflow). */
        uECC_vli_add(result, result, mod, num_words);
    }
}

void uECC_vli_mmod_fast(uECC_word_t *p_result, uECC_word_t *p_product) {
    uECC_word_t l_tmp1[uECC_MAX_WORDS] = {0};
    uECC_word_t l_tmp2[uECC_MAX_WORDS] = {0};
    uECC_word_t l_tmp3[uECC_MAX_WORDS] = {0};
    uECC_word_t l_carry = 0;

    uECC_vli_set(p_result, p_product, uECC_MAX_WORDS);

    /* Y0 */
    l_tmp1[0] = l_tmp1[3] = l_tmp1[7] = p_product[8];
    l_tmp2[2] = p_product[8];
    l_carry += uECC_vli_add(p_result, p_result, l_tmp1, uECC_MAX_WORDS);
    l_carry -= uECC_vli_sub(p_result, p_result, l_tmp2, uECC_MAX_WORDS);

    /* Y1 */
    l_tmp1[0] = l_tmp1[1] = l_tmp1[4] = l_tmp1[7] = p_product[9];
    l_tmp1[3] = 0;
    l_tmp2[2] = p_product[9];
    l_carry += uECC_vli_add(p_result, p_result, l_tmp1, uECC_MAX_WORDS);
    l_carry -= uECC_vli_sub(p_result, p_result, l_tmp2, uECC_MAX_WORDS);

    /* Y2 */
    l_tmp1[0] = l_tmp1[1] = l_tmp1[5] = l_tmp1[7] = p_product[10];
    l_tmp1[4] = 0;
    l_carry += uECC_vli_add(p_result, p_result, l_tmp1, uECC_MAX_WORDS);

    /* Y3 */
    l_tmp1[0] = l_tmp1[1] = l_tmp1[3] = l_tmp1[6] = l_tmp1[7] = p_product[11];
    l_tmp1[5] = 0;
    l_carry += uECC_vli_add(p_result, p_result, l_tmp1, uECC_MAX_WORDS);

    /* Y4 */
    l_tmp1[0] = l_tmp1[1] = l_tmp1[3] = l_tmp1[4] = l_tmp1[7] = l_tmp3[7] = p_product[12];
    l_tmp1[6] = 0;
    l_carry += uECC_vli_add(p_result, p_result, l_tmp1, uECC_MAX_WORDS);
    l_carry += uECC_vli_add(p_result, p_result, l_tmp3, uECC_MAX_WORDS);

    /* Y5 */
    l_tmp1[0] = l_tmp1[1] = l_tmp1[3] = l_tmp1[4] = l_tmp1[5] = l_tmp1[7] = p_product[13];
    l_tmp2[2] = p_product[13];
    l_tmp3[0] = l_tmp3[3] = l_tmp3[7] = p_product[13];
    l_carry += uECC_vli_add(p_result, p_result, l_tmp1, uECC_MAX_WORDS);
    l_carry += uECC_vli_add(p_result, p_result, l_tmp3, uECC_MAX_WORDS);
    l_carry -= uECC_vli_sub(p_result, p_result, l_tmp2, uECC_MAX_WORDS);

    /* Y6 */
    l_tmp1[0] = l_tmp1[1] = l_tmp1[3] = l_tmp1[4] = l_tmp1[5] = l_tmp1[6] = l_tmp1[7] = p_product[14];
    l_tmp2[2] = p_product[14];
    l_tmp3[0] = l_tmp3[1] = l_tmp3[4] = l_tmp3[7] = p_product[14];
    l_tmp3[3] = 0;
    l_carry += uECC_vli_add(p_result, p_result, l_tmp1, uECC_MAX_WORDS);
    l_carry += uECC_vli_add(p_result, p_result, l_tmp3, uECC_MAX_WORDS);
    l_carry -= uECC_vli_sub(p_result, p_result, l_tmp2, uECC_MAX_WORDS);

    /* Y7 */
    l_tmp1[0] = l_tmp1[1] = l_tmp1[3] = l_tmp1[4] = l_tmp1[5] = l_tmp1[6] = l_tmp1[7] = p_product[15];
    l_tmp3[0] = l_tmp3[1] = l_tmp3[5]  = p_product[15];
    l_tmp3[4] = l_tmp3[7] = 0;
    l_tmp2[7] = p_product[15];
    l_tmp2[2] = 0;
    l_carry += uECC_vli_lshift(l_tmp2, l_tmp2, 1);
    l_carry += uECC_vli_add(p_result, p_result, l_tmp1, uECC_MAX_WORDS);
    l_carry += uECC_vli_add(p_result, p_result, l_tmp3, uECC_MAX_WORDS);
    l_carry += uECC_vli_add(p_result, p_result, l_tmp2, uECC_MAX_WORDS);

    if(l_carry < 0)
    {
        do
        {
            l_carry += uECC_vli_add(p_result, p_result, curve_p, uECC_MAX_WORDS);
        } while(l_carry < 0);
    }
    else
    {
        while(l_carry || uECC_vli_cmp_unsafe(curve_p, p_result, uECC_MAX_WORDS) != 1)
        {
            l_carry -= uECC_vli_sub(p_result, p_result, curve_p, uECC_MAX_WORDS);
        }
    }
}


/* Computes p_result = (p_left * p_right) % curve_p. */
void uECC_vli_modMult_fast(uECC_word_t *p_result, uECC_word_t *p_left, uECC_word_t *p_right)
{
   uECC_word_t l_product[2 * uECC_MAX_WORDS];
   uECC_vli_mult(l_product, p_left, p_right, uECC_MAX_WORDS);
   uECC_vli_mmod_fast(p_result, l_product);
}


#define uECC_vli_modSquare_fast(result, left) uECC_vli_modMult_fast((result), (left), (left))


#define EVEN(vli) (!(vli[0] & 1))
void vli_modInv_update(uECC_word_t *uv,
                              const uECC_word_t *mod,
                              wordcount_t num_words) {
    uECC_word_t carry = 0;
    if (!EVEN(uv)) {
        carry = uECC_vli_add(uv, uv, mod, num_words);
    }
    uECC_vli_rshift1(uv, num_words);
    if (carry) {
        uv[num_words - 1] |= HIGH_BIT_SET;
    }
}

/* Computes result = (1 / input) % mod. All VLIs are the same size.
   See "From Euclid's GCD to Montgomery Multiplication to the Great Divide" */
void uECC_vli_modInv(uECC_word_t *result,
                                  const uECC_word_t *input,
                                  const uECC_word_t *mod,
                                  wordcount_t num_words) {
    uECC_word_t a[uECC_MAX_WORDS], b[uECC_MAX_WORDS], u[uECC_MAX_WORDS], v[uECC_MAX_WORDS];
    cmpresult_t cmpResult;

    if (uECC_vli_isZero(input, num_words)) {
        uECC_vli_clear(result, num_words);
        return;
    }

    uECC_vli_set(a, input, num_words);
    uECC_vli_set(b, mod, num_words);
    uECC_vli_clear(u, num_words);
    u[0] = 1;
    uECC_vli_clear(v, num_words);
    while ((cmpResult = uECC_vli_cmp_unsafe(a, b, num_words)) != 0) {
        if (EVEN(a)) {
            uECC_vli_rshift1(a, num_words);
            vli_modInv_update(u, mod, num_words);
        } else if (EVEN(b)) {
            uECC_vli_rshift1(b, num_words);
            vli_modInv_update(v, mod, num_words);
        } else if (cmpResult > 0) {
            uECC_vli_sub(a, a, b, num_words);
            uECC_vli_rshift1(a, num_words);
            if (uECC_vli_cmp_unsafe(u, v, num_words) < 0) {
                uECC_vli_add(u, u, mod, num_words);
            }
            uECC_vli_sub(u, u, v, num_words);
            vli_modInv_update(u, mod, num_words);
        } else {
            uECC_vli_sub(b, b, a, num_words);
            uECC_vli_rshift1(b, num_words);
            if (uECC_vli_cmp_unsafe(v, u, num_words) < 0) {
                uECC_vli_add(v, v, mod, num_words);
            }
            uECC_vli_sub(v, v, u, num_words);
            vli_modInv_update(v, mod, num_words);
        }
    }
    uECC_vli_set(result, u, num_words);
}


/* Point multiplication algorithm using Montgomery's ladder with co-Z coordinates.
From http://eprint.iacr.org/2011/338.pdf
*/

/* Double in place */
void EccPoint_double_jacobian(uECC_word_t *X1, uECC_word_t *Y1, uECC_word_t *Z1)
{
    /* t1 = X, t2 = Y, t3 = Z */
    uECC_word_t t4[uECC_MAX_WORDS];
    uECC_word_t t5[uECC_MAX_WORDS];
    wordcount_t num_words = uECC_MAX_WORDS;

    if (uECC_vli_isZero(Z1, num_words)) {
        return;
    }

    uECC_vli_modSquare_fast(t4, Y1);   /* t4 = y1^2 */
    uECC_vli_modMult_fast(t5, X1, t4); /* t5 = x1*y1^2 = A */
    uECC_vli_modSquare_fast(t4, t4);   /* t4 = y1^4 */
    uECC_vli_modMult_fast(Y1, Y1, Z1); /* t2 = y1*z1 = z3 */
    uECC_vli_modSquare_fast(Z1, Z1);   /* t3 = z1^2 */

    uECC_vli_modAdd(X1, X1, Z1, curve_p, num_words); /* t1 = x1 + z1^2 */
    uECC_vli_modAdd(Z1, Z1, Z1, curve_p, num_words); /* t3 = 2*z1^2 */
    uECC_vli_modSub(Z1, X1, Z1, curve_p, num_words); /* t3 = x1 - z1^2 */
    uECC_vli_modMult_fast(X1, X1, Z1);                /* t1 = x1^2 - z1^4 */

    uECC_vli_modAdd(Z1, X1, X1, curve_p, num_words); /* t3 = 2*(x1^2 - z1^4) */
    uECC_vli_modAdd(X1, X1, Z1, curve_p, num_words); /* t1 = 3*(x1^2 - z1^4) */
    if (uECC_vli_testBit(X1, 0)) {
        uECC_word_t l_carry = uECC_vli_add(X1, X1, curve_p, num_words);
        uECC_vli_rshift1(X1, num_words);
        X1[num_words - 1] |= l_carry << (uECC_WORD_BITS - 1);
    } else {
        uECC_vli_rshift1(X1, num_words);
    }
    /* t1 = 3/2*(x1^2 - z1^4) = B */

    uECC_vli_modSquare_fast(Z1, X1);                  /* t3 = B^2 */
    uECC_vli_modSub(Z1, Z1, t5, curve_p, num_words); /* t3 = B^2 - A */
    uECC_vli_modSub(Z1, Z1, t5, curve_p, num_words); /* t3 = B^2 - 2A = x3 */
    uECC_vli_modSub(t5, t5, Z1, curve_p, num_words); /* t5 = A - x3 */
    uECC_vli_modMult_fast(X1, X1, t5);                /* t1 = B * (A - x3) */
    uECC_vli_modSub(t4, X1, t4, curve_p, num_words); /* t4 = B * (A - x3) - y1^4 = y3 */

    uECC_vli_set(X1, Z1, num_words);
    uECC_vli_set(Z1, Y1, num_words);
    uECC_vli_set(Y1, t4, num_words);
}

/* Modify (x1, y1) => (x1 * z^2, y1 * z^3) */
void apply_z(uECC_word_t * X1,
                    uECC_word_t * Y1,
                    uECC_word_t * const Z)
{
    uECC_word_t t1[uECC_MAX_WORDS];

    uECC_vli_modSquare_fast(t1, Z);    /* z^2 */
    uECC_vli_modMult_fast(X1, X1, t1); /* x1 * z^2 */
    uECC_vli_modMult_fast(t1, t1, Z);  /* z^3 */
    uECC_vli_modMult_fast(Y1, Y1, t1); /* y1 * z^3 */
}

/* P = (x1, y1) => 2P, (x2, y2) => P' */
void XYcZ_initial_double(uECC_word_t *X1, uECC_word_t *Y1, uECC_word_t *X2, uECC_word_t *Y2)
{
    uECC_word_t z[uECC_MAX_WORDS];

    uECC_vli_set(X2, X1, uECC_MAX_WORDS);
    uECC_vli_set(Y2, Y1, uECC_MAX_WORDS);

    uECC_vli_clear(z, uECC_MAX_WORDS);
    z[0] = 1;
    apply_z(X1, Y1, z);

    EccPoint_double_jacobian(X1, Y1, z);

    apply_z(X2, Y2, z);
}

/* Input P = (x1, y1, Z), Q = (x2, y2, Z)
   Output P' = (x1', y1', Z3), P + Q = (x3, y3, Z3)
   or P => P', Q => P + Q
*/
void XYcZ_add(uECC_word_t *X1, uECC_word_t *Y1, uECC_word_t *X2, uECC_word_t *Y2)
{
    /* t1 = X1, t2 = Y1, t3 = X2, t4 = Y2 */
    uECC_word_t t5[uECC_WORD_BITS];

    uECC_vli_modSub(t5, X2, X1, curve_p, uECC_MAX_WORDS); /* t5 = x2 - x1 */
    uECC_vli_modSquare_fast(t5, t5);      /* t5 = (x2 - x1)^2 = A */
    uECC_vli_modMult_fast(X1, X1, t5);    /* t1 = x1*A = B */
    uECC_vli_modMult_fast(X2, X2, t5);    /* t3 = x2*A = C */
    uECC_vli_modSub(Y2, Y2, Y1, curve_p, uECC_MAX_WORDS); /* t4 = y2 - y1 */
    uECC_vli_modSquare_fast(t5, Y2);      /* t5 = (y2 - y1)^2 = D */

    uECC_vli_modSub(t5, t5, X1, curve_p, uECC_MAX_WORDS); /* t5 = D - B */
    uECC_vli_modSub(t5, t5, X2, curve_p, uECC_MAX_WORDS); /* t5 = D - B - C = x3 */
    uECC_vli_modSub(X2, X2, X1, curve_p, uECC_MAX_WORDS); /* t3 = C - B */
    uECC_vli_modMult_fast(Y1, Y1, X2);    /* t2 = y1*(C - B) */
    uECC_vli_modSub(X2, X1, t5, curve_p, uECC_MAX_WORDS); /* t3 = B - x3 */
    uECC_vli_modMult_fast(Y2, Y2, X2);    /* t4 = (y2 - y1)*(B - x3) */
    uECC_vli_modSub(Y2, Y2, Y1, curve_p, uECC_MAX_WORDS); /* t4 = y3 */

    uECC_vli_set(X2, t5, uECC_MAX_WORDS);
}

/* Input P = (x1, y1, Z), Q = (x2, y2, Z)
   Output P + Q = (x3, y3, Z3), P - Q = (x3', y3', Z3)
   or P => P - Q, Q => P + Q
*/
void XYcZ_addC(uECC_word_t *X1, uECC_word_t *Y1, uECC_word_t *X2, uECC_word_t *Y2)
{
    /* t1 = X1, t2 = Y1, t3 = X2, t4 = Y2 */
    uECC_word_t t5[uECC_MAX_WORDS];
    uECC_word_t t6[uECC_MAX_WORDS];
    uECC_word_t t7[uECC_MAX_WORDS];

    uECC_vli_modSub(t5, X2, X1, curve_p, uECC_MAX_WORDS); /* t5 = x2 - x1 */
    uECC_vli_modSquare_fast(t5, t5);      /* t5 = (x2 - x1)^2 = A */
    uECC_vli_modMult_fast(X1, X1, t5);    /* t1 = x1*A = B */
    uECC_vli_modMult_fast(X2, X2, t5);    /* t3 = x2*A = C */
    uECC_vli_modAdd(t5, Y2, Y1, curve_p, uECC_MAX_WORDS); /* t4 = y2 + y1 */
    uECC_vli_modSub(Y2, Y2, Y1, curve_p, uECC_MAX_WORDS); /* t4 = y2 - y1 */

    uECC_vli_modSub(t6, X2, X1, curve_p, uECC_MAX_WORDS); /* t6 = C - B */
    uECC_vli_modMult_fast(Y1, Y1, t6);    /* t2 = y1 * (C - B) */
    uECC_vli_modAdd(t6, X1, X2, curve_p, uECC_MAX_WORDS); /* t6 = B + C */
    uECC_vli_modSquare_fast(X2, Y2);      /* t3 = (y2 - y1)^2 */
    uECC_vli_modSub(X2, X2, t6, curve_p, uECC_MAX_WORDS); /* t3 = x3 */

    uECC_vli_modSub(t7, X1, X2, curve_p, uECC_MAX_WORDS); /* t7 = B - x3 */
    uECC_vli_modMult_fast(Y2, Y2, t7);    /* t4 = (y2 - y1)*(B - x3) */
    uECC_vli_modSub(Y2, Y2, Y1, curve_p, uECC_MAX_WORDS); /* t4 = y3 */

    uECC_vli_modSquare_fast(t7, t5);      /* t7 = (y2 + y1)^2 = F */
    uECC_vli_modSub(t7, t7, t6, curve_p, uECC_MAX_WORDS); /* t7 = x3' */
    uECC_vli_modSub(t6, t7, X1, curve_p, uECC_MAX_WORDS); /* t6 = x3' - B */
    uECC_vli_modMult_fast(t6, t6, t5);    /* t6 = (y2 + y1)*(x3' - B) */
    uECC_vli_modSub(Y1, t6, Y1, curve_p, uECC_MAX_WORDS); /* t2 = y3' */

    uECC_vli_set(X1, t7, uECC_MAX_WORDS);
}

void EccPoint_mult(EccPoint *p_result, EccPoint *p_point, uECC_word_t *p_scalar)
{
    /* R0 and R1 */
    uECC_word_t Rx[2][uECC_MAX_WORDS];
    uECC_word_t Ry[2][uECC_MAX_WORDS];
    uECC_word_t z[uECC_MAX_WORDS];
    bitcount_t i;
    uECC_word_t nb;
    uECC_vli_set(Rx[1], p_point->x, uECC_MAX_WORDS);
    uECC_vli_set(Ry[1], p_point->y, uECC_MAX_WORDS);

    XYcZ_initial_double(Rx[1], Ry[1], Rx[0], Ry[0]);

    for(i = uECC_vli_numBits(p_scalar, uECC_MAX_WORDS) - 2; i > 0; --i)
    {
        nb = !uECC_vli_testBit(p_scalar, i);
        XYcZ_addC(Rx[1-nb], Ry[1-nb], Rx[nb], Ry[nb]);
        XYcZ_add(Rx[nb], Ry[nb], Rx[1-nb], Ry[1-nb]);
    }

    nb = !uECC_vli_testBit(p_scalar, 0);
    XYcZ_addC(Rx[1-nb], Ry[1-nb], Rx[nb], Ry[nb]);

    /* Find final 1/Z value. */
    uECC_vli_modSub(z, Rx[1], Rx[0], curve_p, uECC_MAX_WORDS); /* X1 - X0 */
    uECC_vli_modMult_fast(z, z, Ry[1-nb]);     /* Yb * (X1 - X0) */
    uECC_vli_modMult_fast(z, z, p_point->x);   /* xP * Yb * (X1 - X0) */
    uECC_vli_modInv(z, z, curve_p, uECC_MAX_WORDS);            /* 1 / (xP * Yb * (X1 - X0)) */
    uECC_vli_modMult_fast(z, z, p_point->y);   /* yP / (xP * Yb * (X1 - X0)) */
    uECC_vli_modMult_fast(z, z, Rx[1-nb]);     /* Xb * yP / (xP * Yb * (X1 - X0)) */
    /* End 1/Z calculation */

    XYcZ_add(Rx[nb], Ry[nb], Rx[1-nb], Ry[1-nb]);

    apply_z(Rx[0], Ry[0], z);

    uECC_vli_set(p_result->x, Rx[0], uECC_MAX_WORDS);
    uECC_vli_set(p_result->y, Ry[0], uECC_MAX_WORDS);
}

void ecc_make_key(unsigned int *p_publicKey, unsigned int *p_privateKey)
{

    if(uECC_vli_cmp_unsafe(curve_n, p_privateKey, uECC_MAX_WORDS) != 1)
    {
        uECC_vli_sub(p_privateKey, p_privateKey, curve_n, uECC_MAX_WORDS);
    }

    if(uECC_vli_isZero(p_privateKey, uECC_MAX_WORDS))
    {
        return; /* The private key cannot be 0 (mod p). */
    }

    EccPoint_mult(p_publicKey, &curve_G, p_privateKey);
}

// 全部公钥计算正确 but slow
__kernel void compute(__global const unsigned int* input, __global unsigned int* pubkey) {
    int gid = get_global_id(0);

    // 每个工作项处理一个独立的数据块
    __global const unsigned int* prikey = input + gid * 8;
    __global unsigned int* out = pubkey + gid * 16;

    ecc_make_key(out, prikey);
}
