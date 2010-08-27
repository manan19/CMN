//
//  NetworkSession.h
//  PoultryWars1.1
//
//  Created by dev1 on 9/8/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "Farm.h"
#import "Egg.h"

typedef enum {
	NETWORK_ACK,					// no packet
	NETWORK_COINTOSS,				// decide who is going to be the server
	NETWORK_LEVEL,					// level to be played, decided by player who wins toss
	NETWORK_THROWEGG				// egg thrown over to opponent's farm
} packetCodes;

typedef enum {
	kWon,
	kLost,
	kNotDecided,
} tossStatus;

typedef struct {
	int x;
	int y;
	int points;
	int power;
} eggPacket;

@interface NetworkSession : NSObject<GKSessionDelegate> {
	@public GKSession		*gameSession;
	@public NSInteger		tossStatus;
	@public NSInteger		levelSelected;
	@public NSString		*gamePeerId;
	@public NSInvocation	*addEggInvocation;
}

@property(nonatomic, retain) GKSession	 *gameSession;
@property(nonatomic) NSInteger tossStatus;
@property(nonatomic,retain) NSString *gamePeerId;
@property(nonatomic) NSInteger levelSelected;
@property(nonatomic,retain)NSInvocation *addEggInvocation;

- (void)sendNetworkPacketWithId:(int)packetID withData:(void *)data ofLength:(int)length reliable:(BOOL)howtosend;

@end
