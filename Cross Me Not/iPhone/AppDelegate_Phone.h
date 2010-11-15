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
#import "ScoreManager.h"

#define MAX_LEVELS	10

@class EAGLView;

@interface AppDelegate_Phone : NSObject <UIApplicationDelegate,UIPickerViewDelegate, UIPickerViewDataSource, ADBannerViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver> 
{
@public
	IBOutlet UIWindow *window;
	IBOutlet UIViewController *placeHolderViewController;
	IBOutlet UIView *menuView;
	IBOutlet UIView *infoView;
	IBOutlet UILabel *timerLabel;
	IBOutlet UILabel *bestTimeLabel;
	IBOutlet UIButton *removeAdsButton;
	IBOutlet EAGLView *glView;

		//SKProductsRequest* productRequest;
		//SKProduct* productAdFree;
	NSString* productIdentifierAdFree;
	SKProductsRequest* productsReq;
	SKProduct* productAdFree;
	NSDate *timeCounter;
	ADBannerView *adView;
	ScoreManager* scoreManager;

	int currentLevel,gameEntryLevel;
	BOOL appActive, adFree, adViewVisible;
	double frameRate,time;
}

- (IBAction)menuButton:(id)sender;
- (IBAction)startGame:(id)sender;
- (IBAction)infoButton:(id)sender;
- (IBAction)buyAdFree:(id)sender;
-(void)setScoreLabelForLevel:(int)level;

	//- (void)requestProductData;

- (void) endGame ;
- (void) animate:(ADBannerView*)banner up:(BOOL)up;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) provideContent: (NSString *)productIdentifier;


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;
@property (nonatomic, retain) IBOutlet UIView *menuView;
@property (nonatomic, retain) IBOutlet UIView *infoView;
@property (nonatomic, retain) IBOutlet UIViewController *placeHolderViewController;
@property (nonatomic, retain) IBOutlet UILabel *timerLabel;
@property (nonatomic, retain) IBOutlet UILabel *bestTimeLabel;


@end

