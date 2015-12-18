//
//  ETAccountEditStatisticViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 18..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountAddStatisticViewController.h"

@interface ETAccountEditStatisticViewController : ETAccountAddStatisticViewController{
    NSInteger statisticId;
}

- (void)initStatisticName:(NSString *)name DateString:(NSString *)date EndDateString:(NSString *)end StatisticId:(NSInteger)initId;

@end
