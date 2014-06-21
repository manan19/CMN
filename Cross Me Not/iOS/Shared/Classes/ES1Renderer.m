//
//  ES1Renderer.m
//  Cross Me Not
//
//  Created by Manan Patel on 2/18/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "ES1Renderer.h"

@implementation ES1Renderer

// Create an OpenGL ES 1.1 context
- (id)init
{
    if (self = [super init])
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

        if (!context || ![EAGLContext setCurrentContext:context])
        {
            return nil;
        }

        // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
        glGenFramebuffersOES(1, &defaultFramebuffer);
        glGenRenderbuffersOES(1, &colorRenderbuffer);
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
    }

    return self;
}

- (void)render
{
    [EAGLContext setCurrentContext:context];

    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);

	glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
		// SETUP FOR LINES
	GLfloat lineVertices[graph->edgeCount * 4 + graph->edgeCount * 8];
	for (int i=0; i < graph->edgeCount; i++)
	{
		
		lineVertices[i*12] = (graph->vertices[graph->edges[i].vert1].x / (backingWidth/2) ) - 1;
		lineVertices[i*12+1] = -(graph->vertices[graph->edges[i].vert1].y / (backingHeight/2) ) + 1;
		if( graph->numberOfIntersectionsForEdge[i] > 0 )
		{
			lineVertices[i*12+2] = 0.0;
			lineVertices[i*12+3] = 0.0;
			lineVertices[i*12+4] = 0.0;
		}
		else 
		{
			lineVertices[i*12+2] = 0.0;
			lineVertices[i*12+3] = 1.0;
			lineVertices[i*12+4] = 0.0;
		}
		lineVertices[i*12+5] = 1.0;
		
		
		lineVertices[i*12+6] = (graph->vertices[graph->edges[i].vert2].x / (backingWidth/2) ) - 1;
		lineVertices[i*12+7] = -(graph->vertices[graph->edges[i].vert2].y / (backingHeight/2) ) + 1;
		if( graph->numberOfIntersectionsForEdge[i] > 0 )
		{
			lineVertices[i*12+8] = 0.0;
			lineVertices[i*12+9] = 0.0;
			lineVertices[i*12+10] = 0.0;
		}
		else 
		{
			lineVertices[i*12+8] = 0.0;
			lineVertices[i*12+9] = 1.0;
			lineVertices[i*12+10] = 0.0;
		}
		lineVertices[i*12+11] = 1.0;
		
		//graph->cleanEdges[i] = 0;
	}
	
		// RENDERING LINES
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_LINE_SMOOTH);
	glLineWidth(3.0f*scale);
	glVertexPointer(2, GL_FLOAT, 24, lineVertices);
	glColorPointer(4, GL_FLOAT, 24, &lineVertices[2]);
	glDrawArrays(GL_LINES, 0, 2 * graph->edgeCount);
	
	
		// SETUP FOR VERTICES
	GLfloat points[graph->vertexCount * 6];
	for (int i = 0 ; i < graph->vertexCount; i++) 
	{
		points[i*6] = (graph->vertices[i].x / (backingWidth/2) ) - 1;
		points[i*6+1] = -(graph->vertices[i].y / (backingHeight/2) ) + 1;
		
		points[i*6+2] = 1.0;
		points[i*6+3] = 0.0;
		points[i*6+4] = 0.0;
		points[i*6+5] = 1.0;
		
		if(graph->connectedVertices[i] == 1)
		{
			points[i*6+2] = 0.0;
			points[i*6+4] = 1.0;
		}
	}
	
		// RENDERING VERTICES
	glEnable(GL_POINT_SMOOTH);
	glPointSize(12.0*scale);
	glVertexPointer(2, GL_FLOAT, 24, points);
	glColorPointer(4, GL_FLOAT, 24, &points[2]);
	glDrawArrays(GL_POINTS, 0, graph->vertexCount);
    
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
}

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{	
    // Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);

    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }

    return YES;
}

- (void)dealloc
{
    // Tear down GL
    if (defaultFramebuffer)
    {
        glDeleteFramebuffersOES(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }

    if (colorRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }

    // Tear down context
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];

    context = nil;
}

@end
