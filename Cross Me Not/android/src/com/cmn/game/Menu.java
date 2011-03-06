/**
 * 
 */
package com.cmn.game;

import java.util.ArrayList;
import java.util.Iterator;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;

import com.admob.android.ads.AdView;
import com.flurry.android.FlurryAgent;

/**
 * @author manan19
 *
 */
public final class Menu extends Activity {
	
	private Button _startButton;
	private Button _infoButton;
	private Spinner _levelSpinner;

	public static AdView adView;
	
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
    	Log.i("Menu", "onCreate");
		super.onCreate(savedInstanceState);
		
		FlurryAgent.onStartSession(this, "VKMXGMLCV74L7HSMA9JQ");
		
		setContentView(R.layout.menu);
		
		
		//Static Adview
		// this line is only for testing
		//AdManager.setTestDevices(new String[]{AdManager.TEST_EMULATOR,"E83D20734F72FB3108F104ABC0FFC738",});
		adView = new AdView(this);
		LayoutParams param = new LayoutParams(LayoutParams.FILL_PARENT,LayoutParams.WRAP_CONTENT); 
		addContentView(adView,param);
		
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
