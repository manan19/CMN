//
//  PlayModeViewController.h
//  PoultryWars1.1
//
//  Created by dev1 on 9/4/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FarmSelectViewController.h"
#import "GameViewController.h"
#import "NetworkSession.h"



@interface PlayModeViewController : UIViewController<GKPeerPickerControllerDelegate> {
	NetworkSession *_netSession;
	UIAlertView *lostTossAlert;
}

@property(nonatomic, retain) NetworkSession	 *_netSession;

-(IBAction)backButtonPressed:(id)sender;
-(IBAction)singlePlayerButtonPressed:(id)sender;
-(IBAction)multiPlayerButtonPressed:(id)sender;

-(void)startPicker;
- (void)invalidateSession:(GKSession *)session;
- (void) checkToss:(NSTimer *)timer;
- (void) checkFarmSelect:(NSTimer *)timer;
@end
