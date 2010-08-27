//
//  MainMenuViewController.m
//  PoultryWars1.1
//
//  Created by dev1 on 9/4/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import "MainMenuViewController.h"


@implementation MainMenuViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

-(IBAction)playButtonPressed:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playRandomEffect:@"menu_click1.wav" filepath2:@"menu_click2.wav" filePath3:@"menu_click3.wav"];
	[self.navigationController pushViewController:[[[PlayModeViewController alloc] initWithNibName:
													NSStringFromClass([PlayModeViewController class]) bundle:nil] autorelease] animated:YES];
}

-(IBAction)tutorialButtonPressed:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playRandomEffect:@"menu_click1.wav" filepath2:@"menu_click2.wav" filePath3:@"menu_click3.wav"];
	[self.navigationController pushViewController:[[[TutorialSelectViewController alloc] initWithNibName:
													NSStringFromClass([TutorialSelectViewController class]) bundle:nil] autorelease] animated:YES];
}

-(IBAction)optionsButtonPressed:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playRandomEffect:@"menu_click1.wav" filepath2:@"menu_click2.wav" filePath3:@"menu_click3.wav"];
	[self.navigationController pushViewController:[[[OptionsViewController alloc] initWithNibName:
													NSStringFromClass([OptionsViewController class]) bundle:nil] autorelease] animated:YES];
}

-(IBAction)creditsButtonPressed:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playRandomEffect:@"menu_click1.wav" filepath2:@"menu_click2.wav" filePath3:@"menu_click3.wav"];
	[self.navigationController pushViewController:[[[CreditsViewController alloc] initWithNibName:
													NSStringFromClass([CreditsViewController class]) bundle:nil]autorelease] animated:YES];
}


@end
