package com.cmn.game;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Align;
import android.graphics.Paint.Style;
import android.graphics.Point;
import android.graphics.Rect;
import android.os.CountDownTimer;
import android.preference.PreferenceManager;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;


public class GameView extends LinearLayout 
{
	Rect _clippingRect;
	int _level;
	Bitmap _bitmap;
	Canvas _canvas;
	Paint _paintLineBlack;
	Paint _paintLineGreen;
	Paint _paintPoint;
	Paint _paintSelectedPoint;
	
	Canvas _canvasText;
	Bitmap _bitmapText;
	Paint _paintText;
	int _textHeight;
	int _textWidth;
	
	Point _endPoint;
	Point _startPoint;
	Boolean _touchLegal;
	Graph _graph;
	AlertDialog _alert;
	Boolean _gameComplete;
	
	float _timer;
	TextView _timerLabel;
	CountDownTimer timer;
    
	public GameView(Context context) {
		super(context);
    }
    public GameView(Context context, AttributeSet attrs) {
            super(context, attrs);
    }
    
	public GameView(Context context, int level) {
		super(context);		
		setWillNotDraw(false);
		
		_paintText = new Paint(Paint.ANTI_ALIAS_FLAG);
		_paintText.setColor(Color.BLACK);
		_paintText.setTextSize(20);
		_paintText.setTextAlign(Align.LEFT);
		
		_paintLineBlack = new Paint(Paint.ANTI_ALIAS_FLAG);
		_paintLineBlack.setColor(Color.BLACK);
		_paintLineBlack.setStyle(Style.STROKE);
		_paintLineBlack.setStrokeWidth(2);
		
		_paintLineGreen = new Paint(Paint.ANTI_ALIAS_FLAG);
		_paintLineGreen.setColor(Color.GREEN);
		_paintLineGreen.setStyle(Style.STROKE);
		_paintLineGreen.setStrokeWidth(2);
		
		_gameComplete = false;
		
		_paintSelectedPoint = new Paint(Paint.ANTI_ALIAS_FLAG);
		_paintSelectedPoint.setColor(Color.BLUE);
		_paintSelectedPoint.setStyle(Style.FILL);
		
		_paintPoint = new Paint(Paint.ANTI_ALIAS_FLAG);
		_paintPoint.setColor(Color.RED);
		_paintPoint.setStyle(Style.FILL);
		
		setFocusable(true);
		_touchLegal = false;

		_level = level;
		
		// alert view code
		AlertDialog.Builder builder = new AlertDialog.Builder(context);
		builder.setTitle("You Win")
		.setCancelable(false)
		.setPositiveButton("ShowSuccess", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int id) {
				stareSuccess();
           		}	
       		})
       		.setNegativeButton("NextLevel", new DialogInterface.OnClickListener() {
       			public void onClick(DialogInterface dialog, int id) {
       				newGame(++_level);
       			}
       		});
		_alert = builder.create();
		
		_timer = 0;
		_timerLabel = new TextView(context);
		_timerLabel.setTextColor(Color.BLACK);
		timer =  new CountDownTimer( 6000000, 33) {
			
			@Override
			public void onTick(long millisUntilFinished) {
				// TODO Auto-generated method stub
				_timer = 6000000-millisUntilFinished;
				_timer = _timer/10;
				_timer = Math.round(_timer);
				_timer = _timer/100;
				_timerLabel.setText(String.valueOf(_timer));
				
				_canvasText.drawColor(Color.WHITE);
				_canvasText.drawText(String.valueOf(_timer), 0, _paintText.getTextSize(), _paintText);
				invalidate();
			}
			
			@Override
			public void onFinish() {
				// TODO Auto-generated method stub
				Log.i("Menu","timerfinish");
			}
		};
		addView(_timerLabel);
	}
	
	@Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) 
	{
        int screenWidth = View.MeasureSpec.getSize(widthMeasureSpec);
        int screenHeight = View.MeasureSpec.getSize(heightMeasureSpec);
        setMeasuredDimension(screenWidth, screenHeight);
        
        // Has been manipulated to scale according to screen size
        float drawScale;
        drawScale = (screenWidth + screenHeight)/600;
        _paintPoint.setStrokeWidth(drawScale*7.0f);
        _paintSelectedPoint.setStrokeWidth(drawScale*7.0f);
        _paintLineBlack.setStrokeWidth(drawScale*2.0f);
        _paintLineGreen.setStrokeWidth(drawScale*2.0f);
        _paintText.setTextSize(drawScale*15);
        _textHeight = (int) ( drawScale*18 );
        _textWidth = (int) ( drawScale*45 );
        
        _bitmapText = Bitmap.createBitmap(_textWidth, _textHeight, Bitmap.Config.ARGB_8888);
        _bitmapText.eraseColor(Color.WHITE);
        _canvasText = new Canvas(_bitmapText);
        
        _bitmap = Bitmap.createBitmap(screenWidth, screenHeight, Bitmap.Config.ARGB_8888);
        _bitmap.eraseColor(Color.WHITE);
        _canvas = new Canvas(_bitmap);
        
        _clippingRect = new Rect(0, screenHeight/10, screenWidth, screenHeight);
        _graph = new Graph(_clippingRect);
        newGame(_level);
	}
	
	
	@Override
	protected void onDraw(Canvas canvas) 
	{
		// TODO Auto-generated method stub
		canvas.drawBitmap(_bitmap, 0, 0, _paintLineBlack);
		
		canvas.drawBitmap(_bitmapText, 0, _clippingRect.bottom - _textHeight + 5, _paintLineBlack);
	}
	
	@Override
	public boolean onTouchEvent(MotionEvent event) 
	{
		if (_gameComplete)
		{
			_graph.selectedVertex = -1;
			for (int i = 0; i < _graph.vertexCount; i++) 
			{
				_graph.connectedVertices[i] = 0;
			}
			render();
			return true;
		}
		if (event.getAction() == MotionEvent.ACTION_DOWN)
		{
			Point currentPoint = new Point((int)event.getX(),(int)event.getY());

			
			int leastDistance = 625;
			int thisDistance;
			
			for (int i=0; i < _graph.vertexCount; i++)
			{
				thisDistance =  distanceSquared(_graph.vertices[i],currentPoint);
				if (thisDistance < leastDistance)
				{
					leastDistance = thisDistance;
						//[appDel setUiHidden:YES];
					_graph.selectedVertex = i;
					
						//Populate selected vertices
					for( int j = 0 ; j < _graph.edgeCount ; j++)
					{
						if(_graph.edges[j].vert1 == i || _graph.edges[j].vert2 == i)
						{
							_graph.connectedVertices[_graph.edges[j].vert1] = 1;
							_graph.connectedVertices[_graph.edges[j].vert2] = 1;
						}
					}
					return true;
				}
			}
			
		}
		else if ((event.getAction() == MotionEvent.ACTION_MOVE)) 
		{
			
			Point currentPoint = new Point((int)event.getX(),(int)event.getY());
			
			_graph.moveSelectedVertexToLocation(currentPoint);
			
			_graph.checkGraphForIntersections();

			render();
		}
		else if (event.getAction() == MotionEvent.ACTION_UP)
		{
			_graph.selectedVertex = -1;
			for (int i = 0; i < _graph.vertexCount; i++) 
			{
				_graph.connectedVertices[i] = 0;
			}
			
			int numIntersections = _graph.checkGraphForIntersections();
			if (numIntersections == 0)
			{
				endGame();
			}
			
			render();
		}
		
		
		return true;
	}
	
	
	private void render()
	{
		_canvas.drawColor(Color.WHITE);

		for (int i = 0; i < _graph.edgeCount ;i++)
        {
        	int v1 = _graph.edges[i].vert1;
        	int v2 = _graph.edges[i].vert2;
        	
    		if( _graph.numberOfIntersectionsForEdge[i] > 0 )
    			_canvas.drawLine(_graph.vertices[v1].x,_graph.vertices[v1].y, _graph.vertices[v2].x, _graph.vertices[v2].y, _paintLineBlack);
    		else
    			_canvas.drawLine(_graph.vertices[v1].x,_graph.vertices[v1].y, _graph.vertices[v2].x, _graph.vertices[v2].y, _paintLineGreen);
        }
		
		for (int i=0;i<_graph.vertexCount;i++)
		{
			if( _graph.connectedVertices[i] == 1 )
				_canvas.drawCircle(_graph.vertices[i].x,_graph.vertices[i].y,_paintSelectedPoint.getStrokeWidth() , _paintSelectedPoint);
			else
				_canvas.drawCircle(_graph.vertices[i].x,_graph.vertices[i].y,_paintPoint.getStrokeWidth() , _paintPoint);
		}
		
		invalidate();
	}
	
	private int distanceSquared(Point p1,Point p2)
	{
		return ((p1.x-p2.x)*(p1.x-p2.x) + (p1.y - p2.y)*(p1.y - p2.y));
	} 

	public void endGame()
	{
		reportScore();
		_alert.show();
		_gameComplete = true;
		timer.cancel();
	}
	
	public void reportScore()
	{
		String level = String.valueOf(_level);
		float currScore = _timer;
		SharedPreferences pref = PreferenceManager.getDefaultSharedPreferences(getContext());
		float prevScore = pref.getFloat(level, -99);
	    if(prevScore == -99 || prevScore > currScore)
	    	pref.edit().putFloat(level, currScore).commit();	    
	}
	
	public void newGame(int lvl)
	{
		_gameComplete = false;
		_graph.initGraph(lvl);
		render();
		timer.start();
	}
	
	public void stareSuccess() 
	{
		
	}
	
}



