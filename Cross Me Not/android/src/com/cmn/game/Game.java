package com.cmn.game;

import com.admob.android.ads.AdManager;
import com.admob.android.ads.AdView;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.util.Log;
import android.view.ViewGroup.LayoutParams;

/**
 * @author manan19
 *
 */
public final class Game extends Activity 
{
	GameView _gameView;
	AdView _adView;
	int _selectedLevel;
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
    	Log.i("Game", "onCreate");
		super.onCreate(savedInstanceState);
		
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_NOSENSOR);
		
		_selectedLevel = this.getIntent().getIntExtra("selectedLevel", 1);
		
		_gameView = new GameView(this, _selectedLevel);
		setContentView(_gameView);
		
		AdManager.setAllowUseOfLocation(true);
		// Amazon Market
		//AdManager.setPublisherId("a14d8c2fbb00b33");
		// Android Market
		AdManager.setPublisherId("a14d584ff9994b4");
		// GetJar
		//AdManager.setPublisherId("a14d8c317a376ff");

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
