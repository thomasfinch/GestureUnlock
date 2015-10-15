//
//  Recognizer.m
//  GestureUnlock
//
//  Created by Thomas Finch on 9/12/15.
//  Copyright © 2015 Thomas Finch. All rights reserved.
//

#import "Recognizer.h"

@implementation Recognizer

@synthesize glyphDetector;

+ (Recognizer*)sharedInstance {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    if (self = [super init]) {
        glyphDetector = [WTMGlyphDetector detector];
        glyphDetector.timeoutSeconds = 1;
        
        [self loadTemplatesWithNames:@"A",@"B",@"C",@"X",@"Y",@"Z",@"N", @"T", @"W", @"V", @"circle", @"square", @"triangle", nil];
    }
    return self;
}

- (void)loadTemplatesWithNames:(NSString*)firstTemplate, ...
{
    va_list args;
    va_start(args, firstTemplate);
    for (NSString *glyphName = firstTemplate; glyphName != nil; glyphName = va_arg(args, id))
    {
        if (![glyphName isKindOfClass:[NSString class]])
            continue;
        
        //        [glyphNamesArray addObject:glyphName];
        
        NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:glyphName ofType:@"json"]];
//        NSLog(@"JSON DATA: %@", jsonData);
        [glyphDetector addGlyphFromJSON:jsonData name:glyphName];
    }
    va_end(args);
}


@end
