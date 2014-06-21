	//
	//  AdManager.m
	//  Cross Me Not
	//
	//  Created by Manan Patel on 2/1/11.
	//  Copyright 2011 :). All rights reserved.
	//

#import "AdManager.h"


@implementation AdManager

-(id)init
{
    if ((self = [super init]))
    {
		adViewVisible = FALSE;
		
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
	_adView = NULL;
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

#pragma mark -
#pragma mark ADBannerViewDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner 
{
	[Flurry logEvent:@"iAd:bannerViewDidLoadAd"];

	if (!adViewVisible) {
		[self _animate:banner up:!adTop];
		adViewVisible = TRUE;
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	[Flurry logEvent:@"iAd:didFailToReceiveAdWithError"];

		//iAds failed
	NSLog(@"%@",[error localizedDescription]);
	if (adViewVisible)
	{
		[self _animate:banner up:adTop];
		adViewVisible = FALSE;
	}	
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
	[Flurry logEvent:@"iAd:bannerViewActionShouldBegin"];
	[[[UIApplication sharedApplication] delegate] applicationWillResignActive:nil];
	return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
	[[[UIApplication sharedApplication] delegate] applicationDidBecomeActive:nil];
	[Flurry logEvent:@"iAd:bannerViewActionDidFinish"];
}

@end
