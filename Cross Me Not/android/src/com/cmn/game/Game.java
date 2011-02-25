/**
 * 
 */
package com.cmn.game;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.ViewGroup.LayoutParams;

import com.admob.android.ads.AdManager;
import com.admob.android.ads.AdView;

/**
 * @author manan19
 *
 */
public final class Game extends Activity 
{
	GameView _gameView;
	AdView _adView;
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
    	Log.i("Game", "onCreate");
		super.onCreate(savedInstanceState);
		
		_gameView = new GameView(this);
		setContentView(_gameView);
		
		// adview
		
		AdManager.setTestDevices(new String[]{AdManager.TEST_EMULATOR,"E83D20734F72FB3108F104ABC0FFC738",});
		_adView = new AdView(this);
		LayoutParams param = new LayoutParams(LayoutParams.FILL_PARENT,LayoutParams.WRAP_CONTENT); 
		addContentView(_adView,param);
	}
	
    protected void onRestart()
    {
    	Log.i("Game", "onRestart");
    	super.onRestart();
    }

    protected void onResume()
    {
    	Log.i("Game", "onResume");
    	super.onResume();
    }

    protected void onPause()
    {
    	Log.i("Game", "onPause");
    	super.onPause();
    }

    protected void onStart()
    {
    	Log.i("Game", "onStart");
    	super.onStart();
    }
    
    protected void onStop()
    {
    	Log.i("Game", "onStop");
    	super.onStop();
    }

    protected void onDestroy()
    {
    	Log.i("Game", "onDestroy");
    	super.onDestroy();
    }
	/**
	 * 
	 */
	public Game() {
		// TODO Auto-generated constructor stub
	}

}
