//
//  Constants.h
//  PopOp
//
//  Created by 기용 이 on 2015. 1. 21..
//  Copyright (c) 2015년 Opinion8. All rights reserved.
//

#ifndef PopOp_Constants_h
#define PopOp_Constants_h

#define TEST_FOR_DEV if (NO)

#define _DB @"ETAccount.sqlite"

//#define URL_POPOP_PRE @"http://54.183.205.145/v1"
//#define URL_POPOP_PRE @"http://ec2-54-183-94-75.us-west-1.compute.amazonaws.com"
#define URL_POPOP_PRE @"http://solrcloud0-320055289.us-west-1.elb.amazonaws.com"
#define URL_GEO_CODING_PRE @"http://maps.googleapis.com/maps/api/geocode"

#define INIT_ALL_SHOW_COUNT 5
#define INIT_ITEM_LOAD_COUNT 9

#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size.height
#define DEVICE_SIZE [[[[UIApplication sharedApplication] keyWindow] rootViewController].view convertRect:[[UIScreen mainScreen] bounds] fromView:nil].size

typedef enum : NSUInteger {
    API_HOME,
} API_TYPE;

typedef enum : NSUInteger {
    API_LOCATION,
    API_LATLNG
} GEO_CODING_API_TYPE;

typedef enum : NSUInteger {
    VENUE_DEFAULT = 0,
    VENUE_RESTAURANT = 100,
    VENUE_DESSERT_AND_CAFE = 200,
    VENUE_PUB_AND_BAR = 300,
    VENUE_ATTRACTION = 400,
} VENUE_TYPE;

typedef enum : NSUInteger {
    SCREEN_HEIGHT_IPHONE6Plus = 736,
    SCREEN_HEIGHT_IPHONE6 = 667,
    SCREEN_HEIGHT_IPHONE5 = 568,
    SCREEN_HEIGHT_IPHONE4 = 480,
} DEVICE_SCREEN_SIZE;

typedef enum : NSUInteger {
    ADD_DEAL_CELL_TYPE_BUTTON = 100,
    ADD_DEAL_CELL_TYPE_TEXT = 200,
    ADD_DEAL_CELL_TYPE_NUMBERS = 300
} ADD_DEAL_CELL_TYPE;

typedef enum : NSUInteger {
    NUMBER_PLUS = 100,
    NUMBER_MINUS = 200
};

#endif
