package com.example.snow_fx;

public class Program {
    private Kernel[] kernels;
    private Integer[] bind_idx;

    public Program(Kernel[] kernels, Integer[] bind_idx) {
        this.kernels = kernels;
        this.bind_idx = bind_idx;
    }

    public Kernel[] getKernels() {
        return kernels;
    }

    public Integer[] getBind_idx() {
        return bind_idx;
    }
}
