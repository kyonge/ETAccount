//
//  ETAccountStatisticListViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 23..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountStatisticListViewController.h"

@interface ETAccountStatisticListViewController ()

@end

@implementation ETAccountStatisticListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initStatistics];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self loadStatisticsData];
    [self initStatistics];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ETAccountStatisticDetailSegue"]) {
        statisticDetailViewController = (ETAccountStatisticDetailViewController *)[segue destinationViewController];
    }
    else if ([[segue identifier] isEqualToString:@"ETAccountAddStatisticSegue"]) {
        [(ETAccountAddStatisticViewController *)[[(UINavigationController *)[segue destinationViewController] viewControllers] objectAtIndex:0] setAddStatisticDelegate:self];
    }
}


#pragma mark - 초기화

- (void)initStatistics
{
    //현재는 전체 로드 : 날짜순 조건 추가, 동적 로딩 추가
    
    NSString *querryString = @"SELECT Statistic.id, Statistic.name, Statistic.statistic_order FROM Statistic Statistic ORDER BY Statistic.statistic_order";
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"name", @"statistic_order", nil];
//    NSString *querryString = @"SELECT Deal.id, Deal.name, Deal.tag_target_id, Account_1.name account_1, Account_2.name account_2, money, description, Deal.date FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id ORDER BY datetime(Deal.Date) DESC";
//    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"name", @"tag_target_id", @"account_1", @"account_2", @"money", @"description", @"date", nil];
//    NSLog(@"%@", querryString);
    
    statisticArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
//    NSLog(@"%@", statisticArray);
    [self loadStatisticsData];
}

- (void)loadStatisticsData
{
    NSString *path = [ETUtility documentString:@"GraphData.plist"];
    NSMutableArray *graphSaveDataArray = [NSMutableArray arrayWithContentsOfFile:path];
    
//    tempGraphDataArray = [NSMutableArray array];
    
    for (NSMutableDictionary *statisticsDictionary in statisticArray) {
        NSInteger statisticsId = [[statisticsDictionary objectForKey:@"id"] integerValue];
        NSInteger statisticsTotal = 0;
        
        if ([ETUtility doesArray:graphSaveDataArray hasDictionaryWithId:statisticsId]) {
            NSString *statisticsIdString = [statisticsDictionary objectForKey:@"id"];
            NSDictionary *selectedDictionary = [ETUtility selectDictionaryWithValue:statisticsIdString OfKey:@"id" inArray:graphSaveDataArray];
            NSArray *selectedArray = [selectedDictionary objectForKey:@"selectedArray"];
            
            NSString *querryString = [NSString stringWithFormat:@"SELECT Statistic.id, Statistic.date_1, Statistic.date_2, Statistic.type, Statistic.is_favorite, Statistic.name, Statistic.statistic_order FROM Statistic Statistic WHERE Statistic.id=%@", statisticsIdString];
            NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"date_1", @"date_2", @"type", @"is_favorite", @"name", @"statistic_order", nil];
            NSDictionary *statisticDictionary = [[ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray] objectAtIndex:0];
            NSString *whereString = [ETAccountWhereMaker whereStringWithDictionary:statisticDictionary];
            NSArray *resultAccountArray = [NSArray arrayWithArray:[ETAccountStatisticsCalculator getResultOfAccounts:whereString Order:@"datetime(Deal.Date) DESC" List:nil]];
            
            for (NSString *tempId in selectedArray) {
                NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionaryWithDictionary:[ETUtility selectDictionaryWithValue:tempId OfKey:@"id" inArray:resultAccountArray]];
//                NSLog(@"tempDictionary : %@", tempDictionary);
                statisticsTotal += [[tempDictionary objectForKey:@"money"] integerValue];
            }
//            [[ETAccountGraphView sharedView] setGraphType:[[selectedDictionary objectForKey:@"graphTypeString"] integerValue]];
        }
        [statisticsDictionary setObject:[NSString stringWithFormat:@"%ld", (long)statisticsTotal] forKey:@"total"];
    }
    [statisticListTableView reloadData];
}


#pragma mark - 삭제

- (void)askDelete:(NSIndexPath *)indexPath TableView:(UITableView*)tableView
{
    UIAlertController *deleteAccountAlertControl = [UIAlertController
                                                    alertControllerWithTitle:@"통계 삭제"
                                                    message:@"통계 데이터를 삭제하시겠습니까?"
                                                    preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"삭제", @"Close action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self delete:indexPath TableView:tableView];
                               }];
    [deleteAccountAlertControl addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"취소", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [deleteAccountAlertControl addAction:cancelAction];
    
    [self presentViewController:deleteAccountAlertControl animated:YES completion:nil];
}

- (void)delete:(NSIndexPath *)indexPath TableView:(UITableView*)tableView
{
    NSDictionary *dealDictionary = [statisticArray objectAtIndex:indexPath.row];
//    NSLog(@"%@", dealDictionary);
    
    // Filter 검색
    NSString *querryString = [NSString stringWithFormat:@"SELECT Filter.id, Filter.type, Filter.item, Filter.compare, Statistics_filter_match.id match_id FROM Filter JOIN Statistics_filter_match ON Statistics_filter_match.filter_id = Filter.id WHERE statistic_id = %@", [dealDictionary objectForKey:@"id"]];
    NSArray *filterArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:[NSArray arrayWithObjects:@"id", @"type", @"item", @"compare", @"match_id", nil]];
    
    for (NSDictionary *tempFilterDictionary in filterArray) {
        if (![ETAccountDBManager deleteFromTable:@"Filter" OfId:[[tempFilterDictionary objectForKey:@"id"] integerValue]])
            [ETUtility showAlert:@"ETAccount" Message:@"Filter를 삭제하지 못했습니다." atViewController:self withBlank:NO];
        if (![ETAccountDBManager deleteFromTable:@"Statistics_filter_match" OfId:[[tempFilterDictionary objectForKey:@"id"] integerValue] Key:@"filter_id"])
            [ETUtility showAlert:@"ETAccount" Message:@"Filter_match를 삭제하지 못했습니다." atViewController:self withBlank:NO];
    }
    
    // Statistic에서 삭제
    NSInteger targetStatisticId = [[dealDictionary objectForKey:@"id"] integerValue];
    if (![ETAccountDBManager deleteFromTable:@"Statistic" OfId:targetStatisticId]) {
        [ETUtility showAlert:@"ETAccount" Message:@"삭제하지 못했습니다." atViewController:self withBlank:NO];
    }
    
    // GraphDatad에서 삭제
    NSString *path = [ETUtility documentString:@"GraphData.plist"];
    NSMutableArray *graphSaveDataArray = [NSMutableArray arrayWithContentsOfFile:path];

    if ([ETUtility doesArray:graphSaveDataArray hasDictionaryWithId:targetStatisticId]) {
        [graphSaveDataArray removeObject:[ETUtility selectDictionaryWithValue:[dealDictionary objectForKey:@"id"] OfKey:@"id" inArray:graphSaveDataArray]];
        [graphSaveDataArray writeToFile:path atomically:YES];
    }
    
    [statisticArray removeObject:dealDictionary];
    
    [tableView reloadData];
}


#pragma mark - 델리게이트 메서드

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [statisticArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (ETAccountStatisticListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StatisticListTableViewCellIdentifier";
    
    ETAccountStatisticListTableViewCell *cell = (ETAccountStatisticListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ETAccountStatisticListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ETAccountStatisticListTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempStatisticsDictionary = [statisticArray objectAtIndex:indexPath.row];
    [[(ETAccountStatisticListTableViewCell *)cell nameLabel] setText:[tempStatisticsDictionary objectForKey:@"name"]];
//    [[(ETAccountStatisticDetailTableViewCell *)cell moneyLabel] setText:[[statisticArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    NSInteger tempTotal = [[tempStatisticsDictionary objectForKey:@"total"] integerValue];
    if (tempTotal != 0)
        [[(ETAccountStatisticDetailTableViewCell *)cell moneyLabel] setText:[ETFormatter moneyFormatFromString:[tempStatisticsDictionary objectForKey:@"total"]]];
    else [[(ETAccountStatisticDetailTableViewCell *)cell moneyLabel] setText:@"-"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [statisticDetailViewController setStatisticDictionary:[statisticArray objectAtIndex:indexPath.row]];
    [statisticDetailViewController initStatistic];
    
    [tableView reloadData];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteTagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                               title:@"Delete"
                                                                             handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                 [tableView setEditing:NO animated:NO];
                                                                                 
                                                                                 [self askDelete:indexPath TableView:tableView];
                                                                             }];
    [deleteTagAction setBackgroundColor:[UIColor redColor]];
    
    [tableView setEditing:YES animated:NO];
    return [NSArray arrayWithObject:deleteTagAction];
}

#pragma mark ETAccountAddDealDelegate

- (void)didAddDeal
{
    [self initStatistics];
    [statisticListTableView reloadData];
}

@end
