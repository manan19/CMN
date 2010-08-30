//
//  EAGLView.h
//  Cross Me Not
//
//  Created by Manan Patel on 2/18/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ES1Renderer.h"
#import "ES2Renderer.h"

@interface EAGLView : UIView <UIAlertViewDelegate>
{    
@public
    ESRenderer* renderer;
	BOOL playingGame;
	int viewLevel;
	UIAlertView* aView;
	uint screenWidth,screenHeight;
	CGRect clippingRect;
}

- (void)newGraph:(int)lvl;
- (void)drawView:(id)sender;
- (void)endGame;
- (float)distanceSquared:(CGPoint)p1  p2:(CGPoint)p2;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
