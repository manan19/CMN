//
//  GameViewController.m
//  PoultryWars1.1
//
//  Created by dev1 on 9/4/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import "GameViewController.h"


@implementation GameViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedGameMode:(gameMode)selectedGameMode netSessionOrNil:(NetworkSession*)netSession selectedLevel:(level)selectedLevel{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
        // Custom initialization
		[[Director sharedDirector] attachInViewOfViewController:self];
		[[Director sharedDirector] setDisplayFPS:TRUE];
		
		Scene *scene = [Scene node];
		
		switch(selectedGameMode)
		{
			case SINGLEPLAYER:
				[scene addChild:[[[PlayLayer alloc] initWithNetworkSession:nil selectedLevel:selectedLevel] autorelease] z:0];
				break;
				
			case MULTIPLAYER:
				[scene addChild:[[[PlayLayer alloc] initWithNetworkSession:netSession selectedLevel:selectedLevel] autorelease] z:0];
				break;
				
			case TUTORIAL:
				[scene addChild:[Layer node]];
				break;
		}
		
		[[Director sharedDirector] runWithScene:scene];
	}
    return self;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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

@end
