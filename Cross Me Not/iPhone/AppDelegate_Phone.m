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
	
		// Initial Game Setup
	currentLevel = 0;
	[glView initGraph:0];
	timeCounter = [[NSDate date] retain];
	time = 0;
	
		// Initial setup for In-App Purchases
	productIdentifierAdFree = @"com.mp.crossmenot.adfree";
	
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
		adView = [[[ADBannerView alloc] initWithFrame:CGRectMake(0, 430, 320, 50)] autorelease];
		[adView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, nil]];
		[adView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifier320x50];
		[adView setDelegate:self];
		[menuView addSubview:adView];
	}
	
		// Setup for high scores
	[self loadBestTimes];
	
		// Setup for In-App Purchase if user can purchase
	if ([SKPaymentQueue canMakePayments]) 
	{
			//[self requestProductData];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	
	[NSTimer scheduledTimerWithTimeInterval:(1/60) target:self selector:@selector(update) userInfo:nil repeats:YES];
	
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
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
}

/*
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
		}
		
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[numberFormatter setLocale:product.priceLocale];
		NSLog(@"Product: %@, Title: %@, Description: %@, Price: %@", product.productIdentifier, product.localizedTitle, product.localizedDescription, formattedPrice);
	}
}
*/

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
		else if(placeHolderViewController.view.frame.origin.y != 0)
			[placeHolderViewController.view setFrame:window.frame];
	}
}

/*
 - (void) requestProductData
{
	productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject: productIdentifierAdFree]];
	[productRequest setDelegate:self];
	[productRequest start];
}
*/

-(void) buyAdFree: (id)sender
{
	SKPayment *payment = [SKMutablePayment paymentWithProductIdentifier:productIdentifierAdFree];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
			// Optionally, display an error here.
	}
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
		//If you want to save the transaction
		// [self recordTransaction: transaction];
	
		//Provide the new content
	[self provideContent: transaction.originalTransaction.payment.productIdentifier];
	
		//Finish the transaction
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
		//If you want to save the transaction
		// [self recordTransaction: transaction];
	
		//Provide the new content
	[self provideContent: transaction.payment.productIdentifier];
	
		//Finish the transaction
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) provideContent: (NSString*)productIdentifier
{
	if (![productIdentifier compare:productIdentifierAdFree]) 
	{
		[adView removeFromSuperview];
		adView = NULL;
			//Transaction for Ad Free version complete.
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:@"purchased" forKey:productIdentifierAdFree];
	}
}

- (IBAction)menuButton:(id)sender
{
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
	
	if([glView superview] == placeHolderViewController.view)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.8];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:placeHolderViewController.view cache:YES];
		[glView removeFromSuperview];
		[placeHolderViewController.view addSubview:menuView];
		[UIView commitAnimations];
	}
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
	[glView initGraph:currentLevel];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
	
	if ([menuView superview] == placeHolderViewController.view)
	{
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

- (void) loadBestTimes 
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *appFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"BestTimes.plist"];
	bestTimes = [[NSMutableDictionary alloc] initWithContentsOfFile:appFile];
	if (!bestTimes) 
	{
		bestTimes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"9990", @"1", @"9990", @"2",@"9990", @"3",@"9990", @"4",@"9990", @"5",@"9990", @"6",@"9990", @"7",@"9990", @"8",@"9990", @"9",@"9990", @"10", nil];
	}
	
	NSString* prevBest = [NSString stringWithFormat:@"%@ s",[bestTimes objectForKey:[NSString stringWithFormat:@"%d",currentLevel+1]]];
	if ([prevBest floatValue] == 9990) 
		[bestTimeLabel setText:NSLocalizedString(@"NA",@"No score yet")];
	else
		[bestTimeLabel setText:prevBest];
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
	[bestTimes release];
	
	[super dealloc];
}

@end
