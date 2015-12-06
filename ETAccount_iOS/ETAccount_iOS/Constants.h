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
    ADD_DEAL_CELL_TYPE_DEFAULT = 0,
    ADD_DEAL_CELL_TYPE_BUTTON = 100,
    ADD_DEAL_CELL_TYPE_TEXT = 200,
    ADD_DEAL_CELL_TYPE_NUMBERS = 300,
    ADD_DEAL_CELL_TYPE_TEXT_WITH_ACC_BUTTON = 400
} ADD_DEAL_CELL_TYPE;

typedef enum : NSUInteger {
    NUMBER_SIGN_PLUS = 100,
    NUMBER_SIGN_MINUS = 200
} NUMBER_SIGN;

typedef enum : NSUInteger {
    ACCOUNT_DIRECTION_LEFT = 100,
    ACCOUNT_DIRECTION_RIGHT = 200
} ACCOUNT_DIRECTION;

typedef enum : NSUInteger {
    STATISTIC_TYPE_DELTA = 100,
    STATISTIC_TYPE_RESULT = 200
} STATISTIC_TYPE;

typedef enum : NSUInteger {
    FILTER_TYPE_ITEM = 100,
    FILTER_TYPE_TAG = 200,
    FILTER_TYPE_PRICE = 300
} FILTER_TYPE;

typedef enum : NSUInteger {
    FILTER_COMPARE_DEFAULT = 0,
    FILTER_COMPARE_SAME = 100,
    FILTER_COMPARE_CONTAIN = 150,
    FILTER_COMPARE_LEFT = 200,
    FILTER_COMPARE_SAME_LEFT = 250,
    FILTER_COMPARE_RIGHT = 300,
    FILTER_COMPARE_SAME_RIGHT = 350
} FILTER_COMPARE;

typedef enum : NSUInteger {
    FILTER_DETAIL_TYPE = 0,
    FILTER_DETAIL_ACCOUNT = 100,
    FILTER_DETAIL_TAG = 200,
    FILTER_DETAIL_PRICE = 300
} FILTER_DETAIL;

#endif
