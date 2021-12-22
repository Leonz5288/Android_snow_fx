#version 310 es
layout(local_size_x = 128, local_size_y = 1, local_size_z = 1) in;
precision highp float;
layout(std430, binding = 0) buffer data_i32 { int _data_i32_[];}; 
layout(std430, binding = 0) buffer data_f32 { float _data_f32_[];}; 
layout(std430, binding = 1) buffer gtmp_i32 { int _gtmp_i32_[];}; 
layout(std430, binding = 1) buffer gtmp_f32 { float _gtmp_f32_[];}; 
float atomicAdd_data_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _data_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) + rhs)); } while (old_val != atomicCompSwap(_data_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicSub_data_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _data_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) - rhs)); } while (old_val != atomicCompSwap(_data_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMax_data_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _data_i32_[addr]; new_val = floatBitsToInt(max(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_data_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMin_data_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _data_i32_[addr]; new_val = floatBitsToInt(min(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_data_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); }float atomicAdd_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) + rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicSub_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) - rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMax_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt(max(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMin_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt(min(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); }
const float inf = 1.0f / 0.0f;
const float nan = 0.0f / 0.0f;
void substep_c42_02()
{ // range for
  // range known at runtime
  int _beg = 0, _end = _gtmp_i32_[0 >> 2];
  int _sid0 = int(gl_GlobalInvocationID.x);
  for (int _sid = _sid0; _sid < (_end - _beg); _sid += int(gl_WorkGroupSize.x * gl_NumWorkGroups.x)) {
    int _itv = _beg + _sid;
      int Ctr = int(16383);
      int Ax = int(1);
      float Ay = float(0.0);
      float Az = float(1.0045);
      float AA = float(0.975);
      float AB = float(1.0);
      float AC = float(0.5);
      float AD = float(0.3);
      int AE = _itv;
      int C7q = 0;
      int CDH = int(0);
      int C7s = C7q + 1019908 * CDH; // S0
      int C7t = C7s + 233476; // S1
      int CrQ = AE & Ctr;
      int C7w = C7t + 8 * CrQ; // S1
      int C7x = C7w + 0; // S2
      float AG = _data_f32_[C7x >> 2];
      float AH = float(80.0);
      float AI = AG * AH;
      int C7H = C7w + 4; // S3
      float AK = _data_f32_[C7H >> 2];
      float AL = AK * AH;
      float AM = AI - AC;
      float AN = AL - AC;
      int AO = int(AM);
      int AP = int(AN);
      float AQ = float(AO);
      float AR = float(AP);
      float AS = AI - AQ;
      float AT = AL - AR;
      float AU = float(1.5);
      float AV = AU - AS;
      float AW = AU - AT;
      float AX = AV * AV;
      float AY = AW * AW;
      float AZ = AX * AC;
      float B0 = AY * AC;
      float B1 = AS - AB;
      float B2 = AT - AB;
      float B3 = B1 * B1;
      float B4 = B2 * B2;
      float B5 = float(0.75);
      float B6 = B5 - B3;
      float B7 = B5 - B4;
      float B8 = AS - AC;
      float B9 = AT - AC;
      float Ba = B8 * B8;
      float Bb = B9 * B9;
      float Bc = Ba * AC;
      float Bd = Bb * AC;
      int C7N = C7s + 495620; // S7
      int C7Q = C7N + 16 * CrQ; // S7
      int C7R = C7Q + 0; // S8
      float Bf = _data_f32_[C7R >> 2];
      float Bg = float(0.0001);
      float Bh = Bf * Bg;
      int C81 = C7Q + 4; // S9
      float Bj = _data_f32_[C81 >> 2];
      float Bk = Bj * Bg;
      int C8b = C7Q + 8; // S10
      float Bm = _data_f32_[C8b >> 2];
      float Bn = Bm * Bg;
      int C8l = C7Q + 12; // S11
      float Bp = _data_f32_[C8l >> 2];
      float Bq = Bp * Bg;
      float Br = Bh + AB;
      float Bs = Bq + AB;
      int C8r = C7s + 757764; // S12
      int C8u = C8r + 16 * CrQ; // S12
      int C8v = C8u + 0; // S13
      float Bu = _data_f32_[C8v >> 2];
      float Bv = Br * Bu;
      int C8F = C8u + 8; // S15
      float Bx = _data_f32_[C8F >> 2];
      float By = Bk * Bx;
      float Bz = Bv + By;
      int C8P = C8u + 4; // S14
      float BB = _data_f32_[C8P >> 2];
      float BC = Br * BB;
      int C8Z = C8u + 12; // S16
      float BE = _data_f32_[C8Z >> 2];
      float BF = Bk * BE;
      float BG = BC + BF;
      float BH = Bn * Bu;
      float BI = Bs * Bx;
      float BJ = BH + BI;
      float BK = Bn * BB;
      float BL = Bs * BE;
      float BM = BK + BL;
      _data_f32_[C8v >> 2] = Bz;
      _data_f32_[C8P >> 2] = BG;
      _data_f32_[C8F >> 2] = BJ;
      _data_f32_[C8Z >> 2] = BM;
      float BR = float(0);
      int C9J = C7s + 102404; // S19
      int C9M = C9J + 4 * CrQ; // S19
      int C9N = C9M + 0; // S20
      float BT = _data_f32_[C9N >> 2];
      float BU = AB - BT;
      float BV = float(10.0);
      float BW = BU * BV;
      float BX = float(exp(BW));
      float BY = float(15.0);
      float BZ = float(min(BX, BY));
      BR = BZ;
      int C9T = C7s + 36868; // S17
      int C9W = C9T + 4 * CrQ; // S17
      int C9X = C9W + 0; // S18
      int C2 = _data_i32_[C9X >> 2];
      int C3 = int(2);
      int C4 = -int(C2 >= C3);
      int C5 = C4 & Ax;
      if (C5 != 0) {
        BR = AD;
      }
      float C8 = BR;
      float C9 = float(625.0);
      float Ca = C8 * C9;
      float Cb = float(0);
      Cb = Ca;
      int Ce = -int(C2 == CDH);
      int Cf = Ce & Ax;
      if (Cf != 0) {
        Cb = Ay;
      }
      float Ci = Bz + BM;
      float Cj = BJ - BG;
      float Ck = Ci * Ci;
      float Cl = Cj * Cj;
      float Cm = Ck + Cl;
      float Cn = float(sqrt(Cm));
      float Co = AB / Cn;
      float Cp = Ci * Co;
      float Cq = Cj * Co;
      float Cr = float(-Cq);
      float Cs = Cp * Bz;
      float Ct = Cq * BJ;
      float Cu = Cs + Ct;
      float Cv = Cp * BG;
      float Cw = Cq * BM;
      float Cx = Cv + Cw;
      float Cy = Cr * BG;
      float Cz = Cp * BM;
      float CA = Cy + Cz;
      float CB = float(0);
      float CC = float(0);
      float CD = float(0);
      float CE = float(0);
      float CF = float(abs(Cx));
      float CG = float(1e-05);
      int CH = -int(CF < CG);
      int CI = CH & Ax;
      if (CI != 0) {
        CB = AB;
        CD = Cu;
        CE = CA;
      } else {
        float CN = Cu - CA;
        float CO = CN * AC;
        float CP = CO * CO;
        float CQ = Cx * Cx;
        float CR = CP + CQ;
        float CS = float(sqrt(CR));
        float CT = float(0);
        int CU = -int(CO > Ay);
        int CV = CU & Ax;
        if (CV != 0) {
          float CX = CO + CS;
          float CY = Cx / CX;
          CT = CY;
        } else {
          float D0 = CO - CS;
          float D1 = Cx / D0;
          CT = D1;
        }
        float D3 = CT;
        float D4 = D3 * D3;
        float D5 = D4 + AB;
        float D6 = float(sqrt(D5));
        float D7 = AB / D6;
        CB = D7;
        float D9 = float(-D3);
        float Da = D9 * D7;
        CC = Da;
        float Dc = D7 * D7;
        float Dd = Dc * Cu;
        float De = D7 + D7;
        float Df = De * Da;
        float Dg = Df * Cx;
        float Dh = Dd - Dg;
        float Di = Da * Da;
        float Dj = Di * CA;
        float Dk = Dh + Dj;
        CD = Dk;
        float Dm = Di * Cu;
        float Dn = Dm + Dg;
        float Do = Dc * CA;
        float Dp = Dn + Do;
        CE = Dp;
      }
      float Dr = float(0);
      float Ds = float(0);
      float Dt = float(0);
      float Du = float(0);
      float Dv = CD;
      float Dw = CE;
      int Dx = -int(Dv < Dw);
      int Dy = Dx & Ax;
      if (Dy != 0) {
        float DA = CD;
        float DB = CE;
        CD = DB;
        CE = DA;
        float DE = CC;
        float DF = float(-DE);
        float DG = CB;
        float DH = float(-DG);
        Dr = DF;
        Ds = DG;
        Dt = DH;
        Du = DF;
      } else {
        float DM = CB;
        float DN = CC;
        float DO = float(-DN);
        Dr = DM;
        Ds = DN;
        Dt = DO;
        Du = DM;
      }
      float DT = Dr;
      float DU = Cp * DT;
      float DV = Dt;
      float DW = Cr * DV;
      float DX = DU + DW;
      float DY = Ds;
      float DZ = Cp * DY;
      float E0 = Du;
      float E1 = Cr * E0;
      float E2 = DZ + E1;
      float E3 = Cq * DT;
      float E4 = Cp * DV;
      float E5 = E3 + E4;
      float E6 = Cq * DY;
      float E7 = Cp * E0;
      float E8 = E6 + E7;
      float E9 = CD;
      float Ea = CE;
      float Eb = float(0);
      Eb = E9;
      int Ed = -int(C2 == Ax);
      int Ee = Ed & Ax;
      if (Ee != 0) {
        float Eg = float(max(E9, AA));
        float Eh = float(min(Eg, Az));
        Eb = Eh;
      }
      float Ej = Eb;
      float Ek = E9 / Ej;
      float El = BT * Ek;
      float Em = float(0);
      Em = Ea;
      if (Ee != 0) {
        float Ep = float(max(Ea, AA));
        float Eq = float(min(Ep, Az));
        Em = Eq;
      }
      float Es = Em;
      float Et = Ea / Es;
      float Eu = El * Et;
      _data_f32_[C9N >> 2] = Eu;
      float Ew = Ej * Es;
      if (Cf != 0) {
        float Ey = float(sqrt(Ew));
        _data_f32_[C8v >> 2] = Ey;
        _data_f32_[C8P >> 2] = Ay;
        _data_f32_[C8F >> 2] = Ay;
        _data_f32_[C8Z >> 2] = Ey;
      } else {
        int ED = _data_i32_[C9X >> 2];
        int EE = -int(ED == Ax);
        int EF = EE & Ax;
        if (EF != 0) {
          float EH = DX * Ej;
          float EI = E2 * Es;
          float EJ = E5 * Ej;
          float EK = E8 * Es;
          float EL = Dr;
          float EM = Dt;
          float EN = Ds;
          float EO = Du;
          float EP = EH * EL;
          float EQ = EI * EN;
          float ER = EP + EQ;
          float ES = EH * EM;
          float ET = EI * EO;
          float EU = ES + ET;
          float EV = EJ * EL;
          float EW = EK * EN;
          float EX = EV + EW;
          float EY = EJ * EM;
          float EZ = EK * EO;
          float F0 = EY + EZ;
          _data_f32_[C8v >> 2] = ER;
          _data_f32_[C8P >> 2] = EU;
          _data_f32_[C8F >> 2] = EX;
          _data_f32_[C8Z >> 2] = F0;
        }
      }
      float F5 = Dr;
      float F6 = Dt;
      float F7 = Ds;
      float F8 = Du;
      float F9 = DX * F5;
      float Fa = E2 * F7;
      float Fb = F9 + Fa;
      float Fc = DX * F6;
      float Fd = E2 * F8;
      float Fe = Fc + Fd;
      float Ff = E5 * F5;
      float Fg = E8 * F7;
      float Fh = Ff + Fg;
      float Fi = E5 * F6;
      float Fj = E8 * F8;
      float Fk = Fi + Fj;
      float Fl = _data_f32_[C8v >> 2];
      float Fm = Fl - Fb;
      float Fn = _data_f32_[C8P >> 2];
      float Fo = Fn - Fe;
      float Fp = _data_f32_[C8F >> 2];
      float Fq = Fp - Fh;
      float Fr = _data_f32_[C8Z >> 2];
      float Fs = Fr - Fk;
      float Ft = Cb;
      float Fu = Ft + Ft;
      float Fv = Fu * Fm;
      float Fw = Fu * Fo;
      float Fx = Fu * Fq;
      float Fy = Fu * Fs;
      float Fz = Fv * Fl;
      float FA = Fw * Fn;
      float FB = Fz + FA;
      float FC = Fv * Fp;
      float FD = Fw * Fr;
      float FE = FC + FD;
      float FF = Fx * Fl;
      float FG = Fy * Fn;
      float FH = FF + FG;
      float FI = Fx * Fp;
      float FJ = Fy * Fr;
      float FK = FI + FJ;
      float FL = float(416.66666);
      float FM = C8 * FL;
      float FN = FM * Ew;
      float FO = Ew - AB;
      float FP = FN * FO;
      float FQ = FB + FP;
      float FR = FK + FP;
      float FS = float(-0.0001);
      float FT = FQ * FS;
      float FU = FE * FS;
      float FV = FH * FS;
      float FW = FR * FS;
      float FX = float(3.90625e-05);
      float FY = Bf * FX;
      float FZ = Bj * FX;
      float G0 = Bm * FX;
      float G1 = Bp * FX;
      float G2 = FT + FY;
      float G3 = FU + FZ;
      float G4 = FV + G0;
      float G5 = FW + G1;
      float G6 = Ay - AS;
      float G7 = Ay - AT;
      float G8 = float(0.0125);
      float G9 = G6 * G8;
      float Ga = G7 * G8;
      float Gb = AZ * B0;
      int Ccj = C7s + 364548; // S4
      int Ccm = Ccj + 8 * CrQ; // S4
      int Ccn = Ccm + 0; // S5
      float Gd = _data_f32_[Ccn >> 2];
      float Ge = Gd * FX;
      int Ccx = Ccm + 4; // S6
      float Gg = _data_f32_[Ccx >> 2];
      float Gh = Gg * FX;
      float Gi = G2 * G9;
      float Gj = G3 * Ga;
      float Gk = Gi + Gj;
      float Gl = G4 * G9;
      float Gm = G5 * Ga;
      float Gn = Gl + Gm;
      float Go = Ge + Gk;
      float Gp = Gh + Gn;
      float Gq = Gb * Go;
      float Gr = Gb * Gp;
      int CcE = C7s + 167940; // S23
      int CtT = int(63);
      int CtU = AO & CtT;
      int CtX = int(127);
      int CtY = AP & CtX;
      int CQb = int(7);
      int CQc = CtU << CQb;
      int CFF = CtY + CQc;
      int CcI = CcE + 8 * CFF; // S23
      int CcJ = CcI + 0; // S24
      float Gt;
      { // Begin Atomic Op
      Gt = atomicAdd_data_f32(CcJ >> 2, Gq);
      } // End Atomic Op
      int CcV = CcI + 4; // S25
      float Gv;
      { // Begin Atomic Op
      Gv = atomicAdd_data_f32(CcV >> 2, Gr);
      } // End Atomic Op
      float Gw = Gb * FX;
      int Cd2 = C7s + 4100; // S26
      int Cd6 = Cd2 + 4 * CFF; // S26
      int Cd7 = Cd6 + 0; // S27
      float Gy;
      { // Begin Atomic Op
      Gy = atomicAdd_data_f32(Cd7 >> 2, Gw);
      } // End Atomic Op
      float Gz = AB - AT;
      float GA = Gz * G8;
      float GB = AZ * B7;
      int GC = AP + Ax;
      float GD = G3 * GA;
      float GE = Gi + GD;
      float GF = G5 * GA;
      float GG = Gl + GF;
      float GH = Ge + GE;
      float GI = Gh + GG;
      float GJ = GB * GH;
      float GK = GB * GI;
      int Cum = GC & CtX;
      int CG3 = Cum + CQc;
      int Cdi = CcE + 8 * CG3; // S23
      int Cdj = Cdi + 0; // S24
      float GM;
      { // Begin Atomic Op
      GM = atomicAdd_data_f32(Cdj >> 2, GJ);
      } // End Atomic Op
      int Cdv = Cdi + 4; // S25
      float GO;
      { // Begin Atomic Op
      GO = atomicAdd_data_f32(Cdv >> 2, GK);
      } // End Atomic Op
      float GP = GB * FX;
      int CdG = Cd2 + 4 * CG3; // S26
      int CdH = CdG + 0; // S27
      float GR;
      { // Begin Atomic Op
      GR = atomicAdd_data_f32(CdH >> 2, GP);
      } // End Atomic Op
      float GS = float(2.0);
      float GT = GS - AT;
      float GU = GT * G8;
      float GV = AZ * Bd;
      int GW = AP + C3;
      float GX = G3 * GU;
      float GY = Gi + GX;
      float GZ = G5 * GU;
      float H0 = Gl + GZ;
      float H1 = Ge + GY;
      float H2 = Gh + H0;
      float H3 = GV * H1;
      float H4 = GV * H2;
      int CuK = GW & CtX;
      int CGr = CuK + CQc;
      int CdS = CcE + 8 * CGr; // S23
      int CdT = CdS + 0; // S24
      float H6;
      { // Begin Atomic Op
      H6 = atomicAdd_data_f32(CdT >> 2, H3);
      } // End Atomic Op
      int Ce5 = CdS + 4; // S25
      float H8;
      { // Begin Atomic Op
      H8 = atomicAdd_data_f32(Ce5 >> 2, H4);
      } // End Atomic Op
      float H9 = GV * FX;
      int Ceg = Cd2 + 4 * CGr; // S26
      int Ceh = Ceg + 0; // S27
      float Hb;
      { // Begin Atomic Op
      Hb = atomicAdd_data_f32(Ceh >> 2, H9);
      } // End Atomic Op
      float Hc = AB - AS;
      float Hd = Hc * G8;
      float He = B6 * B0;
      int Hf = AO + Ax;
      float Hg = G2 * Hd;
      float Hh = Hg + Gj;
      float Hi = G4 * Hd;
      float Hj = Hi + Gm;
      float Hk = Ge + Hh;
      float Hl = Gh + Hj;
      float Hm = He * Hk;
      float Hn = He * Hl;
      int Cv4 = Hf & CtT;
      int CQe = Cv4 << CQb;
      int CGP = CtY + CQe;
      int Ces = CcE + 8 * CGP; // S23
      int Cet = Ces + 0; // S24
      float Hp;
      { // Begin Atomic Op
      Hp = atomicAdd_data_f32(Cet >> 2, Hm);
      } // End Atomic Op
      int CeF = Ces + 4; // S25
      float Hr;
      { // Begin Atomic Op
      Hr = atomicAdd_data_f32(CeF >> 2, Hn);
      } // End Atomic Op
      float Hs = He * FX;
      int CeQ = Cd2 + 4 * CGP; // S26
      int CeR = CeQ + 0; // S27
      float Hu;
      { // Begin Atomic Op
      Hu = atomicAdd_data_f32(CeR >> 2, Hs);
      } // End Atomic Op
      float Hv = B6 * B7;
      float Hw = Hg + GD;
      float Hx = Hi + GF;
      float Hy = Ge + Hw;
      float Hz = Gh + Hx;
      float HA = Hv * Hy;
      float HB = Hv * Hz;
      int CHd = Cum + CQe;
      int Cf2 = CcE + 8 * CHd; // S23
      int Cf3 = Cf2 + 0; // S24
      float HD;
      { // Begin Atomic Op
      HD = atomicAdd_data_f32(Cf3 >> 2, HA);
      } // End Atomic Op
      int Cff = Cf2 + 4; // S25
      float HF;
      { // Begin Atomic Op
      HF = atomicAdd_data_f32(Cff >> 2, HB);
      } // End Atomic Op
      float HG = Hv * FX;
      int Cfq = Cd2 + 4 * CHd; // S26
      int Cfr = Cfq + 0; // S27
      float HI;
      { // Begin Atomic Op
      HI = atomicAdd_data_f32(Cfr >> 2, HG);
      } // End Atomic Op
      float HJ = B6 * Bd;
      float HK = Hg + GX;
      float HL = Hi + GZ;
      float HM = Ge + HK;
      float HN = Gh + HL;
      float HO = HJ * HM;
      float HP = HJ * HN;
      int CHB = CuK + CQe;
      int CfC = CcE + 8 * CHB; // S23
      int CfD = CfC + 0; // S24
      float HR;
      { // Begin Atomic Op
      HR = atomicAdd_data_f32(CfD >> 2, HO);
      } // End Atomic Op
      int CfP = CfC + 4; // S25
      float HT;
      { // Begin Atomic Op
      HT = atomicAdd_data_f32(CfP >> 2, HP);
      } // End Atomic Op
      float HU = HJ * FX;
      int Cg0 = Cd2 + 4 * CHB; // S26
      int Cg1 = Cg0 + 0; // S27
      float HW;
      { // Begin Atomic Op
      HW = atomicAdd_data_f32(Cg1 >> 2, HU);
      } // End Atomic Op
      float HX = GS - AS;
      float HY = HX * G8;
      float HZ = Bc * B0;
      int I0 = AO + C3;
      float I1 = G2 * HY;
      float I2 = I1 + Gj;
      float I3 = G4 * HY;
      float I4 = I3 + Gm;
      float I5 = Ge + I2;
      float I6 = Gh + I4;
      float I7 = HZ * I5;
      float I8 = HZ * I6;
      int Cwe = I0 & CtT;
      int CQg = Cwe << CQb;
      int CHZ = CtY + CQg;
      int Cgc = CcE + 8 * CHZ; // S23
      int Cgd = Cgc + 0; // S24
      float Ia;
      { // Begin Atomic Op
      Ia = atomicAdd_data_f32(Cgd >> 2, I7);
      } // End Atomic Op
      int Cgp = Cgc + 4; // S25
      float Ic;
      { // Begin Atomic Op
      Ic = atomicAdd_data_f32(Cgp >> 2, I8);
      } // End Atomic Op
      float Id = HZ * FX;
      int CgA = Cd2 + 4 * CHZ; // S26
      int CgB = CgA + 0; // S27
      float If;
      { // Begin Atomic Op
      If = atomicAdd_data_f32(CgB >> 2, Id);
      } // End Atomic Op
      float Ig = Bc * B7;
      float Ih = I1 + GD;
      float Ii = I3 + GF;
      float Ij = Ge + Ih;
      float Ik = Gh + Ii;
      float Il = Ig * Ij;
      float Im = Ig * Ik;
      int CIn = Cum + CQg;
      int CgM = CcE + 8 * CIn; // S23
      int CgN = CgM + 0; // S24
      float Io;
      { // Begin Atomic Op
      Io = atomicAdd_data_f32(CgN >> 2, Il);
      } // End Atomic Op
      int CgZ = CgM + 4; // S25
      float Iq;
      { // Begin Atomic Op
      Iq = atomicAdd_data_f32(CgZ >> 2, Im);
      } // End Atomic Op
      float Ir = Ig * FX;
      int Cha = Cd2 + 4 * CIn; // S26
      int Chb = Cha + 0; // S27
      float It;
      { // Begin Atomic Op
      It = atomicAdd_data_f32(Chb >> 2, Ir);
      } // End Atomic Op
      float Iu = Bc * Bd;
      float Iv = I1 + GX;
      float Iw = I3 + GZ;
      float Ix = Ge + Iv;
      float Iy = Gh + Iw;
      float Iz = Iu * Ix;
      float IA = Iu * Iy;
      int CIL = CuK + CQg;
      int Chm = CcE + 8 * CIL; // S23
      int Chn = Chm + 0; // S24
      float IC;
      { // Begin Atomic Op
      IC = atomicAdd_data_f32(Chn >> 2, Iz);
      } // End Atomic Op
      int Chz = Chm + 4; // S25
      float IE;
      { // Begin Atomic Op
      IE = atomicAdd_data_f32(Chz >> 2, IA);
      } // End Atomic Op
      float IF = Iu * FX;
      int ChK = Cd2 + 4 * CIL; // S26
      int ChL = ChK + 0; // S27
      float IH;
      { // Begin Atomic Op
      IH = atomicAdd_data_f32(ChL >> 2, IF);
      } // End Atomic Op
  }
}

void main()
{
  substep_c42_02();
}
