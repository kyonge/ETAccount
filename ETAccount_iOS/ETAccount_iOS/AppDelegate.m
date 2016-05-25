//
//  AppDelegate.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 4. 7..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ETUtility copyBundleToDocumentsWithFileName:@"ETAccount.sqlite"];
    
//    [self copyData];
    [self checkDB_ColorColumn];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - 컨버터

- (void)copyData
{
    NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"151107_edit" ofType:@"csv"];
    NSString *dataString = [NSString stringWithContentsOfFile:dataFilePath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"%@", dataString);
    NSArray *dataArray = [dataString componentsSeparatedByString:@"\n"];
//    NSLog(@"%@", dataArray);
    
    for (NSString *tempDataString in dataArray) {
        NSArray *tempDataArray = [tempDataString componentsSeparatedByString:@","];
        NSString *tempDataDate = [tempDataArray objectAtIndex:0];
        NSArray *tempDataDateArray = [tempDataDate componentsSeparatedByString:@". "];
        NSString *tempDataDateString = [NSString stringWithFormat:@"%@-%@-%@ 00:00",
                                        [tempDataDateArray objectAtIndex:0],
                                        [tempDataDateArray objectAtIndex:1],
                                        [[tempDataDateArray objectAtIndex:2] substringToIndex:[[tempDataDateArray objectAtIndex:2] length] - 1]];
        NSString *tempDataName = [tempDataArray objectAtIndex:1];
        NSString *tempDataAccount_1 = [tempDataArray objectAtIndex:2];
        NSString *tempDataAccount_2 = [tempDataArray objectAtIndex:4];
        NSString *tempDataPrice = [tempDataArray objectAtIndex:3];
        
        NSArray *tagKeyArray = [NSArray arrayWithObject:@"object"];
        NSArray *tagObjectsArray = [NSArray arrayWithObject:@"'1'"];
        NSDictionary *tagDataDic = [NSDictionary dictionaryWithObjects:tagObjectsArray forKeys:tagKeyArray];
        [ETAccountDBManager insertToTable:@"Tag_target" dataDictionary:tagDataDic];
        NSInteger newTag = [ETAccountDBManager getLast:@"id" FromTable:@"Tag_target"];
        
        NSString *querryString = @"INSERT INTO Deal (name, account_id_1, account_id_2, tag_target_id, date, money) VALUES (";
        querryString = [NSString stringWithFormat:@"%@'%@', '%@', '%@', '%ld', '%@', '%@')",
                        querryString, tempDataName, tempDataAccount_1, tempDataAccount_2, (long)newTag, tempDataDateString, tempDataPrice];
//        NSLog(@"%@", querryString);
        
        [ETUtility runQuerry:querryString FromFile:_DB];
    }
}

- (void)checkDB_ColorColumn
{
//    NSLog(@"%@", [ETUtility selectDataWithQuerry:@"SELECT name FROM Account LIMIT 1;" FromFile:_DB WithColumn:[NSArray arrayWithObject:@"name"]]);
//    NSLog(@"%@", [ETUtility selectDataWithQuerry:@"SELECT color_r FROM Account LIMIT 1;" FromFile:_DB WithColumn:[NSArray arrayWithObject:@"name"]]);
    
    NSArray *colorColumnArray = [ETUtility selectDataWithQuerry:@"SELECT color_r FROM Account LIMIT 1;" FromFile:_DB WithColumn:[NSArray arrayWithObject:@"name"]];
    if ([colorColumnArray count] == 0) {
        NSLog(@"Create column");
        [ETUtility runQuerry:@"ALTER TABLE Account ADD COLUMN color_r INTEGER" FromFile:_DB];
        [ETUtility runQuerry:@"ALTER TABLE Account ADD COLUMN color_g INTEGER" FromFile:_DB];
        [ETUtility runQuerry:@"ALTER TABLE Account ADD COLUMN color_b INTEGER" FromFile:_DB];
        
        NSArray *accountArray = [ETUtility selectDataWithQuerry:@"SELECT id FROM Account;" FromFile:_DB WithColumn:[NSArray arrayWithObject:@"id"]];
        for (NSDictionary *tempDictionary in accountArray) {
            NSArray *objectArray = [NSArray arrayWithObjects:
                                    [NSString stringWithFormat:@"%d", arc4random() % 255],
                                    [NSString stringWithFormat:@"%d", arc4random() % 255],
                                    [NSString stringWithFormat:@"%d", arc4random() % 255], nil];
            NSArray *keyArray = [NSArray arrayWithObjects:@"color_r", @"color_g", @"color_b", nil];
            NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
            [ETAccountDBManager updateToTable:@"Account" dataDictionary:dataDic ToId:[[tempDictionary objectForKey:@"id"] integerValue]];
        }
    }
}

@end
