//
//  AppDelegate.m
//  ETAccount_Mac
//
//  Created by 기용 이 on 2015. 4. 7..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import "AppDelegate.h"

#import "ETUtility.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [ETUtility copyBundleToDocumentsWithFileName:@"ETAccount.sqlite"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
