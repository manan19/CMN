//
//  PoultryWars2AppDelegate.m
//  PoultryWars1.1
//
//  Created by dev1 on 9/4/09.
//  Copyright www.colworx.com 2009. All rights reserved.
//

#import "PoultryWars2AppDelegate.h"

@implementation PoultryWars2AppDelegate

@synthesize window;
@synthesize navigator;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"menu_click1.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"menu_click2.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"menu_click3.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"leave_screen.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"Egg_collide.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"Egg_creation.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"bgmusic1.mp3"];
	//[[SimpleAudioEngine sharedEngine] preloadEffect:@"bgmusic2.mp3"];
	//[[SimpleAudioEngine sharedEngine] preloadEffect:@"bgmusicmenu.mp3"];
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5];
	
	[window addSubview:navigator.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
