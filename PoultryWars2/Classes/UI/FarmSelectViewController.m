//
//  FarmSelectViewController.m
//  PoultryWars1.1
//
//  Created by dev1 on 9/4/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import "FarmSelectViewController.h"


@implementation FarmSelectViewController

@synthesize _netSession;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedGameMode:(gameMode)selectedGameMode netSessionOrNil:(NetworkSession*)netSession{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		_selectedGameMode = selectedGameMode;
		_netSession = netSession;
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
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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

-(IBAction)farm1ButtonPressed:(id)sender
{
	if(_selectedGameMode == MULTIPLAYER && _netSession!=nil)
	{
		int lvl = ONE;
		[_netSession sendNetworkPacketWithId:NETWORK_LEVEL withData:&lvl ofLength:sizeof(int) reliable:YES];
	}
	[[SimpleAudioEngine sharedEngine] playRandomEffect:@"menu_click1.wav" filepath2:@"menu_click2.wav" filePath3:@"menu_click3.wav"];
	[self.navigationController pushViewController:[[[GameViewController alloc] initWithNibName:
													NSStringFromClass([GameViewController class]) bundle:nil selectedGameMode:_selectedGameMode netSessionOrNil:_netSession selectedLevel:ONE] autorelease] animated:YES];
}

-(IBAction)farm2ButtonPressed:(id)sender
{
	if(_selectedGameMode == MULTIPLAYER && _netSession!=nil)
	{
		int lvl = TWO;
		[_netSession sendNetworkPacketWithId:NETWORK_LEVEL withData:&lvl ofLength:sizeof(int) reliable:YES];
	}
	[[SimpleAudioEngine sharedEngine] playRandomEffect:@"menu_click1.wav" filepath2:@"menu_click2.wav" filePath3:@"menu_click3.wav"];
	[self.navigationController pushViewController:[[[GameViewController alloc] initWithNibName:
													NSStringFromClass([GameViewController class]) bundle:nil selectedGameMode:_selectedGameMode netSessionOrNil:_netSession selectedLevel:TWO] autorelease] animated:YES];
}

-(IBAction)farm3ButtonPressed:(id)sender
{
	if(_selectedGameMode == MULTIPLAYER && _netSession!=nil)
	{
		int lvl = THREE;
		[_netSession sendNetworkPacketWithId:NETWORK_LEVEL withData:&lvl ofLength:sizeof(int) reliable:YES]; 
	}
	[[SimpleAudioEngine sharedEngine] playRandomEffect:@"menu_click1.wav" filepath2:@"menu_click2.wav" filePath3:@"menu_click3.wav"];
	[self.navigationController pushViewController:[[[GameViewController alloc] initWithNibName:
													NSStringFromClass([GameViewController class]) bundle:nil selectedGameMode:_selectedGameMode netSessionOrNil:_netSession selectedLevel:THREE] autorelease] animated:YES];
}

-(IBAction)backButtonPressed:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playRandomEffect:@"menu_click1.wav" filepath2:@"menu_click2.wav" filePath3:@"menu_click3.wav"];
	[self.navigationController popViewControllerAnimated:YES];
}
	
@end
