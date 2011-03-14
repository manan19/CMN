/**
 * 
 */
package com.cmn.game;

import java.util.ArrayList;
import java.util.Iterator;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.TextView;

import com.flurry.android.FlurryAgent;

/**
 * @author manan19
 *
 */
public final class Menu extends Activity
	implements AdapterView.OnItemSelectedListener
{
	
	private Button _startButton;
	private Button _infoButton;
	private Spinner _levelSpinner;
	private TextView _timeTextView;
	
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
    	Log.i("Menu", "onCreate");
		super.onCreate(savedInstanceState);
		
		FlurryAgent.onStartSession(this, "VKMXGMLCV74L7HSMA9JQ");
		
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_NOSENSOR);
		
		setContentView(R.layout.menu);
		
		_startButton = (Button) findViewById(R.id.startButton);
		_infoButton = (Button) findViewById(R.id.infoButton);
		_levelSpinner = (Spinner) findViewById(R.id.levelSpinner);
		_timeTextView = (TextView) findViewById(R.id.timeTextView);
		
        _startButton.setOnClickListener(new View.OnClickListener() 
        {
            public void onClick(View v) 
            {
            	startButtonClicked();
            }
        });
        
        _infoButton.setOnClickListener(new View.OnClickListener() 
        {
            public void onClick(View v) 
            {
            	infoButtonClicked();
            }
        });
        
        ArrayList<Integer> levels = new ArrayList<Integer>();
        for (int i = 0; i < 25; i++) { levels.add(i+1);	}
        
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_dropdown_item_1line);
        Iterator<Integer> iter = levels.iterator();
        while(iter.hasNext())	{
        	adapter.add(iter.next().toString());
        }
        _levelSpinner.setAdapter(adapter);
        _levelSpinner.setOnItemSelectedListener(this);
	}
	
	public void setTimeTextView(String level)
	{
	    float score = PreferenceManager.getDefaultSharedPreferences(this).getFloat(level, -99);
	    if(score == -99)
	    	_timeTextView.setText("--");
	    else
	    	_timeTextView.setText(String.valueOf(score) + " s");
	}
	
	public void onItemSelected(AdapterView<?> parent,View v, int position, long id) 
	{
		setTimeTextView(_levelSpinner.getSelectedItem().toString());
	}
	

	public void onNothingSelected(AdapterView<?> parent) 
	{
	}
	
    protected void onRestart()
    {
    	Log.i("Menu", "onRestart");
    	super.onRestart();
    	
		setTimeTextView(_levelSpinner.getSelectedItem().toString());
    }

    protected void onResume()
    {
    	Log.i("Menu", "onResume");
    	super.onResume();
    	
    	_startButton.setEnabled(true);
    	_infoButton.setEnabled(true);
		setTimeTextView(_levelSpinner.getSelectedItem().toString());
    }

    protected void onPause()
    {
    	_startButton.setEnabled(false);
    	_infoButton.setEnabled(false);
    	
    	Log.i("Menu", "onPause");
    	super.onPause();
    }

    protected void onStart()
    {
    	Log.i("Menu", "onStart");
    	super.onStart();
    	
    	_startButton.setEnabled(true);
    	_infoButton.setEnabled(true);
		setTimeTextView(_levelSpinner.getSelectedItem().toString());
    }
    
    protected void onStop()
    {
    	_startButton.setEnabled(false);
    	_infoButton.setEnabled(false);
    	
    	Log.i("Menu", "onStop");
    	super.onStop();
    }

    protected void onDestroy()
    {
    	Log.i("Menu", "onDestroy");
    	super.onDestroy();
    	
		FlurryAgent.onEndSession(this);
    }
    
	/**
	 * 
	 */
	
    public void infoButtonClicked()
	{
		Intent i = new Intent(this, Info.class);
        startActivity(i);
	}
    
	public void startButtonClicked()
	{
		Intent i = new Intent(this, Game.class);
		int lvl = Integer.parseInt(_levelSpinner.getSelectedItem().toString());
		i.putExtra("selectedLevel", lvl);
        startActivity(i);
	}
	
	
	public Menu() {
		// TODO Auto-generated constructor stub
	}

}
