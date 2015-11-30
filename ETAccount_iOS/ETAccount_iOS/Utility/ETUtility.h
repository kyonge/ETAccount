//
//  ETUtility.h
//  PopOp
//
//  Created by 기용 이 on 2015. 1. 12..
//  Copyright (c) 2015년 Opinion8. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETHTTPUtility.h"
#import "FMDatabase.h"

#define IOS_VERSION_CHECK_8 if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ETUtility : NSObject

// File Control
+ (NSString *)documentString:(NSString *)fileName;
+ (void)copyBundleToDocumentsWithFileName:(NSString *)fileName;

// NSString NULL 체크
+ (NSString *)nullCheckWithString:(NSString *)insertString;

// Image Cache
+ (UIImage *)loadImageFileFromDocumentCache:(NSString *)fileName;
+ (void)loadAndSetImageToImageView:(UIImageView *)targetImageView FromDocumentCacheAsynchronized:(NSString *)fileName;

// NSArray 내에서 NSDictionary 탐색
+ (NSDictionary *)selectDictionaryWithValue:(id)value OfKey:(NSString *)key inArray:(NSArray *)array;
+ (NSInteger)indexOfDictionaryWithValue:(id)value OfKey:(NSString *)key inArray:(NSArray *)array;
+ (BOOL)hasArray:(NSArray *)targetArray hasDictionaryWithId:(NSInteger)targetId;

// iOS8.0 이후 Alert 처리
+ (UIAlertController *)showAlert:(NSString *)titleString Message:(NSString *)messageString atViewController:(UIViewController *)viewController withBlank:(BOOL)blank;

// UIViewAnimation
+ (void)AnimationView:(UIView *)view toFrame:(CGRect)frame toAlpha:(float)alpha inTime:(float)time toTarget:(id)target WithSelector:(SEL)selector;

// sqlite (ALL)
+ (BOOL)runQuerry:(NSString *)querryString FromFile:(NSString *)sqliteFileName;
+ (NSMutableArray *)selectDataWithQuerry:(NSString *)querryString FromFile:(NSString *)sqliteFileName WithColumn:(NSArray *)columns;
+ (NSMutableArray *)selectAllSQliteDatasFromFile:(NSString *)sqliteFileName Table:(NSString *)tableName WithColumn:(NSArray *)columns;

// sqlite (LIKE)
+ (NSMutableArray *)selectSQliteDatasOfColumns:(NSArray *)columns FromFile:(NSString *)sqliteFileName Table:(NSString *)tableName LikeKeys:(NSArray *)keys OfColumns:(NSArray *)columns_;

@end


@interface ETPushNoAnimationSegue : UIStoryboardSegue

@end
