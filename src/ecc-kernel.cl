/**
 * License.....: MIT
 */

#define DECLSPEC
//#define IS_NV //android forbid

#define PRIVATE_AS

#ifdef DECLSPEC
#undef DECLSPEC
#define DECLSPEC inline // for opencl
#else
#define DECLSPEC
#endif

#ifdef GLOBAL_AS
#undef GLOBAL_AS
#define GLOBAL_AS   __global // for opencl
#else
#define GLOBAL_AS
#endif

typedef unsigned int u32;
typedef unsigned long u64;

// x1: 79BE667E F9DCBBAC 55A06295 CE870B07 029BFCDB 2DCE28D9 59F2815B 16F81798
// x1: 79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798
#define SECP256K1_G_PRE_COMPUTED_00 0x16f81798
#define SECP256K1_G_PRE_COMPUTED_01 0x59f2815b
#define SECP256K1_G_PRE_COMPUTED_02 0x2dce28d9
#define SECP256K1_G_PRE_COMPUTED_03 0x029bfcdb
#define SECP256K1_G_PRE_COMPUTED_04 0xce870b07
#define SECP256K1_G_PRE_COMPUTED_05 0x55a06295
#define SECP256K1_G_PRE_COMPUTED_06 0xf9dcbbac
#define SECP256K1_G_PRE_COMPUTED_07 0x79be667e

// y1: 483ADA77 26A3C465 5DA4FBFC 0E1108A8 FD17B448 A6855419 9C47D08F FB10D4B8
// y1: 483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8
#define SECP256K1_G_PRE_COMPUTED_08 0xfb10d4b8
#define SECP256K1_G_PRE_COMPUTED_09 0x9c47d08f
#define SECP256K1_G_PRE_COMPUTED_10 0xa6855419
#define SECP256K1_G_PRE_COMPUTED_11 0xfd17b448
#define SECP256K1_G_PRE_COMPUTED_12 0x0e1108a8
#define SECP256K1_G_PRE_COMPUTED_13 0x5da4fbfc
#define SECP256K1_G_PRE_COMPUTED_14 0x26a3c465
#define SECP256K1_G_PRE_COMPUTED_15 0x483ada77

// -y1: B7C52588 D95C3B9A A25B0403 F1EEF757 02E84BB7 597AABE6 63B82F6F 04EF2777
// -y1: B7C52588D95C3B9AA25B0403F1EEF75702E84BB7597AABE663B82F6F04EF2777
#define SECP256K1_G_PRE_COMPUTED_16 0x04ef2777
#define SECP256K1_G_PRE_COMPUTED_17 0x63b82f6f
#define SECP256K1_G_PRE_COMPUTED_18 0x597aabe6
#define SECP256K1_G_PRE_COMPUTED_19 0x02e84bb7
#define SECP256K1_G_PRE_COMPUTED_20 0xf1eef757
#define SECP256K1_G_PRE_COMPUTED_21 0xa25b0403
#define SECP256K1_G_PRE_COMPUTED_22 0xd95c3b9a
#define SECP256K1_G_PRE_COMPUTED_23 0xb7c52588

// x3: F9308A01 9258C310 49344F85 F89D5229 B531C845 836F99B0 8601F113 BCE036F9
// x3: F9308A019258C31049344F85F89D5229B531C845836F99B08601F113BCE036F9
#define SECP256K1_G_PRE_COMPUTED_24 0xbce036f9
#define SECP256K1_G_PRE_COMPUTED_25 0x8601f113
#define SECP256K1_G_PRE_COMPUTED_26 0x836f99b0
#define SECP256K1_G_PRE_COMPUTED_27 0xb531c845
#define SECP256K1_G_PRE_COMPUTED_28 0xf89d5229
#define SECP256K1_G_PRE_COMPUTED_29 0x49344f85
#define SECP256K1_G_PRE_COMPUTED_30 0x9258c310
#define SECP256K1_G_PRE_COMPUTED_31 0xf9308a01

// y3: 388F7B0F 632DE814 0FE337E6 2A37F356 6500A999 34C2231B 6CB9FD75 84B8E672
// y3: 388F7B0F632DE8140FE337E62A37F3566500A99934C2231B6CB9FD7584B8E672
#define SECP256K1_G_PRE_COMPUTED_32 0x84b8e672
#define SECP256K1_G_PRE_COMPUTED_33 0x6cb9fd75
#define SECP256K1_G_PRE_COMPUTED_34 0x34c2231b
#define SECP256K1_G_PRE_COMPUTED_35 0x6500a999
#define SECP256K1_G_PRE_COMPUTED_36 0x2a37f356
#define SECP256K1_G_PRE_COMPUTED_37 0x0fe337e6
#define SECP256K1_G_PRE_COMPUTED_38 0x632de814
#define SECP256K1_G_PRE_COMPUTED_39 0x388f7b0f

// -y3: C77084F0 9CD217EB F01CC819 D5C80CA9 9AFF5666 CB3DDCE4 93460289 7B4715BD
// -y3: C77084F09CD217EBF01CC819D5C80CA99AFF5666CB3DDCE4934602897B4715BD
#define SECP256K1_G_PRE_COMPUTED_40 0x7b4715bd
#define SECP256K1_G_PRE_COMPUTED_41 0x93460289
#define SECP256K1_G_PRE_COMPUTED_42 0xcb3ddce4
#define SECP256K1_G_PRE_COMPUTED_43 0x9aff5666
#define SECP256K1_G_PRE_COMPUTED_44 0xd5c80ca9
#define SECP256K1_G_PRE_COMPUTED_45 0xf01cc819
#define SECP256K1_G_PRE_COMPUTED_46 0x9cd217eb
#define SECP256K1_G_PRE_COMPUTED_47 0xc77084f0

// x5: 2F8BDE4D 1A072093 55B4A725 0A5C5128 E88B84BD DC619AB7 CBA8D569 B240EFE4
// x5: 2F8BDE4D1A07209355B4A7250A5C5128E88B84BDDC619AB7CBA8D569B240EFE4
#define SECP256K1_G_PRE_COMPUTED_48 0xb240efe4
#define SECP256K1_G_PRE_COMPUTED_49 0xcba8d569
#define SECP256K1_G_PRE_COMPUTED_50 0xdc619ab7
#define SECP256K1_G_PRE_COMPUTED_51 0xe88b84bd
#define SECP256K1_G_PRE_COMPUTED_52 0x0a5c5128
#define SECP256K1_G_PRE_COMPUTED_53 0x55b4a725
#define SECP256K1_G_PRE_COMPUTED_54 0x1a072093
#define SECP256K1_G_PRE_COMPUTED_55 0x2f8bde4d

// y5: D8AC2226 36E5E3D6 D4DBA9DD A6C9C426 F788271B AB0D6840 DCA87D3A A6AC62D6
// y5: D8AC222636E5E3D6D4DBA9DDA6C9C426F788271BAB0D6840DCA87D3AA6AC62D6
#define SECP256K1_G_PRE_COMPUTED_56 0xa6ac62d6
#define SECP256K1_G_PRE_COMPUTED_57 0xdca87d3a
#define SECP256K1_G_PRE_COMPUTED_58 0xab0d6840
#define SECP256K1_G_PRE_COMPUTED_59 0xf788271b
#define SECP256K1_G_PRE_COMPUTED_60 0xa6c9c426
#define SECP256K1_G_PRE_COMPUTED_61 0xd4dba9dd
#define SECP256K1_G_PRE_COMPUTED_62 0x36e5e3d6
#define SECP256K1_G_PRE_COMPUTED_63 0xd8ac2226

// -y5: 2753DDD9 C91A1C29 2B245622 59363BD9 0877D8E4 54F297BF 235782C4 59539959
// -y5: 2753DDD9C91A1C292B24562259363BD90877D8E454F297BF235782C459539959
#define SECP256K1_G_PRE_COMPUTED_64 0x59539959
#define SECP256K1_G_PRE_COMPUTED_65 0x235782c4
#define SECP256K1_G_PRE_COMPUTED_66 0x54f297bf
#define SECP256K1_G_PRE_COMPUTED_67 0x0877d8e4
#define SECP256K1_G_PRE_COMPUTED_68 0x59363bd9
#define SECP256K1_G_PRE_COMPUTED_69 0x2b245622
#define SECP256K1_G_PRE_COMPUTED_70 0xc91a1c29
#define SECP256K1_G_PRE_COMPUTED_71 0x2753ddd9

// x7: 5CBDF064 6E5DB4EA A398F365 F2EA7A0E 3D419B7E 0330E39C E92BDDED CAC4F9BC
// x7: 5CBDF0646E5DB4EAA398F365F2EA7A0E3D419B7E0330E39CE92BDDEDCAC4F9BC
#define SECP256K1_G_PRE_COMPUTED_72 0xcac4f9bc
#define SECP256K1_G_PRE_COMPUTED_73 0xe92bdded
#define SECP256K1_G_PRE_COMPUTED_74 0x0330e39c
#define SECP256K1_G_PRE_COMPUTED_75 0x3d419b7e
#define SECP256K1_G_PRE_COMPUTED_76 0xf2ea7a0e
#define SECP256K1_G_PRE_COMPUTED_77 0xa398f365
#define SECP256K1_G_PRE_COMPUTED_78 0x6e5db4ea
#define SECP256K1_G_PRE_COMPUTED_79 0x5cbdf064

// y7: 6AEBCA40 BA255960 A3178D6D 861A54DB A813D0B8 13FDE7B5 A5082628 087264DA
// y7: 6AEBCA40BA255960A3178D6D861A54DBA813D0B813FDE7B5A5082628087264DA
#define SECP256K1_G_PRE_COMPUTED_80 0x087264da
#define SECP256K1_G_PRE_COMPUTED_81 0xa5082628
#define SECP256K1_G_PRE_COMPUTED_82 0x13fde7b5
#define SECP256K1_G_PRE_COMPUTED_83 0xa813d0b8
#define SECP256K1_G_PRE_COMPUTED_84 0x861a54db
#define SECP256K1_G_PRE_COMPUTED_85 0xa3178d6d
#define SECP256K1_G_PRE_COMPUTED_86 0xba255960
#define SECP256K1_G_PRE_COMPUTED_87 0x6aebca40

// -y7: 951435BF 45DAA69F 5CE87292 79E5AB24 57EC2F47 EC02184A 5AF7D9D6 F78D9755
// -y7: 951435BF45DAA69F5CE8729279E5AB2457EC2F47EC02184A5AF7D9D6F78D9755
#define SECP256K1_G_PRE_COMPUTED_88 0xf78d9755
#define SECP256K1_G_PRE_COMPUTED_89 0x5af7d9d6
#define SECP256K1_G_PRE_COMPUTED_90 0xec02184a
#define SECP256K1_G_PRE_COMPUTED_91 0x57ec2f47
#define SECP256K1_G_PRE_COMPUTED_92 0x79e5ab24
#define SECP256K1_G_PRE_COMPUTED_93 0x5ce87292
#define SECP256K1_G_PRE_COMPUTED_94 0x45daa69f
#define SECP256K1_G_PRE_COMPUTED_95 0x951435bf

#define SECP256K1_P0 0xfffffc2f
#define SECP256K1_P1 0xfffffffe
#define SECP256K1_P2 0xffffffff
#define SECP256K1_P3 0xffffffff
#define SECP256K1_P4 0xffffffff
#define SECP256K1_P5 0xffffffff
#define SECP256K1_P6 0xffffffff
#define SECP256K1_P7 0xffffffff

#define SECP256K1_N0 0xd0364141
#define SECP256K1_N1 0xbfd25e8c
#define SECP256K1_N2 0xaf48a03b
#define SECP256K1_N3 0xbaaedce6
#define SECP256K1_N4 0xfffffffe
#define SECP256K1_N5 0xffffffff
#define SECP256K1_N6 0xffffffff
#define SECP256K1_N7 0xffffffff

typedef struct secp256k1
{
  u32 xy[96]; // pre-computed points: (x1,y1,-y1),(x3,y3,-y3),(x5,y5,-y5),(x7,y7,-y7)

} secp256k1_t;


DECLSPEC u32 sub (u32 *r, const u32 *a, const u32 *b)
{
  u32 c = 0; // carry/borrow

  #if defined IS_NV
  asm volatile
  (
    "sub.cc.u32   %0,  %9, %17;"
    "subc.cc.u32  %1, %10, %18;"
    "subc.cc.u32  %2, %11, %19;"
    "subc.cc.u32  %3, %12, %20;"
    "subc.cc.u32  %4, %13, %21;"
    "subc.cc.u32  %5, %14, %22;"
    "subc.cc.u32  %6, %15, %23;"
    "subc.cc.u32  %7, %16, %24;"
    "subc.u32     %8,   0,   0;"
    : "=r"(r[0]), "=r"(r[1]), "=r"(r[2]), "=r"(r[3]), "=r"(r[4]), "=r"(r[5]), "=r"(r[6]), "=r"(r[7]),
      "=r"(c)
    :  "r"(a[0]),  "r"(a[1]),  "r"(a[2]),  "r"(a[3]),  "r"(a[4]),  "r"(a[5]),  "r"(a[6]),  "r"(a[7]),
       "r"(b[0]),  "r"(b[1]),  "r"(b[2]),  "r"(b[3]),  "r"(b[4]),  "r"(b[5]),  "r"(b[6]),  "r"(b[7])
  );
  #elif defined IS_AMD && HAS_VSUB == 1 && HAS_VSUBB == 1
  __asm__ __volatile__
  (
    "V_SUB_U32   %0,  %9, %17;"
    "V_SUBB_U32  %1, %10, %18;"
    "V_SUBB_U32  %2, %11, %19;"
    "V_SUBB_U32  %3, %12, %20;"
    "V_SUBB_U32  %4, %13, %21;"
    "V_SUBB_U32  %5, %14, %22;"
    "V_SUBB_U32  %6, %15, %23;"
    "V_SUBB_U32  %7, %16, %24;"
    "V_SUBB_U32  %8,   0,   0;"
    : "=v"(r[0]), "=v"(r[1]), "=v"(r[2]), "=v"(r[3]), "=v"(r[4]), "=v"(r[5]), "=v"(r[6]), "=v"(r[7]),
      "=v"(c)
    :  "v"(a[0]),  "v"(a[1]),  "v"(a[2]),  "v"(a[3]),  "v"(a[4]),  "v"(a[5]),  "v"(a[6]),  "v"(a[7]),
       "v"(b[0]),  "v"(b[1]),  "v"(b[2]),  "v"(b[3]),  "v"(b[4]),  "v"(b[5]),  "v"(b[6]),  "v"(b[7])
  );
  #else
  for (u32 i = 0; i < 8; i++)
  {
    const u32 diff = a[i] - b[i] - c;

    if (diff != a[i]) c = (diff > a[i]);

    r[i] = diff;
  }
  #endif

  return c;
}

DECLSPEC u32 add (u32 *r, const u32 *a, const u32 *b)
{
  u32 c = 0; // carry/borrow

  #if defined IS_NV
  asm volatile
  (
    "add.cc.u32   %0,  %9, %17;"
    "addc.cc.u32  %1, %10, %18;"
    "addc.cc.u32  %2, %11, %19;"
    "addc.cc.u32  %3, %12, %20;"
    "addc.cc.u32  %4, %13, %21;"
    "addc.cc.u32  %5, %14, %22;"
    "addc.cc.u32  %6, %15, %23;"
    "addc.cc.u32  %7, %16, %24;"
    "addc.u32     %8,   0,   0;"
    : "=r"(r[0]), "=r"(r[1]), "=r"(r[2]), "=r"(r[3]), "=r"(r[4]), "=r"(r[5]), "=r"(r[6]), "=r"(r[7]),
      "=r"(c)
    :  "r"(a[0]),  "r"(a[1]),  "r"(a[2]),  "r"(a[3]),  "r"(a[4]),  "r"(a[5]),  "r"(a[6]),  "r"(a[7]),
       "r"(b[0]),  "r"(b[1]),  "r"(b[2]),  "r"(b[3]),  "r"(b[4]),  "r"(b[5]),  "r"(b[6]),  "r"(b[7])
  );
  #elif defined IS_AMD && HAS_VADD == 1 && HAS_VADDC == 1
  __asm__ __volatile__
  (
    "V_ADD_U32   %0,  %9, %17;"
    "V_ADDC_U32  %1, %10, %18;"
    "V_ADDC_U32  %2, %11, %19;"
    "V_ADDC_U32  %3, %12, %20;"
    "V_ADDC_U32  %4, %13, %21;"
    "V_ADDC_U32  %5, %14, %22;"
    "V_ADDC_U32  %6, %15, %23;"
    "V_ADDC_U32  %7, %16, %24;"
    "V_ADDC_U32  %8,   0,   0;"
    : "=v"(r[0]), "=v"(r[1]), "=v"(r[2]), "=v"(r[3]), "=v"(r[4]), "=v"(r[5]), "=v"(r[6]), "=v"(r[7]),
      "=v"(c)
    :  "v"(a[0]),  "v"(a[1]),  "v"(a[2]),  "v"(a[3]),  "v"(a[4]),  "v"(a[5]),  "v"(a[6]),  "v"(a[7]),
       "v"(b[0]),  "v"(b[1]),  "v"(b[2]),  "v"(b[3]),  "v"(b[4]),  "v"(b[5]),  "v"(b[6]),  "v"(b[7])
  );
  #else
  for (u32 i = 0; i < 8; i++)
  {
    const u32 t = a[i] + b[i] + c;

    if (t != a[i]) c = (t < a[i]);

    r[i] = t;
  }
  #endif

  return c;
}

DECLSPEC void sub_mod (u32 *r, const u32 *a, const u32 *b)
{
  const u32 c = sub (r, a, b); // carry

  if (c)
  {
    u32 t[8];

    t[0] = SECP256K1_P0;
    t[1] = SECP256K1_P1;
    t[2] = SECP256K1_P2;
    t[3] = SECP256K1_P3;
    t[4] = SECP256K1_P4;
    t[5] = SECP256K1_P5;
    t[6] = SECP256K1_P6;
    t[7] = SECP256K1_P7;

    add (r, r, t);
  }
}

DECLSPEC void add_mod (u32 *r, const u32 *a, const u32 *b)
{
  const u32 c = add (r, a, b); // carry

  u32 t[8];

  t[0] = SECP256K1_P0;
  t[1] = SECP256K1_P1;
  t[2] = SECP256K1_P2;
  t[3] = SECP256K1_P3;
  t[4] = SECP256K1_P4;
  t[5] = SECP256K1_P5;
  t[6] = SECP256K1_P6;
  t[7] = SECP256K1_P7;

  // check if modulo operation is needed

  u32 mod = 1;

  if (c == 0)
  {
    for (int i = 7; i >= 0; i--)
    {
      if (r[i] < t[i])
      {
        mod = 0;

        break; // or return ! (check if faster)
      }

      if (r[i] > t[i]) break;
    }
  }

  if (mod == 1)
  {
    sub (r, r, t);
  }
}

DECLSPEC void mul_mod (u32 *r, const u32 *a, const u32 *b) // TODO get rid of u64 ?
{
  u32 t[16] = { 0 }; // we need up to double the space (2 * 8)

  u32 t0 = 0;
  u32 t1 = 0;
  u32 c  = 0;

  for (u32 i = 0; i < 8; i++)
  {
    for (u32 j = 0; j <= i; j++)
    {
      u64 p = ((u64) a[j]) * b[i - j];

      u64 d = ((u64) t1) << 32 | t0;

      d += p;

      t0 = (u32) d;
      t1 = d >> 32;

      c += d < p; // carry
    }

    t[i] = t0;

    t0 = t1;
    t1 = c;

    c = 0;
  }

  for (u32 i = 8; i < 15; i++)
  {
    for (u32 j = i - 7; j < 8; j++)
    {
      u64 p = ((u64) a[j]) * b[i - j];

      u64 d = ((u64) t1) << 32 | t0;

      d += p;

      t0 = (u32) d;
      t1 = d >> 32;

      c += d < p;
    }

    t[i] = t0;

    t0 = t1;
    t1 = c;

    c = 0;
  }

  t[15] = t0;

  u32 tmp[16] = { 0 };

  for (u32 i = 0, j = 8; i < 8; i++, j++)
  {
    u64 p = ((u64) 0x03d1) * t[j] + c;

    tmp[i] = (u32) p;

    c = p >> 32;
  }

  tmp[8] = c;

  c = add (tmp + 1, tmp + 1, t + 8); // modifies tmp[1]...tmp[8]

  tmp[9] = c;

  c = add (r, t, tmp);

  u32 c2 = 0;

  for (u32 i = 0, j = 8; i < 8; i++, j++)
  {
    u64 p = ((u64) 0x3d1) * tmp[j] + c2;

    t[i] = (u32) p;

    c2 = p >> 32;
  }

  t[8] = c2;

  c2 = add (t + 1, t + 1, tmp + 8); // modifies t[1]...t[8]

  t[9] = c2;

  c2 = add (r, r, t);

  c += c2;

  t[0] = SECP256K1_P0;
  t[1] = SECP256K1_P1;
  t[2] = SECP256K1_P2;
  t[3] = SECP256K1_P3;
  t[4] = SECP256K1_P4;
  t[5] = SECP256K1_P5;
  t[6] = SECP256K1_P6;
  t[7] = SECP256K1_P7;

  for (u32 i = c; i > 0; i--)
  {
    sub (r, r, t);
  }

  for (int i = 7; i >= 0; i--)
  {
    if (r[i] < t[i]) break;

    if (r[i] > t[i])
    {
      sub (r, r, t);

      break;
    }
  }
}

DECLSPEC void inv_mod (u32 *a)
{
  u32 t0[8];

  t0[0] = a[0];
  t0[1] = a[1];
  t0[2] = a[2];
  t0[3] = a[3];
  t0[4] = a[4];
  t0[5] = a[5];
  t0[6] = a[6];
  t0[7] = a[7];

  u32 p[8];

  p[0] = SECP256K1_P0;
  p[1] = SECP256K1_P1;
  p[2] = SECP256K1_P2;
  p[3] = SECP256K1_P3;
  p[4] = SECP256K1_P4;
  p[5] = SECP256K1_P5;
  p[6] = SECP256K1_P6;
  p[7] = SECP256K1_P7;

  u32 t1[8];

  t1[0] = SECP256K1_P0;
  t1[1] = SECP256K1_P1;
  t1[2] = SECP256K1_P2;
  t1[3] = SECP256K1_P3;
  t1[4] = SECP256K1_P4;
  t1[5] = SECP256K1_P5;
  t1[6] = SECP256K1_P6;
  t1[7] = SECP256K1_P7;

  u32 t2[8] = { 0 };

  t2[0] = 0x00000001;

  u32 t3[8] = { 0 };

  u32 b = (t0[0] != t1[0])
        | (t0[1] != t1[1])
        | (t0[2] != t1[2])
        | (t0[3] != t1[3])
        | (t0[4] != t1[4])
        | (t0[5] != t1[5])
        | (t0[6] != t1[6])
        | (t0[7] != t1[7]);

  while (b)
  {
    if ((t0[0] & 1) == 0) // even
    {
      t0[0] = t0[0] >> 1 | t0[1] << 31;
      t0[1] = t0[1] >> 1 | t0[2] << 31;
      t0[2] = t0[2] >> 1 | t0[3] << 31;
      t0[3] = t0[3] >> 1 | t0[4] << 31;
      t0[4] = t0[4] >> 1 | t0[5] << 31;
      t0[5] = t0[5] >> 1 | t0[6] << 31;
      t0[6] = t0[6] >> 1 | t0[7] << 31;
      t0[7] = t0[7] >> 1;

      u32 c = 0;

      if (t2[0] & 1) c = add (t2, t2, p);

      t2[0] = t2[0] >> 1 | t2[1] << 31;
      t2[1] = t2[1] >> 1 | t2[2] << 31;
      t2[2] = t2[2] >> 1 | t2[3] << 31;
      t2[3] = t2[3] >> 1 | t2[4] << 31;
      t2[4] = t2[4] >> 1 | t2[5] << 31;
      t2[5] = t2[5] >> 1 | t2[6] << 31;
      t2[6] = t2[6] >> 1 | t2[7] << 31;
      t2[7] = t2[7] >> 1 | c     << 31;
    }
    else if ((t1[0] & 1) == 0)
    {
      t1[0] = t1[0] >> 1 | t1[1] << 31;
      t1[1] = t1[1] >> 1 | t1[2] << 31;
      t1[2] = t1[2] >> 1 | t1[3] << 31;
      t1[3] = t1[3] >> 1 | t1[4] << 31;
      t1[4] = t1[4] >> 1 | t1[5] << 31;
      t1[5] = t1[5] >> 1 | t1[6] << 31;
      t1[6] = t1[6] >> 1 | t1[7] << 31;
      t1[7] = t1[7] >> 1;

      u32 c = 0;

      if (t3[0] & 1) c = add (t3, t3, p);

      t3[0] = t3[0] >> 1 | t3[1] << 31;
      t3[1] = t3[1] >> 1 | t3[2] << 31;
      t3[2] = t3[2] >> 1 | t3[3] << 31;
      t3[3] = t3[3] >> 1 | t3[4] << 31;
      t3[4] = t3[4] >> 1 | t3[5] << 31;
      t3[5] = t3[5] >> 1 | t3[6] << 31;
      t3[6] = t3[6] >> 1 | t3[7] << 31;
      t3[7] = t3[7] >> 1 | c     << 31;
    }
    else
    {
      u32 gt = 0;

      for (int i = 7; i >= 0; i--)
      {
        if (t0[i] > t1[i])
        {
          gt = 1;

          break;
        }

        if (t0[i] < t1[i]) break;
      }

      if (gt)
      {
        sub (t0, t0, t1);

        t0[0] = t0[0] >> 1 | t0[1] << 31;
        t0[1] = t0[1] >> 1 | t0[2] << 31;
        t0[2] = t0[2] >> 1 | t0[3] << 31;
        t0[3] = t0[3] >> 1 | t0[4] << 31;
        t0[4] = t0[4] >> 1 | t0[5] << 31;
        t0[5] = t0[5] >> 1 | t0[6] << 31;
        t0[6] = t0[6] >> 1 | t0[7] << 31;
        t0[7] = t0[7] >> 1;

        u32 lt = 0;

        for (int i = 7; i >= 0; i--)
        {
          if (t2[i] < t3[i])
          {
            lt = 1;

            break;
          }

          if (t2[i] > t3[i]) break;
        }

        if (lt) add (t2, t2, p);

        sub (t2, t2, t3);

        u32 c = 0;

        if (t2[0] & 1) c = add (t2, t2, p);

        t2[0] = t2[0] >> 1 | t2[1] << 31;
        t2[1] = t2[1] >> 1 | t2[2] << 31;
        t2[2] = t2[2] >> 1 | t2[3] << 31;
        t2[3] = t2[3] >> 1 | t2[4] << 31;
        t2[4] = t2[4] >> 1 | t2[5] << 31;
        t2[5] = t2[5] >> 1 | t2[6] << 31;
        t2[6] = t2[6] >> 1 | t2[7] << 31;
        t2[7] = t2[7] >> 1 | c     << 31;
      }
      else
      {
        sub (t1, t1, t0);

        t1[0] = t1[0] >> 1 | t1[1] << 31;
        t1[1] = t1[1] >> 1 | t1[2] << 31;
        t1[2] = t1[2] >> 1 | t1[3] << 31;
        t1[3] = t1[3] >> 1 | t1[4] << 31;
        t1[4] = t1[4] >> 1 | t1[5] << 31;
        t1[5] = t1[5] >> 1 | t1[6] << 31;
        t1[6] = t1[6] >> 1 | t1[7] << 31;
        t1[7] = t1[7] >> 1;

        u32 lt = 0;

        for (int i = 7; i >= 0; i--)
        {
          if (t3[i] < t2[i])
          {
            lt = 1;

            break;
          }

          if (t3[i] > t2[i]) break;
        }

        if (lt) add (t3, t3, p);

        sub (t3, t3, t2);

        u32 c = 0;

        if (t3[0] & 1) c = add (t3, t3, p);

        t3[0] = t3[0] >> 1 | t3[1] << 31;
        t3[1] = t3[1] >> 1 | t3[2] << 31;
        t3[2] = t3[2] >> 1 | t3[3] << 31;
        t3[3] = t3[3] >> 1 | t3[4] << 31;
        t3[4] = t3[4] >> 1 | t3[5] << 31;
        t3[5] = t3[5] >> 1 | t3[6] << 31;
        t3[6] = t3[6] >> 1 | t3[7] << 31;
        t3[7] = t3[7] >> 1 | c     << 31;
      }
    }

    // update b:

    b = (t0[0] != t1[0])
      | (t0[1] != t1[1])
      | (t0[2] != t1[2])
      | (t0[3] != t1[3])
      | (t0[4] != t1[4])
      | (t0[5] != t1[5])
      | (t0[6] != t1[6])
      | (t0[7] != t1[7]);
  }

  // set result:

  a[0] = t2[0];
  a[1] = t2[1];
  a[2] = t2[2];
  a[3] = t2[3];
  a[4] = t2[4];
  a[5] = t2[5];
  a[6] = t2[6];
  a[7] = t2[7];
}


DECLSPEC void point_double (u32 *x, u32 *y, u32 *z)
{
  u32 t1[8];

  t1[0] = x[0];
  t1[1] = x[1];
  t1[2] = x[2];
  t1[3] = x[3];
  t1[4] = x[4];
  t1[5] = x[5];
  t1[6] = x[6];
  t1[7] = x[7];

  u32 t2[8];

  t2[0] = y[0];
  t2[1] = y[1];
  t2[2] = y[2];
  t2[3] = y[3];
  t2[4] = y[4];
  t2[5] = y[5];
  t2[6] = y[6];
  t2[7] = y[7];

  u32 t3[8];

  t3[0] = z[0];
  t3[1] = z[1];
  t3[2] = z[2];
  t3[3] = z[3];
  t3[4] = z[4];
  t3[5] = z[5];
  t3[6] = z[6];
  t3[7] = z[7];

  u32 t4[8];
  u32 t5[8];
  u32 t6[8];

  mul_mod (t4, t1, t1); // t4 = x^2

  mul_mod (t5, t2, t2); // t5 = y^2

  mul_mod (t1, t1, t5); // t1 = x*y^2

  mul_mod (t5, t5, t5); // t5 = t5^2 = y^4

  // here the z^2 and z^4 is not needed for a = 0

  mul_mod (t3, t2, t3); // t3 = x * z

  add_mod (t2, t4, t4); // t2 = 2 * t4 = 2 * x^2
  add_mod (t4, t4, t2); // t4 = 3 * t4 = 3 * x^2

  // a * z^4 = 0 * 1^4 = 0

  // don't discard the least significant bit it's important too!

  u32 c = 0;

  if (t4[0] & 1)
  {
    u32 t[8];

    t[0] = SECP256K1_P0;
    t[1] = SECP256K1_P1;
    t[2] = SECP256K1_P2;
    t[3] = SECP256K1_P3;
    t[4] = SECP256K1_P4;
    t[5] = SECP256K1_P5;
    t[6] = SECP256K1_P6;
    t[7] = SECP256K1_P7;

    c = add (t4, t4, t); // t4 + SECP256K1_P
  }

  // right shift (t4 / 2):

  t4[0] = t4[0] >> 1 | t4[1] << 31;
  t4[1] = t4[1] >> 1 | t4[2] << 31;
  t4[2] = t4[2] >> 1 | t4[3] << 31;
  t4[3] = t4[3] >> 1 | t4[4] << 31;
  t4[4] = t4[4] >> 1 | t4[5] << 31;
  t4[5] = t4[5] >> 1 | t4[6] << 31;
  t4[6] = t4[6] >> 1 | t4[7] << 31;
  t4[7] = t4[7] >> 1 | c     << 31;

  mul_mod (t6, t4, t4); // t6 = t4^2 = (3/2 * x^2)^2

  add_mod (t2, t1, t1); // t2 = 2 * t1

  sub_mod (t6, t6, t2); // t6 = t6 - t2
  sub_mod (t1, t1, t6); // t1 = t1 - t6

  mul_mod (t4, t4, t1); // t4 = t4 * t1

  sub_mod (t1, t4, t5); // t1 = t4 - t5

  // => x = t6, y = t1, z = t3:

  x[0] = t6[0];
  x[1] = t6[1];
  x[2] = t6[2];
  x[3] = t6[3];
  x[4] = t6[4];
  x[5] = t6[5];
  x[6] = t6[6];
  x[7] = t6[7];

  y[0] = t1[0];
  y[1] = t1[1];
  y[2] = t1[2];
  y[3] = t1[3];
  y[4] = t1[4];
  y[5] = t1[5];
  y[6] = t1[6];
  y[7] = t1[7];

  z[0] = t3[0];
  z[1] = t3[1];
  z[2] = t3[2];
  z[3] = t3[3];
  z[4] = t3[4];
  z[5] = t3[5];
  z[6] = t3[6];
  z[7] = t3[7];
}

DECLSPEC void point_add (u32 *x1, u32 *y1, u32 *z1, u32 *x2, u32 *y2) // z2 = 1
{

  u32 t1[8];

  t1[0] = x1[0];
  t1[1] = x1[1];
  t1[2] = x1[2];
  t1[3] = x1[3];
  t1[4] = x1[4];
  t1[5] = x1[5];
  t1[6] = x1[6];
  t1[7] = x1[7];

  u32 t2[8];

  t2[0] = y1[0];
  t2[1] = y1[1];
  t2[2] = y1[2];
  t2[3] = y1[3];
  t2[4] = y1[4];
  t2[5] = y1[5];
  t2[6] = y1[6];
  t2[7] = y1[7];

  u32 t3[8];

  t3[0] = z1[0];
  t3[1] = z1[1];
  t3[2] = z1[2];
  t3[3] = z1[3];
  t3[4] = z1[4];
  t3[5] = z1[5];
  t3[6] = z1[6];
  t3[7] = z1[7];

  // x2/y2:

  u32 t4[8];

  t4[0] = x2[0];
  t4[1] = x2[1];
  t4[2] = x2[2];
  t4[3] = x2[3];
  t4[4] = x2[4];
  t4[5] = x2[5];
  t4[6] = x2[6];
  t4[7] = x2[7];

  u32 t5[8];

  t5[0] = y2[0];
  t5[1] = y2[1];
  t5[2] = y2[2];
  t5[3] = y2[3];
  t5[4] = y2[4];
  t5[5] = y2[5];
  t5[6] = y2[6];
  t5[7] = y2[7];

  u32 t6[8];
  u32 t7[8];
  u32 t8[8];
  u32 t9[8];

  mul_mod (t6, t3, t3); // t6 = t3^2

  mul_mod (t7, t6, t3); // t7 = t6*t3
  mul_mod (t6, t6, t4); // t6 = t6*t4
  mul_mod (t7, t7, t5); // t7 = t7*t5

  sub_mod (t6, t6, t1); // t6 = t6-t1
  sub_mod (t7, t7, t2); // t7 = t7-t2

  mul_mod (t8, t3, t6); // t8 = t3*t6
  mul_mod (t4, t6, t6); // t4 = t6^2
  mul_mod (t9, t4, t6); // t9 = t4*t6
  mul_mod (t4, t4, t1); // t4 = t4*t1

  // left shift (t4 * 2):

  t6[7] = t4[7] << 1 | t4[6] >> 31;
  t6[6] = t4[6] << 1 | t4[5] >> 31;
  t6[5] = t4[5] << 1 | t4[4] >> 31;
  t6[4] = t4[4] << 1 | t4[3] >> 31;
  t6[3] = t4[3] << 1 | t4[2] >> 31;
  t6[2] = t4[2] << 1 | t4[1] >> 31;
  t6[1] = t4[1] << 1 | t4[0] >> 31;
  t6[0] = t4[0] << 1;

  // don't discard the most significant bit, it's important too!

  if (t4[7] & 0x80000000)
  {
    // use most significant bit and perform mod P, since we have: t4 * 2 % P

    u32 a[8] = { 0 };

    a[1] = 1;
    a[0] = 0x000003d1; // omega (see: mul_mod ())

    add (t6, t6, a);
  }

  mul_mod (t5, t7, t7); // t5 = t7*t7

  sub_mod (t5, t5, t6); // t5 = t5-t6
  sub_mod (t5, t5, t9); // t5 = t5-t9
  sub_mod (t4, t4, t5); // t4 = t4-t5

  mul_mod (t4, t4, t7); // t4 = t4*t7
  mul_mod (t9, t9, t2); // t9 = t9*t2

  sub_mod (t9, t4, t9); // t9 = t4-t9

  x1[0] = t5[0];
  x1[1] = t5[1];
  x1[2] = t5[2];
  x1[3] = t5[3];
  x1[4] = t5[4];
  x1[5] = t5[5];
  x1[6] = t5[6];
  x1[7] = t5[7];

  y1[0] = t9[0];
  y1[1] = t9[1];
  y1[2] = t9[2];
  y1[3] = t9[3];
  y1[4] = t9[4];
  y1[5] = t9[5];
  y1[6] = t9[6];
  y1[7] = t9[7];

  z1[0] = t8[0];
  z1[1] = t8[1];
  z1[2] = t8[2];
  z1[3] = t8[3];
  z1[4] = t8[4];
  z1[5] = t8[5];
  z1[6] = t8[6];
  z1[7] = t8[7];
}

DECLSPEC void point_mul (__global u32 *r, __global const u32 *k, GLOBAL_AS const secp256k1_t *tmps)
{
  u32 n[9];

  n[0] =    0; // we need this extra slot sometimes for the subtraction to work
  n[1] = k[7];
  n[2] = k[6];
  n[3] = k[5];
  n[4] = k[4];
  n[5] = k[3];
  n[6] = k[2];
  n[7] = k[1];
  n[8] = k[0];

  u32 naf[32 + 1] = { 0 }; // we need one extra slot

  int loop_start = 0;

  for (int i = 0; i <= 256; i++)
  {
    if (n[8] & 1)
    {
      int diff = n[8] & 0x0f; // n % 2^w == n & (2^w - 1)

      int val = diff;

      if (diff >= 0x08)
      {
        diff -= 0x10;

        val = 0x11 - val;
      }

      naf[i >> 3] |= val << ((i & 7) << 2);

      u32 t = n[8]; // t is the (temporary) old/unmodified value

      n[8] -= diff;

      // we need to take care of the carry/borrow:

      u32 k = 8;

      if (diff > 0)
      {
        while (n[k] > t) // overflow propagation
        {
          if (k == 0) break; // needed ?

          k--;

          t = n[k];

          n[k]--;
        }
      }
      else // if (diff < 0)
      {
        while (t > n[k]) // overflow propagation
        {
          if (k == 0) break;

          k--;

          t = n[k];

          n[k]++;
        }
      }

      // update start:

      loop_start = i;
    }

    // n = n / 2:

    n[8] = n[8] >> 1 | n[7] << 31;
    n[7] = n[7] >> 1 | n[6] << 31;
    n[6] = n[6] >> 1 | n[5] << 31;
    n[5] = n[5] >> 1 | n[4] << 31;
    n[4] = n[4] >> 1 | n[3] << 31;
    n[3] = n[3] >> 1 | n[2] << 31;
    n[2] = n[2] >> 1 | n[1] << 31;
    n[1] = n[1] >> 1 | n[0] << 31;
    n[0] = n[0] >> 1;
  }


  // first set:

  const u32 multiplier = (naf[loop_start >> 3] >> ((loop_start & 7) << 2)) & 0x0f; // or use u8 ?

  const u32 odd = multiplier & 1;

  const u32 x_pos = ((multiplier - 1 + odd) >> 1) * 24;
  const u32 y_pos = odd ? (x_pos + 8) : (x_pos + 16);

  u32 x1[8];

  x1[0] = tmps->xy[x_pos + 0];
  x1[1] = tmps->xy[x_pos + 1];
  x1[2] = tmps->xy[x_pos + 2];
  x1[3] = tmps->xy[x_pos + 3];
  x1[4] = tmps->xy[x_pos + 4];
  x1[5] = tmps->xy[x_pos + 5];
  x1[6] = tmps->xy[x_pos + 6];
  x1[7] = tmps->xy[x_pos + 7];

  u32 y1[8];

  y1[0] = tmps->xy[y_pos + 0];
  y1[1] = tmps->xy[y_pos + 1];
  y1[2] = tmps->xy[y_pos + 2];
  y1[3] = tmps->xy[y_pos + 3];
  y1[4] = tmps->xy[y_pos + 4];
  y1[5] = tmps->xy[y_pos + 5];
  y1[6] = tmps->xy[y_pos + 6];
  y1[7] = tmps->xy[y_pos + 7];

  u32 z1[8] = { 0 };

  z1[0] = 1;

  for (int pos = loop_start - 1; pos >= 0; pos--) // -1 because we've set/add the point already
  {
    // always double:

    point_double (x1, y1, z1);

    // add only if needed:

    const u32 multiplier = (naf[pos >> 3] >> ((pos & 7) << 2)) & 0x0f;

    if (multiplier)
    {
      const u32 odd = multiplier & 1;

      const u32 x_pos = ((multiplier - 1 + odd) >> 1) * 24;
      const u32 y_pos = odd ? (x_pos + 8) : (x_pos + 16);

      u32 x2[8];

      x2[0] = tmps->xy[x_pos + 0];
      x2[1] = tmps->xy[x_pos + 1];
      x2[2] = tmps->xy[x_pos + 2];
      x2[3] = tmps->xy[x_pos + 3];
      x2[4] = tmps->xy[x_pos + 4];
      x2[5] = tmps->xy[x_pos + 5];
      x2[6] = tmps->xy[x_pos + 6];
      x2[7] = tmps->xy[x_pos + 7];

      u32 y2[8];

      y2[0] = tmps->xy[y_pos + 0];
      y2[1] = tmps->xy[y_pos + 1];
      y2[2] = tmps->xy[y_pos + 2];
      y2[3] = tmps->xy[y_pos + 3];
      y2[4] = tmps->xy[y_pos + 4];
      y2[5] = tmps->xy[y_pos + 5];
      y2[6] = tmps->xy[y_pos + 6];
      y2[7] = tmps->xy[y_pos + 7];

      // (x1, y1, z1) + multiplier * (x, y, z) = (x1, y1, z1) + (x2, y2, z2)

      point_add (x1, y1, z1, x2, y2);
    }
  }

  inv_mod (z1);

  u32 z2[8];

  mul_mod (z2, z1, z1); // z1^2
  mul_mod (x1, x1, z2); // x1_affine

  mul_mod (z1, z2, z1); // z1^3
  mul_mod (y1, y1, z1); // y1_affine

  r[8] =                (x1[0] << 24);
  r[7] = (x1[0] >> 8) | (x1[1] << 24);
  r[6] = (x1[1] >> 8) | (x1[2] << 24);
  r[5] = (x1[2] >> 8) | (x1[3] << 24);
  r[4] = (x1[3] >> 8) | (x1[4] << 24);
  r[3] = (x1[4] >> 8) | (x1[5] << 24);
  r[2] = (x1[5] >> 8) | (x1[6] << 24);
  r[1] = (x1[6] >> 8) | (x1[7] << 24);
  r[0] = (x1[7] >> 8);

  const u32 type = 0x02 | (y1[0] & 1); // (note: 0b10 | 0b01 = 0x03)

  r[0] = r[0] | type << 24; // 0x02 or 0x03
}

DECLSPEC void set_precomputed_basepoint_g (PRIVATE_AS secp256k1_t *r)
{
  // x1
  r->xy[ 0] = SECP256K1_G_PRE_COMPUTED_00;
  r->xy[ 1] = SECP256K1_G_PRE_COMPUTED_01;
  r->xy[ 2] = SECP256K1_G_PRE_COMPUTED_02;
  r->xy[ 3] = SECP256K1_G_PRE_COMPUTED_03;
  r->xy[ 4] = SECP256K1_G_PRE_COMPUTED_04;
  r->xy[ 5] = SECP256K1_G_PRE_COMPUTED_05;
  r->xy[ 6] = SECP256K1_G_PRE_COMPUTED_06;
  r->xy[ 7] = SECP256K1_G_PRE_COMPUTED_07;

  // y1
  r->xy[ 8] = SECP256K1_G_PRE_COMPUTED_08;
  r->xy[ 9] = SECP256K1_G_PRE_COMPUTED_09;
  r->xy[10] = SECP256K1_G_PRE_COMPUTED_10;
  r->xy[11] = SECP256K1_G_PRE_COMPUTED_11;
  r->xy[12] = SECP256K1_G_PRE_COMPUTED_12;
  r->xy[13] = SECP256K1_G_PRE_COMPUTED_13;
  r->xy[14] = SECP256K1_G_PRE_COMPUTED_14;
  r->xy[15] = SECP256K1_G_PRE_COMPUTED_15;

  // -y1
  r->xy[16] = SECP256K1_G_PRE_COMPUTED_16;
  r->xy[17] = SECP256K1_G_PRE_COMPUTED_17;
  r->xy[18] = SECP256K1_G_PRE_COMPUTED_18;
  r->xy[19] = SECP256K1_G_PRE_COMPUTED_19;
  r->xy[20] = SECP256K1_G_PRE_COMPUTED_20;
  r->xy[21] = SECP256K1_G_PRE_COMPUTED_21;
  r->xy[22] = SECP256K1_G_PRE_COMPUTED_22;
  r->xy[23] = SECP256K1_G_PRE_COMPUTED_23;

  // x3
  r->xy[24] = SECP256K1_G_PRE_COMPUTED_24;
  r->xy[25] = SECP256K1_G_PRE_COMPUTED_25;
  r->xy[26] = SECP256K1_G_PRE_COMPUTED_26;
  r->xy[27] = SECP256K1_G_PRE_COMPUTED_27;
  r->xy[28] = SECP256K1_G_PRE_COMPUTED_28;
  r->xy[29] = SECP256K1_G_PRE_COMPUTED_29;
  r->xy[30] = SECP256K1_G_PRE_COMPUTED_30;
  r->xy[31] = SECP256K1_G_PRE_COMPUTED_31;

  // y3
  r->xy[32] = SECP256K1_G_PRE_COMPUTED_32;
  r->xy[33] = SECP256K1_G_PRE_COMPUTED_33;
  r->xy[34] = SECP256K1_G_PRE_COMPUTED_34;
  r->xy[35] = SECP256K1_G_PRE_COMPUTED_35;
  r->xy[36] = SECP256K1_G_PRE_COMPUTED_36;
  r->xy[37] = SECP256K1_G_PRE_COMPUTED_37;
  r->xy[38] = SECP256K1_G_PRE_COMPUTED_38;
  r->xy[39] = SECP256K1_G_PRE_COMPUTED_39;

  // -y3
  r->xy[40] = SECP256K1_G_PRE_COMPUTED_40;
  r->xy[41] = SECP256K1_G_PRE_COMPUTED_41;
  r->xy[42] = SECP256K1_G_PRE_COMPUTED_42;
  r->xy[43] = SECP256K1_G_PRE_COMPUTED_43;
  r->xy[44] = SECP256K1_G_PRE_COMPUTED_44;
  r->xy[45] = SECP256K1_G_PRE_COMPUTED_45;
  r->xy[46] = SECP256K1_G_PRE_COMPUTED_46;
  r->xy[47] = SECP256K1_G_PRE_COMPUTED_47;

  // x5
  r->xy[48] = SECP256K1_G_PRE_COMPUTED_48;
  r->xy[49] = SECP256K1_G_PRE_COMPUTED_49;
  r->xy[50] = SECP256K1_G_PRE_COMPUTED_50;
  r->xy[51] = SECP256K1_G_PRE_COMPUTED_51;
  r->xy[52] = SECP256K1_G_PRE_COMPUTED_52;
  r->xy[53] = SECP256K1_G_PRE_COMPUTED_53;
  r->xy[54] = SECP256K1_G_PRE_COMPUTED_54;
  r->xy[55] = SECP256K1_G_PRE_COMPUTED_55;

  // y5
  r->xy[56] = SECP256K1_G_PRE_COMPUTED_56;
  r->xy[57] = SECP256K1_G_PRE_COMPUTED_57;
  r->xy[58] = SECP256K1_G_PRE_COMPUTED_58;
  r->xy[59] = SECP256K1_G_PRE_COMPUTED_59;
  r->xy[60] = SECP256K1_G_PRE_COMPUTED_60;
  r->xy[61] = SECP256K1_G_PRE_COMPUTED_61;
  r->xy[62] = SECP256K1_G_PRE_COMPUTED_62;
  r->xy[63] = SECP256K1_G_PRE_COMPUTED_63;

  // -y5
  r->xy[64] = SECP256K1_G_PRE_COMPUTED_64;
  r->xy[65] = SECP256K1_G_PRE_COMPUTED_65;
  r->xy[66] = SECP256K1_G_PRE_COMPUTED_66;
  r->xy[67] = SECP256K1_G_PRE_COMPUTED_67;
  r->xy[68] = SECP256K1_G_PRE_COMPUTED_68;
  r->xy[69] = SECP256K1_G_PRE_COMPUTED_69;
  r->xy[70] = SECP256K1_G_PRE_COMPUTED_70;
  r->xy[71] = SECP256K1_G_PRE_COMPUTED_71;

  // x7
  r->xy[72] = SECP256K1_G_PRE_COMPUTED_72;
  r->xy[73] = SECP256K1_G_PRE_COMPUTED_73;
  r->xy[74] = SECP256K1_G_PRE_COMPUTED_74;
  r->xy[75] = SECP256K1_G_PRE_COMPUTED_75;
  r->xy[76] = SECP256K1_G_PRE_COMPUTED_76;
  r->xy[77] = SECP256K1_G_PRE_COMPUTED_77;
  r->xy[78] = SECP256K1_G_PRE_COMPUTED_78;
  r->xy[79] = SECP256K1_G_PRE_COMPUTED_79;

  // y7
  r->xy[80] = SECP256K1_G_PRE_COMPUTED_80;
  r->xy[81] = SECP256K1_G_PRE_COMPUTED_81;
  r->xy[82] = SECP256K1_G_PRE_COMPUTED_82;
  r->xy[83] = SECP256K1_G_PRE_COMPUTED_83;
  r->xy[84] = SECP256K1_G_PRE_COMPUTED_84;
  r->xy[85] = SECP256K1_G_PRE_COMPUTED_85;
  r->xy[86] = SECP256K1_G_PRE_COMPUTED_86;
  r->xy[87] = SECP256K1_G_PRE_COMPUTED_87;

  // -y7
  r->xy[88] = SECP256K1_G_PRE_COMPUTED_88;
  r->xy[89] = SECP256K1_G_PRE_COMPUTED_89;
  r->xy[90] = SECP256K1_G_PRE_COMPUTED_90;
  r->xy[91] = SECP256K1_G_PRE_COMPUTED_91;
  r->xy[92] = SECP256K1_G_PRE_COMPUTED_92;
  r->xy[93] = SECP256K1_G_PRE_COMPUTED_93;
  r->xy[94] = SECP256K1_G_PRE_COMPUTED_94;
  r->xy[95] = SECP256K1_G_PRE_COMPUTED_95;
}

__kernel void compute(__global const unsigned int* input, __global unsigned int* pubkey) {
    int gid = get_global_id(0);

    secp256k1_t preG;
    set_precomputed_basepoint_g (&preG);

    // 每个工作项处理一个独立的数据块
    __global const unsigned int* prikey = input + gid * 8;
    __global unsigned int* out = pubkey + gid * 16; // 公钥占用33字节，这里为对齐分配64字节

    point_mul(out, prikey, &preG);
}
