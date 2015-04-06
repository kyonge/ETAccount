//
//  PODataManager.h
//  PopOp
//
//  Created by 기용 이 on 2015. 3. 11..
//  Copyright (c) 2015년 Opinion8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface PODataManager : NSObject {
    VENUE_TYPE selectedVenutType;
    
    NSInteger maximumCount;
    
    double lastLatitude, lastLongitude;
}

+ (PODataManager *)sharedInfo;

@property (readwrite) VENUE_TYPE selectedVenutType;
@property (readwrite) NSInteger maximumCount;
@property (readwrite) double lastLatitude, lastLongitude;
//@property (readwrite) NSMutableArray *restaurantArray, *dessertArray, *pubArray, *attractionArray;
//@property (readwrite) NSInteger restaurantRank, dessertRank, pubRank, attractionRank;

@end
