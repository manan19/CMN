	//
	//  EAGLView.m
	//  Cross Me Not
	//
	//  Created by Manan Patel on 2/18/10.
	//  Copyright Apple Inc 2010. All rights reserved.
	//

#import "EAGLView.h"
#import "AppDelegate_Phone.h"

@implementation EAGLView


	// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
    {
			// Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
			//renderer = [[ES2Renderer alloc] init];
		
        if (!renderer)
        {
            renderer = [[ES1Renderer alloc] init];
			
            if (!renderer)
            {
                [self release];
                return nil;
            }
        }
		
		
		screenWidth = [UIScreen mainScreen].currentMode.size.width;
		screenHeight = [UIScreen mainScreen].currentMode.size.height;
		
		if (screenWidth > 320) 
		{
				// It's the iPhone4
			renderer->scale = 2;
			eaglLayer.contentsScale = 2;
		}
		else 
		{
			renderer->scale = 1;
		}
		
		playingGame = FALSE;
		aView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Well Done",@"") message:NSLocalizedString(@"What would you like to do?",@"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Play Again",@""),NSLocalizedString(@"Play Next Level",@""),NSLocalizedString(@"Go Back To Menu",@""),NSLocalizedString(@"Stare at your Success",@""),nil];
    }
	return self;
}

- (void) newGraph:(int) lvl
{
	if (renderer->graph)
		[renderer->graph release];
	renderer->graph = [[Graph alloc] initGraph:lvl clippingRect:clippingRect];
	
	[self layoutSubviews];
}

- (void)drawView:(id)sender
{
    [renderer render];
}

- (void)layoutSubviews
{
    [renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}

- (void) endGame 
{
	playingGame = FALSE;
	[aView show];
	
	AppDelegate_Phone* appDel = (AppDelegate_Phone*)([[UIApplication sharedApplication] delegate]);
	[appDel endGame];
}

-(float)distanceSquared:(CGPoint)p1  p2:(CGPoint)p2
{
	return ((p1.x-p2.x)*(p1.x-p2.x) + (p1.y - p2.y)*(p1.y - p2.y));
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (playingGame)
	{
		UITouch *touch = [touches anyObject];
		CGPoint location = [touch locationInView:touch.view];
		int leastDistance = 625;
		int thisDistance;
		
		location.x = location.x * renderer->scale;
		location.y = location.y * renderer->scale;
		
		for (int i=0; i < renderer->graph->vertexCount; i++)
		{
			thisDistance = [self distanceSquared:renderer->graph->vertices[i] p2:location];
			if (thisDistance < leastDistance)
			{
				leastDistance = thisDistance;
					//[appDel setUiHidden:YES];
				renderer->graph->selectedVertex = i;
				
					//Populate selected vertices
				for( int j = 0 ; j < renderer->graph->edgeCount ; j++)
				{
					if(renderer->graph->edges[j].vert1 == i || renderer->graph->edges[j].vert2 == i)
					{
						renderer->graph->connectedVertices[renderer->graph->edges[j].vert1] = 1;
						renderer->graph->connectedVertices[renderer->graph->edges[j].vert2] = 1;
					}
				}
				return;
			}
		}
		
			// Try again with a larger radius
		leastDistance = 1600;
		for (int i=0; i < renderer->graph->vertexCount; i++)
		{
			thisDistance = [self distanceSquared:renderer->graph->vertices[i] p2:location];
			if (thisDistance < leastDistance)
			{
				leastDistance = thisDistance;
					//[appDel setUiHidden:YES];
				renderer->graph->selectedVertex = i;
				
					//Populate selected vertices
				for( int j = 0 ; j < renderer->graph->edgeCount ; j++)
				{
					if(renderer->graph->edges[j].vert1 == i || renderer->graph->edges[j].vert2 == i)
					{
						renderer->graph->connectedVertices[renderer->graph->edges[j].vert1] = 1;
						renderer->graph->connectedVertices[renderer->graph->edges[j].vert2] = 1;
					}
				}
				return;
			}
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (playingGame) 
	{
		UITouch *touch = [touches anyObject];
		CGPoint location = [touch locationInView:touch.view];
		location.x = location.x * renderer->scale;
		location.y = location.y * renderer->scale;
		
		[renderer->graph moveSelectedVertexToLocation:location clippingRect:clippingRect];
		
		[renderer->graph checkGraphForIntersections];
		
		[renderer render];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(playingGame)
	{
		if ([renderer->graph checkGraphForIntersections] == 0 && renderer->graph->selectedVertex >= 0)
		{
			[self endGame];
			
				//[NSTimer scheduledTimerWithTimeInterval:(1) target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO];
		}
		
			//Clear selected vertex and connected vertices in graph
		renderer->graph->selectedVertex = -1;
		for (int i = 0; i < renderer->graph->vertexCount; i++) 
		{
			renderer->graph->connectedVertices[i] = 0;
		}
		[renderer render];
	}
}

- (void)dealloc
{
    [renderer release];
	[aView release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	AppDelegate_Phone* appDel = (AppDelegate_Phone*)([[UIApplication sharedApplication] delegate]);
	switch (buttonIndex) {
		case 0:
			[appDel startGame:nil];
			break;
		case 1:
			if(appDel->currentLevel < MAX_LEVELS - 1)
			{
				appDel->currentLevel++;
				[appDel startGame:nil];
			}
			break;
		case 2:
			[appDel menuButton:nil];
			break;
		default:
			break;
	}
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
}

@end
