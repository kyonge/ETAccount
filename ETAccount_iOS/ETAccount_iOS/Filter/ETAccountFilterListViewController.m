//
//  ETAccountFilterListViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 6..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountFilterListViewController.h"

@interface ETAccountFilterListViewController ()

@end

@implementation ETAccountFilterListViewController

@synthesize filterDetailDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 확인

- (IBAction)selectOK:(id)sender
{
    if (!isTypeSelected) {
        [ETUtility showAlert:@"ETAccount" Message:@"필터 종류를 선택하세요." atViewController:self withBlank:NO];
        return;
    }
    
    NSArray *tempObjectArray;
    NSArray *tempKeyArray = [NSArray arrayWithObjects:@"type", @"item", @"compare", nil];
    
    if (selectedType == FILTER_DETAIL_ACCOUNT || selectedType == FILTER_DETAIL_TAG) {
        if (!selectedItem || [selectedItem length] == 0) {
            [ETUtility showAlert:@"ETAccount" Message:@"필터 내용을 선택하세요." atViewController:self withBlank:NO];
            return;
        }
        tempObjectArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld", (long)selectedType], selectedItemId, @"0", nil];
    }
    else if (selectedType == FILTER_DETAIL_PRICE) {
        if (!selectedItem || [selectedItem length] == 0 || !selectedPrice || [selectedPrice length] == 0) {
            [ETUtility showAlert:@"ETAccount" Message:@"필터 내용을 선택하세요." atViewController:self withBlank:NO];
            return;
        }
        tempObjectArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld", (long)selectedType], selectedPrice, selectedItemId, nil];
    }
    
    NSDictionary *tempDictionary = [NSDictionary dictionaryWithObjects:tempObjectArray forKeys:tempKeyArray];
    [filterDetailDelegate didSelect:tempDictionary];
    
    [[self navigationController] popViewControllerAnimated:YES];
}


#pragma mark - 델리게이트 메서드

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!isTypeSelected)
        return 1;
    else
        return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"종류";
        case 1: {
            if (selectedType == FILTER_DETAIL_ACCOUNT) return @"항목";
            else if (selectedType == FILTER_DETAIL_TAG) return @"태그";
            else if (selectedType == FILTER_DETAIL_PRICE) return @"금액";
        }
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 && selectedType == FILTER_DETAIL_PRICE)
        return 2;
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedType == FILTER_DETAIL_PRICE && indexPath.section == 1 && indexPath.row == 0)
        return NO;
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (selectedType == FILTER_DETAIL_PRICE && indexPath.section == 1 && indexPath.row == 0) {
        NSString *CellIdentifier = @"ETAccountAddFilterPriceCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
            cell = [[ETAccountAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        [(ETAccountAddFilterPriceTableViewCell *)cell setAddDealCellDelegate:self];
        [(ETAccountAddFilterPriceTableViewCell *)cell setType:ADD_DEAL_CELL_TYPE_NUMBERS];
        [(ETAccountAddFilterPriceTableViewCell *)cell setPlaceholder:@"입력"];
    }
    else {
        NSString *CellIdentifier = @"ETAccountAddFilterCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isTypeSelected) {
        if (indexPath.row == 0)
            [[cell textLabel] setText:@"선택"];
    }
    else {
        if (indexPath.section == 0) {
            if (selectedType == FILTER_DETAIL_ACCOUNT) [[cell textLabel] setText:@"항목"];
            else if (selectedType == FILTER_DETAIL_TAG) [[cell textLabel] setText:@"태그"];
            else if (selectedType == FILTER_DETAIL_PRICE) [[cell textLabel] setText:@"금액"];
        }
        else if (indexPath.section == 1) {
            if (selectedType == FILTER_DETAIL_PRICE && indexPath.row == 0) {
                if (!selectedPrice || [selectedPrice length] == 0) {
                    [[(ETAccountAddFilterPriceTableViewCell *)cell titleTextField] setText:@""];
                    [[cell textLabel] setText:@""];
                }
                else {
//                    [[(ETAccountAddFilterPriceTableViewCell *)cell titleTextField] setText:[ETFormatter moneyFormatFromString:selectedPrice]];
//                    [[cell textLabel] setText:[ETFormatter moneyFormatFromString:selectedPrice]];
                }
            }
            else if (!selectedItem || [selectedItem length] == 0)
                [[cell textLabel] setText:@"선택"];
            else if (selectedType == FILTER_DETAIL_ACCOUNT || selectedType == FILTER_DETAIL_TAG) [[cell textLabel] setText:selectedItem];
            else if (selectedType == FILTER_DETAIL_PRICE) {
                [[cell textLabel] setText:selectedItem];
//                if (indexPath.row == 0) [[cell textLabel] setText:[ETFormatter moneyFormatFromString:selectedPrice]];
//                else if (indexPath.row == 1) [[cell textLabel] setText:selectedItem];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
//    [[tableView cellForRowAtIndexPath:indexPath] resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ETAccountFilterDetailTableViewController *detailViewController = [ETAccountFilterDetailTableViewController new];
    [detailViewController setFilterDetailDelegate:self];
    [[self navigationController] pushViewController:detailViewController animated:YES];
    
    if (indexPath.section == 0)
        [detailViewController setSelectedType:FILTER_DETAIL_TYPE];
    else if (indexPath.section == 1) {
        [detailViewController setSelectedType:selectedType];
        [detailViewController setItemArray:itemsArray];
    }
    
    [tableView reloadData];
}

#pragma mark ETAccountAddDealCellDelegate

- (void)didEndEditText:(NSString *)insertedText CellIndex:(NSInteger)index
{
    switch (index) {
        case 2:
            selectedPrice = insertedText;
            break;
            
        default:
            break;
    }
    
    [filterTableView reloadData];
}

#pragma mark ETAccountFilterDetailDelegate

- (void)didSelect:(FILTER_DETAIL)filterDetail Index:(NSInteger)index
{
    if (filterDetail == FILTER_DETAIL_TYPE) {
        isTypeSelected = YES;
        if (index == 0) {
            selectedItem = @"";
            selectedPrice = @"";
            
            selectedType = FILTER_DETAIL_ACCOUNT;
            NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"name", @"tag_target_id", @"auto_target_id", @"account_order", nil];
            itemsArray = [ETUtility selectAllSQliteDatasFromFile:_DB Table:@"Account" WithColumn:columnArray];
//            NSLog(@"%@", itemsArray);
        }
        else if (index == 1) {
            selectedItem = @"";
            selectedPrice = @"";
            
            selectedType = FILTER_DETAIL_TAG;
            NSString *querryString = @"SELECT DISTINCT Tag.name, Tag.id FROM Tag_match Tag_match JOIN Tag Tag ON Tag.id=Tag_match.tag_id";
            NSArray *columnArray = [NSArray arrayWithObjects:@"name", @"id", nil];
            itemsArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
//            NSLog(@"%@", itemsArray);
        }
        else if (index == 2) {
            selectedItem = @"";
            selectedPrice = @"";
            
            selectedType = FILTER_DETAIL_PRICE;
            itemsArray = [NSArray arrayWithObjects:@"동일", @"초과", @"이상", @"미만", @"이하", nil];
        }
    }
    else if (filterDetail == FILTER_DETAIL_ACCOUNT || filterDetail == FILTER_DETAIL_TAG) {
        selectedItem = [[itemsArray objectAtIndex:index] objectForKey:@"name"];
        selectedItemId = [[itemsArray objectAtIndex:index] objectForKey:@"id"];
    }
    else if (filterDetail == FILTER_DETAIL_PRICE) {
        selectedItem = [itemsArray objectAtIndex:index];
        if (index == 0) selectedItemId = @"100";
        else if (index == 1) selectedItemId = @"200";
        else if (index == 2) selectedItemId = @"250";
        else if (index == 3) selectedItemId = @"300";
        else if (index == 4) selectedItemId = @"350";
    }
    
    [filterTableView reloadData];
}

@end
