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
    
//    [fileManager removeItemAtPath:sourceFilePath error:nil];
    
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

+ (UIImage *)loadImage:(NSString *)imageName
{
    NSString *fileName = [imageName stringByDeletingPathExtension];
    NSString *fileExtension = [imageName pathExtension];
    UIImage *tempImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension]];
    if (tempImage) return tempImage;
    
    NSString *documentPath = [ETUtility documentString:imageName];
    UIImage *loadedImage;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:documentPath];
    
    if (exist) loadedImage = [UIImage imageWithContentsOfFile:documentPath];
    else loadedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imageName stringByDeletingPathExtension] ofType:[imageName pathExtension]]];
    
    return loadedImage;
}

+ (UIImage *)loadImageFromTempDocuments:(NSString *)imageName
{
    NSString *fileName = [imageName stringByDeletingPathExtension];
    NSString *fileExtension = [imageName pathExtension];
    UIImage *tempImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension]];
    
    if (tempImage) return tempImage;
    
    NSString *documentPath = [ETUtility tempDocumentString:imageName];
    UIImage *loadedImage;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:documentPath];
    
    
    if (exist) loadedImage = [UIImage imageWithContentsOfFile:documentPath];
    else {
        loadedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imageName stringByDeletingPathExtension] ofType:[imageName pathExtension]]];
    }
    return loadedImage;
}

+ (UIImage *)loadImageFileFromDocumentCache:(NSString *)fileName
{
    NSString *savedName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    BOOL hasCacheFile = [[NSFileManager defaultManager] fileExistsAtPath:[ETUtility documentString:savedName]];
    if (hasCacheFile) {
        return [ETUtility loadImage:savedName];
    }
    else {
        NSData *tempData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileName]];
        UIImage *tempImage = [UIImage imageWithData:tempData];
        
//        NSData *imageData = UIImagePNGRepresentation(tempImage);
        NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.5);
        [imageData writeToFile:[ETUtility documentString:savedName] atomically:YES];
        
        return tempImage;
    }
}

+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

+ (void)loadAndSetImageToImageView:(UIImageView *)targetImageView FromDocumentCacheAsynchronized:(NSString *)fileName
{
    NSString *savedName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    BOOL hasCacheFile = [[NSFileManager defaultManager] fileExistsAtPath:[ETUtility documentString:savedName]];
    if (hasCacheFile) {
        [targetImageView setImage:[ETUtility loadImage:savedName]];
    }
    else {
        [ETUtility downloadImageWithURL:[NSURL URLWithString:fileName] completionBlock:^(BOOL succeeded, UIImage *downloadedImage) {
            if (succeeded) {
                NSData *imageData = UIImageJPEGRepresentation(downloadedImage, 0.5);
                [imageData writeToFile:[ETUtility documentString:savedName] atomically:YES];
                
                [targetImageView setImage:downloadedImage];
            }
        }];
    }
}


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

+ (BOOL)hasArray:(NSArray *)targetArray hasDictionaryWithId:(NSInteger)targetId
{
    for (NSDictionary *tempDictionary in targetArray) {
        if ([[tempDictionary objectForKey:@"id"] integerValue] == targetId)
            return YES;
    }
    
    return NO;
}


#pragma mark - Alert

// iOS8.0 이후 Alert 처리
+ (UIAlertController *)showAlert:(NSString *)titleString Message:(NSString *)messageString atViewController:(UIViewController *)viewController withBlank:(BOOL)blank
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:titleString
                                          message:messageString
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    if (!blank) {
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:nil];
        [alertController addAction:okAction];
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    return alertController;
}\


#pragma mark - UIViewAnimation

// UIViewAnimation
+ (void)AnimationView:(UIView *)view toFrame:(CGRect)frame toAlpha:(float)alpha inTime:(float)time toTarget:(id)target WithSelector:(SEL)selector
{
    [UIView animateWithDuration:time animations:^{
        [view setFrame:frame];
        [view setAlpha:alpha];
    } completion:^(BOOL finished) {
        if (selector)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
    }];
}


#pragma mark - FMDatabase : SQLite

+ (BOOL)runQuerry:(NSString *)querryString FromFile:(NSString *)sqliteFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:sqliteFileName];
    FMDatabase *db = [FMDatabase databaseWithPath:documentPath];
    [db open];
    
    BOOL excuted = [db executeUpdate:querryString];
    [db close];
    
    return excuted;
}

+ (NSMutableArray *)selectDataWithQuerry:(NSString *)querryString FromFile:(NSString *)sqliteFileName WithColumn:(NSArray *)columns
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:sqliteFileName];
    FMDatabase *db = [FMDatabase databaseWithPath:documentPath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:querryString];
    
    NSInteger countOfColumn = [columns count];
    NSMutableArray *returnArray = [NSMutableArray array];
    
    while ([rs next]) {
        NSMutableDictionary *tempDB = [NSMutableDictionary dictionary];
        for (int i = 0; i < countOfColumn; i++) {
            NSString *tempKey = [columns objectAtIndex:i];
            NSString *tempValue = [rs stringForColumn:tempKey];
//            NSLog(@"%@", tempValue);
            [tempDB setValue:tempValue forKey:tempKey];
        }
        [returnArray addObject:tempDB];
    }
    [db close];
    
    return returnArray;
}

// sqlite (ALL)
+ (NSMutableArray *)selectAllSQliteDatasFromFile:(NSString *)sqliteFileName Table:(NSString *)tableName WithColumn:(NSArray *)columns
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:sqliteFileName];
    FMDatabase *db = [FMDatabase databaseWithPath:documentPath];
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    
    FMResultSet *rs = [db executeQuery:sql];
    
//    NSLog(@"sql : %@", sql);
    
    NSInteger countOfColumn = [columns count];
    NSMutableArray *returnArray = [NSMutableArray array];
    
    while ([rs next]) {
        NSMutableDictionary *tempDB = [NSMutableDictionary dictionary];
        for (int i = 0; i < countOfColumn; i++) {
            NSString *tempKey = [columns objectAtIndex:i];
            NSString *tempValue = [rs stringForColumn:tempKey];
            [tempDB setValue:tempValue forKey:tempKey];
        }
        [returnArray addObject:tempDB];
    }
    [db close];
    
    return returnArray;
}

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
    UIViewController *vc = self.sourceViewController;
    [vc.navigationController pushViewController:self.destinationViewController animated:NO];
}

@end
