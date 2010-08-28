	//
	//  AppDelegate_Phone.h
	//  Cross Me Not
	//
	//  Created by Manan Patel on 2/18/10.
	//  Copyright Apple Inc 2010. All rights reserved.
	//

#import <UIKit/UIKit.h>
#import <iAd/ADBannerView.h>
#import <StoreKit/StoreKit.h>

#define MAX_LEVELS	10

#define AD_REFRESH_PERIOD 60.0 // display fresh ads once per minute

@class EAGLView;

@interface AppDelegate_Phone : NSObject <UIApplicationDelegate,UIPickerViewDelegate, UIPickerViewDataSource, ADBannerViewDelegate, /*SKProductsRequestDelegate,*/ SKPaymentTransactionObserver> 
{
@public
	IBOutlet UIWindow *window;
	IBOutlet UIView *placeHolderView;
	IBOutlet UIViewController *placeHolderViewController;
	IBOutlet UIView *menuView;
	IBOutlet UIView *infoView;
	IBOutlet UILabel *timerLabel;
	IBOutlet UILabel *bestTimeLabel;
	IBOutlet EAGLView *glView;
	NSMutableDictionary *bestTimes;

		//SKProductsRequest* productRequest;
		//SKProduct* productAdFree;
	NSString* productIdentifierAdFree;
	NSDate *timeCounter;
	ADBannerView *adView;

	int currentLevel;
	BOOL appActive, adFree;
	double frameRate,time;
}

- (IBAction)menuButton:(id)sender;
- (IBAction)startGame:(id)sender;
- (IBAction)infoButton:(id)sender;
- (void)loadBestTimes;
	//- (void)requestProductData;
- (void) buyAdFree:(id)sender;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) provideContent: (NSString *)productIdentifier;


@property (nonatomic, retain) NSMutableDictionary *bestTimes;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;
@property (nonatomic, retain) IBOutlet UIView *menuView;
@property (nonatomic, retain) IBOutlet UIView *infoView;
@property (nonatomic, retain) IBOutlet UIView *placeHolderView;
@property (nonatomic, retain) IBOutlet UIViewController *placeHolderViewController;
@property (nonatomic, retain) IBOutlet UILabel *timerLabel;
@property (nonatomic, retain) IBOutlet UILabel *bestTimeLabel;


@end

