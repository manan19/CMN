//
//  Mazes.h
//  iEngine
//
//  Created by CS 526 on 3/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "chipmunk.h"
#import "cocos2d.h"

enum 
{
	kBound,
	kCheckPoint,
	kExit,
	kNoExit,
	kPower,
};

typedef enum levelNumber {
	ZERO,
	ONE,
	TWO,
	THREE,
} level;


@interface VectorPoints : NSObject {
@public
	cpVect points[10];
	int noOfPoints;
	int edgetype;
	int* checkPointNo;
}
@end

@interface Farm : NSObject {
@public
	NSMutableArray *polygonArray;
	cpVect RandomPoints[20];
}

- (id)init:(level)levelNo;
+(void)InitPhysics:(level)levelNo physicsSpace:(cpSpace*)space;

@end
