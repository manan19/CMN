package com.cmn.game;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.Paint.Style;
import android.graphics.Rect;
import android.view.MotionEvent;
import android.view.View;


public class GameView extends View 
{
	Rect _clippingRect;
	int _level;
	Bitmap _bitmap;
	Canvas _canvas;
	Paint _paintLineBlack;
	Paint _paintLineGreen;
	Paint _paintPoint;
	Paint _paintSelectedPoint;
	
	Point _endPoint;
	Point _startPoint;
	Boolean _touchLegal;
	Graph _graph;
	AlertDialog _alert;
	
	public GameView(Context context , int level)
	{
		super(context);
		_paintLineBlack = new Paint();
		_paintLineBlack.setColor(Color.BLACK);
		_paintLineBlack.setStyle(Style.STROKE);
		_paintLineBlack.setStrokeWidth(2);
		
		_paintLineGreen = new Paint();
		_paintLineGreen.setColor(Color.GREEN);
		_paintLineGreen.setStyle(Style.STROKE);
		_paintLineGreen.setStrokeWidth(2);
		
		_paintSelectedPoint = new Paint();
		_paintSelectedPoint.setColor(Color.BLUE);
		_paintSelectedPoint.setStyle(Style.FILL);
		_paintSelectedPoint.setStrokeWidth(2);
		
		_paintPoint = new Paint();
		_paintPoint.setColor(Color.RED);
		_paintPoint.setStyle(Style.FILL);
		_paintPoint.setStrokeWidth(3);
		
		this.setFocusable(true);
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
	}
	
	@Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) 
	{
        int screenWidth = View.MeasureSpec.getSize(widthMeasureSpec);
        int screenHeight = View.MeasureSpec.getSize(heightMeasureSpec);
        setMeasuredDimension(screenWidth, screenHeight);
        
        _bitmap = Bitmap.createBitmap(screenWidth, screenHeight, Bitmap.Config.ARGB_8888);
        _bitmap.eraseColor(Color.WHITE);
        _canvas = new Canvas(_bitmap);
        
        _clippingRect = new Rect(0, 50, screenWidth, screenHeight);
        _graph = new Graph(_clippingRect);
        newGame(_level);
	}
	
	
	@Override
	protected void onDraw(Canvas canvas) 
	{
		// TODO Auto-generated method stub
		canvas.drawBitmap(_bitmap, 0, 0, _paintLineBlack);
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
			
			int numIntersections = _graph.checkGraphForIntersections();
			if (numIntersections == 0)
			{
				_alert.show();
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
        	
    		if( _graph.numberOfIntersectionsForEdge[i] > 0 )
    			_canvas.drawLine(_graph.vertices[v1].x,_graph.vertices[v1].y, _graph.vertices[v2].x, _graph.vertices[v2].y, _paintLineBlack);
    		else
    			_canvas.drawLine(_graph.vertices[v1].x,_graph.vertices[v1].y, _graph.vertices[v2].x, _graph.vertices[v2].y, _paintLineGreen);
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

	public void newGame(int lvl)
	{
		_graph.initGraph(lvl);
		_canvas.drawColor(Color.WHITE);
		render();
		invalidate();
	}
	
	public void stareSuccess() 
	{
		
	}
	
}



