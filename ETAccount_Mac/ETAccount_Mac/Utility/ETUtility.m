//
//  ETUtility.m
//  PopOp
//
//  Created by 기용 이 on 2015. 1. 12..
//  Copyright (c) 2015년 Opinion8. All rights reserved.
//

#import "ETUtility.h"

@implementation ETUtility

#pragma mark - File Control

// Documents 경로 출력
+ (void)listsOfDocumentsCheckDirectory:(BOOL)isDirectory
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* rootDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:rootDir];
    NSString *path;
    
    while((path = [enumerator nextObject]) != nil ) {
        if([fileManager fileExistsAtPath:[rootDir stringByAppendingPathComponent:path]] ){
            NSLog(@"%@ 이름 : %@", (isDirectory ? (@"[폴더]") : (@"[파일]") ), path );
        }
    }
}

// Documents 파일 경로 가져오기
+ (NSString *)documentString:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    return documentPath;
}

// Bundle 경로에서 Documents 경로로 파일 복사하기
+ (void)copyBundleToDocumentsWithFileName:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *localDBPath = [ETUtility documentString:fileName];
    BOOL exist = [fileManager fileExistsAtPath:localDBPath];
    
    NSString *nameString = [fileName stringByDeletingPathExtension];
    NSString *extensionString = [fileName pathExtension];
    
    NSString *sourceFilePath = [[NSBundle mainBundle] pathForResource:nameString ofType:extensionString];
//    NSString *sourceFilePath = [[NSBundle mainBundle] pathForResource:@"Locations" ofType:@"sqlite"];
    
    if (!exist)
        [fileManager copyItemAtPath:sourceFilePath toPath:localDBPath error:nil];
}


#pragma mark - NSString NULL 판별

// NSString NULL 체크
+ (NSString *)nullCheckWithString:(NSString *)insertString
{
    if ([insertString isEqual:[NSNull null]])
        return @"";
    else return insertString;
}


#pragma mark - Image Cache

+ (NSString *)tempDocumentString:(NSString *)fileName
{
    NSString *tempPath = NSTemporaryDirectory();
    NSString *documentPath = [tempPath stringByAppendingPathComponent:fileName];
    
    return documentPath;
}

//+ (NSImage *)loadImage:(NSString *)imageName
//{
//    NSString *fileName = [imageName stringByDeletingPathExtension];
//    NSString *fileExtension = [imageName pathExtension];
//    NSImage *tempImage = [NSImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension]];
//    if (tempImage) return tempImage;
//    
//    NSString *documentPath = [ETUtility documentString:imageName];
//    NSImage *loadedImage;
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL exist = [fileManager fileExistsAtPath:documentPath];
//    
//    if (exist) loadedImage = [NSImage imageWithContentsOfFile:documentPath];
//    else loadedImage = [NSImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imageName stringByDeletingPathExtension] ofType:[imageName pathExtension]]];
//    
//    return loadedImage;
//}

//+ (NSImage *)loadImageFromTempDocuments:(NSString *)imageName
//{
//    NSString *fileName = [imageName stringByDeletingPathExtension];
//    NSString *fileExtension = [imageName pathExtension];
//    NSImage *tempImage = [NSImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension]];
//    
//    if (tempImage) return tempImage;
//    
//    NSString *documentPath = [ETUtility tempDocumentString:imageName];
//    NSImage *loadedImage;
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL exist = [fileManager fileExistsAtPath:documentPath];
//    
//    
//    if (exist) loadedImage = [NSImage imageWithContentsOfFile:documentPath];
//    else {
//        loadedImage = [NSImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imageName stringByDeletingPathExtension] ofType:[imageName pathExtension]]];
//    }
//    return loadedImage;
//}

//+ (NSImage *)loadImageFileFromDocumentCache:(NSString *)fileName
//{
//    NSString *savedName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//    
//    BOOL hasCacheFile = [[NSFileManager defaultManager] fileExistsAtPath:[ETUtility documentString:savedName]];
//    if (hasCacheFile) {
//        return [ETUtility loadImage:savedName];
//    }
//    else {
//        NSData *tempData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileName]];
//        NSImage *tempImage = [NSImage imageWithData:tempData];
//        
////        NSData *imageData = NSImagePNGRepresentation(tempImage);
//        NSData *imageData = NSImageJPEGRepresentation(tempImage, 0.5);
//        [imageData writeToFile:[ETUtility documentString:savedName] atomically:YES];
//        
//        return tempImage;
//    }
//}

+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, NSImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   NSImage *image = [[NSImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

//+ (void)loadAndSetImageToImageView:(NSImageView *)targetImageView FromDocumentCacheAsynchronized:(NSString *)fileName
//{
//    NSString *savedName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//    
//    BOOL hasCacheFile = [[NSFileManager defaultManager] fileExistsAtPath:[ETUtility documentString:savedName]];
//    if (hasCacheFile) {
//        [targetImageView setImage:[ETUtility loadImage:savedName]];
//    }
//    else {
//        [ETUtility downloadImageWithURL:[NSURL URLWithString:fileName] completionBlock:^(BOOL succeeded, NSImage *downloadedImage) {
//            if (succeeded) {
//                NSData *imageData = NSImageJPEGRepresentation(downloadedImage, 0.5);
//                [imageData writeToFile:[ETUtility documentString:savedName] atomically:YES];
//                
//                [targetImageView setImage:downloadedImage];
//            }
//        }];
//    }
//}


#pragma mark - NSArray 내에서 NSDictionary 탐색

// NSArray 내에서 NSDictionary 탐색
+ (NSDictionary *)selectDictionaryWithValue:(id)value OfKey:(NSString *)key inArray:(NSArray *)array
{
    for (NSDictionary *tempDictionary in array) {
        if ([[tempDictionary objectForKey:key] isEqualToString:value])
            return tempDictionary;
    }
    
    return nil;
}


#pragma mark - Alert

// iOS8.0 이후 Alert 처리
+ (void)showAlert:(NSString *)titleString Message:(NSString *)messageString atViewController:(NSViewController *)viewController
{
//    UIAlertController *alertController = [UIAlertController
//                                          alertControllerWithTitle:titleString
//                                          message:messageString
//                                          preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *okAction = [UIAlertAction
//                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                               style:UIAlertActionStyleDefault
//                               handler:nil];
//    
//    [alertController addAction:okAction];
//    [viewController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - NSViewAnimation

// NSViewAnimation
+ (void)AnimationView:(NSView *)view toFrame:(CGRect)frame toAlpha:(float)alpha inTime:(float)time toTarget:(id)target WithSelector:(SEL)selector
{
//    [NSView animateWithDuration:time animations:^{
//        [view setFrame:frame];
//        [view setAlpha:alpha];
//    } completion:^(BOOL finished) {
//        if (selector)
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//            [target performSelector:selector];
//#pragma clang diagnostic pop
//    }];
}


#pragma mark - FMDatabase : SQLite

// sqlite (LIKE)
+ (NSMutableArray *)selectSQliteDatasOfColumns:(NSArray *)columns FromFile:(NSString *)sqliteFileName Table:(NSString *)tableName LikeKeys:(NSArray *)keys OfColumns:(NSArray *)columns_
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:sqliteFileName];
    FMDatabase *db = [FMDatabase databaseWithPath:documentPath];
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE", tableName];
    for (NSString *tempColumn in columns_) {
        sql = [NSString stringWithFormat:@"%@ %@ LIKE \"%%%@%%\" OR", sql, tempColumn, [keys objectAtIndex:[columns_ indexOfObject:tempColumn]]];
    }
    sql = [sql stringByReplacingCharactersInRange:NSMakeRange([sql length] - 3, 3) withString:@""];
    
    FMResultSet *rs = [db executeQuery:sql];
    
//    NSLog(@"sql : %@", sql);
    
    NSInteger countOfDB = (long)[columns count];
    NSMutableArray *returnArray = [NSMutableArray array];
    
    while ([rs next]) {
        NSMutableDictionary *tempDB = [NSMutableDictionary dictionaryWithCapacity:countOfDB];
        for (int i = 0; i < countOfDB; i++) {
            NSString *tempKey = [columns objectAtIndex:i];
            NSString *tempValue = [rs stringForColumn:tempKey];
            [tempDB setValue:tempValue forKey:tempKey];
        }
        [returnArray addObject:tempDB];
    }
    [db close];
    
    return returnArray;
}

@end


@implementation ETPushNoAnimationSegue

-(void) perform{
//    NSViewController *vc = self.sourceViewController;
//    [vc.navigationController pushViewController:self.destinationViewController animated:NO];
}

@end
