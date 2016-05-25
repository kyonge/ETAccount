//
//  ETAccountStatisticDetailViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 24..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountStatisticDetailViewController.h"

@interface ETAccountStatisticDetailViewController ()

@end

@implementation ETAccountStatisticDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!tempGraphDataArray)
        tempGraphDataArray = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [statisticTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[ETAccountGraphView sharedView] closeInnerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ETAccountEditStatisticSegue"]) {
        ETAccountEditStatisticViewController *editStatisticViewController = (ETAccountEditStatisticViewController *)[[(UINavigationController *)[segue destinationViewController] viewControllers] objectAtIndex:0];
        [editStatisticViewController setAddStatisticDelegate:self];
        [editStatisticViewController initStatisticName:[statisticDictionary objectForKey:@"name"]
                                            DateString:[statisticDictionary objectForKey:@"date_1"]
                                         EndDateString:[statisticDictionary objectForKey:@"date_2"]
                                           StatisticId:[[statisticDictionary objectForKey:@"id"] integerValue]];
    }
    else if ([[segue identifier] isEqualToString:@"ETAccountGraphOptionSegue"]) {
        ETAccountGraphOptionViewController *optionViewController = (ETAccountGraphOptionViewController *)[segue destinationViewController];
        [optionViewController setGraphOptionDelegate:self];
    }
    else if ([[segue identifier] isEqualToString:@"ETAccountDetailStatisticItemSegue"]) {
        NSDictionary *selectedDeal = [resultArray objectAtIndex:selectedRow];
        
        NSString *tempDateString = [selectedDeal objectForKey:@"date"];
//        NSString *finalDateString = [ETFormatter dateColumnFormat:tempDateString];
        
        NSString *querryString_1 = [NSString stringWithFormat:@"SELECT Account.id FROM Account WHERE Account.name = '%@'", [selectedDeal objectForKey:@"account_1"]];
        NSArray *columnArray = [NSArray arrayWithObject:@"id"];
        NSArray *account_1_id = [ETUtility selectDataWithQuerry:querryString_1 FromFile:_DB WithColumn:columnArray];
        NSString *querryString_2 = [NSString stringWithFormat:@"SELECT Account.id FROM Account WHERE Account.name = '%@'", [selectedDeal objectForKey:@"account_2"]];
        NSArray *account_2_id = [ETUtility selectDataWithQuerry:querryString_2 FromFile:_DB WithColumn:columnArray];
        
        [(ETAccountDealDetailViewController *)[segue destinationViewController] setAddDealDelegate:self];
        [(ETAccountDealDetailViewController *)[segue destinationViewController] initDealDetailWithDate:tempDateString
                                                                                                  Name:[selectedDeal objectForKey:@"name"]
                                                                                                 Money:[selectedDeal objectForKey:@"money"]
                                                                                                  Left:[[[account_1_id objectAtIndex:0] objectForKey:@"id"] integerValue]
                                                                                                 Right:[[[account_2_id objectAtIndex:0] objectForKey:@"id"] integerValue]
                                                                                           Description:[selectedDeal objectForKey:@"description"]
                                                                                             tagTarget:[[selectedDeal objectForKey:@"tag_target_id"] integerValue]
                                                                                                    Id:[[selectedDeal objectForKey:@"id"] integerValue]];
    }
}

- (void)setStatisticDictionary:(NSDictionary *)inputDictionary
{
    statisticDictionary = [NSDictionary dictionaryWithDictionary:inputDictionary];
}


#pragma mark - 통계

- (void)initStatistic
{
    // 통계 기본 데이터
    NSString *querryString = [NSString stringWithFormat:@"SELECT Statistic.id, Statistic.date_1, Statistic.date_2, Statistic.type, Statistic.is_favorite, Statistic.name, Statistic.statistic_order FROM Statistic Statistic WHERE Statistic.id=%@", [statisticDictionary objectForKey:@"id"]];
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"date_1", @"date_2", @"type", @"is_favorite", @"name", @"statistic_order", nil];
    
    statisticDictionary = [[ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray] objectAtIndex:0];
//    NSLog(@"staticDictionary : %@", statisticDictionary);
    
    // 조건
    whereString = [ETAccountWhereMaker whereStringWithDictionary:statisticDictionary];
    NSString *whereStringTillFrom;
    
    querryString = @"SELECT Deal.id, Deal.name, Deal.tag_target_id, Account_1.name account_1, Account_1.color_r account_1_r, Account_1.color_g account_1_g, Account_1.color_b account_1_b, Account_1.tag_target_id tag_target_id_1, Account_2.name account_2, Account_2.color_r account_2_r, Account_2.color_g account_2_g, Account_2.color_b account_2_b,Account_2.tag_target_id tag_target_id_2, money, description, Deal.date FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id ";
    NSString *querryStringTillFrom;
    
    if (![[statisticDictionary objectForKey:@"date_1"] isEqualToString:@"~"]) {
        NSMutableDictionary *statisticDictionaryTillFrom = [statisticDictionary mutableCopy];
        NSString *originalDate_1String = [statisticDictionary objectForKey:@"date_1"];
        
//        NSLog(@"date_1 : %@", [statisticDictionary objectForKey:@"date_1"]);
//        NSLog(@"date_1 + one day : %@", [ETFormatter dateStringAddedOneDay:originalDate_1String]);
        
        [statisticDictionaryTillFrom setValue:@"~" forKey:@"date_1"];
//        [statisticDictionaryTillFrom setValue:[ETFormatter dateStringAddedOneDay:originalDate_1String] forKey:@"date_2"];
        [statisticDictionaryTillFrom setValue:originalDate_1String forKey:@"date_2"];
        
        whereStringTillFrom = [ETAccountWhereMaker whereStringWithDictionary:statisticDictionaryTillFrom];
        querryStringTillFrom = [NSString stringWithFormat:@"%@ %@",querryString, whereStringTillFrom];
    }
    
    querryString = [NSString stringWithFormat:@"%@ %@",querryString, whereString];
    
    // ORDER BY
    querryString = [NSString stringWithFormat:@"%@ ORDER BY datetime(Deal.Date) DESC", querryString];
    if (querryStringTillFrom)
        querryStringTillFrom = [NSString stringWithFormat:@"%@ ORDER BY datetime(Deal.Date) DESC", querryStringTillFrom];
//    NSLog(@"querryString : %@", querryString);
    
    // Deal SELECT
    columnArray = [NSArray arrayWithObjects:
                   @"id", @"name", @"tag_target_id",
                   @"account_1", @"account_1_r", @"account_1_g", @"account_1_b", @"tag_target_id_1",
                   @"account_2", @"account_2_r", @"account_2_g", @"account_2_b", @"tag_target_id_2",
                   @"money", @"description", @"date", nil];
    resultArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
    NSMutableArray *resultArrayTillFrom;
    if (querryStringTillFrom)
        resultArrayTillFrom = [ETUtility selectDataWithQuerry:querryStringTillFrom FromFile:_DB WithColumn:columnArray];
    
    tempGraphDataListDictionary = [NSMutableDictionary dictionary];
    tempGraphDataListDictionaryTillFrom = [NSMutableDictionary dictionary];
//    NSLog(@"%@", resultArray);
    
    resultAccountArray = [NSArray arrayWithArray:[ETAccountStatisticsCalculator getResultOfAccounts:whereString Order:@"datetime(Deal.Date) DESC" List:tempGraphDataListDictionary]];
    if (resultArrayTillFrom)
        resultAccountArrayTillFrom = [NSArray arrayWithArray:[ETAccountStatisticsCalculator getResultOfAccounts:whereStringTillFrom Order:@"datetime(Deal.Date) DESC" List:tempGraphDataListDictionaryTillFrom]];
//    NSLog(@"whereString : %@", whereString);
//    NSLog(@"whereStringTillFrom : %@", whereStringTillFrom);
//    NSLog(@"tempGraphDataListDictionaryTillFrom : %@", tempGraphDataListDictionaryTillFrom);
    
    resultTagArray = [NSArray arrayWithArray:[self getResultOfTags]];
//    NSLog(@"tempGraphDataListDictionary : %@", tempGraphDataListDictionary);
    
    [statisticTableView reloadData];
    
    [self loadGraphData];
//    NSLog(@"%@", tempGraphDataArray);
}

- (NSMutableArray *)getResultOfTags
{
    NSMutableArray *tempPreResultArray = [NSMutableArray array];
    
    NSString *querryString = @"SELECT Deal.id, Deal.tag_target_id, Deal.tag_target_id, Account_1.tag_target_id tag_target_id_1, Account_2.tag_target_id tag_target_id_2, money FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id JOIN Tag_match Tag_match ON Deal.tag_target_id = Tag_match.tag_target_id";
    [self getPreTagsDataWithQuerry:querryString To:tempPreResultArray];
    
    querryString = @"SELECT Deal.id, Deal.tag_target_id, Deal.tag_target_id, Account_1.tag_target_id tag_target_id_1, Account_2.tag_target_id tag_target_id_2, money FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id JOIN Tag_match Tag_match ON Account_1.tag_target_id = Tag_match.tag_target_id";
    [self getPreTagsDataWithQuerry:querryString To:tempPreResultArray];
    
    querryString = @"SELECT Deal.id, Deal.tag_target_id, Deal.tag_target_id, Account_1.tag_target_id tag_target_id_1, Account_2.tag_target_id tag_target_id_2, money FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id JOIN Tag_match Tag_match ON Account_2.tag_target_id = Tag_match.tag_target_id";
    [self getPreTagsDataWithQuerry:querryString To:tempPreResultArray];
//    NSLog(@"%@", tempPreResultArray);
    
//    querryString = @"SELECT * FROM Tag_match";
//    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"tag_target_id", @"tag_id", nil];
//    NSArray *resultDataArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
//    NSLog(@"%@", resultDataArray);
    
    NSMutableArray *tempResultArray = [NSMutableArray array];

    for (NSDictionary *tempDataDictionary in tempPreResultArray)
    {
        NSInteger dealId = [[tempDataDictionary objectForKey:@"id"] integerValue];
        NSInteger tempId = [[tempDataDictionary objectForKey:@"tag_target_id"] integerValue];
        NSInteger tempTagId = [[ETAccountDBManager getItem:@"tag_id" OfId:tempId Key:@"tag_target_id" FromTable:@"Tag_match"] integerValue];
        NSString *tempTag = [ETAccountDBManager getItem:@"name" OfId:tempTagId FromTable:@"Tag"];
        NSInteger tempId_1 = [[tempDataDictionary objectForKey:@"tag_target_id_1"] integerValue];
        NSInteger tempTagId_1 = [[ETAccountDBManager getItem:@"tag_id" OfId:tempId_1 Key:@"tag_target_id_1" FromTable:@"Tag_match"] integerValue];
        NSString *tempTag_1 = [ETAccountDBManager getItem:@"name" OfId:tempTagId_1 FromTable:@"Tag"];
        NSInteger tempId_2 = [[tempDataDictionary objectForKey:@"tag_target_id_2"] integerValue];
        NSInteger tempTagId_2 = [[ETAccountDBManager getItem:@"tag_id" OfId:tempId_2 Key:@"tag_target_id_2" FromTable:@"Tag_match"] integerValue];
        NSString *tempTag_2 = [ETAccountDBManager getItem:@"name" OfId:tempTagId_2 FromTable:@"Tag"];
        NSInteger tempMoney = [[tempDataDictionary objectForKey:@"money"] integerValue];
        NSString *tempDate = [tempDataDictionary objectForKey:@"date"];

        if (tempTagId > 0) [ETAccountStatisticsCalculator addMoneyWithDealId:dealId Id:tempTagId Name:tempTag Color:nil Money:tempMoney Date:tempDate To:tempResultArray List:nil Is1:YES];
        if (tempTagId_1 > 0) [ETAccountStatisticsCalculator addMoneyWithDealId:dealId Id:tempTagId_1 Name:tempTag_1 Color:nil Money:tempMoney Date:tempDate To:tempResultArray List:nil Is1:YES];
        if (tempTagId_2 > 0) [ETAccountStatisticsCalculator addMoneyWithDealId:dealId Id:tempTagId_2 Name:tempTag_2 Color:nil Money:tempMoney Date:tempDate To:tempResultArray List:nil Is1:NO];
    }
    
//    NSLog(@"%@", tempResultArray);
    return tempResultArray;
}

- (void)getPreTagsDataWithQuerry:(NSString *)querryString To:(NSMutableArray *)tempPreResultArray
{
    querryString = [NSString stringWithFormat:@"%@ %@",querryString, whereString];
    
    // ORDER BY
    querryString = [NSString stringWithFormat:@"%@ ORDER BY datetime(Deal.Date) DESC", querryString];
//    NSLog(@"querryString : %@", querryString);
    
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"tag_target_id", @"tag_target_id_1", @"tag_target_id_2", @"money", nil];
    NSArray *resultDataArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
//    NSLog(@"%@", resultDataArray);
    
    for (NSDictionary *tempDataDictionary in resultDataArray)
    {
        NSInteger tempId = [[tempDataDictionary objectForKey:@"id"] integerValue];
        if (![ETUtility doesArray:tempPreResultArray hasDictionaryWithId:tempId])
            [tempPreResultArray addObject:tempDataDictionary];
    }
}


#pragma mark - 그래프

- (void)saveGraphData
{
    NSString *path = [ETUtility documentString:@"GraphData.plist"];
    NSMutableArray *graphSaveDataArray = [NSMutableArray arrayWithContentsOfFile:path];
    if (!graphSaveDataArray)
        graphSaveDataArray = [NSMutableArray array];
    
    NSMutableArray *tempGraphIdDataArray = [NSMutableArray array];
    for (NSDictionary *tempDataDictionary in tempGraphDataArray) {
        if ([[tempDataDictionary allKeys] containsObject:@"id"])
            [tempGraphIdDataArray addObject:[tempDataDictionary objectForKey:@"id"]];
    }
    
    NSMutableDictionary *selectedDictionary;
    NSString *statisticsId = [statisticDictionary objectForKey:@"id"];
    NSString *graphTypeString = [NSString stringWithFormat:@"%ld", (long)[[ETAccountGraphView sharedView] graphType]];
    NSString *graphKindString = [NSString stringWithFormat:@"%ld", (long)[[ETAccountGraphView sharedView] graphKind]];
    
    if ([ETUtility doesArray:graphSaveDataArray hasDictionaryWithId:[statisticsId integerValue]]) {
        selectedDictionary = [NSMutableDictionary dictionaryWithDictionary:[ETUtility selectDictionaryWithValue:statisticsId OfKey:@"id" inArray:graphSaveDataArray]];
        NSInteger selectedIndex = [graphSaveDataArray indexOfObject:selectedDictionary];
        [selectedDictionary setObject:tempGraphIdDataArray forKey:@"selectedArray"];
        [selectedDictionary setObject:graphTypeString forKey:@"type"];
        [selectedDictionary setObject:graphKindString forKey:@"kind"];
        [graphSaveDataArray replaceObjectAtIndex:selectedIndex withObject:selectedDictionary];
    }
    else {
        selectedDictionary = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:statisticsId, graphTypeString, graphKindString, tempGraphIdDataArray, nil]
                                                                forKeys:[NSArray arrayWithObjects:@"id", @"type", @"kind", @"selectedArray", nil]];
        [graphSaveDataArray addObject:selectedDictionary];
    }
    [graphSaveDataArray writeToFile:path atomically:YES];
}

- (void)loadGraphData
{
    NSString *path = [ETUtility documentString:@"GraphData.plist"];
    NSMutableArray *graphSaveDataArray = [NSMutableArray arrayWithContentsOfFile:path];
    
    tempGraphDataArray = [NSMutableArray array];
    tempGraphDailyDataArray = [NSMutableArray array];
    tempGraphDailyDataArrayTillFrom = [NSMutableArray array];
    
    if ([ETUtility doesArray:graphSaveDataArray hasDictionaryWithId:[[statisticDictionary objectForKey:@"id"] integerValue]]) {
        NSString *statisticsId = [statisticDictionary objectForKey:@"id"];
        NSDictionary *selectedDictionary = [ETUtility selectDictionaryWithValue:statisticsId OfKey:@"id" inArray:graphSaveDataArray];
        NSArray *selectedArray = [selectedDictionary objectForKey:@"selectedArray"];
        
        [[ETAccountGraphView sharedView] setGraphType:[[selectedDictionary objectForKey:@"type"] integerValue]];
        [[ETAccountGraphView sharedView] setGraphKind:[[selectedDictionary objectForKey:@"kind"] integerValue]];
        
        for (NSString *tempId in selectedArray) {
            NSMutableDictionary *tempItemDictionary = [NSMutableDictionary dictionaryWithDictionary:[ETUtility selectDictionaryWithValue:tempId OfKey:@"id" inArray:resultAccountArray]];
            [tempGraphDataArray addObject:tempItemDictionary];
            
            if ([[ETAccountGraphView sharedView] graphType] == ETACCOUNT_GRAPH_TYPE_DAILY_FLOW) {
                NSMutableArray *tempItemArray = [tempGraphDataListDictionary objectForKey:tempId];
                tempItemArray = [[[tempItemArray reverseObjectEnumerator] allObjects] mutableCopy];
//                tempItemArray = [ETUtility reverseArrayWithMutableDictioanryObjects:tempItemArray];
                [tempGraphDailyDataArray addObject:tempItemArray];
                
                NSMutableArray *tempItemArrayTillFrom = [tempGraphDataListDictionaryTillFrom objectForKey:tempId];
//                NSLog(@"tempItemArrayTillFrom : %@", tempItemArrayTillFrom);
                tempItemArrayTillFrom = [[[tempItemArrayTillFrom reverseObjectEnumerator] allObjects] mutableCopy];
                if (!tempItemArrayTillFrom || [tempItemArrayTillFrom count] == 0)
                    [tempGraphDailyDataArrayTillFrom addObject:[NSArray array]];
                else
                    [tempGraphDailyDataArrayTillFrom addObject:tempItemArrayTillFrom];
            }
        }
    }
    
    [statisticTableView reloadData];
}

- (void)initGraphWithCell:(ETAccountGraphTableViewCell *)cell
{
    [[ETAccountGraphView sharedView] setBaseWithFrame:CGRectMake(0, 0, [[cell contentView] frame].size.width - 16, [[self view] frame].size.width - 16)];
    if ([[[cell graphView] subviews] count] == 0)
        [[cell graphView] addSubview:[ETAccountGraphView sharedView]];
    
    if ([tempGraphDataArray count] == 0) {
        [[ETAccountGraphView sharedView] closeInnerView];
        
        return;
    }
    
    if ([[ETAccountGraphView sharedView] graphType] == ETACCOUNT_GRAPH_TYPE_DAILY_FLOW) {
        NSString *firstDate, *lastDate;
        
        for (NSMutableArray *tempItemArray in tempGraphDailyDataArray) {
//            NSLog(@"tempItemArray : %@", tempItemArray);
            NSDate *tempFirstDate, *tempLastDate;
            if ([tempItemArray count] > 0 ) {
                tempFirstDate = [ETFormatter dateFromDateSting:[[tempItemArray objectAtIndex:0] objectForKey:@"date"]];
                tempLastDate = [ETFormatter dateFromDateSting:[[tempItemArray lastObject] objectForKey:@"date"]];
                
                if (!firstDate || (firstDate && [ETFormatter dateFromDateSting:firstDate] > tempFirstDate))
                    firstDate = [ETFormatter dateStringForDeal:tempFirstDate];
                if (!lastDate || (lastDate && [ETFormatter dateFromDateSting:lastDate] < tempLastDate))
                    lastDate = [ETFormatter dateStringForDeal:tempLastDate];
            }
        }
        
//        NSLog(@"%@ ~ %@", firstDate, lastDate);
        [[ETAccountGraphView sharedView] setFirstDate:firstDate];
        [[ETAccountGraphView sharedView] setLastDate:lastDate];
    }
    
//    switch ([[ETAccountGraphView sharedView] graphType]) {
////        case ETACCOUNT_GRAPH_TYPE_DEFAULT:
////            break;
//            
//        case ETACCOUNT_GRAPH_TYPE_EACH_TOTAL: {
//            NSLog(@"init Sum for Item InnerView");
//            
//            break;
//        }
//            
//        case ETACCOUNT_GRAPH_TYPE_DAILY_FLOW: {
//            NSLog(@"init List for Daily Flow");
//            NSLog(@"tempGraphDataArray : %@", tempGraphDataArray);
//            break;
//        }
//            
//        default:
//            break;
//    }
    
    [[ETAccountGraphView sharedView] setGlobalDataArray:tempGraphDataArray];
    [[ETAccountGraphView sharedView] setGlobalFullDateArray:tempGraphDailyDataArray];
    [[ETAccountGraphView sharedView] setGlobalFullDateArrayTillFrom:tempGraphDailyDataArrayTillFrom];
    
    [[ETAccountGraphView sharedView] initInnerView];
}


#pragma mark - 삭제

- (void)askDelete:(NSIndexPath *)indexPath TableView:(UITableView*)tableView
{
    UIAlertController *deleteAccountAlertControl = [UIAlertController
                                                    alertControllerWithTitle:@"거래 삭제"
                                                    message:@"거래를 삭제하시겠습니까?"
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
    NSDictionary *dealDictionary = [resultArray objectAtIndex:indexPath.row];
    
    // tag_target_id 삭제
    NSInteger targetTag = [[dealDictionary objectForKey:@"tag_target_id"] integerValue];
    [ETAccountDBManager deleteFromTable:@"Tag_target" OfId:targetTag];
    
    NSString *deleteMatchOfTargetQuerryString = [NSString stringWithFormat:@"DELETE FROM Tag_match WHERE tag_target_id = %ld", (long)targetTag];
    [ETUtility runQuerry:deleteMatchOfTargetQuerryString FromFile:_DB];
    
    // DB에서 삭제
    NSInteger targetAccountId = [[dealDictionary objectForKey:@"id"] integerValue];
    if (![ETAccountDBManager deleteFromTable:@"Deal" OfId:targetAccountId]) {
        [ETUtility showAlert:@"ETAccount" Message:@"삭제하지 못했습니다." atViewController:self withBlank:NO];
    }
    
    [self initStatistic];
    [tableView reloadData];
}


#pragma mark - 델리게이트 메서드

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Graph";
        case 1:
            return @"Result - Account";
        case 2:
            return @"Result - Tag";
        case 3:
            return @"Data";
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1)
        return [resultAccountArray count];
    else if (section == 2)
        return [resultTagArray count];
    else if (section == 3)
        return [resultArray count];
    else return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            return [[self view] frame].size.width;
        else return 60;
    }
    else if (indexPath.section == 3)
        return 60;
    else return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *CellIdentifier = @"ETAccountStatisticResultGraphTableViewCellIdentifier";
            
            ETAccountGraphTableViewCell *cell = (ETAccountGraphTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[ETAccountGraphTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            return cell;
        }
        else {
            NSString *CellIdentifier = @"GraphOptionCellIdentifier";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            return cell;
        }
    }
    else if (indexPath.section == 1 || indexPath.section == 2) {
        NSString *CellIdentifier = @"ETAccountStatisticResultSummaryTableViewCellIdentifier";
        
        ETAccountStatisticDetailTableViewCell *cell = (ETAccountStatisticDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        [cell setAddDealCellDelegate:self];
        if (cell == nil) {
            cell = [[ETAccountStatisticDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    else if (indexPath.section == 3) {
        static NSString *CellIdentifier = @"ETAccountStatisticResultDataListTableViewCellIdentifier";
        
        ETAccountTableViewCell *cell = (ETAccountTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ETAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"UITableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ETAccountTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self initGraphWithCell:(ETAccountGraphTableViewCell *)cell];
        }
    }
    else if (indexPath.section == 1) {
        NSString *selectedId = [[resultAccountArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        if ([ETUtility doesArray:tempGraphDataArray hasDictionaryWithId:[selectedId integerValue]])
            [cell setBackgroundColor:[UIColor lightGrayColor]];
        else [cell setBackgroundColor:[UIColor clearColor]];
        
        NSDictionary *tempAccountDictionary = [resultAccountArray objectAtIndex:indexPath.row];
        [cell setTag:[[tempAccountDictionary objectForKey:@"id"] integerValue]];
        [[(ETAccountStatisticDetailTableViewCell *)cell nameLabel] setText:[[resultAccountArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
        [[(ETAccountStatisticDetailTableViewCell *)cell moneyLabel] setText:[ETFormatter moneyFormatFromString:[[resultAccountArray objectAtIndex:indexPath.row] objectForKey:@"money"]]];
    }
    else if (indexPath.section == 2) {
        [[(ETAccountStatisticDetailTableViewCell *)cell nameLabel] setText:[[resultTagArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
        [[(ETAccountStatisticDetailTableViewCell *)cell moneyLabel] setText:[ETFormatter moneyFormatFromString:[[resultTagArray objectAtIndex:indexPath.row] objectForKey:@"money"]]];
    }
    else if (indexPath.section == 3) {
        NSDictionary *tempAccountDictionary = [resultArray objectAtIndex:indexPath.row];
        NSString *tempDateString = [tempAccountDictionary objectForKey:@"date"];
        NSString *finalDateString = [ETFormatter dateColumnFormat:tempDateString];
        
        [[cell accountDateLabel] setText:finalDateString];
        [[cell accountNameLabel] setText:[tempAccountDictionary objectForKey:@"name"]];
        [[cell accountIncomeLabel] setText:[tempAccountDictionary objectForKey:@"account_1"]];
        [[cell accountExpenseLabel] setText:[tempAccountDictionary objectForKey:@"account_2"]];
        [[cell accountPriceLabel] setText:[NSString stringWithFormat:@"%@", [ETFormatter moneyFormatFromString:[tempAccountDictionary objectForKey:@"money"]]]];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
        return NO;
    else if (indexPath.section == 3)
        selectedRow = indexPath.row;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 1) {
                
            }
//            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
//            [cell setTitle:@"날짜"];
            break;
        case 1: {
            // 전체
//            NSString *selectedId = [[resultAccountArray objectAtIndex:indexPath.row] objectForKey:@"id"];
//            if ([ETUtility doesArray:tempGraphDataArray hasDictionaryWithId:selectedId WithKey:@"account_id"]) {
//                [tempGraphDataArray removeObject:[ETUtility selectDictionaryWithValue:selectedId OfKey:@"account_id" inArray:tempGraphDataArray]];
//                [(ETAccountStatisticDetailTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] setIsTinted:NO];
//            }
//            else {
//                // 전체
//                NSString *localWhereString = [NSString stringWithFormat:@"WHERE Deal.account_id_1='%@' OR Deal.account_id_2='%@'", selectedId, selectedId];
//                NSArray *localSelectedArray = [NSArray arrayWithArray:[self getResultOfAccounts:localWhereString Order:@"datetime(Deal.Date) DESC"]];
//                NSArray *tempArrayWithMoney = [NSArray arrayWithArray:[self getResultOfAccounts:localWhereString Order:@"Money DESC"]];
//                UIColor *tempColor = [UIColor colorWithRed:arc4random() % 255 / 255.0
//                                                     green:arc4random() % 255 / 255.0
//                                                      blue:arc4random() % 255 / 255.0 alpha:1.0];
//                
//                NSDictionary *tempDataDictionary = [NSDictionary dictionaryWithObjects:[NSArray  arrayWithObjects:selectedId, localSelectedArray, tempColor,
//                                                                                        [[localSelectedArray objectAtIndex:0] objectForKey:@"date"],
//                                                                                        [[localSelectedArray lastObject] objectForKey:@"date"],
////                                                                                        [[[[localSelectedArray objectAtIndex:0] objectForKey:@"date"] componentsSeparatedByString:@" "] objectAtIndex:0],
////                                                                                        [[[[localSelectedArray lastObject] objectForKey:@"date"] componentsSeparatedByString:@" "] objectAtIndex:0],
//                                                                                        [[tempArrayWithMoney objectAtIndex:0] objectForKey:@"money"], [[tempArrayWithMoney objectAtIndex:0] objectForKey:@"money"], nil]
//                                                                               forKeys:[NSArray  arrayWithObjects:@"account_id", @"dataArray", @"color",
//                                                                                        @"latest", @"earliest", @"biggest", @"smallest", nil]];
//                [tempGraphDataArray addObject:tempDataDictionary];
//            }
            
            // 합
            NSString *selectedId = [NSString stringWithFormat:@"%ld", (long)[[tableView cellForRowAtIndexPath:indexPath] tag]];
            
            if ([ETUtility doesArray:tempGraphDataArray hasDictionaryWithId:selectedId WithKey:@"id"]) {
                [tempGraphDataArray removeObject:[ETUtility selectDictionaryWithValue:selectedId OfKey:@"id" inArray:tempGraphDataArray]];
            } else {
                // 합
                NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionaryWithDictionary:[ETUtility selectDictionaryWithValue:selectedId OfKey:@"id" inArray:resultAccountArray]];
//                CGFloat red = arc4random() % 255 / 255.0, green = arc4random() % 255 / 255.0, blue = arc4random() % 255 / 255.0;
//                UIColor *tempColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
////                [tempDictionary setObject:[NSString stringWithFormat:@"%f %f %f", red, green, blue] forKey:@"color"];
//                [tempDictionary setObject:tempColor forKey:@"color"];
                [tempGraphDataArray addObject:tempDictionary];
            }
//            [[graphCell graphViewController] refreshGraph];
            
            [self saveGraphData];
            
            break;
            
//            switch ([[ETAccountGraphView sharedView] graphType]) {
//                case ETACCOUNT_GRAPH_TYPE_EACH_TOTAL: {
//                    
//                }
//                    
//                case ETACCOUNT_GRAPH_TYPE_DAILY_FLOW: {
//                    
//                    break;
//                }
//                    
//                default:
//                    break;
//            }
            
            break;
        }
    }
    
    [tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 3)
        return NO;
    
    return YES;
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
    [self initStatistic];
}

#pragma mark ETAccountGraphOptionDelegate

- (void)didTypeChanged:(ETACCOUNT_GRAPH_TYPE)type
{
    [[ETAccountGraphView sharedView] setGraphType:type];
    [self saveGraphData];
    
    [statisticTableView reloadData];
}

- (void)didKindChanged:(ETACCOUNT_GRAPH_KIND)kind
{
    [[ETAccountGraphView sharedView] setGraphKind:kind];
    [self saveGraphData];
    
    [statisticTableView reloadData];
}

@end
