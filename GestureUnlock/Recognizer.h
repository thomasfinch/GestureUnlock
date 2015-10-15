//
//  Recognizer.h
//  GestureUnlock
//
//  Created by Thomas Finch on 9/12/15.
//  Copyright © 2015 Thomas Finch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTMGlyphDetector.h"

@interface Recognizer : NSObject

@property WTMGlyphDetector *glyphDetector;

+ (Recognizer*)sharedInstance;

@end
