#import "Graph.h"


@implementation Graph

-(id)init
{
	[super init];
	edgeCount = 0;
	vertexCount = 0;
	selectedVertex = -1;
	for (int i = 0; i < MAX_VERTEX_COUNT; i++) 
	{
		connectedVertices[i] = 0;
	}
	return self;
}

-(Boolean)lineIntersect:(CGPoint)a1 Point2:(CGPoint)a2 Point3:(CGPoint)b1 Point4:(CGPoint)b2
{
	//----------------------------------------------------------------------
    
    float	a1yb1y, a1xb1x, a2xa1x, a2ya1y;
    float	crossa, crossb;
	
    //----------------------------------------------------------------------
	
    a1yb1y = a1.y-b1.y;
    a1xb1x = a1.x-b1.x;
    a2xa1x = a2.x-a1.x;
    a2ya1y = a2.y-a1.y;
	
    //----------------------------------------------------------------------
	
    crossa = a1yb1y * ( b2.x - b1.x ) - a1xb1x * ( b2.y - b1.y );
    crossb = a2xa1x * ( b2.y - b1.y ) - a2ya1y * ( b2.x - b1.x );
	
    //----------------------------------------------------------------------
    
    if ( crossb == 0 )
    {
		return FALSE;
    }
    else if ( fabs( crossa ) > fabs( crossb ) || crossa * crossb < 0.0f )
    {
		return FALSE;
    }
    else
    {
		crossa = a1yb1y * a2xa1x - a1xb1x * a2ya1y;
		
		if ( fabs( crossa ) > fabs( crossb ) || crossa * crossb< 0.0f )
		{
			return FALSE;   
		}
    }
    
    //----------------------------------------------------------------------
    
    return TRUE;
}

-(int)checkGraphForIntersections
{
	int numberOfIntersections = 0;
	for(int i = 0 ; i < edgeCount - 1 ; i ++)
	{
		for (int  j = i+1 ; j < edgeCount ; j++) 
		{
			if( edges[i].vert1 != edges[j].vert1 && edges[i].vert1 != edges[j].vert2 
			   && edges[i].vert2 != edges[j].vert1 && edges[i].vert2 != edges[j].vert2)
			{
				
				if ( [self lineIntersect:vertices[edges[i].vert1] 
								  Point2:vertices[edges[i].vert2]  
								  Point3:vertices[edges[j].vert1] 
								  Point4:vertices[edges[j].vert2] ] )
				{
					numberOfIntersections++;
				}
			}
		}
	}
	return numberOfIntersections;
}

@end
