package com.cmn.game;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.Paint.Style;
import android.view.MotionEvent;
import android.view.View;


public class GameView extends View 
{
	int _width;
	int _height;
	Bitmap _bitmap;
	Canvas _canvas;
	Paint _paint;
	Paint _paintPoint;
	Paint _paintSelectedPoint;
	
	Point _endPoint;
	Point _startPoint;
	Boolean _touchLegal;
	Graph _graph;
	
	public GameView(Context context)
	{
		super(context);
		_paint = new Paint();
		_paint.setColor(Color.BLACK);
		_paint.setStyle(Style.STROKE);
		_paint.setStrokeWidth(2);
		
		_paintSelectedPoint = new Paint();
		_paintSelectedPoint.setColor(Color.GREEN);
		_paintSelectedPoint.setStyle(Style.STROKE);
		_paintSelectedPoint.setStrokeWidth(2);
		
		_paintPoint = new Paint();
		_paintPoint.setColor(Color.RED);
		_paintPoint.setStyle(Style.FILL);
		_paintPoint.setStrokeWidth(3);
		
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
        _bitmap.eraseColor(Color.WHITE);
        _canvas = new Canvas(_bitmap);
        
        _graph = new Graph(_width, _height);
        _graph.initGraph(0);
        
       /* _endPoint = new Point(_width, _height);
        _startPoint = new Point(_width/2, _height/2);
        _canvas.drawLine(_startPoint.x,_startPoint.y, _endPoint.x, _endPoint.y, _paint);*/
        
        render();
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
			
			/*if (Distance(currentPoint,_endPoint))
			{
				_touchLegal = true;
				
			}*/
			
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
			_canvas.drawColor(Color.WHITE);
			render();
			invalidate();
		}
		else if (event.getAction() == MotionEvent.ACTION_UP)
		{
			_graph.selectedVertex = -1;
			for (int i = 0; i < _graph.vertexCount; i++) 
			{
				_graph.connectedVertices[i] = 0;
			}
			_canvas.drawColor(Color.WHITE);
			render();
			invalidate();
		}
		
		
		return true;
	}
	
	private void render()
	{
		for (int i = 0; i < _graph.edgeCount ;i++)
        {
        	int v1 = _graph.edges[i].vert1;
        	int v2 = _graph.edges[i].vert2;
        	
        	_canvas.drawLine(_graph.vertices[v1].x,_graph.vertices[v1].y, _graph.vertices[v2].x, _graph.vertices[v2].y, _paint);
        }
		
		for (int i=0;i<_graph.vertexCount;i++)
		{
			if( _graph.connectedVertices[i] == 1 )
				_canvas.drawCircle(_graph.vertices[i].x,_graph.vertices[i].y,5 , _paintSelectedPoint);
			else
				_canvas.drawCircle(_graph.vertices[i].x,_graph.vertices[i].y,5 , _paintPoint);
		}
		
		
	}
	
	private int distanceSquared(Point p1,Point p2)
	{
		return ((p1.x-p2.x)*(p1.x-p2.x) + (p1.y - p2.y)*(p1.y - p2.y));
	} 

	
}



