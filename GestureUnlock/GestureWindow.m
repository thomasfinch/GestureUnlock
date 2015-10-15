//
//  GestureWindow.m
//  GestureUnlock
//
//  Created by Thomas Finch on 9/12/15.
//  Copyright © 2015 Thomas Finch. All rights reserved.
//

#import "GestureWindow.h"

@implementation GestureWindow

- (id)init {
    if (self = [super initWithContentRect:[[NSScreen mainScreen] frame] styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO]) {
        self.opaque = NO;
        self.backgroundColor = [NSColor clearColor];
        self.level = CGShieldingWindowLevel();
        
        const CGFloat viewSize = 380;
        gestureView = [[GestureView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(([[NSScreen mainScreen] frame].size.width - viewSize)/2, 125, viewSize, viewSize))];
        [self.contentView addSubview:gestureView];
    }
    return self;
}

@end
