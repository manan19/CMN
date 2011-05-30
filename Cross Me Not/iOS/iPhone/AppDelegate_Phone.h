	//
	//  AppDelegate_Phone.h
	//  Cross Me Not
	//
	//  Created by Manan Patel on 2/18/10.
	//  Copyright Apple Inc 2010. All rights reserved.
	//

#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>
#import "ScoreManager.h"
#import "AdManager.h"
#import "FlurryAPI.h"

#define MAX_LEVELS	25

@class EAGLView;

@interface AppDelegate_Phone : NSObject <UIApplicationDelegate,UIPickerViewDelegate, UIPickerViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver, GKLeaderboardViewControllerDelegate> 
{
@public
	IBOutlet UIWindow *window;
	IBOutlet UIViewController *placeHolderViewController;
	IBOutlet UIView *menuView;
	IBOutlet UIView *infoView;
	IBOutlet UILabel *timerLabel;
	IBOutlet UILabel *bestTimeLabel;
	IBOutlet UIButton *removeAdsButton;
    IBOutlet UIButton *gameCenterButton;
	IBOutlet EAGLView *glView;

		//SKProductsRequest* productRequest;
		//SKProduct* productAdFree;
	NSString* productIdentifierAdFree;
	SKProductsRequest* productsReq;
	SKProduct* productAdFree;
	NSDate *timeCounter;
	ScoreManager* scoreManager;
	AdManager* adManager;
    GKLeaderboardViewController *leaderboardController;

	int currentLevel,gameEntryLevel;
	BOOL appActive,adFree;
	double frameRate,time;
}

- (IBAction)menuButton:(id)sender;
- (IBAction)startGame:(id)sender;
- (IBAction)infoButton:(id)sender;
- (IBAction)gameCenter:(id)sender;
- (IBAction)buyAdFree:(id)sender;
-(void)setScoreLabelForLevel:(int)level;

- (void) requestProductData;
- (void) endGame ;
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

