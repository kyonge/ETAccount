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

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


#pragma mark - Tag 컨트롤

- (void)setFilterCell:(ETAccountAddTableViewCell *)cell
{
//    if ([filterArray count] > 0) {
//        NSString *tagString = [[filterArray objectAtIndex:0] objectForKey:@"name"];
//        
//        for (NSInteger index = 1; index < [filterArray count]; index++)
//            tagString = [NSString stringWithFormat:@"%@, %@", tagString, [[filterArray objectAtIndex:index] objectForKey:@"name"]];
//        
//        [cell setTitle:tagString];
//    }
//    else [[cell textLabel] setText:@"필터 추가"];
    [[cell textLabel] setText:@"필터 추가"];
}

- (NSArray *)getSelectedTagsWithTargetId:(NSInteger)targetID
{
    NSString *querryString = [NSString stringWithFormat:@"SELECT Filter.id, Filter.type, Filter.item, Filter.compare from Filter Filter JOIN Statistics_filter_match Match ON Filter.id = Match.filter_id WHERE Match.statistic_id = %ld", (long)targetID];
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"type", @"compare", nil];
    NSArray *tempSelectedTagsArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
    
    return tempSelectedTagsArray;
}

//- (void)openAddTagViewController
//{
//    ETAccountAddTagViewController *addTagViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"ETAccountAddTagViewController"];
//    [addTagViewController setSelectedTags:selectedTagsArray];
//    [addTagViewController setChangeTagDelegate:self];
//    
//    [[self navigationController] pushViewController:addTagViewController animated:YES];
//}
//
//- (BOOL)saveTagsWithTargetId:(NSInteger)targetId
//{
//    for (NSDictionary *tempTagDictionary in selectedTagsArray) {
//        NSArray *keyArray = [NSArray arrayWithObjects:@"tag_id", @"tag_target_id", nil];
//        NSArray *objectsArray = [NSArray arrayWithObjects:
//                                 [NSString stringWithFormat:@"'%ld'", (long)[[tempTagDictionary objectForKey:@"id"] integerValue]],
//                                 [NSString stringWithFormat:@"'%ld'", (long)targetId], nil];
//        
//        NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
//        
//        if (![ETAccountDBManager insertToTable:@"Tag_match" dataDictionary:dataDic]) {
//            return NO;
//        }
//    }
//    
//    return YES;
//}


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
//    NSLog(@"%@", tempDealNameString);
    
    // 시작 날짜
    NSString *tempDealDateString = [NSString stringWithFormat:@"'%@'", dealDateString];
//    NSLog(@"%@", tempDealDateString);
    
    NSString *tempEndDateString = [NSString stringWithFormat:@"'%@'", endDateString];
//    NSLog(@"%@", tempEndDateString);
    
    NSInteger statisticOrder = [ETAccountDBManager getLast:@"statistic_order" FromTable:@"Statistic"] + 1;

    NSArray *keyArray = [NSArray arrayWithObjects:@"date_1", @"date_2", @"type", @"is_favorite", @"name", @"statistic_order", nil];
    NSArray *objectsArray = [NSArray arrayWithObjects:tempDealDateString, tempEndDateString, @"100",
                             [NSNumber numberWithInteger:isFavorite], tempDealNameString,
                             [NSNumber numberWithInteger:statisticOrder], nil];
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
    
    // 필터
    
//    [super writeToDB:dataDic Table:@"Statistic"];
    
    
    
    
//    // 태그
//    NSInteger statistic_id;
//    if (dealTagTarget == 0) statistic_id = [ETAccountUtility getTagFromViewController:self];
//    else statistic_id = dealTagTarget;
//    
//    if (statistic_id == -1)
//        return;
//    else {
//        if (![self saveTagsWithTargetId:tag_target_1]) {
//            [ETUtility showAlert:@"ETAccount" Message:@"태그를 저장하지 못했습니다." atViewController:self withBlank:NO];
//            return;
//        }
//        
//        NSArray *keyArray = [NSArray arrayWithObjects:@"name", @"account_id_1", @"account_id_2", @"tag_target_id", @"description", @"'date'", @"money", nil];
//        NSArray *objectsArray = [NSArray arrayWithObjects:tempDealNameString,
//                                 [NSNumber numberWithInteger:accountLeftId], [NSNumber numberWithInteger:accountRightId],
//                                 [NSNumber numberWithInteger:tag_target_1],
//                                 tempDealDescription, tempDealDateString, dealCost, nil];
//        
//        NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
//        
//        [self writeToDB:dataDic Table:@"Deal"];
//    }
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
            [[cell plusMinusButton] setTag:ADD_DEAL_CELL_TYPE_TEXT_WITH_ACC_BUTTON];
            break;
        case 1:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            if (indexPath.row == 0)
                [cell setPlaceholder:@"시작"];
            else if (indexPath.row == 1)
                [cell setPlaceholder:@"종료"];
            
            [[cell plusMinusButton] setHidden:NO];
            [[cell plusMinusButton] setTag:ADD_DEAL_CELL_TYPE_TEXT];
            [[cell plusMinusButton] setTitle:@"X" forState:UIControlStateNormal];
            
            [cell setDatePicker:UIDatePickerModeDate WithCurrentTime:YES DatePickerIndex:indexPath.row];
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
                    [[cell textLabel] setText:[NSString stringWithFormat:@"항목명 : %@", tempItemName]];
                }
                else if (filterType == FILTER_TYPE_TAG) {
                    NSString *tempItemName = [ETAccountDBManager getItem:@"name" OfId:[[tempFilterDictionary objectForKey:@"item"] integerValue] FromTable:@"Tag"];
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
    NSLog(@"%@", filterArray);
    
    [statisticTableView reloadData];
}

@end
