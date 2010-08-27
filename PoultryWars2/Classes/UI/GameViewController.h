//
//  GameViewController.h
//  PoultryWars1.1
//
//  Created by dev1 on 9/4/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "NetworkSession.h"
#import "PlayLayer.h"
#import "SimpleAudioEngine.h"

#define kPoultryWarsSessionID @"98250"

@interface GameViewController : UIViewController {

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedGameMode:(gameMode)selectedGameMode netSessionOrNil:(NetworkSession*)netSession selectedLevel:(level)selectedLevel;

@end
