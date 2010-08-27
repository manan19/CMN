//
//  Egg.h
//  PoultryWars1.1
//
//  Created by dev1 on 9/5/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "chipmunk.h"
#import "cocos2d.h"

typedef enum {
	PLAYER,
	OPPONENT
}eggType;

typedef enum {
	NONE,
	FREEZE
}powerType; 

@interface Egg : NSObject {
	@public Sprite* eggSprite;
	@public	int checkPointVisited[4];
	@public int _points;
	@public powerType _powerID;
}

-(id)init:(int)x y:(int)y type:(eggType)type points:(int)points powerID:(powerType)powerID physicsSpace:(cpSpace*)space;

@end
