//
//  ETAccountAddStatisticViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 5..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountAddStatisticViewController.h"

@interface ETAccountAddStatisticViewController ()

@end

@implementation ETAccountAddStatisticViewController

@synthesize addStatisticDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!filterArray)
        filterArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ETAccountAddFilterSegue"]) {
        ETAccountFilterListViewController *addFilterViewController = (ETAccountFilterListViewController *)[segue destinationViewController];
        [addFilterViewController setFilterDetailDelegate:self];
    }
}


#pragma mark - Filter 컨트롤

- (void)setFilterCell:(ETAccountAddTableViewCell *)cell
{
    [[cell textLabel] setText:@"필터 추가"];
}

- (NSArray *)getSelectedTagsWithTargetId:(NSInteger)targetID
{
    NSString *querryString = [NSString stringWithFormat:@"SELECT Filter.id, Filter.type, Filter.item, Filter.compare from Filter Filter JOIN Statistics_filter_match Match ON Filter.id = Match.filter_id WHERE Match.statistic_id = %ld", (long)targetID];
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"type", @"compare", nil];
    NSArray *tempSelectedTagsArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
    
    return tempSelectedTagsArray;
}


#pragma mark - 저장

- (IBAction)selectOk:(id)sender
{
    // 통계명
    if(!dealNameString || [dealNameString length] == 0) {
        [ETUtility showAlert:@"ETAccount" Message:@"통계명을 입력해주세요" atViewController:self withBlank:NO];
        return;
    }
    NSString *tempDealNameString;
    NSIndexPath *nameIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    tempDealNameString = [[[addDealTableView cellForRowAtIndexPath:nameIndex] titleTextField] text];
    if (!tempDealNameString || [tempDealNameString length] == 0) {
        tempDealNameString = dealNameString;
    }
    tempDealNameString = [NSString stringWithFormat:@"'%@'", tempDealNameString];
    
    // 시작 날짜
    NSString *tempDealDateString = [NSString stringWithFormat:@"'%@'", dealDateString];
    
    // 종료 날짜
    NSString *tempEndDateString = [NSString stringWithFormat:@"'%@'", endDateString];
    
    NSInteger statisticOrder = [ETAccountDBManager getLast:@"statistic_order" FromTable:@"Statistic"] + 1;

    NSArray *keyArray = [NSArray arrayWithObjects:@"date_1", @"date_2", @"type", @"is_favorite", @"name", @"statistic_order", nil];
    NSArray *objectsArray = [NSArray arrayWithObjects:tempDealDateString, tempEndDateString, @"100",
                             [NSNumber numberWithInteger:isFavorite], tempDealNameString,
                             [NSNumber numberWithInteger:statisticOrder], nil];
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
    [self writeToDB:dataDic Table:@"Statistic"];
}

- (void)writeToDB:(NSDictionary *)dataDic Table:(NSString *)tableName
{
    if (![ETAccountDBManager insertToTable:tableName dataDictionary:dataDic]) {
        UIAlertController *errorAlertController = [ETUtility showAlert:@"ETAccount" Message:@"저장하지 못했습니다." atViewController:self withBlank:YES];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"확인", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        [errorAlertController addAction:cancelAction];
    }
    
    NSString *querryString = @"SELECT id FROM Statistic ORDER BY id DESC LIMIT 1";
    NSArray *resultArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:[NSArray arrayWithObject:@"id"]];
    NSInteger insertedId = [[[resultArray objectAtIndex:0] objectForKey:@"id"] integerValue];
    
    // 필터
    NSInteger statistic_id;
    statistic_id = insertedId;
    
    if (statistic_id == -1)
        return;
    else {
        if (![self saveFiltersWithTargetId:statistic_id]) {
            [ETUtility showAlert:@"ETAccount" Message:@"필터를 저장하지 못했습니다." atViewController:self withBlank:NO];
            return;
        }
        
        [addStatisticDelegate didAddDeal];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)saveFiltersWithTargetId:(NSInteger)targetId
{
    for (NSDictionary *tempFilterDictionary in filterArray) {
        NSArray *keyArray = [NSArray arrayWithObjects:@"type", @"item", @"compare", nil];
        NSArray *objectsArray = [NSArray arrayWithObjects:
                                 [NSString stringWithFormat:@"'%ld'", (long)[[tempFilterDictionary objectForKey:@"type"] integerValue]],
                                 [NSString stringWithFormat:@"'%ld'", (long)[[tempFilterDictionary objectForKey:@"item"] integerValue]],
                                 [NSString stringWithFormat:@"'%ld'", (long)[[tempFilterDictionary objectForKey:@"compare"] integerValue]], nil];
        NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
        
        if (![ETAccountDBManager insertToTable:@"Filter" dataDictionary:dataDic]) {
            return NO;
        }
        
        NSString *querryString = @"SELECT id FROM Filter ORDER BY id DESC LIMIT 1";
        NSArray *resultArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:[NSArray arrayWithObject:@"id"]];
        NSInteger insertedFilterId = [[[resultArray objectAtIndex:0] objectForKey:@"id"] integerValue];
        
        keyArray = [NSArray arrayWithObjects:@"statistic_id", @"filter_id", nil];
        objectsArray = [NSArray arrayWithObjects:
                        [NSString stringWithFormat:@"'%ld'", (long)targetId],
                        [NSString stringWithFormat:@"'%ld'", (long)insertedFilterId], nil];
        dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
        
        if (![ETAccountDBManager insertToTable:@"Statistics_filter_match" dataDictionary:dataDic]) {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - 델리게이트 메서드

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"통계명";
        case 1:
            return @"날짜";
        case 2:
            return @"조건";
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1)
        return 2;
    else if (section == 2)
        return [filterArray count] + 1;
    
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == [filterArray count])
        return YES;
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"ETAccountAddStatisticCell";
    
    ETAccountAddStatisticTableViewCell *cell = (ETAccountAddStatisticTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ETAccountAddStatisticTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setAddDealCellDelegate:self];
    [cell setCellSection:indexPath.section];
    
    switch (indexPath.section) {
        case 0:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT_WITH_ACC_BUTTON];
            [cell setPlaceholder:@"통계명"];
            [[cell titleTextField] setText:dealNameString];
            [[cell plusMinusButton] setTag:ADD_DEAL_CELL_TYPE_TEXT_WITH_ACC_BUTTON];
            break;
        case 1:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            if (indexPath.row == 0) {
                [cell setPlaceholder:@"시작"];
                if (!dealDateString || [dealDateString length] == 0)
                    [cell setDatePicker:UIDatePickerModeDate WithCurrentTime:YES DatePickerIndex:0 DateString:@""];
                else [cell setDatePicker:UIDatePickerModeDate WithCurrentTime:NO DatePickerIndex:0 DateString:dealDateString];
            }
            else if (indexPath.row == 1) {
                [cell setPlaceholder:@"종료"];
                if (!endDateString || [endDateString length] == 0)
                    [cell setDatePicker:UIDatePickerModeDate WithCurrentTime:YES DatePickerIndex:1 DateString:@""];
                else [cell setDatePicker:UIDatePickerModeDate WithCurrentTime:NO DatePickerIndex:1 DateString:endDateString];
            }
            
            [[cell plusMinusButton] setHidden:NO];
            [[cell plusMinusButton] setTag:ADD_DEAL_CELL_TYPE_TEXT];
            [[cell plusMinusButton] setTitle:@"X" forState:UIControlStateNormal];
            
//            [cell setDatePicker:UIDatePickerModeDate WithCurrentTime:YES DatePickerIndex:indexPath.row];
            break;
        case 2: {
            if (indexPath.row == [filterArray count]) {
                [cell setType:ADD_DEAL_CELL_TYPE_DEFAULT];
                [self setFilterCell:cell];
                [[cell plusMinusButton] setHidden:YES];
            }
            else {
                NSDictionary *tempFilterDictionary = [filterArray objectAtIndex:indexPath.row];
                FILTER_TYPE filterType = [[tempFilterDictionary objectForKey:@"type"] integerValue];
                
                if (filterType == FILTER_TYPE_ITEM) {
                    NSString *tempItemName = [ETAccountDBManager getItem:@"name" OfId:[[tempFilterDictionary objectForKey:@"item"] integerValue] FromTable:@"Account"];
                    [[cell titleTextField] setHidden:YES];
//                    [cell setTitle:@""];
                    [[cell textLabel] setText:[NSString stringWithFormat:@"항목명 : %@", tempItemName]];
                }
                else if (filterType == FILTER_TYPE_TAG) {
                    NSString *tempItemName = [ETAccountDBManager getItem:@"name" OfId:[[tempFilterDictionary objectForKey:@"item"] integerValue] FromTable:@"Tag"];
                    [[cell titleTextField] setHidden:YES];
//                    [cell setTitle:@""];
                    [[cell textLabel] setText:[NSString stringWithFormat:@"태그 : %@", tempItemName]];
                }
                else if (filterType == FILTER_TYPE_PRICE) {
                    FILTER_COMPARE tempCompare = [[tempFilterDictionary objectForKey:@"compare"] integerValue];
                    NSString *tempCompareString;
                    if (tempCompare == FILTER_COMPARE_SAME) tempCompareString = @"=";
                    else if (tempCompare == FILTER_COMPARE_LEFT) tempCompareString = @">";
                    else if (tempCompare == FILTER_COMPARE_SAME_LEFT) tempCompareString = @">=";
                    else if (tempCompare == FILTER_COMPARE_RIGHT) tempCompareString = @"<";
                    else if (tempCompare == FILTER_COMPARE_SAME_RIGHT) tempCompareString = @"<=";
                    
                    [[cell textLabel] setText:[NSString stringWithFormat:@"가격 %@ %@", tempCompareString, [tempFilterDictionary objectForKey:@"item"]]];
                }
            }
            
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            break;
        case 2: {
            if (indexPath.row != [filterArray count]) {
                
            }
            else {
//                ETAccountFilterListViewController *filterListViewController = [ETAccountFilterListViewController new];
//                [[self navigationController] pushViewController:filterListViewController animated:YES];
            }
            break;
        }
//        case 3: {
//            if (indexPath.row == 0)
//                direction = ACCOUNT_DIRECTION_LEFT;
//            else if(indexPath.row == 1)
//                direction = ACCOUNT_DIRECTION_RIGHT;
//            
//            ETAccountAddAccountTableViewController *addItemTableViewController = [[ETAccountAddAccountTableViewController alloc] init];
//            [addItemTableViewController setAddDelegate:self];
//            [[self navigationController] pushViewController:addItemTableViewController animated:YES];
//            break;
//        }
    }
    
    [tableView reloadData];
}

#pragma mark ETAccountAddDealCellDelegate

- (void)didEndEditText:(NSString *)insertedText CellIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            dealNameString = insertedText;
            break;
            
        case 10:
            dealDateString = insertedText;
            break;
            
        case 11:
            endDateString = insertedText;
            break;
            
        case 2:
            dealPrice = [insertedText integerValue];
            break;
            
        case 4:
            dealDescriptionString = insertedText;
            
        default:
            break;
    }
}

#pragma ETAccountFilterSelectDelegate

- (void)didSelect:(NSDictionary *)filterDataDictionary
{
//    NSLog(@"%@", filterDataDictionary);
    [filterArray addObject:filterDataDictionary];
//    NSLog(@"%@", filterArray);
    
    [statisticTableView reloadData];
}

@end
