//
//  GestureWindow.h
//  GestureUnlock
//
//  Created by Thomas Finch on 9/12/15.
//  Copyright © 2015 Thomas Finch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GestureView.h"

@interface GestureWindow : NSWindow {
    GestureView *gestureView;
}

@end
