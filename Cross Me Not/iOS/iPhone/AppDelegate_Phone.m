	//
	//  AppDelegate_Phone.m
	//  Cross Me Not
	//
	//  Created by Manan Patel on 2/18/10.
	//  Copyright Apple Inc 2010. All rights reserved.
	//

#import "AppDelegate_Phone.h"
#import "EAGLView.h"

void uncaughtExceptionHandler(NSException *exception) {
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

@implementation AppDelegate_Phone

@synthesize window;
@synthesize placeHolderViewController;
@synthesize glView;
@synthesize timerLabel;
@synthesize bestTimeLabel;
@synthesize menuView;
@synthesize infoView;

#pragma mark -
#pragma mark UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
		// Analytics
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	[Flurry setAppVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
	[Flurry startSession:@"HZITZ7GERIG6LHLM5U7Q"];

		// Initial UI Setup
	[placeHolderViewController.view addSubview:menuView];
	[window addSubview:placeHolderViewController.view];
	[window makeKeyAndVisible];
	
		// Initial setup for In-App Purchases
	productIdentifierAdFree = @"com.mp.crossmenot.adfree";
	[removeAdsButton removeFromSuperview];
	
		// Check for In-App Purchases
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *results = [defaults stringForKey:productIdentifierAdFree];
	if (results) 
	{
		adFree = TRUE;
	}
	else 
	{
		adFree = FALSE;
	}
	
		// Setup Ads if NOT Ad Free
	if (!adFree)
	{
		adManager = [[AdManager alloc] init];
		[adManager setParentViewController:placeHolderViewController];
		[adManager setParentView:menuView andPosition:FALSE];
		
		glView->clippingRect = CGRectMake(0, 50 * glView->renderer->scale , glView->screenWidth, glView->screenHeight - 50 * glView->renderer->scale );
		
		[self requestProductData];
	}
	else 
	{
		glView->clippingRect = CGRectMake(0, 0, glView->screenWidth, glView->screenHeight);
	}
	
	
		// Setup for high scores
	scoreManager = [[ScoreManager alloc] init];
	[scoreManager readBestTimes];	
    if([scoreManager _isGameCenterAvailable])
    {
        leaderboardController = [[GKLeaderboardViewController alloc] init];
    }
    else
    {
        [gameCenterButton removeFromSuperview];
    }
    
		// Setup for In-App Purchase if user can purchase
	if ([SKPaymentQueue canMakePayments]) 
	{
			//[self requestProductData];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	
		// Initial Game Setup
	currentLevel = 0;
	gameEntryLevel = 0;
	[glView newGraph:0];
	timeCounter = [[NSDate date] retain];
	time = 0;
	[NSTimer scheduledTimerWithTimeInterval:(1/30) target:self selector:@selector(update) userInfo:nil repeats:YES];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	appActive = FALSE;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	appActive = TRUE;
	[timeCounter release];
	timeCounter = [[NSDate date] retain];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

#pragma mark -
#pragma mark SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSArray *myProduct = response.products;
	
	for(int i=0;i<[myProduct count];i++)
	{
		SKProduct *product = [myProduct objectAtIndex:i];
		
		if (![product.productIdentifier compare:productIdentifierAdFree]) 
		{
			productAdFree = [product retain];
			[menuView addSubview:removeAdsButton];
		}
	}
	
	[productsReq release];
}


#pragma mark -
#pragma mark SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
			default:
				break;
		}
	}
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	currentLevel = row;
	gameEntryLevel = row;
}

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
	if (appActive) 
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
		
		[self setScoreLabelForLevel:currentLevel+1];
		
			//Hack to keep FCKING AdMob Ads to change the placeHolder frame
		if(placeHolderViewController.view.frame.origin.y != 0)
			[placeHolderViewController.view setFrame:window.frame];
	}
}

-(void)setScoreLabelForLevel:(int)level
{
	float prevBest = [scoreManager getBestScoreForLevel:level];
	if ( prevBest == 9990 ) 
		[bestTimeLabel setText:NSLocalizedString(@"NA",@"No score yet")];
	else
		[bestTimeLabel setText:[NSString stringWithFormat:@"%.2f s",prevBest]];
}


- (void) requestProductData
{
	productsReq = [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject: productIdentifierAdFree]];
	[productsReq setDelegate:self];
	[productsReq start];
}

-(IBAction) buyAdFree: (id)sender
{
	SKPayment *payment = [SKMutablePayment paymentWithProductIdentifier:productIdentifierAdFree];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
	
	[removeAdsButton setEnabled:FALSE];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not connect to Store" message:@"Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
			// Optionally, display an error here.
	}
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[removeAdsButton setEnabled:TRUE];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
		//If you want to save the transaction
		// [self recordTransaction: transaction];
	
		//Provide the new content
	[self provideContent: transaction.originalTransaction.payment.productIdentifier];
	
		//Finish the transaction
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[removeAdsButton setEnabled:TRUE];
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
		//If you want to save the transaction
		// [self recordTransaction: transaction];
	
		//Provide the new content
	[self provideContent: transaction.payment.productIdentifier];
	
		//Finish the transaction
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[removeAdsButton setEnabled:TRUE];
}

- (void) provideContent: (NSString*)productIdentifier
{
	if (![productIdentifier compare:productIdentifierAdFree]) 
	{
		[adManager shutdown];
		
		glView->clippingRect = CGRectMake(0, 0, glView->screenWidth, glView->screenHeight);
			//Transaction for Ad Free version complete.
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:@"purchased" forKey:productIdentifierAdFree];
		
		[removeAdsButton removeFromSuperview];
	}
}

- (IBAction)menuButton:(id)sender
{
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
	
	if([glView superview] == placeHolderViewController.view)
	{
		[adManager setParentView:menuView andPosition:FALSE];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.8];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:placeHolderViewController.view cache:YES];
		[glView removeFromSuperview];
		[placeHolderViewController.view addSubview:menuView];
		[UIView commitAnimations];
	}
	
	glView->playingGame = FALSE;
	
	currentLevel = gameEntryLevel;
}

- (IBAction)infoButton:(id)sender
{
	[Flurry logEvent:@"Viewed Info Page"];
	
	if([infoView superview] == placeHolderViewController.view)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.8];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:placeHolderViewController.view cache:YES];
		[infoView removeFromSuperview];
		[placeHolderViewController.view addSubview:menuView];
		[adManager setParentView:menuView andPosition:FALSE];
		[UIView commitAnimations];
	}
	else 
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.8];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:placeHolderViewController.view cache:YES];
		[menuView removeFromSuperview];
		[placeHolderViewController.view addSubview:infoView];
		[adManager setParentView:infoView andPosition:FALSE];
		[UIView commitAnimations];
	}
}

- (void) showLeaderboardOfLevel:(int) level
{
    if (leaderboardController != nil)
    {
        leaderboardController.category = [NSString stringWithFormat:@"l%d",level];
        leaderboardController.leaderboardDelegate = self;
        [placeHolderViewController presentModalViewController: leaderboardController animated: YES];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [placeHolderViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)gameCenter:(id)sender
{
    [self showLeaderboardOfLevel:currentLevel+1];
}

- (IBAction)startGame:(id)sender
{
	[Flurry logEvent:@"1"];
	[glView newGraph:currentLevel];
	
	[Flurry logEvent:@"2"];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
	
	[Flurry logEvent:@"3"];
	if ([menuView superview] == placeHolderViewController.view)
	{
		[adManager setParentView:glView andPosition:TRUE];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.8];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:placeHolderViewController.view cache:YES];
		[menuView removeFromSuperview];
		[placeHolderViewController.view addSubview:glView];
		[UIView commitAnimations];
	}
	[Flurry logEvent:@"4"];

		//Reset Counter
	time = 0.0f;
	[timeCounter release];
	timeCounter = [[NSDate date] retain];
	[Flurry logEvent:@"5"];

		//Set Label
	[timerLabel setText:[NSString stringWithFormat:@"%.2f",time]];
	[Flurry logEvent:@"6"];
	
	glView->playingGame = TRUE;
	[Flurry logEvent:@"7"];
}

- (void) endGame
{
	NSString *currTime = timerLabel.text;
	[scoreManager newScore:[currTime floatValue] forLevel:currentLevel+1 sendToGC:TRUE];
}

- (void)dealloc
{
	[window release];
    [leaderboardController release];
	[placeHolderViewController.view release];
	[timerLabel release];
	[glView release];
	[menuView release];
	[infoView release];
	[timeCounter release];
	[productAdFree release];
	[removeAdsButton release];
	[productsReq release];
	[adManager release];
    [scoreManager release];

	[super dealloc];
}

@end
