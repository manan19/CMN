	//
	//  ScoreManager.m
	//  Cross Me Not
	//
	//  Created by Manan Patel on 10/28/10.
	//  Copyright 2010 ngmoco:). All rights reserved.
	//

#import "ScoreManager.h"
#import "AppDelegate_Phone.h"


@implementation ScoreManager

- (id) init
{
	self = [super init];
	if (self != nil) {
		
		if([self isGameCenterAvailable])
		{
			[self registerForAuthenticationNotification];
			[self authenticateLocalPlayer];
		}
	}
	return self;
}


- (void) authenticateLocalPlayer
{
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
		if (error == nil)
		{
				// Insert code here to handle a successful authentication.
		}
		else
		{
				// Your application can process the error parameter to report the error to the player.
		}
	}];
}

- (void) registerForAuthenticationNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
}

- (void) updateScoresFromGameCenter:(int)level
{
	temp = level;
	GKLeaderboard *lbquery;
	
	lbquery = [[GKLeaderboard alloc] initWithPlayerIDs:[NSArray arrayWithObjects:[GKLocalPlayer localPlayer].playerID,nil]];
	[lbquery setCategory:[NSString stringWithFormat:@"l%d",level]];
	
	[lbquery loadScoresWithCompletionHandler:
	 ^(NSArray *scores, NSError *error) 
	{
		if (error != nil) 
		{
			[self updateScoresFromGameCenter:temp];
		}
		else if (scores != nil)
		{
			if([scores count])
			{
				float score = [((GKScore*)[scores objectAtIndex:0]) value];
				[self newScore:score/100 forLevel:temp sendToGC:FALSE];
			}
			
			if (temp < MAX_LEVELS)
			{
				[self updateScoresFromGameCenter:++temp];
			}
		}
	}
	];
	
	[lbquery release];
}

- (void) authenticationChanged
{
	[self readBestTimes];
	
    if ([GKLocalPlayer localPlayer].isAuthenticated)
	{
			// Insert code here to handle a successful authentication.
		
			///////////////////////// TODO read in scores properly
		[self updateScoresFromGameCenter:1];		
	}
	else
	{
			// Insert code here to clean up any outstanding Game Center-related classes.
	}
}

- (void) reportHighScore:(int64_t) score forCategory: (NSString*) category
{
	if( [self isGameCenterAvailable] && [GKLocalPlayer localPlayer].isAuthenticated )
	{
		GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
		scoreReporter.value = score;
		
		[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
			if (error != nil)
			{
				NSLog(@"%@",[error localizedFailureReason]);
			}
		}];
	}
}


- (void) readBestTimes 
{
	NSString *appFile = [self getFilePath];
	bestTimes = [[NSMutableDictionary alloc] initWithContentsOfFile:appFile];
	
	if (!bestTimes) 
	{
		bestTimes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"9990", @"1", @"9990", @"2",@"9990", @"3",@"9990", @"4",@"9990", @"5",@"9990", @"6",@"9990", @"7",@"9990", @"8",@"9990", @"9",@"9990", @"10", nil];
	}
}

- (void) writeBestTimes
{
	NSString *appFile = [self getFilePath];
	[bestTimes writeToFile:appFile atomically:YES];
}

- (void) setBestScore:(float)score forLevel:(int)level
{
	[bestTimes setObject:[NSString stringWithFormat:@"%f",score] forKey:[NSString stringWithFormat:@"%d",level]];
}

-(BOOL)isGameCenterAvailable
{
		// Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
		// The device must be running running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
    return (gcClass && osVersionSupported);
}

- (NSString*)getFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *appFile;
	if([self isGameCenterAvailable] && [GKLocalPlayer localPlayer].isAuthenticated)
	{
		appFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[GKLocalPlayer localPlayer].alias]];
	}
	else 
	{
		appFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"LocalBestTimes"];
	}
	
	return appFile;
}


- (void) newScore:(float)score forLevel:(int)level sendToGC:(BOOL)report
{
	float prevBest = [self getBestScoreForLevel:level];
	
	if( prevBest > score)
	{
			//Update new Best Time
		[self setBestScore:score forLevel:level];
			//Write to file
		[self writeBestTimes];
			//Report to Game Center
		
		if (report) {
			int64_t newBest = score * 100;
			[self reportHighScore:newBest forCategory:[NSString stringWithFormat:@"l%d",level]];
		}
	}
	else
	{
		if (!report) 
		{
			int64_t newBest = prevBest * 100;
			[self reportHighScore:newBest forCategory:[NSString stringWithFormat:@"l%d",level]];
		}
	}

	
}


- (float) getBestScoreForLevel:(int)level
{
	return [[bestTimes objectForKey:[NSString stringWithFormat:@"%d",level]] floatValue];
}


- (void) dealloc
{
	[bestTimes release];
	
	[super dealloc];
}



@end

