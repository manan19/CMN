package com.cmn.game;

import java.util.Random;

import android.graphics.Point;
import android.graphics.Rect;

public class Graph 
{
	Random _rand;
	final int MAX_VERTEX_COUNT = 30;
	final int MAX_EDGE_COUNT = 100;
	Rect _clippingRect;
	
	public Point[] vertices;
	public Edge[] edges;
	
	public int vertexCount;
	public int edgeCount;
	public int selectedVertex;
	public int[] connectedVertices;
	public int[] numberOfIntersectionsForEdge;
	
	public  Graph(Rect clippingRect)
	{
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

		_clippingRect = clippingRect;
		_clippingRect.left += 5;
		_clippingRect.top += 5;
		_clippingRect.bottom -= 5;
		_clippingRect.right -=5;
		
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
			vertices[selectedVertex].y = Math.max ( _clippingRect.top ,Math.min(location.y,_clippingRect.bottom) );
		}
	}


	
	public void initGraph(int lvl) 
	{
		if( lvl >= 0 )
		{
			vertices[0].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[0].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			vertices[1].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[1].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			vertices[2].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[2].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			vertices[3].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[3].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			vertices[4].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[4].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			vertices[5].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[5].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
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
		}
		
		if(lvl >= 1)
		{
			vertices[6].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[6].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			vertices[7].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[7].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 8;
			
			edges[8].vert1 = 6;
			edges[8].vert2 = 5;
			edges[9].vert1 = 6;
			edges[9].vert2 = 7;
			edges[10].vert1 = 1;
			edges[10].vert2 = 7;
			
			edgeCount = 11;
		}
		if(lvl >= 2)
		{
			vertices[8].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[8].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 9;
			
			edges[11].vert1 = 1;
			edges[11].vert2 = 6;
			edges[12].vert1 = 5;
			edges[12].vert2 = 8;
			edges[13].vert1 = 6;
			edges[13].vert2 = 8;
			
			edgeCount = 14;
		}
		if(lvl >= 3)
		{
			
			vertices[9].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[9].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			vertices[10].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[10].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 11;
			
			edges[14].vert1 = 9;
			edges[14].vert2 = 4;
			edges[15].vert1 = 9;
			edges[15].vert2 = 8;
			edges[16].vert1 = 8;
			edges[16].vert2 = 10;
			edges[17].vert1 = 9;
			edges[17].vert2 = 10;
			
			edgeCount = 18;
		}
		if(lvl >= 4)
		{
			vertices[11].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[11].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			vertices[12].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[12].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 13;
			
			edges[18].vert1 = 0;
			edges[18].vert2 = 11;
			edges[19].vert1 = 11;
			edges[19].vert2 = 12;
			edges[20].vert1 = 7;
			edges[20].vert2 = 12;
			
			edgeCount = 21;
		}
		if(lvl >= 5)
		{
			vertices[13].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[13].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			vertices[14].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[14].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 15;
			
			edges[21].vert1 = 7;
			edges[21].vert2 = 13;
			edges[22].vert1 = 13;
			edges[22].vert2 = 14;
			edges[23].vert1 = 12;
			edges[23].vert2 = 14;
			
			edgeCount = 24;
		}
		if(lvl >= 6)
		{
			vertices[15].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[15].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 16;
			
			edges[24].vert1 = 12;
			edges[24].vert2 = 13;
			edges[25].vert1 = 9;
			edges[25].vert2 = 15;
			edges[26].vert1 = 10;
			edges[26].vert2 = 15;
			
			edgeCount = 27;
		}
		if(lvl >= 7)
		{
			vertices[16].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[16].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			vertices[17].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[17].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 18;
			
			edges[27].vert1 = 2;
			edges[27].vert2 = 16;
			edges[28].vert1 = 16;
			edges[28].vert2 = 17;
			edges[29].vert1 = 11;
			edges[29].vert2 = 17;
			
			edgeCount = 30;
		}
		if(lvl >= 8)
		{	
			vertices[18].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[18].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			vertices[19].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[19].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 20;
			
			edges[30].vert1 = 18;
			edges[30].vert2 = 17;
			edges[31].vert1 = 18;
			edges[31].vert2 = 19;
			edges[32].vert1 = 14;
			edges[32].vert2 = 19;
			
			edgeCount = 33;
		}
		if(lvl >= 9)
		{
			vertices[20].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[20].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 21;
			
			edges[33].vert1 = 17;
			edges[33].vert2 = 20;
			edges[34].vert1 = 18;
			edges[34].vert2 = 20;
			edges[35].vert1 = 11;
			edges[35].vert2 = 18;
			
			edgeCount = 36;
		}
		
		if(lvl >= 10)
		{
				//vertices[21].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
				//vertices[21].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 21;
			
			edges[36].vert1 = 1;
			edges[36].vert2 = 12;
			edges[37].vert1 = 16;
			edges[37].vert2 = 20;
			edges[38].vert1 = 15;
			edges[38].vert2 = 16;
			
			edgeCount = 39;
		}
		
		if(lvl >= 11)
		{
				//vertices[20].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
				//vertices[20].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 21;
			
			edges[39].vert1 = 12;
			edges[39].vert2 = 19;
			edges[40].vert1 = 11;
			edges[40].vert2 = 19;
			edges[41].vert1 = 2;
			edges[41].vert2 = 17;
			
			edgeCount = 42;
		}
		if(lvl >= 12)
		{
			vertices[21].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[21].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 22;
			
			edges[42].vert1 = 7;
			edges[42].vert2 = 21;
			edges[43].vert1 = 6;
			edges[43].vert2 = 21;
			edges[44].vert1 = 8;
			edges[44].vert2 = 21;
			edges[45].vert1 = 10;
			edges[45].vert2 = 21;
			
			edgeCount = 46;
		}
		if(lvl >= 13)
		{
			vertices[22].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[22].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 23;
			
			edges[46].vert1 = 13;
			edges[46].vert2 = 22;
			edges[47].vert1 = 21;
			edges[47].vert2 = 22;

			edgeCount = 48;
		}
		
		if(lvl >= 14)
		{
			vertices[23].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[23].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 24;
			
			edges[48].vert1 = 20;
			edges[48].vert2 = 23;
			edges[49].vert1 = 18;
			edges[49].vert2 = 23;
			edges[50].vert1 = 19;
			edges[50].vert2 = 23;
			
			edgeCount = 51;
		}
		
			///////////// PAID LEVELS
		
		if(lvl >= 15)
		{
			vertices[24].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[24].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 25;
			
			edges[51].vert1 = 24;
			edges[51].vert2 = 15;
			edges[52].vert1 = 16;
			edges[52].vert2 = 24;
			edges[53].vert1 = 3;
			edges[53].vert2 = 6;
			
			edgeCount = 54;
		}
		
		if(lvl >= 16)
		{
			vertices[25].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[25].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 26;
			
			edges[54].vert1 = 23;
			edges[54].vert2 = 25;
			edges[55].vert1 = 14;
			edges[55].vert2 = 25;
			edges[56].vert1 = 1;
			edges[56].vert2 = 11;
			
			edgeCount = 57;
		}
		
		if(lvl >= 17)
		{
			vertices[26].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[26].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 27;
			
			edges[57].vert1 = 26;
			edges[57].vert2 = 14;
			edges[58].vert1 = 13;
			edges[58].vert2 = 26;
			edges[59].vert1 = 26;
			edges[59].vert2 = 22;
			
			edgeCount = 60;
		}
		
		if(lvl >= 18)
		{
			vertices[27].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[27].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 28;
			
			edges[60].vert1 = 20;
			edges[60].vert2 = 27;
			edges[61].vert1 = 24;
			edges[61].vert2 = 27;
			
			edgeCount = 62;
		}
		
		if(lvl >= 19)
		{
			vertices[28].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[28].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 29;
			
			edges[62].vert1 = 14;
			edges[62].vert2 = 28;
			edges[63].vert1 = 25;
			edges[63].vert2 = 28;
			edges[64].vert1 = 26;
			edges[64].vert2 = 28;
			
			edgeCount = 65;
		}
		
		if(lvl >= 20)
		{
			vertices[29].x = _rand.nextInt(_clippingRect.width()) + _clippingRect.left;
			vertices[29].y = _rand.nextInt(_clippingRect.height()) + _clippingRect.top;
			
			vertexCount = 30;
			
			edges[65].vert1 = 29;
			edges[65].vert2 = 27;
			edges[66].vert1 = 29;
			edges[66].vert2 = 24;
			edges[67].vert1 = 29;
			edges[67].vert2 = 15;
			
			edgeCount = 68;
		}
		
		if(lvl >= 21)
		{
			edges[68].vert1 = 4;
			edges[68].vert2 = 15;
			edges[69].vert1 = 2;
			edges[69].vert2 = 3;
			edges[70].vert1 = 19;
			edges[70].vert2 = 25;
			
			edgeCount = 71;
		}
		
		if(lvl >= 22)
		{
			edges[71].vert1 = 2;
			edges[71].vert2 = 15;
			edges[72].vert1 = 5;
			edges[72].vert2 = 9;
			
			edgeCount = 73;
		}
		
		if(lvl >= 23)
		{
			edges[73].vert1 = 16;
			edges[73].vert2 = 27;
			edges[74].vert1 = 21;
			edges[74].vert2 = 26;
			
			edgeCount = 75;
		}
		
		if(lvl >= 24)
		{
			edges[75].vert1 = 25;
			edges[75].vert2 = 26;
			edges[76].vert1 = 25;
			edges[76].vert2 = 20;
			edges[77].vert1 = 20;
			edges[77].vert2 = 29;
			
			edgeCount = 78;
		}
		
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
