#version 310 es
layout(local_size_x = 128, local_size_y = 1, local_size_z = 1) in;
precision highp float;
layout(std430, binding = 0) buffer data_i32 { int _data_i32_[];}; 
layout(std430, binding = 0) buffer data_f32 { float _data_f32_[];}; 
layout(std430, binding = 1) buffer gtmp_i32 { int _gtmp_i32_[];}; 
layout(std430, binding = 1) buffer gtmp_f32 { float _gtmp_f32_[];}; 
layout(std430, binding = 2) buffer args_i32 { int _args_i32_[];}; 
layout(std430, binding = 2) buffer args_f32 { float _args_f32_[];}; 

const float inf = 1.0f / 0.0f;
const float nan = 0.0f / 0.0f;
void drop_staging_tetromino_c44_01()
{ // range for
  // range known at compile time
  int _sid0 = int(gl_GlobalInvocationID.x);
  for (int _sid = _sid0; _sid < (512); _sid += int(gl_WorkGroupSize.x * gl_NumWorkGroups.x)) {
    int _itv = 0 + _sid;
      int H = _itv;
      int CV8 = int(511);
      int CV9 = H & CV8;
      int N = 0;
      int O = _gtmp_i32_[N >> 2];
      int P = O + CV9;
      int CSV = 0;
      int CVY = int(0);
      int CSX = CSV + 1019908 * CVY; // S0
      int CSY = CSX + 4; // S28
      int CT1 = CSY + 8 * CV9; // S28
      int CT2 = CT1 + 0; // S29
      float R = _data_f32_[CT2 >> 2];
      int CT8 = CSX + 233476; // S1
      int CVg = int(16383);
      int CVh = P & CVg;
      int CTb = CT8 + 8 * CVh; // S1
      int CTc = CTb + 0; // S2
      _data_f32_[CTc >> 2] = R;
      int CTm = CT1 + 4; // S30
      float V = _data_f32_[CTm >> 2];
      int CTw = CTb + 4; // S3
      _data_f32_[CTw >> 2] = V;
      int Y = _args_i32_[0 << 1];
      int CTC = CSX + 36868; // S17
      int CTF = CTC + 4 * CVh; // S17
      int CTG = CTF + 0; // S18
      _data_i32_[CTG >> 2] = Y;
      float As = float(0.0);
      int CTM = CSX + 364548; // S4
      int CTP = CTM + 8 * CVh; // S4
      int CTQ = CTP + 0; // S5
      _data_f32_[CTQ >> 2] = As;
      float Av = float(-2.0);
      int CU0 = CTP + 4; // S6
      _data_f32_[CU0 >> 2] = Av;
      float Ay = float(1.0);
      int CU6 = CSX + 757764; // S12
      int CU9 = CU6 + 16 * CVh; // S12
      int CUa = CU9 + 0; // S13
      _data_f32_[CUa >> 2] = Ay;
      int CUk = CU9 + 4; // S14
      _data_f32_[CUk >> 2] = As;
      int CUu = CU9 + 8; // S15
      _data_f32_[CUu >> 2] = As;
      int CUE = CU9 + 12; // S16
      _data_f32_[CUE >> 2] = Ay;
      int CUK = CSX + 102404; // S19
      int CUN = CUK + 4 * CVh; // S19
      int CUO = CUN + 0; // S20
      _data_f32_[CUO >> 2] = Ay;
  }
}

void main()
{
  drop_staging_tetromino_c44_01();
}
