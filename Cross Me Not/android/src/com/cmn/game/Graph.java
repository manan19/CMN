package com.cmn.game;

import java.util.Random;

import android.graphics.Point;

public class Graph 
{
	Random _rand;
	final int MAX_VERTEX_COUNT = 30;
	final int MAX_EDGE_COUNT = 100;
	int _screenWidth;
	int _screenHeight;
	
	public Point[] vertices;
	public Edge[] edges;
	
	public int vertexCount;
	public int edgeCount;
	public int selectedVertex;
	public int[] connectedVertices;
	public int[] numberOfIntersectionsForEdge;
	
	public  Graph(int w,int h)
	{
		_screenWidth = w;
		_screenHeight = h;
		vertices = new Point[MAX_VERTEX_COUNT];
		edges = new Edge[MAX_EDGE_COUNT];
		connectedVertices = new int[MAX_VERTEX_COUNT];
		numberOfIntersectionsForEdge = new int[MAX_EDGE_COUNT]; 
		
		for (int i=0; i<MAX_VERTEX_COUNT;i++)
		{
			vertices[i] = new Point();
		}
		
		for (int i=0; i<MAX_EDGE_COUNT;i++)
		{
			edges[i] = new Edge();
		}
		edgeCount = 0;
		vertexCount = 0;
		selectedVertex = -1;

		
		_rand = new Random();
	}
	
	public boolean lineIntersect(Point a1, Point a2, Point b1, Point b2)
	{
	    float	a1yb1y, a1xb1x, a2xa1x, a2ya1y;
	    float	crossa, crossb;
		
	    a1yb1y = a1.y-b1.y;
	    a1xb1x = a1.x-b1.x;
	    a2xa1x = a2.x-a1.x;
	    a2ya1y = a2.y-a1.y;
		
	    crossa = a1yb1y * ( b2.x - b1.x ) - a1xb1x * ( b2.y - b1.y );
	    crossb = a2xa1x * ( b2.y - b1.y ) - a2ya1y * ( b2.x - b1.x );
		
	    if ( crossb == 0 )
	    {
			return false;
	    }
	    else if ( Math.abs( crossa ) > Math.abs( crossb ) || crossa * crossb < 0.0f )
	    {
			return false;
	    }
	    else
	    {
			crossa = a1yb1y * a2xa1x - a1xb1x * a2ya1y;
			
			if ( Math.abs( crossa ) > Math.abs( crossb ) || crossa * crossb< 0.0f )
			{
				return false;   
			}
	    }
	    
	    return true;
	}

	public int checkGraphForIntersections()
	{
		int numberOfIntersections = 0;
		for (int i=0 ; i < edgeCount; i++)
		{
			numberOfIntersectionsForEdge[i] = 0;
		}
		
		for(int i = 0 ; i < edgeCount - 1 ; i ++)
		{
			for (int  j = i+1 ; j < edgeCount ; j++) 
			{
				if( edges[i].vert1 != edges[j].vert1 && edges[i].vert1 != edges[j].vert2 
				   && edges[i].vert2 != edges[j].vert1 && edges[i].vert2 != edges[j].vert2)
				{
					
					if ( lineIntersect(vertices[edges[i].vert1],
									 vertices[edges[i].vert2],  
									  vertices[edges[j].vert1] ,
									  vertices[edges[j].vert2] ) )
					{
						numberOfIntersections++;
						numberOfIntersectionsForEdge[i]++;
						numberOfIntersectionsForEdge[j]++;
					}
				}
			}
		}
		return numberOfIntersections;
	}
	
	public void moveSelectedVertexToLocation(Point location)
	{
		if (selectedVertex >= 0 && selectedVertex < vertexCount) 
		{
			vertices[selectedVertex].x = location.x;
			vertices[selectedVertex].y = Math.max ( 0 ,Math.min(location.y,_screenHeight) );
		}
	}


	
	public void initGraph(int lvl) 
	{
		int xLim = _screenWidth - 5;
		int yLim = _screenHeight - 5;
		
		vertices[0].x = _rand.nextInt(xLim) + 5;
		vertices[0].y = _rand.nextInt(yLim) + 5;
		vertices[1].x = _rand.nextInt(xLim) + 5;
		vertices[1].y = _rand.nextInt(yLim) + 5;
		vertices[2].x = _rand.nextInt(xLim) + 5;
		vertices[2].y = _rand.nextInt(yLim) + 5;
		vertices[3].x = _rand.nextInt(xLim) + 5;
		vertices[3].y = _rand.nextInt(yLim) + 5;
		vertices[4].x = _rand.nextInt(xLim) + 5;
		vertices[4].y = _rand.nextInt(yLim) + 5;
		vertices[5].x = _rand.nextInt(xLim) + 5;
		vertices[5].y = _rand.nextInt(yLim) + 5;
		
		
		edges[0].vert1 = 0;
		edges[0].vert2 = 1;
		edges[1].vert1 = 0;
		edges[1].vert2 = 2;
		edges[2].vert1 = 0; 
		edges[2].vert2 = 3;
		edges[3].vert1 = 1;
		edges[3].vert2 = 3;
		edges[4].vert1 = 2;
		edges[4].vert2 = 4;
		edges[5].vert1 = 3;
		edges[5].vert2 = 4;
		edges[6].vert1 = 3;
		edges[6].vert2 = 5;
		edges[7].vert1 = 4;
		edges[7].vert2 = 5;
		
		vertexCount = 6;
		edgeCount = 8;
		
		for (int i = 0 ; i < edgeCount ; i++) 
		{
			numberOfIntersectionsForEdge[i] = 0;
		}
		
		if (checkGraphForIntersections() <= (lvl+1)*2)
		{
			initGraph(lvl);
		}
		
		

	}
}
