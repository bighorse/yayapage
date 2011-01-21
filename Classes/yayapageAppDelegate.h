//
//  yayapageAppDelegate.h
//  yayapage
//
//  Created by 馬 広軍 on 11/01/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yayapageAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *nav;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

