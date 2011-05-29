	//
	//  AdManager.m
	//  Cross Me Not
	//
	//  Created by Manan Patel on 2/1/11.
	//  Copyright 2011 ngmoco:). All rights reserved.
	//

#import "AdManager.h"


@implementation AdManager

-(id)init
{
    if ((self = [super init]))
    {
		adViewVisible = FALSE;
		
			// Get user's country code based on currentLocale
		NSLocale *locale = [NSLocale currentLocale];
		NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
		
		if ([countryCode isEqualToString:@"US"] ||
			[countryCode isEqualToString:@"GB"] ||
			[countryCode isEqualToString:@"FR"] ||
			[countryCode isEqualToString:@"JP"] ||
            [countryCode isEqualToString:@"IT"] ||
			[countryCode isEqualToString:@"DE"])
		{
				// Use iAds
			ADBannerView *iadView = [[ADBannerView alloc] initWithFrame:BOTTOM_AD_FRAME];
			iadView.frame = CGRectOffset(iadView.frame, 0, 50);
			if( [[[UIDevice currentDevice] systemVersion] compare:@"4.2" options:NSNumericSearch] != NSOrderedAscending )
			{
				[iadView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, nil]];
				[iadView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
			}
			else 
			{
				[iadView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, nil]];
				[iadView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifier320x50];
			}
			
			[iadView setDelegate:self];
			_adView = iadView;			
		}
		else 
		{
				// Use Admob
			_adView = [AdMobView requestAdWithDelegate:self];
		}
    }	
    return self;
}

-(UIView *) getAdView
{
	return _adView;
}

-(void) setParentView:(UIView*)pView andPosition:(Boolean)Top
{
	_parentView = pView;
	adTop = Top;
	if (_adView) 
	{
		if(adTop)
		{
			[_adView setFrame:TOP_AD_FRAME];
			if(!adViewVisible)
				_adView.frame = CGRectOffset(_adView.frame, 0, -50);
		}
		else
		{
			[_adView setFrame:BOTTOM_AD_FRAME];
			if(!adViewVisible)
				_adView.frame = CGRectOffset(_adView.frame, 0, 50);
		}

		[_parentView addSubview:_adView];
	}
	
}

-(void) setParentViewController:(UIViewController*)pVC
{
	_parentViewController = pVC;
}

-(void) shutdown
{
	[_adView removeFromSuperview];
	[_adView release];
	_adView = NULL;
}


#pragma mark -
#pragma mark ADBannerViewDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner 
{
	[FlurryAPI logEvent:@"iAd:bannerViewDidLoadAd"];

	if (!adViewVisible) {
		[self _animate:banner up:!adTop];
		adViewVisible = TRUE;
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	[FlurryAPI logEvent:@"iAd:didFailToReceiveAdWithError"];

		//iAds failed
	NSLog(@"%@",[error localizedDescription]);
	if (adViewVisible)
	{
		[self _animate:banner up:adTop];
		adViewVisible = FALSE;
	}	
		// clean iAds
		//[banner removeFromSuperview];
		//[banner release];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
	[FlurryAPI logEvent:@"iAd:bannerViewActionShouldBegin"];
	[[[UIApplication sharedApplication] delegate] applicationWillResignActive:nil];
	return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
	[[[UIApplication sharedApplication] delegate] applicationDidBecomeActive:nil];
	[FlurryAPI logEvent:@"iAd:bannerViewActionDidFinish"];
}


#pragma mark -
#pragma mark AdMobDelegate
- (void)didReceiveAd:(AdMobView *)adView {
	[FlurryAPI logEvent:@"Admob:didReceiveAd"];

	if (adTop)
	{
		[_adView setFrame:TOP_AD_FRAME];
		_adView.frame = CGRectOffset(_adView.frame, 0, -48);
		[_parentView addSubview:_adView];
	}
	else
	{
		[_adView setFrame:BOTTOM_AD_FRAME];
		_adView.frame = CGRectOffset(_adView.frame, 0, 48);
		[_parentView addSubview:_adView];
	}
	
	if (!adViewVisible) {
		[self _animate:_adView up:!adTop];
		adViewVisible = TRUE;
	}
}

	// Sent when an ad request failed to load an ad
- (void)didFailToReceiveAd:(AdMobView *)adView {
	[FlurryAPI logEvent:@"Admob:didFailToReceiveAd"];

	if(adViewVisible)
	{
		[self _animate:adView up:adTop];
		adViewVisible = FALSE;
	}
}

- (NSString *)publisherIdForAd:(AdMobView *)adView {
	return @"a14b84284a8b3d3";
}

- (void)didReceiveRefreshedAd:(AdMobView *)adView {
	[FlurryAPI logEvent:@"Admob:didReceiveRefreshedAd"];
}

- (void)didFailToReceiveRefreshedAd:(AdMobView *)adView {
	[FlurryAPI logEvent:@"Admob:didFailToReceiveRefreshedAd"];
}

- (void)willPresentFullScreenModalFromAd:(AdMobView *)adView {
	[FlurryAPI logEvent:@"Admob:willPresentFullScreenModalFromAd"];
	[[[UIApplication sharedApplication] delegate] applicationWillResignActive:nil];
}

- (void)didPresentFullScreenModalFromAd:(AdMobView *)adView {
	[FlurryAPI logEvent:@"Admob:didPresentFullScreenModalFromAd"];
}

- (void)willDismissFullScreenModalFromAd:(AdMobView *)adView {
	[FlurryAPI logEvent:@"Admob:willDismissFullScreenModalFromAd"];
}

- (void)didDismissFullScreenModalFromAd:(AdMobView *)adView {
	[FlurryAPI logEvent:@"Admob:didDismissFullScreenModalFromAd"];
	[[[UIApplication sharedApplication] delegate] applicationDidBecomeActive:nil];
}

- (void)applicationWillTerminateFromAd:(AdMobView *)adView {
	[FlurryAPI logEvent:@"Admob:applicationWillTerminateFromAd"];
}


#pragma mark -

- (UIViewController *)currentViewControllerForAd:(AdMobView *)adView {
	return _parentViewController;
}

- (void)_animate:(UIView*)adView up:(BOOL)up
{
	if (up)
	{
			//if (adView.frame.origin.y == 480) 
		{
			[UIView beginAnimations:@"animateAdBannerUp" context:NULL];
			adView.frame = CGRectOffset(adView.frame, 0, -50);
			[UIView commitAnimations];	
		}
	}
	else 
	{
			//if (adView.frame.origin.y == -50) 
		{
			[UIView beginAnimations:@"animateAdBannerUp" context:NULL];
			adView.frame = CGRectOffset(adView.frame, 0, 50);
			[UIView commitAnimations];
		}
	}
}


-(void) dealloc
{
	[_adView release];
	
	[super dealloc];
}

@end
