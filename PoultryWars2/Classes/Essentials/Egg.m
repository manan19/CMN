//
//  Egg.m
//  PoultryWars1.1
//
//  Created by dev1 on 9/5/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import "Egg.h"
#define EggRadius 7.0

@implementation Egg

-(id)init:(int)x y:(int)y type:(eggType)type points:(int)points powerID:(powerType)powerID physicsSpace:(cpSpace*)space
{
	cpBody *body = cpBodyNew(20,20);
	body->p = ccp(x, y);
	cpSpaceAddBody(space, body);
	
	cpShape* shape = cpCircleShapeNew(body, EggRadius, cpvzero);
	shape->e = 0; shape->u = 1.0f;
	
	if(type == PLAYER)
	{
		eggSprite = [Sprite spriteWithFile:@"egg.png"];
		shape->collision_type = 1;
	}
	else if(type == OPPONENT)
	{
		eggSprite = [Sprite spriteWithFile:@"egg2.png"];
		shape->collision_type = 5;
	}
	
	eggSprite.position = ccp(x,y);

	shape->data = self;

	cpSpaceAddShape(space, shape);
	
	_powerID = powerID;
	_points = points;
	
	[self retain];
	
	return self;
}


-(void)dealloc
{
	[super dealloc];
}
@end
