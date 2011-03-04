/**
 * 
 */
package com.cmn.game;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.util.Log;
import android.view.ViewGroup.LayoutParams;
import android.widget.TextView;

import com.admob.android.ads.AdView;

/**
 * @author manan19
 *
 */
public final class Game extends Activity 
{
	GameView _gameView;
	AdView _adView;
	TextView _timerLabel;
	int _selectedLevel;
	float _timer;
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
    	Log.i("Game", "onCreate");
		super.onCreate(savedInstanceState);
		
		_selectedLevel = this.getIntent().getIntExtra("selectedLevel", 1);
		
		_gameView = new GameView(this, _selectedLevel);
		setContentView(_gameView);
		
		// this line is only for testing
		//AdManager.setTestDevices(new String[]{AdManager.TEST_EMULATOR,"E83D20734F72FB3108F104ABC0FFC738",});
		_adView = new AdView(this);
		LayoutParams param = new LayoutParams(LayoutParams.FILL_PARENT,LayoutParams.WRAP_CONTENT); 
		addContentView(_adView,param);
		
		_timer = 0;
		_timerLabel = new TextView(this);
		_timerLabel.setTextColor(Color.BLACK);
		new CountDownTimer( 6000000, 17) {
			
			@Override
			public void onTick(long millisUntilFinished) {
				// TODO Auto-generated method stub
				_timer = (6000000-millisUntilFinished)/1000;
				_timerLabel.setText(String.valueOf(_timer));
			}
			
			@Override
			public void onFinish() {
				// TODO Auto-generated method stub
				
			}
		}.start();
		addContentView(_timerLabel, param);
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
