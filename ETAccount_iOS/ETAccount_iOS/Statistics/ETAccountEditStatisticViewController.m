//
//  ETAccountEditStatisticViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 18..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountEditStatisticViewController.h"

@interface ETAccountEditStatisticViewController ()

@end

@implementation ETAccountEditStatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initStatisticName:(NSString *)name DateString:(NSString *)date EndDateString:(NSString *)end StatisticId:(NSInteger)initId
{
    dealNameString = name;
    dealDateString = date;
    endDateString = end;
    statisticId = initId;
    
    [statisticTableView reloadData];
}

- (void)writeToDB:(NSDictionary *)dataDic Table:(NSString *)tableName
{
    NSLog(@"%@", dataDic);
//    if (![ETAccountDBManager insertToTable:tableName dataDictionary:dataDic]) {
//        UIAlertController *errorAlertController = [ETUtility showAlert:@"ETAccount" Message:@"저장하지 못했습니다." atViewController:self withBlank:YES];
//        UIAlertAction *cancelAction = [UIAlertAction
//                                       actionWithTitle:NSLocalizedString(@"확인", @"Cancel action")
//                                       style:UIAlertActionStyleCancel
//                                       handler:nil];
//        [errorAlertController addAction:cancelAction];
//    }
//    
//    NSString *querryString = @"SELECT id FROM Statistic ORDER BY id DESC LIMIT 1";
//    NSArray *resultArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:[NSArray arrayWithObject:@"id"]];
//    NSInteger insertedId = [[[resultArray objectAtIndex:0] objectForKey:@"id"] integerValue];
//    
//    // 필터
//    NSInteger statistic_id;
//    statistic_id = insertedId;
//    
//    if (statistic_id == -1)
//        return;
//    else {
//        if (![self saveFiltersWithTargetId:statistic_id]) {
//            [ETUtility showAlert:@"ETAccount" Message:@"필터를 저장하지 못했습니다." atViewController:self withBlank:NO];
//            return;
//        }
//        
//        [addStatisticDelegate didAddDeal];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}

@end
