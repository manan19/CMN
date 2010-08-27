//
//  MainMenuViewController.h
//  PoultryWars1.1
//
//  Created by dev1 on 9/4/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsViewController.h"
#import "PlayModeViewController.h"
#import "TutorialSelectViewController.h"
#import "CreditsViewController.h"
#import "SimpleAudioEngine.h"

@interface MainMenuViewController : UIViewController {

}

-(IBAction)playButtonPressed:(id)sender;
-(IBAction)tutorialButtonPressed:(id)sender;
-(IBAction)optionsButtonPressed:(id)sender;
-(IBAction)creditsButtonPressed:(id)sender;

@end
