/**
 * AdMobView.h
 * AdMob iPhone SDK publisher code.
 *
 * The entry point for requesting a 320x48 AdMob ad to display.
 */
#import <UIKit/UIKit.h>

@protocol AdMobDelegate;

@interface AdMobView : UIView

/**
 * Initiates an ad request and returns a view that will contain the results;
 * the delegate is alerted when the ad is ready to display (or has failed to
 * load); this is a good opportunity to attach the view to your hierarchy.
 * If you already have a AdMobView with an ad loaded, and simply want to show
 * a new ad in the same location, you may use -requestFreshAd instead (see below).
 *
 * This method should only be called from a run loop in default run loop mode.
 * If you don't know what that means, you're probably ok. If in doubt, check
 * whether ([[NSRunLoop currentRunLoop] currentMode] == NSDefaultRunLoopMode).
 */
+ (AdMobView *)requestAdWithDelegate:(id<AdMobDelegate>)delegate;

/**
 * Causes an existing AdMobView to display a fresh ad. If an ad successfully loads,
 * it is animated in with a flip; if not, this call fails silently and the old
 * ad remains onscreen.
 *
 * Note that, during the flip, views under the AdMobView will be exposed.
 *
 * If refreshing an ad, we recommend doing it no more frequently than every 12
 * seconds.  The click through rates of ads remain high for that amount of time
 * and it gives users a chance to read and comprehend the ad.
 */
- (void)requestFreshAd;

/**
 * Returns the version of the current SDK.
 */
+ (NSString *)version;

/**
 * This property is exposed so that the delegate can be cleared if it is going to 
 * be dealloc'ed.  This ensures that the AdMob SDK will never make a call to a 
 * deallocated instance.
 */
@property (assign) id<AdMobDelegate> delegate;

@end