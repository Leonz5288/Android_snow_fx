#version 310 es
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
precision highp float;
layout(std430, binding = 0) buffer data_i32 { int _data_i32_[];}; 
layout(std430, binding = 1) buffer gtmp_i32 { int _gtmp_i32_[];}; 

const float inf = 1.0f / 0.0f;
const float nan = 0.0f / 0.0f;
void drop_staging_tetromino_c44_00()
{ // serial
  int CSM = 0;
  int CVW = int(0);
  int CSO = CSM + 1019908 * CVW; // S0
  int CSP = CSO + 0; // S21
  int CSR = CSP + 4 * CVW; // S21
  int CSS = CSR + 0; // S22
  int C = _data_i32_[CSS >> 2];
  int D = 0;
  _gtmp_i32_[D >> 2] = C;
}

void main()
{
  drop_staging_tetromino_c44_00();
}
