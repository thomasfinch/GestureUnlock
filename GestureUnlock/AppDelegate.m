//
//  AppDelegate.m
//  GestureUnlock
//
//  Created by Thomas Finch on 9/12/15.
//  Copyright © 2015 Thomas Finch. All rights reserved.
//

#import "AppDelegate.h"
#import "Recognizer.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self selector: @selector(screenDidSleep:) name: NSWorkspaceWillSleepNotification object: NULL];
//    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self selector: @selector(screenDidWake:) name: NSWorkspaceDidWakeNotification object: NULL];
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(screenUnlocked) name:@"com.apple.screenIsUnlocked" object:nil];
    
    NSMenu *menu = [[NSMenu alloc] init];
    menu.delegate = self;
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:120];
    statusItem.title = @"GestureUnlock";
    statusItem.menu = menu;
    
    [Recognizer sharedInstance];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)screenDidSleep:(NSNotification*)notif {
    NSLog(@"Screen did sleep");
    
    window = [[GestureWindow alloc] init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        window.alphaValue = 1.0;
        [window makeKeyAndOrderFront:self];
    });
}

- (void)screenDidWake:(NSNotification*)notif {
    NSLog(@"Screen did wake");
}

- (void)screenUnlocked {
    NSLog(@"Screen unlocked");
    window.alphaValue = 0;
}

@end

