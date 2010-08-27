//
//  PlayModeViewController.m
//  PoultryWars1.1
//
//  Created by dev1 on 9/4/09.
//  Copyright 2009 www.colworx.com. All rights reserved.
//

#import "PlayModeViewController.h"


@implementation PlayModeViewController

@synthesize _netSession;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		_netSession = nil;
    }
    return self;
}


#pragma mark -
#pragma mark Peer Picker Related Methods

-(void)startPicker {
	
	GKPeerPickerController *_picker;

	_picker = [[GKPeerPickerController alloc] init]; // note: picker is released in various picker delegate methods when picker use is done.
	_picker.delegate = self;
	[_picker show]; // show the Peer Picker
}

#pragma mark GKPeerPickerControllerDelegate Methods

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker { 
	// Peer Picker automatically dismisses on user cancel. No need to programmatically dismiss.
    
	// autorelease the picker. 
	picker.delegate = nil;
    [picker autorelease];
	
	// invalidate and release game session if one is around.
	if(_netSession.gameSession != nil)	{
		[self invalidateSession:_netSession.gameSession];
		_netSession.gameSession = nil;
	}
} 

//
// Provide a custom session that has a custom session ID. This is also an opportunity to provide a session with a custom display name.
//
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type { 
	GKSession *session = [[GKSession alloc] initWithSessionID:kPoultryWarsSessionID displayName:nil sessionMode:GKSessionModePeer]; 
	return [session autorelease]; // peer picker retains a reference, so autorelease ours so we don't leak.
}

- (void) checkToss:(NSTimer *)timer
{
	if(_netSession.tossStatus == kWon)
	{
		[self.navigationController pushViewController:[[[FarmSelectViewController alloc] initWithNibName:
														NSStringFromClass([FarmSelectViewController class]) bundle:nil selectedGameMode:MULTIPLAYER netSessionOrNil:_netSession] autorelease] animated:YES];
		[timer invalidate];
	}
	else if(_netSession.tossStatus == kLost)
	{
		lostTossAlert = [[UIAlertView alloc] initWithTitle:@"Lost Toss" message:@"Please Wait..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
		[lostTossAlert show];
		
		[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(checkFarmSelect:) userInfo:nil repeats:YES];
		[timer invalidate];
	}
}

- (void) checkFarmSelect:(NSTimer *)timer
{
	if(_netSession.levelSelected == ONE)
	{
		[self.navigationController pushViewController:[[[GameViewController alloc] initWithNibName:
														NSStringFromClass([GameViewController class]) bundle:nil selectedGameMode:MULTIPLAYER  netSessionOrNil:_netSession selectedLevel:ONE] autorelease] animated:YES];
		[timer invalidate];
		[lostTossAlert dismissWithClickedButtonIndex:0 animated:YES];
	}
	else if(_netSession.levelSelected == TWO)
	{
		[self.navigationController pushViewController:[[[GameViewController alloc] initWithNibName:
														NSStringFromClass([GameViewController class]) bundle:nil selectedGameMode:MULTIPLAYER netSessionOrNil:_netSession selectedLevel:TWO] autorelease] animated:YES];
		[timer invalidate];
		[lostTossAlert dismissWithClickedButtonIndex:0 animated:YES];
	}
	else if(_netSession.levelSelected == THREE)
	{
		[self.navigationController pushViewController:[[[GameViewController alloc] initWithNibName:
														NSStringFromClass([GameViewController class]) bundle:nil selectedGameMode:MULTIPLAYER netSessionOrNil:_netSession selectedLevel:THREE] autorelease] animated:YES];
		[timer invalidate];
		[lostTossAlert dismissWithClickedButtonIndex:0 animated:YES];
	}
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session { 
	
	_netSession = [[[NetworkSession alloc] init] retain];
	// Make sure we have a reference to the game session and it is set up
	_netSession.gameSession = session; // retain
	_netSession.gameSession.delegate = _netSession;
	_netSession.gamePeerId = peerID;
	
	[_netSession.gameSession setDataReceiveHandler:_netSession withContext:NULL];
	
	int gameUniqueID = [[[UIDevice currentDevice] uniqueIdentifier] hash];
	[_netSession sendNetworkPacketWithId:NETWORK_COINTOSS withData:&gameUniqueID ofLength:sizeof(int) reliable:YES];
		
	[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(checkToss:) userInfo:nil repeats:YES];
	
	// Done with the Peer Picker so dismiss it.
	[picker dismiss];
	picker.delegate = nil;
	[picker autorelease];
} 

#pragma mark -
#pragma mark Session Related Methods

//
// invalidate session
//
- (void)invalidateSession:(GKSession *)session {
	if(session != nil) {
		[session disconnectFromAllPeers]; 
		session.available = NO; 
		[session setDataReceiveHandler: nil withContext: NULL]; 
		session.delegate = nil; 
	}
}

#pragma mark -

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

-(IBAction)backButtonPressed:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playRandomEffect:@"menu_click1.wav" filepath2:@"menu_click2.wav" filePath3:@"menu_click3.wav"];
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)singlePlayerButtonPressed:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playRandomEffect:@"menu_click1.wav" filepath2:@"menu_click2.wav" filePath3:@"menu_click3.wav"];
	[self.navigationController pushViewController:[[[FarmSelectViewController alloc] initWithNibName:
													NSStringFromClass([FarmSelectViewController class]) bundle:nil selectedGameMode:SINGLEPLAYER netSessionOrNil:nil] autorelease] animated:YES];
}

-(IBAction)multiPlayerButtonPressed:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playRandomEffect:@"menu_click1.wav" filepath2:@"menu_click2.wav" filePath3:@"menu_click3.wav"];
	[self startPicker];
}

@end
