//
//  PoultryWars2AppDelegate.h
//  PoultryWars1.1
//
//  Created by dev1 on 9/4/09.
//  Copyright www.colworx.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleAudioEngine.h"

@interface PoultryWars2AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navigator;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigator;

@end

