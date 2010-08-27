//
//  FarmSelectViewController.h
//  PoultryWars1.1
//
//  Created by dev1 on 9/4/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"


@interface FarmSelectViewController : UIViewController {
	gameMode _selectedGameMode;
	NetworkSession *_netSession;
}

@property(nonatomic,retain) NetworkSession *_netSession;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedGameMode:(gameMode)selectedGameMode netSessionOrNil:(NetworkSession*)netSession;
-(IBAction)farm1ButtonPressed:(id)sender;
-(IBAction)farm2ButtonPressed:(id)sender;
-(IBAction)farm3ButtonPressed:(id)sender;
-(IBAction)backButtonPressed:(id)sender;



@end
