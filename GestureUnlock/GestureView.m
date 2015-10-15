//
//  GestureView.m
//  GestureUnlock
//
//  Created by Thomas Finch on 9/12/15.
//  Copyright © 2015 Thomas Finch. All rights reserved.
//

#import "GestureView.h"

@implementation GestureView

- (id)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        self.wantsLayer = YES;
        self.acceptsTouchEvents = YES;
        self.wantsRestingTouches = YES;
        
        curState = Indeterminate;
        
        highlighted = NO;

        [Recognizer sharedInstance].glyphDetector.delegate = self;
        
        curPath = [[NSBezierPath alloc] init];
        curPath.lineCapStyle = kCGLineCapRound;
        curPath.miterLimit = 0;
    }
    return self;
}

- (void)mouseDown:(NSEvent *)event {
    if (!highlighted) {
        highlighted = YES;
        
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [NSColor blueColor];
        shadow.shadowOffset = CGSizeMake(0, 0);
        shadow.shadowBlurRadius = 5 ;
        self.shadow = shadow;
    }
    else {
        NSPoint point = [self convertPoint:[NSEvent mouseLocation] fromView:self.superview];
        curState = Indeterminate;
        [[Recognizer sharedInstance].glyphDetector reset];
        [curPath removeAllPoints];
        [curPath moveToPoint:point];
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint point = [self convertPoint:[NSEvent mouseLocation] fromView:self.superview];
    [[Recognizer sharedInstance].glyphDetector addPoint:point];
    [curPath lineToPoint:point];
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)event {
    NSPoint point = [self convertPoint:[NSEvent mouseLocation] fromView:self.superview];
    [[Recognizer sharedInstance].glyphDetector addPoint:point];
    [[Recognizer sharedInstance].glyphDetector detectGlyph];
}

- (void)glyphDetected:(WTMGlyph *)glyph withScore:(float)score {
    NSLog(@"Detected glyph: %@", glyph.name);
    
    if ([glyph.name isEqualToString:@"C"]) {
        NSLog(@"Correct password");
        curState = Right;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self unlock];
        });
    }
    else {
        NSLog(@"Wrong password");
        curState = Wrong;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [curPath removeAllPoints];
            [self setNeedsDisplay:YES];
        });
    }
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSRect rect = [self bounds];
    CGRect pathRect = CGRectInset(CGRectMake(0, 0, rect.size.width, rect.size.height), 20, 20);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSRectFromCGRect(pathRect) xRadius:20 yRadius:20];
    [path addClip];
    [[NSColor lightGrayColor] set];
    NSRectFill(dirtyRect);
    
    if (curState == Indeterminate)
        [[NSColor blackColor] setStroke];
    else if (curState == Right)
        [[NSColor colorWithRed:0/255 green:204.0/255 blue:0/255 alpha:1.0] setStroke];
    else
        [[NSColor redColor] setStroke];
    
    [curPath setLineWidth:5];
    [curPath stroke];
    
    [super drawRect:dirtyRect];
}

- (void)unlock {
    if (curState != Right)
        return;
    
    NSLog(@"Unlocking");
    
    //Hardcoded the password for demoing ("test")
    //Yeah, I know it's bad
    
    CGEventRef downEvt = CGEventCreateKeyboardEvent( NULL, 0, true );
    CGEventRef upEvt = CGEventCreateKeyboardEvent( NULL, 0, false );
    UniChar oneChar = 't';
    CGEventKeyboardSetUnicodeString( downEvt, 1, &oneChar );
    CGEventKeyboardSetUnicodeString( upEvt, 1, &oneChar );
    CGEventPost( kCGSessionEventTap, downEvt );
    CGEventPost( kCGSessionEventTap, upEvt );
    oneChar = 'e';
    CGEventKeyboardSetUnicodeString( downEvt, 1, &oneChar );
    CGEventKeyboardSetUnicodeString( upEvt, 1, &oneChar );
    CGEventPost( kCGSessionEventTap, downEvt );
    CGEventPost( kCGSessionEventTap, upEvt );
    oneChar = 's';
    CGEventKeyboardSetUnicodeString( downEvt, 1, &oneChar );
    CGEventKeyboardSetUnicodeString( upEvt, 1, &oneChar );
    CGEventPost( kCGSessionEventTap, downEvt );
    CGEventPost( kCGSessionEventTap, upEvt );
    oneChar = 't';
    CGEventKeyboardSetUnicodeString( downEvt, 1, &oneChar );
    CGEventKeyboardSetUnicodeString( upEvt, 1, &oneChar );
    CGEventPost( kCGSessionEventTap, downEvt );
    CGEventPost( kCGSessionEventTap, upEvt );
    oneChar = '\n';
    CGEventKeyboardSetUnicodeString( downEvt, 1, &oneChar );
    CGEventKeyboardSetUnicodeString( upEvt, 1, &oneChar );
    CGEventPost( kCGSessionEventTap, downEvt );
    CGEventPost( kCGSessionEventTap, upEvt );
}

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

@end
