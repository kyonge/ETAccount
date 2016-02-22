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
    querryString = @"SELECT Deal.id, Deal.name, Deal.tag_target_id, Account_1.name account_1, Account_1.tag_target_id tag_target_id_1, Account_2.name account_2, Account_2.tag_target_id tag_target_id_2, money, description, Deal.date FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id ";
    querryString = [NSString stringWithFormat:@"%@ %@",querryString, whereString];
    
    // ORDER BY
    querryString = [NSString stringWithFormat:@"%@ ORDER BY datetime(Deal.Date) DESC", querryString];
//    NSLog(@"querryString : %@", querryString);
    
    // Deal SELECT
    columnArray = [NSArray arrayWithObjects:@"id", @"name", @"tag_target_id", @"account_1", @"tag_target_id_1", @"account_2", @"tag_target_id_2", @"money", @"description", @"date", nil];
    resultArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
//    NSLog(@"%@", resultArray);
    
    resultAccountArray = [NSArray arrayWithArray:[self getResultOfAccount]];
    resultTagArray = [NSArray arrayWithArray:[self getResultOfTags]];
    
    [statisticTableView reloadData];
}

- (NSMutableArray *)getResultOfAccount
{
    NSString *querryString = @"SELECT Deal.id, Deal.tag_target_id, Account_1.id account_1, Account_1.name account_1_name, Account_1.tag_target_id tag_target_id_1, Account_2.id account_2, Account_2.name account_2_name, Account_2.tag_target_id tag_target_id_2, money FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id ";
    querryString = [NSString stringWithFormat:@"%@ %@",querryString, whereString];
    
    // ORDER BY
    querryString = [NSString stringWithFormat:@"%@ ORDER BY datetime(Deal.Date) DESC", querryString];
    
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"tag_target_id", @"account_1", @"account_1_name", @"tag_target_id_1", @"account_2", @"account_2_name", @"tag_target_id_2", @"money", nil];
    NSArray *resultDataArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
//    NSLog(@"%@", resultDataArray);
    
    NSMutableArray *tempResultArray = [NSMutableArray array];
    
    for (NSDictionary *tempDataDictionary in resultDataArray)
    {
        NSInteger tempId_1 = [[tempDataDictionary objectForKey:@"account_1"] integerValue];
        NSString *tempName_1 = [tempDataDictionary objectForKey:@"account_1_name"];
        NSInteger tempId_2 = [[tempDataDictionary objectForKey:@"account_2"] integerValue];
        NSString *tempName_2 = [tempDataDictionary objectForKey:@"account_2_name"];
        NSInteger tempMoney = [[tempDataDictionary objectForKey:@"money"] integerValue];
        
        [self addMoneyWithId:tempId_1 Name:tempName_1 Money:tempMoney To:tempResultArray Is1:YES];
        [self addMoneyWithId:tempId_2 Name:tempName_2 Money:tempMoney To:tempResultArray Is1:NO];
    }
    
//    NSLog(@"%@", tempResultArray);
    return tempResultArray;
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

        if (tempTagId > 0) [self addMoneyWithId:tempTagId Name:tempTag Money:tempMoney To:tempResultArray Is1:YES];
        if (tempTagId_1 > 0) [self addMoneyWithId:tempTagId_1 Name:tempTag_1 Money:tempMoney To:tempResultArray Is1:YES];
        if (tempTagId_2 > 0) [self addMoneyWithId:tempTagId_2 Name:tempTag_2 Money:tempMoney To:tempResultArray Is1:NO];
    }
    
//    NSLog(@"%@", tempResultArray);
    return tempResultArray;
}

- (void)getPreTagsDataWithQuerry:(NSString *)querryString To:(NSMutableArray *)tempPreResultArray
{
    querryString = [NSString stringWithFormat:@"%@ %@",querryString, whereString];
    
    // ORDER BY
    querryString = [NSString stringWithFormat:@"%@ ORDER BY datetime(Deal.Date) DESC", querryString];
    
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

- (void)addMoneyWithId:(NSInteger)tempId Name:(NSString *)tempName Money:(NSInteger)tempMoney To:(NSMutableArray *)tempResultArray Is1:(BOOL)is1
{
    if (tempId < 0)
        return;
    
    if (!is1)
        tempMoney *= -1;
    
    NSArray *keyArray = [NSArray arrayWithObjects:@"id", @"name", @"money", nil];
    
    if (![ETUtility doesArray:tempResultArray hasDictionaryWithId:tempId]) {
        NSArray *tempObjectArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld", (long)tempId], tempName, [NSString stringWithFormat:@"%ld", (long)tempMoney], nil];
        NSDictionary *tempAccountDataDictionary = [NSDictionary dictionaryWithObjects:tempObjectArray forKeys:keyArray];
        [tempResultArray addObject:tempAccountDataDictionary];
    }
    else {
        NSMutableDictionary *tempAccountDataDictionary = [NSMutableDictionary dictionaryWithDictionary:[ETUtility selectDictionaryWithValue:[NSString stringWithFormat:@"%ld", (long)tempId] OfKey:@"id" inArray:tempResultArray]];
        NSInteger tempIndex = [tempResultArray indexOfObject:tempAccountDataDictionary];
        [tempAccountDataDictionary setValue:[NSString stringWithFormat:@"%ld", (long)([[tempAccountDataDictionary objectForKey:@"money"] integerValue] + tempMoney)] forKey:@"money"];
        [tempResultArray replaceObjectAtIndex:tempIndex withObject:tempAccountDataDictionary];
    }
}


#pragma mark - 그래프

- (void)setGraphData
{
    // Test
    NSArray *testArray = [NSArray arrayWithObjects:@"1", @"2", nil];
    
    graphArray = [NSMutableArray array];
    
    NSString *firstDate, *lastDate;
    
    for (NSInteger tempIndex = 0; tempIndex < [testArray count]; tempIndex++) {
        NSInteger tempTarget = [[testArray objectAtIndex:tempIndex] integerValue];
        NSMutableArray *graphDataArray = [NSMutableArray array];
        
        for (NSDictionary *tempDictionary in resultArray) {
            NSInteger tag_target_id = [[tempDictionary objectForKey:@"tag_target_id"] integerValue];
            NSInteger tag_target_id_1 = [[tempDictionary objectForKey:@"tag_target_id_1"] integerValue];
            NSInteger tag_target_id_2 = [[tempDictionary objectForKey:@"tag_target_id_2"] integerValue];
            
            if (tag_target_id == tempTarget || tag_target_id_1 == tempTarget || tag_target_id_2 == tempTarget)
                [graphDataArray addObject:tempDictionary];
        }
        
//        NSLog(@"%@", graphDataArray);
        [graphArray addObject:graphDataArray];
        
        if ([graphDataArray count] == 0)
            continue;
        
        NSString *tempFirstDate = [[graphDataArray objectAtIndex:0] objectForKey:@"date"];
        NSString *tempLastDate = [[graphDataArray lastObject] objectForKey:@"date"];
        
        if (!firstDate || ([ETFormatter dateFromDateSting:firstDate] > [ETFormatter dateFromDateSting:tempFirstDate]))
            firstDate = [NSString stringWithString:tempFirstDate];
        if (!lastDate || ([ETFormatter dateFromDateSting:lastDate] < [ETFormatter dateFromDateSting:tempLastDate]))
            lastDate = [NSString stringWithString:tempLastDate];
    }
    
//    NSLog(@"%@", firstDate);
//    NSLog(@"%@", lastDate);
    
    if (!firstDate || !lastDate)
        return;

    [graphView setStartDateString:firstDate];
    [graphView setEndDateString:lastDate];
    [graphView initInnerView];
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
    else return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return [[self view] frame].size.width;
    else if (indexPath.section == 3)
        return 60;
    else return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *CellIdentifier = @"ETAccountStatisticResultGraphTableViewCellIdentifier";
        
        ETAccountGraphTableViewCell *cell = (ETAccountGraphTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ETAccountGraphTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
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
            graphView = [(ETAccountGraphTableViewCell *)cell graphView];
            [graphView setBaseWithFrame:CGRectMake(0, 0, [[cell contentView] frame].size.width - 16, [[self view] frame].size.width - 16)];
            
            [self setGraphData];
        }
    }
    else if (indexPath.section == 1) {
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
    if (indexPath.section == 0)
        return NO;
    else if (indexPath.section == 3)
        selectedRow = indexPath.row;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
//            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
//            [cell setTitle:@"날짜"];
            break;
        case 1:
//            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
//            [cell setPlaceholder:@"거래명"];
            break;
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

@end
