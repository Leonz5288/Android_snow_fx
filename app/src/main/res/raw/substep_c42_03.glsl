#version 310 es
layout(local_size_x = 128, local_size_y = 1, local_size_z = 1) in;
precision highp float;
layout(std430, binding = 0) buffer data_i32 { int _data_i32_[];}; 
layout(std430, binding = 0) buffer data_f32 { float _data_f32_[];}; 
layout(std430, binding = 1) buffer gtmp_i32 { int _gtmp_i32_[];}; 
layout(std430, binding = 1) buffer gtmp_f32 { float _gtmp_f32_[];}; 
layout(std430, binding = 2) buffer args_i32 { int _args_i32_[];}; 
layout(std430, binding = 2) buffer args_f32 { float _args_f32_[];}; 
float atomicAdd_data_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _data_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) + rhs)); } while (old_val != atomicCompSwap(_data_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicSub_data_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _data_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) - rhs)); } while (old_val != atomicCompSwap(_data_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMax_data_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _data_i32_[addr]; new_val = floatBitsToInt(max(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_data_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMin_data_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _data_i32_[addr]; new_val = floatBitsToInt(min(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_data_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); }float atomicAdd_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) + rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicSub_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) - rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMax_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt(max(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMin_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt(min(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); }
const float inf = 1.0f / 0.0f;
const float nan = 0.0f / 0.0f;
void substep_c42_03()
{ // range for
  // range known at compile time
  int _sid0 = int(gl_GlobalInvocationID.x);
  for (int _sid = _sid0; _sid < (8192); _sid += int(gl_WorkGroupSize.x * gl_NumWorkGroups.x)) {
    int _itv = 0 + _sid;
      int CJL = int(0);
      int CA9 = int(127);
      int CA5 = int(63);
      float Jc = float(-0.005);
      float Jb = float(0.0125);
      float Ja = float(0.1);
      float J9 = float(1e-08);
      float J8 = float(1.0);
      float J7 = float(0.5);
      int J6 = int(37);
      int J5 = int(3);
      int J4 = int(77);
      int J3 = int(1);
      float J2 = float(0.0);
      int IL = _itv;
      int Cxl = int(7);
      int Cxm = IL >> Cxl;
      int Cxo = Cxm & CA5;
      int Cxs = IL & CA9;
      int IV = int(40);
      int IW = -int(Cxo < IV);
      int IY = int(80);
      int IZ = -int(Cxs < IY);
      int J0 = IW & IZ;
      if (J0 != 0) {
        int ChP = 0;
        int ChR = ChP + 1019908 * CJL; // S0
        int ChS = ChR + 4100; // S26
        int CQi = Cxo << Cxl;
        int CJS = Cxs + CQi;
        int ChW = ChS + 4 * CJS; // S26
        int ChX = ChW + 0; // S27
        float Je = _data_f32_[ChX >> 2];
        int Jf = -int(Je > J2);
        int Jg = Jf & J3;
        if (Jg != 0) {
          float Ji = _data_f32_[ChX >> 2];
          float Jj = J8 / Ji;
          int Cig = ChR + 167940; // S23
          int Cik = Cig + 8 * CJS; // S23
          int Cil = Cik + 0; // S24
          float Jl = _data_f32_[Cil >> 2];
          float Jm = Jj * Jl;
          int Cix = Cik + 4; // S25
          float Jo = _data_f32_[Cix >> 2];
          float Jp = Jj * Jo;
          _data_f32_[Cil >> 2] = Jm;
          _data_f32_[Cix >> 2] = Jp;
          float Js = _data_f32_[Cix >> 2];
          float Jt = Js + Jc;
          _data_f32_[Cix >> 2] = Jt;
          float Jv = float(Cxo);
          float Jw = Jv * Jb;
          float Jx = float(Cxs);
          float Jy = Jx * Jb;
          float Jz = _args_f32_[0 << 1];
          float JA = _args_f32_[1 << 1];
          float JB = Jw - Jz;
          float JC = Jy - JA;
          float JD = JB * JB;
          float JE = JC * JC;
          float JF = JD + JE;
          float JG = float(sqrt(JF));
          int JH = -int(JG < Ja);
          int JI = JH & J3;
          if (JI != 0) {
            float JK = JG + J9;
            float JL = J8 / JK;
            float JM = JL * JB;
            float JN = JL * JC;
            float JO = _args_f32_[2 << 1];
            float JP = _args_f32_[3 << 1];
            float JQ = float(0);
            float JR = _data_f32_[Cil >> 2];
            float JS = JR - JO;
            JQ = JS;
            float JU = float(0);
            float JV = _data_f32_[Cix >> 2];
            float JW = JV - JP;
            JU = JW;
            float JY = JS * JM;
            float JZ = JW * JN;
            float K0 = JY + JZ;
            int K1 = -int(K0 < J2);
            int K2 = K1 & J3;
            if (K2 != 0) {
              float K4 = K0 * JM;
              float K5 = K0 * JN;
              float K6 = JS - K4;
              float K7 = JW - K5;
              float K8 = K6 * K6;
              float K9 = K7 * K7;
              float Ka = K8 + K9;
              float Kb = float(sqrt(Ka));
              float Kc = float(-K0);
              float Kd = Kc * J7;
              int Ke = -int(Kb < Kd);
              int Kf = Ke & J3;
              if (Kf != 0) {
                JQ = J2;
                JU = J2;
              } else {
                float Kj = K0 * J7;
                float Kk = Kj / Kb;
                float Kl = Kk * K6;
                float Km = Kk * K7;
                float Kn = K6 + Kl;
                float Ko = K7 + Km;
                JQ = Kn;
                JU = Ko;
              }
            }
            float Kr = JQ;
            float Ks = Kr + JO;
            float Kt = JU;
            float Ku = Kt + JP;
            _data_f32_[Cil >> 2] = Ks;
            _data_f32_[Cix >> 2] = Ku;
          }
          int Kx = -int(Cxo < J5);
          int Ky = Kx & J3;
          float Kz = _data_f32_[Cil >> 2];
          int KA = -int(Kz < J2);
          int KB = KA & J3;
          int KC = Ky & KB;
          if (KC != 0) {
            _data_f32_[Cil >> 2] = J2;
          }
          int KF = -int(Cxo > J6);
          int KG = KF & J3;
          float KH = _data_f32_[Cil >> 2];
          int KI = -int(KH > J2);
          int KJ = KI & J3;
          int KK = KG & KJ;
          if (KK != 0) {
            _data_f32_[Cil >> 2] = J2;
          }
          int KN = -int(Cxs < J5);
          int KO = KN & J3;
          float KP = _data_f32_[Cix >> 2];
          int KQ = -int(KP < J2);
          int KR = KQ & J3;
          int KS = KO & KR;
          if (KS != 0) {
            _data_f32_[Cil >> 2] = J2;
            _data_f32_[Cix >> 2] = J2;
          }
          int KW = -int(Cxs > J4);
          int KX = KW & J3;
          float KY = _data_f32_[Cix >> 2];
          int KZ = -int(KY > J2);
          int L0 = KZ & J3;
          int L1 = KX & L0;
          if (L1 != 0) {
            _data_f32_[Cix >> 2] = J2;
          }
        }
      }
  }
}

void main()
{
  substep_c42_03();
}
