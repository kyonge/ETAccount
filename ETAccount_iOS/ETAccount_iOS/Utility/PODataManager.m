//
//  PODataManager.m
//  PopOp
//
//  Created by 기용 이 on 2015. 3. 11..
//  Copyright (c) 2015년 Opinion8. All rights reserved.
//

#import "PODataManager.h"

@implementation PODataManager

@synthesize selectedVenutType;
@synthesize maximumCount;
@synthesize lastLatitude, lastLongitude;
//@synthesize restaurantArray, dessertArray, pubArray, attractionArray;
//@synthesize restaurantRank, dessertRank, pubRank, attractionRank;

static PODataManager *sharedInfo = nil;

+ (PODataManager *)sharedInfo
{
    if (!sharedInfo) {
        sharedInfo = [[self alloc] init];
        
        [sharedInfo setSelectedVenutType:VENUE_DEFAULT];
        
//        [sharedInfo setRestaurantArray:[NSMutableArray array]];
//        [sharedInfo setDessertArray:[NSMutableArray array]];
//        [sharedInfo setPubArray:[NSMutableArray array]];
//        [sharedInfo setAttractionArray:[NSMutableArray array]];
    }
    
    return sharedInfo;
}

@end
