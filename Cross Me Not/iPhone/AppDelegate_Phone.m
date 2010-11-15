	//
	//  AppDelegate_Phone.m
	//  Cross Me Not
	//
	//  Created by Manan Patel on 2/18/10.
	//  Copyright Apple Inc 2010. All rights reserved.
	//

#import "AppDelegate_Phone.h"
#import "EAGLView.h"

#define TOP_AD_FRAME CGRectMake(0, 0, 320, 50)
#define BOTTOM_AD_FRAME CGRectMake(0, 430, 320, 50)

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
		// Initial UI Setup
	[window addSubview:placeHolderViewController.view];
	[window makeKeyAndVisible];
	[placeHolderViewController.view addSubview:menuView];
	
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
		adViewVisible = FALSE;
		adView = [[[ADBannerView alloc] initWithFrame:BOTTOM_AD_FRAME] autorelease];
		adView.frame = CGRectOffset(adView.frame, 0, 50);
		[adView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, nil]];
		[adView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifier320x50];
		[adView setDelegate:self];
		[menuView addSubview:adView];
		
		glView->clippingRect = CGRectMake(0, 50 * glView->renderer->scale , glView->screenWidth, glView->screenHeight - 50 * glView->renderer->scale );
		
		productsReq = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productIdentifierAdFree]];
		[productsReq setDelegate:self];
		[productsReq start];
	}
	else 
	{
		glView->clippingRect = CGRectMake(0, 0, glView->screenWidth, glView->screenHeight);
		[removeAdsButton removeFromSuperview];
	}
	
		// Setup for high scores
	scoreManager = [[ScoreManager alloc] init];
	[scoreManager readBestTimes];
	[self setScoreLabelForLevel:currentLevel+1];
	
	
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
	[NSTimer scheduledTimerWithTimeInterval:(1/10) target:self selector:@selector(update) userInfo:nil repeats:YES];
	
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
#pragma mark ADBannerViewDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner 
{
	if (!adViewVisible) {
		[self animate:banner up:!glView->playingGame];
		adViewVisible = TRUE;
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	if (adViewVisible)
	{
		[self animate:banner up:glView->playingGame];
		adViewVisible = FALSE;
	}
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
	
	[self setScoreLabelForLevel:currentLevel+1];
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
		
			//Hack to keep FCKING AdMob Ads to change the placeHoler frame
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

/*
 - (void) requestProductData
 {
 productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject: productIdentifierAdFree]];
 [productRequest setDelegate:self];
 [productRequest start];
 }
 */

-(IBAction) buyAdFree: (id)sender
{
	SKPayment *payment = [SKMutablePayment paymentWithProductIdentifier:productIdentifierAdFree];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
	
	[removeAdsButton setEnabled:FALSE];
}

- (void)animate:(ADBannerView*)banner up:(BOOL)up
{
	if (up)
	{
		if (banner.frame.origin.y == 480) 
		{
			[UIView beginAnimations:@"animateAdBannerUp" context:NULL];
			banner.frame = CGRectOffset(banner.frame, 0, -50);
			[UIView commitAnimations];	
		}
	}
	else 
	{
		if (banner.frame.origin.y == -50) 
		{
			[UIView beginAnimations:@"animateAdBannerUp" context:NULL];
			banner.frame = CGRectOffset(banner.frame, 0, 50);
			[UIView commitAnimations];
		}
	}
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
		[adView removeFromSuperview];
		adView = NULL;
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
		if (adView) 
		{
			[adView setFrame:BOTTOM_AD_FRAME];
			[menuView addSubview:adView];
		}
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.8];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:placeHolderViewController.view cache:YES];
		[glView removeFromSuperview];
		[placeHolderViewController.view addSubview:menuView];
		[UIView commitAnimations];
	}
	
	glView->playingGame = FALSE;
	
		//Update bestTimeLabel
	[self setScoreLabelForLevel:gameEntryLevel+1];
}

- (IBAction)infoButton:(id)sender
{
	if([infoView superview] == placeHolderViewController.view)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.8];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:placeHolderViewController.view cache:YES];
		[infoView removeFromSuperview];
		[placeHolderViewController.view addSubview:menuView];
		if (adView) 
		{
			[menuView addSubview:adView];	
		}
		[UIView commitAnimations];
	}
	else 
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.8];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:placeHolderViewController.view cache:YES];
		[menuView removeFromSuperview];
		[placeHolderViewController.view addSubview:infoView];
		if (adView) 
		{
			[infoView addSubview:adView];
		}
		[UIView commitAnimations];
	}
}

- (IBAction)startGame:(id)sender
{
	[glView newGraph:currentLevel];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
	
	if ([menuView superview] == placeHolderViewController.view)
	{
		if (adView) 
		{
			[adView setFrame:TOP_AD_FRAME];
			if (!adViewVisible) 
			{
				adView.frame = CGRectOffset(adView.frame, 0, -50);
			}
			[glView addSubview:adView];	
		}
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.8];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:placeHolderViewController.view cache:YES];
		[menuView removeFromSuperview];
		[placeHolderViewController.view addSubview:glView];
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

- (void) endGame
{
	NSString *currTime = timerLabel.text;
	[scoreManager newScore:[currTime floatValue] forLevel:currentLevel+1];
}

- (void)dealloc
{
	[window release];
	[placeHolderViewController.view release];
	[timerLabel release];
	[glView release];
	[menuView release];
	[infoView release];
	[adView release];
	[timeCounter release];
	[productAdFree release];
	[removeAdsButton release];
	[productsReq release];
	
	[super dealloc];
}

@end
