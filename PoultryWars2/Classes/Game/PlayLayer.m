//
//  PlayScene.m
//  PoultryWars1.1
//
//  Created by dev1 on 9/5/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import "PlayLayer.h"

#define kFilterFactor 0.05f
#define GravityIntensity 1000

cpShape* collidedEgg1Shape;
cpShape* collidedEgg2Shape;
cpShape* thrownEggShape;

static void eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	if(shape->collision_type == 1 || shape->collision_type == 5)
	{
		Egg *egg = shape->data;
		if( egg ) 
		{
			cpBody *body = shape->body;
			[egg->eggSprite setPosition: body->p];
			[egg->eggSprite setRotation: (float) CC_RADIANS_TO_DEGREES(-body->a)];
		}
	}
}

@implementation PlayLayer

@synthesize _netSession;


-(id) initWithNetworkSession:(NetworkSession*)netSession selectedLevel:(level)selectedLevel
{
	
	if( (self=[super init])) 
	{
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		//Physics
		space = cpSpaceNew();
		[Farm InitPhysics:selectedLevel physicsSpace:space];

		cpSpaceAddCollisionPairFunc(space, 1, 3, &LeaveScreen, space);
		cpSpaceAddCollisionPairFunc(space, 1, 4, &DoNothing, NULL);
		cpSpaceAddCollisionPairFunc(space, 1, 5, &DestroyBothRocks, space);
		
		//Network
		_netSession = netSession;
		_netSession.addEggInvocation = [NSInvocation invocationWithMethodSignature:[PlayLayer instanceMethodSignatureForSelector:@selector(addNewEgg:y:type:points:powerID:)]];
		[_netSession.addEggInvocation setTarget:self];
		[_netSession.addEggInvocation setSelector:@selector(addNewEgg:y:type:points:powerID:)];
		if(_netSession)
		{
			_selectedGameMode = MULTIPLAYER;
		}
		else
		{
			_selectedGameMode = SINGLEPLAYER;
		}
		_selectedLevel = selectedLevel;
		
		//Background + some Physics Callbacks
		Sprite *background = nil;
		switch(selectedLevel)
		{
			case ONE:
				background = [Sprite spriteWithFile:@"map1.png"];
				break;
			case TWO:
				background = [Sprite spriteWithFile:@"map2.png"];
				cpSpaceAddCollisionPairFunc(space, 1, 2, &IncreasePoints, space);
				break;
			case THREE:
				background = [Sprite spriteWithFile:@"map3.png"];
				cpSpaceAddCollisionPairFunc(space, 1, 2, &IncreasePoints, space);
				cpSpaceAddCollisionPairFunc(space, 6, 1, &PowerUp, space);
				break;
		}
		if(background != nil)
		{
			[background setPosition:CGPointMake(160, 240)];
			[self addChild:background z:0];
		}
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgmusic1.mp3" loop:YES];
	}
	
	return self;
}

- (void) addLabels 
{
	//Set Scores to 0-0
	playerScore = 0;
	opponentScore = 0;

	//Add Score Labels
	playerScoreLabel = [LabelAtlas labelAtlasWithString:[NSString stringWithFormat:@"%d", playerScore] charMapFile:@"numbers_bluebold.png" itemWidth:47 itemHeight:63 startCharMap:'0'];
	[playerScoreLabel setRotation:90];
	[playerScoreLabel setPosition:ccp(5,470)];
	[playerScoreLabel setScale:0.5];
	[self addChild:playerScoreLabel z:10];
	
	if(_selectedGameMode == MULTIPLAYER)
	{
		opponentScoreLabel = [LabelAtlas labelAtlasWithString:[NSString stringWithFormat:@"%d", opponentScore] charMapFile:@"numbers_redbold.png" itemWidth:47 itemHeight:63 startCharMap:'0'];
		[opponentScoreLabel setRotation:90];
		[opponentScoreLabel setPosition:ccp(5,60)];
		[opponentScoreLabel setScale:0.5];
		[self addChild:opponentScoreLabel z:10];
	}
	
	//Set timer values
	timerMinutes = 2;
	timerSeconds = 0;
	
	//Add timer Label
	timerLabel = [LabelAtlas labelAtlasWithString:[NSString stringWithFormat:@"%d:%02d",timerMinutes,timerSeconds] charMapFile:@"numbers_bluebold.png" itemWidth:47 itemHeight:63 startCharMap:'0'];
	[timerLabel setRotation:90];
	if(_selectedLevel == ONE)
	{
		[timerLabel setPosition:ccp(290,470)];
	}
	else
	{
		[timerLabel setPosition:ccp(290,80)];
	}
	[timerLabel setScale:0.4];
	[self addChild:timerLabel z:10];
	
}

-(void) addNewEgg: (int)x y:(int)y type:(eggType)type points:(int)points powerID:(powerType)powerID
{
	if (type == OPPONENT) 
	{
		opponentScore++;
		[opponentScoreLabel setString:[NSString stringWithFormat:@"%d",opponentScore]];
	}
	
	Egg* egg = [[Egg alloc] init:x y:y type:type points:points powerID:powerID physicsSpace:space];
	[self addChild:egg->eggSprite z:1];
	[egg release];
}

-(void) onEnter
{
	[super onEnter];
	
	//Sets Accelerometer Callback frequency
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
	
	[self addNewEgg:200 y:200 type:OPPONENT points:1 powerID:NONE];
	
	//Adds labels for Player's score, Opponent's Score and GameTimer
	[self addLabels];
	
	//Update function
	[self schedule: @selector(step:)];
	[self schedule:	@selector(stepTimer:) interval:1];
}

-(void)onExit
{
	[super onExit];
	
	[timerLabel release];
	[playerScoreLabel release];
	[opponentScoreLabel release];
	[_netSession release];
}	

- (void) farmCleanUp 
{
	[self farmCleanUp:collidedEgg1Shape];
	collidedEgg1Shape = nil;
	[self farmCleanUp:collidedEgg2Shape];
	collidedEgg2Shape = nil;
	[self farmCleanUp:thrownEggShape];
	thrownEggShape = nil;	
}

- (void) farmCleanUp:(cpShape*)shape
{
	if(shape)
	{
		Egg* egg = shape->data;
		[self removeChild:egg->eggSprite cleanup:TRUE];
		[egg release];
		cpSpaceRemoveBody(space,shape->body);
		cpSpaceRemoveShape(space,shape);
		cpBodyFree(shape->body);
		cpShapeFree(shape);
		shape = nil;
	}
}

-(void) stepTimer: (ccTime) delta
{
	if(timerSeconds == 0)
	{
		timerMinutes --;
		timerSeconds = 59;
	}
	else
	{
		timerSeconds--;
	}
	
	[timerLabel setString:[NSString stringWithFormat:@"%d:%02d",timerMinutes,timerSeconds]];
}

-(void) step: (ccTime) delta
{
	cpSpaceStep(space, delta/2);
	cpSpaceStep(space, delta/2);

	if(thrownEggShape != nil)
	{
		//Play Throw Egg sound
		[[SimpleAudioEngine sharedEngine] playEffect:@"leave_screen.wav"];
		
		//Update Score Sprite
		Egg* egg = thrownEggShape->data;
		playerScore += egg->_points;
		[playerScoreLabel setString:[NSString stringWithFormat:@"%d",playerScore]];
				
		if(_selectedGameMode == MULTIPLAYER)
		{
			//Send Egg via Network
			eggPacket packet;
			packet.x = [egg->eggSprite position].x-10;
			packet.y = [egg->eggSprite position].y;
			packet.points = egg->_points;
			packet.power = egg->_powerID;
			[_netSession sendNetworkPacketWithId:NETWORK_THROWEGG withData:&packet ofLength:sizeof(eggPacket) reliable:YES];
		}
	}
	
	if(collidedEgg1Shape && collidedEgg2Shape)
	{
		//Play Egg Smash Sound
		[[SimpleAudioEngine sharedEngine] playEffect:@"Egg_collide.wav"];
		//Display Smashed Egg Sprite
	}
	
	[self farmCleanUp];
	
	cpSpaceHashEach(space->activeShapes, &eachShape, nil);
	cpSpaceHashEach(space->staticShapes, &eachShape, nil);
}


- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];

		location = [[Director sharedDirector] convertCoordinate: location];

		[self addNewEgg:location.x y:location.y type:PLAYER points:1 powerID:NONE];
		
		//Play Egg creation sound
		[[SimpleAudioEngine sharedEngine] playEffect:@"Egg_creation.wav"];
	}
	return kEventHandled;
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	CGPoint v = ccp( accelX, accelY);
	
	space->gravity = ccpMult(v, GravityIntensity);
}

int DestroyBothRocks(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	collidedEgg1Shape = a;
	collidedEgg2Shape = b;
	return 1;
}

int DoNothing(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	return 0;
}

int IncreasePoints(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	return 1;
}

int PowerUp(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	return 1;
}

int LeaveScreen(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	thrownEggShape = a;
	return 1;
}


@end
