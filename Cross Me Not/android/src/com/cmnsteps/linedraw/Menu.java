/**
 * 
 */
package com.cmnsteps.linedraw;

import android.app.Activity;
import android.view.View;
import android.widget.Button;
import android.widget.Spinner;
import android.os.Bundle;

/**
 * @author manan19
 *
 */
public class Menu extends Activity {
	Board _board;
	
	private Button _startButton;
	private Spinner _levelSpinner;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.menu);
		
		_startButton = (Button) findViewById(R.id.start);
		_levelSpinner = (Spinner) findViewById(R.id.Spinner01);
		
        _board = new Board(this);
        _startButton.setOnClickListener(new View.OnClickListener() 
        {
            public void onClick(View v) 
            {
            	_start();
            }
        });
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
