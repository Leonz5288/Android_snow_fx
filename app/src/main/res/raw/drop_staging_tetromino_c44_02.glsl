#version 310 es
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
precision highp float;
layout(std430, binding = 0) buffer data_i32 { int _data_i32_[];}; 
layout(std430, binding = 0) buffer data_f32 { float _data_f32_[];}; 
layout(std430, binding = 1) buffer gtmp_i32 { int _gtmp_i32_[];}; 
layout(std430, binding = 1) buffer gtmp_f32 { float _gtmp_f32_[];}; 
layout(std430, binding = 2) buffer args_i32 { int _args_i32_[];}; 
layout(std430, binding = 2) buffer args_f32 { float _args_f32_[];}; 

const float inf = 1.0f / 0.0f;
const float nan = 0.0f / 0.0f;
void drop_staging_tetromino_c44_02()
{ // serial
  int AJ = int(512);
  int CUQ = 0;
  int CWW = int(0);
  int CUS = CUQ + 1019908 * CWW; // S0
  int CUT = CUS + 0; // S21
  int CUV = CUT + 4 * CWW; // S21
  int CUW = CUV + 0; // S22
  int AL = _data_i32_[CUW >> 2];
  int AM = AL + AJ;
  _data_i32_[CUW >> 2] = AM;
}

void main()
{
  drop_staging_tetromino_c44_02();
}
