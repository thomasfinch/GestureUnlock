//
//  GestureView.h
//  GestureUnlock
//
//  Created by Thomas Finch on 9/12/15.
//  Copyright © 2015 Thomas Finch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WTMGlyphDetector.h"
#import "Recognizer.h"

enum PasswordState {
    Right,
    Wrong,
    Indeterminate
};

@interface GestureView : NSView <WTMGlyphDelegate> {
    NSBezierPath *curPath;
    BOOL highlighted;
    enum PasswordState curState;
}

@end
