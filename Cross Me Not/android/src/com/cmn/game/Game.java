/**
 * 
 */
package com.cmn.game;

import com.admob.android.ads.AdView;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.util.Log;
import android.view.ViewGroup.LayoutParams;
import android.widget.TextView;

//import com.admob.android.ads.AdView;

/**
 * @author manan19
 *
 */
public final class Game extends Activity 
{
	GameView _gameView;
	AdView _adView;
	int _selectedLevel;
	float _timer;
	TextView _timerLabel;
	
	public static CountDownTimer timer;
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
    	Log.i("Game", "onCreate");
		super.onCreate(savedInstanceState);
		
		_selectedLevel = this.getIntent().getIntExtra("selectedLevel", 1);
		
		_gameView = new GameView(this, _selectedLevel);
		setContentView(_gameView);
		
		_adView = new AdView(this);
		LayoutParams param = new LayoutParams(LayoutParams.FILL_PARENT,LayoutParams.WRAP_CONTENT);
		addContentView(_adView,param);
		
		_timer = 0;
		_timerLabel = new TextView(this);
		_timerLabel.setTextColor(Color.BLACK);
		timer =  new CountDownTimer( 6000000, 17) {
			
			@Override
			public void onTick(long millisUntilFinished) {
				// TODO Auto-generated method stub
				_timer = 6000000-millisUntilFinished;
				_timer = _timer/10;
				_timer = Math.round(_timer);
				_timer = _timer/100;
				_timerLabel.setText(String.valueOf(_timer));
			}
			
			@Override
			public void onFinish() {
				// TODO Auto-generated method stub
				
			}
		}.start();
		//addContentView(_timerLabel, param);
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
