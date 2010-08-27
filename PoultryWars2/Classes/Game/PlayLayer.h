//
//  PlayScene.h
//  PoultryWars1.1
//
//  Created by dev1 on 9/5/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Farm.h"
#import "Egg.h"
#import "NetworkSession.h"
#import "SimpleAudioEngine.h"

typedef enum typeOfGameModes
	{
		TUTORIAL,
		SINGLEPLAYER,
		MULTIPLAYER,
	} gameMode;


@interface PlayLayer : Layer
{
	cpSpace *space;
	NetworkSession *_netSession;
	
	gameMode _selectedGameMode;
	level _selectedLevel;
	int playerScore,opponentScore,timerMinutes,timerSeconds;
	
	LabelAtlas *opponentScoreLabel;
	LabelAtlas *playerScoreLabel;
	LabelAtlas *timerLabel;
}

@property(nonatomic, retain) NetworkSession	 *_netSession;

-(id) initWithNetworkSession:(NetworkSession*)netSession selectedLevel:(level)selectedLevel;
-(void) step: (ccTime) dt;
- (void) addLabels;
-(void) addNewEgg: (int)x y:(int)y type:(eggType)type points:(int)points powerID:(powerType)powerID;
-(void) farmCleanUp;
-(void) farmCleanUp:(cpShape*)shape;


int DestroyBothRocks(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data);
int DoNothing(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data);
int IncreasePoints(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data);
int PowerUp(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data);
int LeaveScreen(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data);

@end


