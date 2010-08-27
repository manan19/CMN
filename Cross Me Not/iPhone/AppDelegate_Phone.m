	//
	//  AppDelegate_Phone.m
	//  Cross Me Not
	//
	//  Created by Manan Patel on 2/18/10.
	//  Copyright Apple Inc 2010. All rights reserved.
	//

#import "AppDelegate_Phone.h"
#import "EAGLView.h"

@implementation AppDelegate_Phone

@synthesize bestTimes;
@synthesize window;
@synthesize placeHolderView;
@synthesize glView;
@synthesize timerLabel;
@synthesize bestTimeLabel;
@synthesize menuView;
@synthesize infoView;

#pragma mark -
#pragma mark UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	currentLevel = 0;
	
	[placeHolderView addSubview:menuView];
	[glView initGraph:0];
	timeCounter = [[NSDate date] retain];
	time = 0;
	glView->GAME_X_MAX = window.frame.size.width;
	glView->GAME_Y_MAX = window.frame.size.height;
	
	adView = [AdMobView requestAdWithDelegate:self]; // start a new ad request
	[adView retain];
	
	[self loadBestTimes];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark -
#pragma mark AdMobDelegate methods
- (NSString *)publisherId 
{
	return @"a14b84284a8b3d3"; // this should be prefilled; if not, get it from www.admob.com
}

- (UIViewController *)currentViewController
{
	return nil;
}

- (UIColor *)adBackgroundColor 
{
	return [UIColor colorWithRed:0.851 green:0.89 blue:0.925 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)primaryTextColor 
{
	return [UIColor colorWithRed:0.298 green:0.345 blue:0.416 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)secondaryTextColor 
{
	return [UIColor colorWithRed:0.298 green:0.345 blue:0.416 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (BOOL)mayAskForLocation 
{
	return NO; // this should be prefilled; if not, see AdMobProtocolDelegate.h for instructions
}

	// To receive test ads rather than real ads...
	//- (BOOL)useTestAd 
	//{
	//	return YES;
	//}
	//
	//- (NSString *)testAdAction 
	//{
	//	return @"url"; // see AdMobDelegateProtocol.h for a listing of valid values here
	//}


	// Sent when an ad request loaded an ad; this is a good opportunity to attach
	// the ad view to the hierachy.
- (void)didReceiveAd:(AdMobView *)receivedAdView 
{
	NSLog(@"AdMob: Did receive ad");
	
		// put the ad at the top of the screen
	adView.frame = CGRectMake(glView->GAME_X_MAX/2 - 160 , glView->GAME_Y_MAX - 48 , 320, 48);
	[menuView addSubview:adView];
	
	[NSTimer scheduledTimerWithTimeInterval:AD_REFRESH_PERIOD target:adView	selector:@selector(requestFreshAd) userInfo:nil repeats:NO];
}

	// Sent when an ad request failed to load an ad
- (void)didFailToReceiveAd:(AdMobView *)receivedAdView {
	NSLog(@"AdMob: Did fail to receive ad");
	
		// release the older admobview
	[adView release];
	adView = nil;
	
		// we could start a new ad request here, but in the interests of the user's battery life, let's not
	[NSTimer scheduledTimerWithTimeInterval:AD_REFRESH_PERIOD target:adView	selector:@selector(requestFreshAd) userInfo:nil repeats:NO];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	currentLevel = row;
	
	NSString* prevBest = [NSString stringWithFormat:@"%@ s",[bestTimes objectForKey:[NSString stringWithFormat:@"%d",currentLevel+1]]];
	if ([prevBest floatValue] == 9990) 
		[bestTimeLabel setText:NSLocalizedString(@"NA",@"No score yet")];
	else
		[bestTimeLabel setText:prevBest];
}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [[NSNumber numberWithInt:row+1] stringValue];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return MAX_LEVELS;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

#pragma mark -
#pragma mark AppDelegate_Phone methods
- (void)update
{
	if (glView->playingGame)
	{
			//Update Time
		time += [[NSDate date] timeIntervalSinceDate:timeCounter];
		[timeCounter release];
		timeCounter = [[NSDate date] retain];
			//Set Label
		[timerLabel setText:[NSString stringWithFormat:@"%.2f",time]];
	}
	
		//Hack to keep FCKING AdMob Ads to change the placeHoler frame
	if(placeHolderView.frame.origin.y != 0)
		[placeHolderView setFrame:CGRectMake(0, 0, glView->GAME_X_MAX, glView->GAME_Y_MAX)];
}

- (void) loadBestTimes 
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *appFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"BestTimes.plist"];
	bestTimes = [[NSMutableDictionary alloc] initWithContentsOfFile:appFile];
	if (!bestTimes) 
	{
		bestTimes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"9990", @"1", @"9990", @"2",@"9990", @"3",@"9990", @"4",@"9990", @"5",@"9990", @"6",@"9990", @"7",@"9990", @"8",@"9990", @"9",@"9990", @"10", nil];
	}
	[NSTimer scheduledTimerWithTimeInterval:(1/60) target:self selector:@selector(update) userInfo:nil repeats:YES];
	
	NSString* prevBest = [NSString stringWithFormat:@"%@ s",[bestTimes objectForKey:[NSString stringWithFormat:@"%d",currentLevel+1]]];
	if ([prevBest floatValue] == 9990) 
		[bestTimeLabel setText:NSLocalizedString(@"NA",@"No score yet")];
	else
		[bestTimeLabel setText:prevBest];
	
}

- (IBAction)menuButton:(id)sender
{
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	
	if([glView superview] == placeHolderView)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.8];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:placeHolderView cache:YES];
		[glView removeFromSuperview];
		[placeHolderView addSubview:menuView];
		[UIView commitAnimations];
	}
}

- (IBAction)startGame:(id)sender
{
	[glView initGraph:currentLevel];
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	
	if ([menuView superview] == placeHolderView)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.8];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:placeHolderView cache:YES];
		[menuView removeFromSuperview];
		[placeHolderView addSubview:glView];
		[UIView commitAnimations];
	}
		//Reset Counter
	time = 0.0f;
	[timeCounter release];
	timeCounter = [[NSDate date] retain];
		//Set Label
	[timerLabel setText:[NSString stringWithFormat:@"%.2f",time]];
	
	glView->playingGame = TRUE;
}

- (IBAction)infoButton:(id)sender
{
	if([infoView superview] == placeHolderView)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.8];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:placeHolderView cache:YES];
		[infoView removeFromSuperview];
		[placeHolderView addSubview:menuView];
		[menuView addSubview:adView];
		[UIView commitAnimations];
	}
	else 
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.8];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:placeHolderView cache:YES];
		[menuView removeFromSuperview];
		[placeHolderView addSubview:infoView];
		[infoView addSubview:adView];
		[UIView commitAnimations];
	}
}

- (void)dealloc
{
	[window release];
	[placeHolderView release];
	[timerLabel release];
	[glView release];
	[menuView release];
	[infoView release];
	[adView release];
	[timeCounter release];
	[bestTimes release];
	
	[super dealloc];
}

@end
