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
		
		GAME_X_MAX = [UIScreen mainScreen].currentMode.size.width;
		GAME_Y_MAX = [UIScreen mainScreen].currentMode.size.height;
		
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
		
		if (GAME_X_MAX > 320) 
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

- (void) initGraph:(int) lvl
{
	[renderer->graph release];
	renderer->graph = [Graph new];
	
	if(lvl >= 0)
	{
		renderer->graph->vertices[0].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[0].y = arc4random()%(GAME_Y_MAX-10) + 5;
		renderer->graph->vertices[1].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[1].y = arc4random()%(GAME_Y_MAX-10) + 5;
		renderer->graph->vertices[2].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[2].y = arc4random()%(GAME_Y_MAX-10) + 5;
		renderer->graph->vertices[3].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[3].y = arc4random()%(GAME_Y_MAX-10) + 5;
		renderer->graph->vertices[4].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[4].y = arc4random()%(GAME_Y_MAX-10) + 5;
		renderer->graph->vertices[5].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[5].y = arc4random()%(GAME_Y_MAX-10) + 5;
		
		renderer->graph->vertexCount = 6;
		
		renderer->graph->edges[0].vert1 = 0;
		renderer->graph->edges[0].vert2 = 1;
		renderer->graph->edges[1].vert1 = 0;
		renderer->graph->edges[1].vert2 = 2;
		renderer->graph->edges[2].vert1 = 0;
		renderer->graph->edges[2].vert2 = 3;
		renderer->graph->edges[3].vert1 = 1;
		renderer->graph->edges[3].vert2 = 3;
		renderer->graph->edges[4].vert1 = 2;
		renderer->graph->edges[4].vert2 = 4;
		renderer->graph->edges[5].vert1 = 3;
		renderer->graph->edges[5].vert2 = 4;
		renderer->graph->edges[6].vert1 = 3;
		renderer->graph->edges[6].vert2 = 5;
		renderer->graph->edges[7].vert1 = 4;
		renderer->graph->edges[7].vert2 = 5;
		
		renderer->graph->edgeCount = 8;
	}	
	if(lvl >= 1)
	{
		renderer->graph->vertices[6].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[6].y = arc4random()%(GAME_Y_MAX-10) + 5;
		renderer->graph->vertices[7].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[7].y = arc4random()%(GAME_Y_MAX-10) + 5;
		
		renderer->graph->vertexCount = 8;
		
		renderer->graph->edges[8].vert1 = 6;
		renderer->graph->edges[8].vert2 = 5;
		renderer->graph->edges[9].vert1 = 6;
		renderer->graph->edges[9].vert2 = 7;
		renderer->graph->edges[10].vert1 = 1;
		renderer->graph->edges[10].vert2 = 7;
		
		renderer->graph->edgeCount = 11;
	}
	if(lvl >= 2)
	{
		renderer->graph->vertices[8].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[8].y = arc4random()%(GAME_Y_MAX-10) + 5;
		
		renderer->graph->vertexCount = 9;
		
		renderer->graph->edges[11].vert1 = 1;
		renderer->graph->edges[11].vert2 = 6;
		renderer->graph->edges[12].vert1 = 5;
		renderer->graph->edges[12].vert2 = 8;
		renderer->graph->edges[13].vert1 = 6;
		renderer->graph->edges[13].vert2 = 8;
		
		renderer->graph->edgeCount = 14;
	}
	if(lvl >= 3)
	{
		
		renderer->graph->vertices[9].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[9].y = arc4random()%(GAME_Y_MAX-10) + 5;
		renderer->graph->vertices[10].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[10].y = arc4random()%(GAME_Y_MAX-10) + 5;
		
		renderer->graph->vertexCount = 11;
		
		renderer->graph->edges[14].vert1 = 9;
		renderer->graph->edges[14].vert2 = 4;
		renderer->graph->edges[15].vert1 = 9;
		renderer->graph->edges[15].vert2 = 8;
		renderer->graph->edges[16].vert1 = 8;
		renderer->graph->edges[16].vert2 = 10;
		renderer->graph->edges[17].vert1 = 9;
		renderer->graph->edges[17].vert2 = 10;
		
		renderer->graph->edgeCount = 18;
	}
	if(lvl >= 4)
	{
		renderer->graph->vertices[11].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[11].y = arc4random()%(GAME_Y_MAX-10) + 5;
		renderer->graph->vertices[12].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[12].y = arc4random()%(GAME_Y_MAX-10) + 5;
		
		renderer->graph->vertexCount = 13;
		
		renderer->graph->edges[18].vert1 = 0;
		renderer->graph->edges[18].vert2 = 11;
		renderer->graph->edges[19].vert1 = 11;
		renderer->graph->edges[19].vert2 = 12;
		renderer->graph->edges[20].vert1 = 7;
		renderer->graph->edges[20].vert2 = 12;
		
		renderer->graph->edgeCount = 21;
	}
	if(lvl >= 5)
	{
		renderer->graph->vertices[13].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[13].y = arc4random()%(GAME_Y_MAX-10) + 5;
		renderer->graph->vertices[14].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[14].y = arc4random()%(GAME_Y_MAX-10) + 5;
		
		renderer->graph->vertexCount = 15;
		
		renderer->graph->edges[21].vert1 = 7;
		renderer->graph->edges[21].vert2 = 13;
		renderer->graph->edges[22].vert1 = 13;
		renderer->graph->edges[22].vert2 = 14;
		renderer->graph->edges[23].vert1 = 12;
		renderer->graph->edges[23].vert2 = 14;
		
		renderer->graph->edgeCount = 24;
	}
	if(lvl >= 6)
	{
		renderer->graph->vertices[15].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[15].y = arc4random()%(GAME_Y_MAX-10) + 5;
		
		renderer->graph->vertexCount = 16;
		
		renderer->graph->edges[24].vert1 = 12;
		renderer->graph->edges[24].vert2 = 13;
		renderer->graph->edges[25].vert1 = 9;
		renderer->graph->edges[25].vert2 = 15;
		renderer->graph->edges[26].vert1 = 10;
		renderer->graph->edges[26].vert2 = 15;
		
		renderer->graph->edgeCount = 27;
	}
	if(lvl >= 7)
	{
		renderer->graph->vertices[16].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[16].y = arc4random()%(GAME_Y_MAX-10) + 5;
		renderer->graph->vertices[17].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[17].y = arc4random()%(GAME_Y_MAX-10) + 5;
		
		renderer->graph->vertexCount = 18;
		
		renderer->graph->edges[27].vert1 = 2;
		renderer->graph->edges[27].vert2 = 16;
		renderer->graph->edges[28].vert1 = 16;
		renderer->graph->edges[28].vert2 = 17;
		renderer->graph->edges[29].vert1 = 11;
		renderer->graph->edges[29].vert2 = 17;
		
		renderer->graph->edgeCount = 30;
	}
	if(lvl >= 8)
	{	
		renderer->graph->vertices[18].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[18].y = arc4random()%(GAME_Y_MAX-10) + 5;
		renderer->graph->vertices[19].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[19].y = arc4random()%(GAME_Y_MAX-10) + 5;
		
		renderer->graph->vertexCount = 20;
		
		renderer->graph->edges[30].vert1 = 18;
		renderer->graph->edges[30].vert2 = 17;
		renderer->graph->edges[31].vert1 = 18;
		renderer->graph->edges[31].vert2 = 19;
		renderer->graph->edges[32].vert1 = 14;
		renderer->graph->edges[32].vert2 = 19;
		
		renderer->graph->edgeCount = 33;
	}
	if(lvl >= 9)
	{
		renderer->graph->vertices[20].x = arc4random()%(GAME_X_MAX-10) + 5;
		renderer->graph->vertices[20].y = arc4random()%(GAME_Y_MAX-10) + 5;
		
		renderer->graph->vertexCount = 21;
		
		renderer->graph->edges[33].vert1 = 17;
		renderer->graph->edges[33].vert2 = 20;
		renderer->graph->edges[34].vert1 = 18;
		renderer->graph->edges[34].vert2 = 20;
		renderer->graph->edges[35].vert1 = 11;
		renderer->graph->edges[35].vert2 = 18;
		
		renderer->graph->edgeCount = 36;
	}
	
	for (int i = 0 ; i < renderer->graph->edgeCount ; i++) 
	{
		renderer->graph->numberOfIntersectionsForEdge[i] = 0;
	}
	
	if ([renderer->graph checkGraphForIntersections] <= (lvl+1)*2)
	{
		[self initGraph:lvl];
		return;
	}
	

	
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
	NSString *currTime = appDel->timerLabel.text;

	NSString *prevBest = [appDel->bestTimes objectForKey:[NSString stringWithFormat:@"%d",appDel->currentLevel+1]];
	
	if( [prevBest floatValue] > [currTime floatValue])
	{
			//Update new Best Time
		[appDel->bestTimes setObject:currTime forKey:[NSString stringWithFormat:@"%d",appDel->currentLevel+1]];
			//Update bestTimeLabel
		[appDel->bestTimeLabel setText:[NSString stringWithFormat:@"%@ s",currTime]];
			//Write to file
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *appFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"BestTimes.plist"];
		[appDel->bestTimes writeToFile:appFile atomically:YES];
	}	
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
		location.x = location.x * renderer->scale;
		location.y = location.y * renderer->scale;
		
		for (int i=0; i < renderer->graph->vertexCount; i++)
		{
			if ([self distanceSquared:renderer->graph->vertices[i] p2:location] < 625)
			{
					//[appDel setUiHidden:YES];
				selectedVertex = i;
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
		
		if (selectedVertex >= 0 && selectedVertex < renderer->graph->vertexCount) 
		{
			renderer->graph->vertices[selectedVertex].x = location.x;
			renderer->graph->vertices[selectedVertex].y = MIN(location.y,GAME_Y_MAX);
		}
		
		[renderer->graph checkGraphForIntersections];
		
		[renderer render];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(playingGame)
	{
		if ([renderer->graph checkGraphForIntersections] == 0 && selectedVertex >= 0)
		{
			[self endGame];
			
				//[NSTimer scheduledTimerWithTimeInterval:(1) target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO];
		}
		
			//Clear selected vertex and connected vertices in graph
		selectedVertex = -1;
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
