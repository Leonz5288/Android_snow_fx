package com.example.snow_fx;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.opengl.GLSurfaceView;
import android.opengl.GLES32;
import android.os.Build;
import android.util.DisplayMetrics;
import android.util.Log;

import androidx.annotation.RequiresApi;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;
import java.nio.charset.StandardCharsets;
import java.util.Iterator;
import java.util.Random;
import java.util.stream.Collectors;

public class SnowFX implements GLSurfaceView.Renderer {
    private Context context;
    private int render_program;
    private int render_circle_program;
    private int global_tmp_buf;
    private int arg_buf;
    private int color_buf;
    private int root_buf;
    private int uniform_buf;
    private int circle_buf;
    private int num_particle = 0;
    private Program[] programs;
    private final String[] kernel_names = {"drop_staging_tetromino", "substep"};

    private FloatBuffer f_args;
    private FloatBuffer color;
    private FloatBuffer ball;
    private FloatBuffer uniform;
    private FloatBuffer circle_data;
    private IntBuffer i_args;

    private final int num_per_tetromino = 128 * 4;
    private final int max_num_particles = 1024 * 16;

    private int frame = 0;
    private int last_frame = 0;

    private int screen_width;
    private int screen_height;

    private float last_x;
    private float last_y;
    public float touch_x;
    public float touch_y;
    public boolean on_touch;

    public SnowFX(Context _context) {
        context = _context;
        // Open Json file.
        JSONParser parser = new JSONParser();
        InputStream jsonfile = this.context.getResources().openRawResource(R.raw.metadata);
        JSONObject mpm88;
        on_touch = false;
        last_x = 0;
        last_y = 0;
        touch_x = 0;
        touch_y = 0;
        try {
            mpm88 = (JSONObject) parser.parse(new InputStreamReader(jsonfile, "utf-8"));
            jsonfile.close();
        } catch (Exception e) {
            Log.e("ERR", "Mpm88Ndarray: exception when parsing json: " + e);
            return;
        }

        DisplayMetrics displayMetrics = new DisplayMetrics();
        ((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
        screen_height = displayMetrics.heightPixels;
        screen_width = displayMetrics.widthPixels;

        // -----------------------------------------------------------------------------------------
        // Parse Json data.
        parseJsonData(mpm88);
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void onSurfaceCreated(GL10 gl, EGLConfig config) {
        // Generate SSBOs.
        generateSSBO();
        // Compile compute shaders and link compute programs.
        compileComputeShaders();
        // Compile render shaders and link render program.
        compileRenderShaders();

        GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, 0, root_buf);
        GLES32.glBufferData(GLES32.GL_SHADER_STORAGE_BUFFER, 1019908, null, GLES32.GL_DYNAMIC_COPY);
        GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, 1, global_tmp_buf);
        GLES32.glBufferData(GLES32.GL_SHADER_STORAGE_BUFFER, 2048, null, GLES32.GL_DYNAMIC_COPY);

        // Fill color info into color buffer.
        float[] data_v = new float[]{166f, 181f, 247f, 255f,
                238f, 238f, 240f, 255f,
                237f, 85f, 59f, 255f,
                50f, 85f, 167f, 255f,
                109f, 53f, 203f, 255f,
                254f, 46f, 68f, 255f,
                38f, 165f, 167f, 255f,
                237f, 229f, 59f, 255f};
        for (int i = 0; i < data_v.length; i++) {
            data_v[i] = data_v[i] / 255f;
        }
        color = ByteBuffer.allocateDirect(data_v.length * 4).order(ByteOrder.nativeOrder()).asFloatBuffer();
        color.put(data_v).position(0);

        float[] data_stage = new float[num_per_tetromino * 2];
        Random rd = new Random();
        for (int i = 0; i < data_stage.length; i += 2) {
            float r = 0.08f * (float)Math.sqrt(rd.nextFloat());
            float theta = rd.nextFloat() * 2f * (float)Math.PI;
            data_stage[i] = 0.25f + r * (float)Math.cos(theta);
            data_stage[i+1] = 0.8f + r * (float)Math.sin(theta);
        }
        ball = ByteBuffer.allocateDirect(data_stage.length * 4).order(ByteOrder.nativeOrder()).asFloatBuffer();
        ball.put(data_stage).position(0);

        float[] uniform_data = new float[8];
        uniform_data[0] = (float) screen_width; uniform_data[1] = (float) screen_height;
        uniform_data[4] = 0.5f; uniform_data[5] = 0.5f; uniform_data[6] = 0.5f;
        uniform_data[7] = 200f;
        uniform = ByteBuffer.allocateDirect(uniform_data.length * 4).order(ByteOrder.nativeOrder()).asFloatBuffer();
        uniform.put(uniform_data).position(0);
    }

    @Override
    public void onSurfaceChanged(GL10 gl, int width, int height) {
        GLES32.glViewport(0, 0, width, height);
    }

    @Override
    public void onDrawFrame(GL10 gl) {
        // Clear color.
        GLES32.glClearColor(0.631373f, 0.180392f, 0.219608f, 1f);
        GLES32.glClear(GLES32.GL_COLOR_BUFFER_BIT);

        if (frame - last_frame > 100) {
            if (num_particle + num_per_tetromino <= max_num_particles) {
                drop_staging_tetromino();
                num_particle += num_per_tetromino;
            }
            last_frame = frame;
        }
        // Run substep kernel, pass in the number of substep you want to run per frame.
        substep(20);

        // Render point to the screen.
        render();
        frame++;
    }

    private void parseJsonData(JSONObject mpm88) {
        JSONObject json_programs = (JSONObject) ((JSONObject) mpm88.get("aot_data")).get("kernels");
        programs = new Program[json_programs.size()];
        for (int i = 0; i < json_programs.size(); i++) {
            // Initialize program & kernel data structure.
            JSONObject cur_json_program = (JSONObject) json_programs.get(kernel_names[i]);
            JSONArray json_kernels = (JSONArray) cur_json_program.get("tasks");
            Kernel[] kernels = new Kernel[json_kernels.size()];
            Iterator json_kernel_iterator = json_kernels.iterator();
            int k = 0;
            while (json_kernel_iterator.hasNext()) {
                JSONObject cur_json_kernel = (JSONObject) json_kernel_iterator.next();
                kernels[k] = new Kernel(
                        (String) cur_json_kernel.get("name"),
                        ((Long) cur_json_kernel.get("workgroup_size")).intValue(),
                        ((Long) cur_json_kernel.get("num_groups")).intValue()
                );
                k++;
            }

            JSONObject json_bind_idx = (JSONObject) cur_json_program.get("used.arr_arg_to_bind_idx");
            Integer[] bind_idx = new Integer[json_bind_idx.size()];
            for (int j = 0; j < json_bind_idx.size(); j++) {
                bind_idx[j] = ((Long) json_bind_idx.get(String.valueOf(j))).intValue();
            }
            programs[i] = new Program(kernels, bind_idx);
        }
    }

    private void generateSSBO() {
        int[] temp = new int[1];
        GLES32.glGenBuffers(1, temp, 0);
        color_buf = temp[0];
        GLES32.glGenBuffers(1, temp, 0);
        arg_buf = temp[0];
        GLES32.glGenBuffers(1, temp, 0);
        global_tmp_buf = temp[0];
        GLES32.glGenBuffers(1, temp, 0);
        root_buf = temp[0];
        GLES32.glGenBuffers(1, temp, 0);
        uniform_buf = temp[0];
        GLES32.glGenBuffers(1, temp, 0);
        circle_buf = temp[0];
    }


    @RequiresApi(api = Build.VERSION_CODES.N)
    private void compileComputeShaders() {
        for (int i = 0; i < programs.length; i++) {
            Kernel[] cur_kernels = programs[i].getKernels();
            for (int j = 0; j < cur_kernels.length; j++) {
                int shader = GLES32.glCreateShader(GLES32.GL_COMPUTE_SHADER);
                InputStream raw_shader = this.context.getResources().openRawResource(this.context.getResources().getIdentifier(
                        cur_kernels[j].getName(), "raw", this.context.getPackageName()
                ));
                String string_shader = new BufferedReader(
                        new InputStreamReader(raw_shader, StandardCharsets.UTF_8))
                        .lines()
                        .collect(Collectors.joining("\n"));
                try {
                    raw_shader.close();
                } catch (Exception e) {
                    Log.e("ERR", "onSurfaceCreated: error in closing input stream: " + e);
                    return;
                }

                GLES32.glShaderSource(shader, string_shader);
                GLES32.glCompileShader(shader);
                final int[] compileStatus = new int[1];
                GLES32.glGetShaderiv(shader, GLES32.GL_COMPILE_STATUS, compileStatus, 0);
                if (compileStatus[0] == 0) {
                    GLES32.glDeleteShader(shader);
                    shader = 0;
                }
                if (shader == 0) {
                    throw new RuntimeException("Error creating compute shader: " + GLES32.glGetShaderInfoLog(shader));
                }

                int shader_program = GLES32.glCreateProgram();
                GLES32.glAttachShader(shader_program, shader);
                GLES32.glLinkProgram(shader_program);
                final int[] linkStatus = new int[1];
                GLES32.glGetProgramiv(shader_program, GLES32.GL_LINK_STATUS, linkStatus, 0);
                if (linkStatus[0] == 0) {
                    GLES32.glDeleteProgram(shader_program);
                    shader_program = 0;
                }
                if (shader_program == 0) {
                    throw new RuntimeException("Error creating program: " + GLES32.glGetProgramInfoLog(shader_program));
                }
                cur_kernels[j].setShader_program(shader_program);
            }
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    private void compileRenderShaders() {
        int mVertShader = GLES32.glCreateShader(GLES32.GL_VERTEX_SHADER);
        int mFragShader = GLES32.glCreateShader(GLES32.GL_FRAGMENT_SHADER);
        int mVertCircleShader = GLES32.glCreateShader(GLES32.GL_VERTEX_SHADER);
        int mFragCircleShader = GLES32.glCreateShader(GLES32.GL_FRAGMENT_SHADER);
        InputStream rawVertShader = this.context.getResources().openRawResource(R.raw.vertshader);
        String stringVertShader = new BufferedReader(
                new InputStreamReader(rawVertShader, StandardCharsets.UTF_8))
                .lines()
                .collect(Collectors.joining("\n"));
        InputStream rawFragShader = this.context.getResources().openRawResource(R.raw.fragshader);
        String stringFragShader = new BufferedReader(
                new InputStreamReader(rawFragShader, StandardCharsets.UTF_8))
                .lines()
                .collect(Collectors.joining("\n"));
        InputStream rawVertCircleShader = this.context.getResources().openRawResource(R.raw.vert_circle_shader);
        String stringVertCircleShader = new BufferedReader(
                new InputStreamReader(rawVertCircleShader, StandardCharsets.UTF_8))
                .lines()
                .collect(Collectors.joining("\n"));
        InputStream rawFragCircleShader = this.context.getResources().openRawResource(R.raw.frag_circle_shader);
        String stringFragCircleShader = new BufferedReader(
                new InputStreamReader(rawFragCircleShader, StandardCharsets.UTF_8))
                .lines()
                .collect(Collectors.joining("\n"));

        try {
            rawVertShader.close();
            rawFragShader.close();
            rawVertCircleShader.close();
            rawFragCircleShader.close();
        } catch (Exception e) {
            System.out.println(e.toString());
            return;
        }

        GLES32.glShaderSource(mVertShader, stringVertShader);
        GLES32.glCompileShader(mVertShader);
        final int[] compileStatus = new int[1];
        GLES32.glGetShaderiv(mVertShader, GLES32.GL_COMPILE_STATUS, compileStatus, 0);
        // If the compilation failed, delete the shader.
        if (compileStatus[0] == 0)
        {
            GLES32.glDeleteShader(mVertShader);
            mVertShader = 0;
        }
        if (mVertShader == 0)
        {
            throw new RuntimeException("Error creating vertex shader.");
        }

        GLES32.glShaderSource(mFragShader, stringFragShader);
        GLES32.glCompileShader(mFragShader);
        GLES32.glGetShaderiv(mFragShader, GLES32.GL_COMPILE_STATUS, compileStatus, 0);
        // If the compilation failed, delete the shader.
        if (compileStatus[0] == 0)
        {
            GLES32.glDeleteShader(mFragShader);
            mFragShader = 0;
        }
        if (mFragShader == 0)
        {
            throw new RuntimeException("Error creating fragment shader.");
        }

        GLES32.glShaderSource(mVertCircleShader, stringVertCircleShader);
        GLES32.glCompileShader(mVertCircleShader);
        GLES32.glGetShaderiv(mVertCircleShader, GLES32.GL_COMPILE_STATUS, compileStatus, 0);
        // If the compilation failed, delete the shader.
        if (compileStatus[0] == 0)
        {
            GLES32.glDeleteShader(mVertCircleShader);
            mVertCircleShader = 0;
        }
        if (mVertCircleShader == 0)
        {
            throw new RuntimeException("Error creating vertex circle shader.");
        }

        GLES32.glShaderSource(mFragCircleShader, stringFragCircleShader);
        GLES32.glCompileShader(mFragCircleShader);
        GLES32.glGetShaderiv(mFragCircleShader, GLES32.GL_COMPILE_STATUS, compileStatus, 0);
        // If the compilation failed, delete the shader.
        if (compileStatus[0] == 0)
        {
            GLES32.glDeleteShader(mFragCircleShader);
            mFragCircleShader = 0;
        }
        if (mFragCircleShader == 0)
        {
            throw new RuntimeException("Error creating vertex circle shader.");
        }

        render_program = GLES32.glCreateProgram();
        if (render_program != 0) {
            GLES32.glAttachShader(render_program, mVertShader);
            GLES32.glAttachShader(render_program, mFragShader);
            GLES32.glLinkProgram(render_program);
            final int[] linkStatus = new int[1];
            GLES32.glGetProgramiv(render_program, GLES32.GL_LINK_STATUS, linkStatus, 0);

            // If the link failed, delete the program.
            if (linkStatus[0] == 0)
            {
                GLES32.glDeleteProgram(render_program);
                render_program = 0;
            }
        }
        if (render_program == 0)
        {
            throw new RuntimeException("Error creating program.");
        }

        render_circle_program = GLES32.glCreateProgram();
        if (render_circle_program != 0) {
            GLES32.glAttachShader(render_circle_program, mVertCircleShader);
            GLES32.glAttachShader(render_circle_program, mFragCircleShader);
            GLES32.glLinkProgram(render_circle_program);
            final int[] linkStatus = new int[1];
            GLES32.glGetProgramiv(render_circle_program, GLES32.GL_LINK_STATUS, linkStatus, 0);

            // If the link failed, delete the program.
            if (linkStatus[0] == 0)
            {
                GLES32.glDeleteProgram(render_circle_program);
                render_circle_program = 0;
            }
        }
        if (render_circle_program == 0)
        {
            throw new RuntimeException("Error creating circle program.");
        }
    }

    private void fillData(float[] argument) {
        // Fill shape info into arg buffer.
        float[] data = new float[8*8+16];
        data[0] = argument[0];
        data[8/4] = argument[1];
        data[16/4] = argument[2];
        data[24/4] = argument[3];
        f_args = ByteBuffer.allocateDirect(data.length*4).order(ByteOrder.nativeOrder()).asFloatBuffer();
        f_args.put(data).position(0);
    }

    private void fillData(int[] argument) {
        // Fill shape info into arg buffer.
        int[] data = new int[8*8+16];
        data[0] = argument[0];
        i_args = ByteBuffer.allocateDirect(data.length*4).order(ByteOrder.nativeOrder()).asIntBuffer();
        i_args.put(data).position(0);
    }

    private void drop_staging_tetromino() {
        Kernel[] drop_kernel = programs[0].getKernels();

        GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, 0, root_buf);
        GLES32.glBufferSubData(GLES32.GL_SHADER_STORAGE_BUFFER, 4, num_per_tetromino*2*4, ball);
        // Fill some data to buffers.
        //Random rd = new Random();
        //int mat = rd.nextInt(8);
        int mat = 1;
        fillData(new int[]{mat});
        GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, 2, arg_buf);
        GLES32.glBufferData(GLES32.GL_SHADER_STORAGE_BUFFER, 64*5, i_args, GLES32.GL_DYNAMIC_COPY);

        for (int i = 0; i < drop_kernel.length; i++) {
            GLES32.glUseProgram(drop_kernel[i].getShader_program());
            GLES32.glMemoryBarrierByRegion(GLES32.GL_SHADER_STORAGE_BARRIER_BIT);
            GLES32.glDispatchCompute(drop_kernel[i].getNum_groups(), 1, 1);
        }
    }

    private void substep(int step) {
        Kernel[] substep_kernel = programs[1].getKernels();

        GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, 0, root_buf);
        // Fill some data to buffers.
        if (on_touch) {
            float vx = 0;
            float vy = 0;
            if (last_x != -1) {
                vx = (touch_x - last_x) / (float)2e-3;
                vy = (touch_y - last_y) / (float)2e-3;
            }
            fillData(new float[]{touch_x, touch_y, vx, vy});
            last_x = touch_x;
            last_y = touch_y;
        } else {
            fillData(new float[]{-100f, -100f, 0f, 0f});
            last_x = -1;
            last_y = -1;
        }
        GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, 2, arg_buf);
        GLES32.glBufferData(GLES32.GL_SHADER_STORAGE_BUFFER, 64*5, f_args, GLES32.GL_DYNAMIC_COPY);

        for (int i = 0; i < step; i++) {
            for (int j = 0; j < substep_kernel.length; j++) {
                GLES32.glUseProgram(substep_kernel[j].getShader_program());
                GLES32.glMemoryBarrierByRegion(GLES32.GL_SHADER_STORAGE_BARRIER_BIT);
                GLES32.glDispatchCompute(substep_kernel[j].getNum_groups(), 1, 1);
            }
        }
    }

    private void fillCircleData() {
        float[] data = new float[2];
        data[0] = touch_x;
        data[1] = touch_y;
        circle_data = ByteBuffer.allocateDirect(data.length*4).order(ByteOrder.nativeOrder()).asFloatBuffer();
        circle_data.put(data).position(0);
    }

    private void render() {
        GLES32.glMemoryBarrier(GLES32.GL_VERTEX_ATTRIB_ARRAY_BARRIER_BIT);

        GLES32.glUseProgram(render_program);

        GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, 0, color_buf);
        GLES32.glBufferData(GLES32.GL_SHADER_STORAGE_BUFFER, 8*4*4, color, GLES32.GL_STATIC_DRAW);

        GLES32.glBindBuffer(GLES32.GL_ARRAY_BUFFER, root_buf);
        GLES32.glEnableVertexAttribArray(0);
        GLES32.glVertexAttribPointer(0, 2, GLES32.GL_FLOAT, false, 2*4, 233476);

        GLES32.glBindBuffer(GLES32.GL_ARRAY_BUFFER, root_buf);
        GLES32.glEnableVertexAttribArray(1);
        GLES32.glVertexAttribPointer(1, 1, GLES32.GL_UNSIGNED_INT, false, 4, 36868);

        GLES32.glDrawArrays(GLES32.GL_POINTS, 0, num_particle);

        if (on_touch) {
            fillCircleData();

            GLES32.glUseProgram(render_circle_program);

            GLES32.glBindBufferBase(GLES32.GL_UNIFORM_BUFFER, 0, uniform_buf);
            GLES32.glBufferData(GLES32.GL_UNIFORM_BUFFER, 8*4, uniform, GLES32.GL_STATIC_DRAW);

            GLES32.glBindBuffer(GLES32.GL_ARRAY_BUFFER, circle_buf);
            GLES32.glBufferData(GLES32.GL_ARRAY_BUFFER, 2*4, circle_data, GLES32.GL_DYNAMIC_DRAW);
            GLES32.glEnableVertexAttribArray(0);
            GLES32.glVertexAttribPointer(0, 2, GLES32.GL_FLOAT, false, 2*4, 0);

            GLES32.glDrawArrays(GLES32.GL_POINTS, 0, 1);
        }
    }
}
