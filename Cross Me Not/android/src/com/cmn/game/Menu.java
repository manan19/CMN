/**
 * 
 */
package com.cmn.game;

import java.util.ArrayList;
import java.util.Iterator;

import com.cmn.game.R;

import android.app.Activity;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;
import android.os.Bundle;

/**
 * @author manan19
 *
 */
public class Menu extends Activity {
	GameView _board;
	
	private Button _startButton;
	private Spinner _levelSpinner;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.menu);
		
		_board = new GameView(this);
		
		_startButton = (Button) findViewById(R.id.start);
		_levelSpinner = (Spinner) findViewById(R.id.Spinner01);
		
        _startButton.setOnClickListener(new View.OnClickListener() 
        {
            public void onClick(View v) 
            {
            	_start();
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
	/**
	 * 
	 */
	
	public void _start()
	{
		setContentView(_board);
	}
	
	
	public Menu() {
		// TODO Auto-generated constructor stub
	}

}
