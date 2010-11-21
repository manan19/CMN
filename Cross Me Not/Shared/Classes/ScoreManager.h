//
//  ScoreManager.h
//  Cross Me Not
//
//  Created by Manan Patel on 10/28/10.
//  Copyright 2010 ngmoco:). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@interface ScoreManager : NSObject {
	NSMutableDictionary *bestTimes;
	int temp;
}

- (void) readBestTimes;
- (void) writeBestTimes;
- (void) setBestScore:(float)score forLevel:(int)level;
- (void) newScore:(float)score forLevel:(int)level sendToGC:(BOOL)report;
- (float) getBestScoreForLevel:(int)level;
- (void) reportHighScore:(int64_t) score forCategory: (NSString*) category;
- (void) authenticateLocalPlayer;
- (void) registerForAuthenticationNotification;
- (void) authenticationChanged;
- (BOOL) isGameCenterAvailable;
- (NSString*)getFilePath;

@end
