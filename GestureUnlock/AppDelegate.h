//
//  AppDelegate.h
//  GestureUnlock
//
//  Created by Thomas Finch on 9/12/15.
//  Copyright © 2015 Thomas Finch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GestureWindow.h"
#import "WTMGlyphDetector.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate> {
    NSStatusItem *statusItem;
    GestureWindow *window;
}

@end

