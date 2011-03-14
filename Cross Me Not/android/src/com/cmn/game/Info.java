/**
 * 
 */
package com.cmn.game;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.util.Log;

/**
 * @author manan19
 *
 */
public class Info extends Activity {
	protected void onCreate(Bundle savedInstanceState)
	{
    	Log.i("Info", "onCreate");
		super.onCreate(savedInstanceState);
		
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_NOSENSOR);
		
		setContentView(R.layout.info);
	}
	
    protected void onRestart()
    {
    	Log.i("Info", "onRestart");
    	super.onRestart();
    }

    protected void onResume()
    {
    	Log.i("Info", "onResume");
    	super.onResume();
    }

    protected void onPause()
    {
    	Log.i("Info", "onPause");
    	super.onPause();
    }

    protected void onStart()
    {
    	Log.i("Info", "onStart");
    	super.onStart();
    }
    
    protected void onStop()
    {
    	Log.i("Info", "onStop");
    	super.onStop();
    }

    protected void onDestroy()
    {
    	Log.i("Info", "onDestroy");
    	super.onDestroy();
    }

}
