package com.cmnsteps.linedraw;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.Paint.Style;
import android.view.MotionEvent;
import android.view.View;

public class Board extends View 
{
	int _width;
	int _height;
	Bitmap _bitmap;
	Canvas _canvas;
	Paint _paint;
	Point _endPoint;
	Point _startPoint;
	Boolean _touchLegal;
	
	public Board(Context context)
	{
		super(context);
		_paint = new Paint();
		_paint.setColor(Color.RED);
		_paint.setStyle(Style.STROKE);
		this.setFocusable(true);
		_touchLegal = false;
		
	}
	
	@Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) 
	{
        _width = View.MeasureSpec.getSize(widthMeasureSpec);
        _height = View.MeasureSpec.getSize(heightMeasureSpec);
        setMeasuredDimension(_width, _height);
        
        _bitmap = Bitmap.createBitmap(_width, _height, Bitmap.Config.ARGB_8888);
        _canvas = new Canvas(_bitmap);
        
        _endPoint = new Point(_width, _height);
        _startPoint = new Point(_width/2, _height/2);
        _canvas.drawLine(_startPoint.x,_startPoint.y, _endPoint.x, _endPoint.y, _paint);
	}
	
	
	@Override
	protected void onDraw(Canvas canvas) 
	{
		// TODO Auto-generated method stub
		canvas.drawBitmap(_bitmap, 0, 0, _paint);
	}
	
	@Override
	public boolean onTouchEvent(MotionEvent event) 
	{
		if (event.getAction() == MotionEvent.ACTION_DOWN)
		{
			Point currentPoint = new Point((int)event.getX(),(int)event.getY());
			
			if (Distance(currentPoint,_endPoint))
			{
				_touchLegal = true;
				
			}
			
		}
		else if ((event.getAction() == MotionEvent.ACTION_MOVE) && _touchLegal) 
		{
			_endPoint.x = (int)event.getX();
			_endPoint.y = (int)event.getY();
			_canvas.drawColor(Color.BLACK);
			_canvas.drawLine(_startPoint.x,_startPoint.y, _endPoint.x, _endPoint.y, _paint);
			invalidate();
		}
		else if (event.getAction() == MotionEvent.ACTION_UP)
		{
			_touchLegal = false;
		}
		
		
		return true;
	}
	
	private Boolean Distance(Point p1,Point p2) 
	{
		
		int distSqaured = (p1.x - p2.x)^2 + (p1.y - p2.y)^2;
		if (distSqaured < 10)
			return true;
		else
			return false;
	}
}
