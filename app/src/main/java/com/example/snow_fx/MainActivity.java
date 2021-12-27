package com.example.snow_fx;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.pm.ConfigurationInfo;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

public class MainActivity extends Activity {
    /** Hold a reference to our GLSurfaceView */
    private GLSurfaceView mGLSurfaceView;
    private SnowFX snow_renderer;

    private View.OnTouchListener handleTouch = new View.OnTouchListener() {
        @Override
        public boolean onTouch(View v, MotionEvent event) {
            int x = (int) event.getX();
            int y = (int) event.getY();
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                case MotionEvent.ACTION_MOVE:
                    snow_renderer.touch_x = x / 1080f * 0.5f;
                    snow_renderer.touch_y = 1f - y / 1971f;
                    for (int i = 0; i < snow_renderer.base_data.length; i += 2) {
                        snow_renderer.data_stage[i] = snow_renderer.base_data[i] + snow_renderer.touch_x;
                    }
                    break;
                case MotionEvent.ACTION_UP:
                    snow_renderer.release = true;
                    snow_renderer.touch_x = x / 1080f * 0.5f;
                    snow_renderer.touch_y = 1f - y / 1971f;
                    for (int i = 0; i < snow_renderer.base_data.length; i += 2) {
                        snow_renderer.data_stage[i] = snow_renderer.base_data[i] + snow_renderer.touch_x;
                    }
                    break;
            }
            return true;
        }
    };


    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        mGLSurfaceView = new GLSurfaceView(this);

        snow_renderer = new SnowFX(mGLSurfaceView.getContext());

        mGLSurfaceView.setOnTouchListener(handleTouch);

        // Check if the system supports OpenGL ES 2.0.
        final ActivityManager activityManager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        final ConfigurationInfo configurationInfo = activityManager.getDeviceConfigurationInfo();
        final boolean supportsEs32 = configurationInfo.reqGlEsVersion >= 0x30002;

        if (supportsEs32)
        {
            // Request an OpenGL ES 2.0 compatible context.
            mGLSurfaceView.setEGLContextClientVersion(3);

            // Set the renderer to our demo renderer, defined below.
            //mGLSurfaceView.setRenderer(new ExampleCompute(mGLSurfaceView.getContext()));
            mGLSurfaceView.setRenderer(snow_renderer);
        }
        else
        {
            // This is where you could create an OpenGL ES 1.x compatible
            // renderer if you wanted to support both ES 1 and ES 2.
            return;
        }

        setContentView(mGLSurfaceView);
    }

    @Override
    protected void onResume()
    {
        // The activity must call the GL surface view's onResume() on activity onResume().
        super.onResume();
        mGLSurfaceView.onResume();
    }

    @Override
    protected void onPause()
    {
        // The activity must call the GL surface view's onPause() on activity onPause().
        super.onPause();
        mGLSurfaceView.onPause();
    }
}
