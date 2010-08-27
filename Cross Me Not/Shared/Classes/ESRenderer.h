//
//  ESRenderer.h
//  Cross Me Not
//
//  Created by Manan Patel on 2/18/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Graph.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

@interface ESRenderer :NSObject
{
@public	
	Graph *graph;
}
- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end


