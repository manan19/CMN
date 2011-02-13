package com.cmnsteps.linedraw;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class Lines extends Activity 
{
	
	Board _board;
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        //setContentView(new Board(this));
        setContentView(R.layout.menu);
        final Button button = (Button) findViewById(R.id.start);
        _board = new Board(this);
        button.setOnClickListener(new View.OnClickListener() 
        {
            public void onClick(View v) 
            {
                Start(v);
            }
        });
    }
    
    public void Start(View view)// on click listener
    {
    	setContentView(_board);
    }
}