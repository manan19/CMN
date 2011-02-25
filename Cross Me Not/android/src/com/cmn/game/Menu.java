/**
 * 
 */
package com.cmn.game;

import java.util.ArrayList;
import java.util.Iterator;

import com.cmn.game.R;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;
import android.os.Bundle;

/**
 * @author manan19
 *
 */
public final class Menu extends Activity {
	
	private Button _startButton;
	private Button _infoButton;
	private Spinner _levelSpinner;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
    	Log.i("Menu", "onCreate");
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.menu);
		
		_startButton = (Button) findViewById(R.id.startButton);
		_infoButton = (Button) findViewById(R.id.infoButton);
		_levelSpinner = (Spinner) findViewById(R.id.Spinner01);
		
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
	}
	
    protected void onRestart()
    {
    	Log.i("Menu", "onRestart");
    	super.onRestart();
    }

    protected void onResume()
    {
    	Log.i("Menu", "onResume");
    	super.onResume();
    	
    	_startButton.setEnabled(true);
    	_infoButton.setEnabled(true);
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
        startActivity(i);
	}
	
	
	public Menu() {
		// TODO Auto-generated constructor stub
	}

}
