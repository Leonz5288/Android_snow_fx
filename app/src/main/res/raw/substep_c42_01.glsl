#version 310 es
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
precision highp float;
layout(std430, binding = 0) buffer data_i32 { int _data_i32_[];}; 
layout(std430, binding = 0) buffer data_f32 { float _data_f32_[];}; 
layout(std430, binding = 1) buffer gtmp_i32 { int _gtmp_i32_[];}; 
layout(std430, binding = 1) buffer gtmp_f32 { float _gtmp_f32_[];}; 

const float inf = 1.0f / 0.0f;
const float nan = 0.0f / 0.0f;
void substep_c42_01()
{ // serial
  int C7h = 0;
  int CDF = int(0);
  int C7j = C7h + 1019908 * CDF; // S0
  int C7k = C7j + 0; // S21
  int C7m = C7k + 4 * CDF; // S21
  int C7n = C7m + 0; // S22
  int At = _data_i32_[C7n >> 2];
  int Au = 0;
  _gtmp_i32_[Au >> 2] = At;
}

void main()
{
  substep_c42_01();
}
