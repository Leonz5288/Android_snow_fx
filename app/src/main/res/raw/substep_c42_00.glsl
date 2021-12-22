#version 310 es
layout(local_size_x = 128, local_size_y = 1, local_size_z = 1) in;
precision highp float;
layout(std430, binding = 0) buffer data_f32 { float _data_f32_[];}; 

const float inf = 1.0f / 0.0f;
const float nan = 0.0f / 0.0f;
void substep_c42_00()
{ // range for
  // range known at compile time
  int _sid0 = int(gl_GlobalInvocationID.x);
  for (int _sid = _sid0; _sid < (8192); _sid += int(gl_WorkGroupSize.x * gl_NumWorkGroups.x)) {
    int _itv = 0 + _sid;
      int CDh = int(0);
      int CrL = int(127);
      int CrH = int(63);
      float V = float(0.0);
      int D = _itv;
      int Crh = int(7);
      int Cri = D >> Crh;
      int Crk = Cri & CrH;
      int Cro = D & CrL;
      int N = int(40);
      int O = -int(Crk < N);
      int Q = int(80);
      int R = -int(Cro < Q);
      int S = O & R;
      if (S != 0) {
        int C6J = 0;
        int C6L = C6J + 1019908 * CDh; // S0
        int C6M = C6L + 167940; // S23
        int CQa = Crk << Crh;
        int CDo = Cro + CQa;
        int C6Q = C6M + 8 * CDo; // S23
        int C6R = C6Q + 0; // S24
        _data_f32_[C6R >> 2] = V;
        int C73 = C6Q + 4; // S25
        _data_f32_[C73 >> 2] = V;
        int C7a = C6L + 4100; // S26
        int C7e = C7a + 4 * CDo; // S26
        int C7f = C7e + 0; // S27
        _data_f32_[C7f >> 2] = V;
      }
  }
}

void main()
{
  substep_c42_00();
}
