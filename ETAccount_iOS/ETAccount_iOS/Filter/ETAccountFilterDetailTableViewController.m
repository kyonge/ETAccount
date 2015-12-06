//
//  ETAccountFilterDetailTableViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 6..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountFilterDetailTableViewController.h"

@interface ETAccountFilterDetailTableViewController ()

@end

@implementation ETAccountFilterDetailTableViewController

@synthesize itemArray;
@synthesize selectedType;
@synthesize filterDetailDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 델리게이트 메서드

#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (selectedType == FILTER_DETAIL_TYPE)
        return 3;
//    else if (section == 2)
//        return [filterArray count] + 1;
    else if (selectedType == FILTER_DETAIL_ACCOUNT || selectedType == FILTER_DETAIL_TAG || selectedType == FILTER_DETAIL_PRICE)
        return [itemArray count];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"ETAccountAddFilterCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    //    switch (indexPath.section) {
    //        case 0:
    //            [cell setType:ADD_DEAL_CELL_TYPE_TEXT_WITH_ACC_BUTTON];
    //            [cell setPlaceholder:@"통계명"];
    //            [[cell plusMinusButton] setTag:ADD_DEAL_CELL_TYPE_TEXT_WITH_ACC_BUTTON];
    //            break;
    //        case 1:
    //            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
    //            if (indexPath.row == 0)
    //                [cell setPlaceholder:@"시작"];
    //            else if (indexPath.row == 1)
    //                [cell setPlaceholder:@"종료"];
    //
    //            [[cell plusMinusButton] setHidden:NO];
    //            [[cell plusMinusButton] setTag:ADD_DEAL_CELL_TYPE_TEXT];
    //            [[cell plusMinusButton] setTitle:@"X" forState:UIControlStateNormal];
    //
    //            [cell setDatePicker:UIDatePickerModeDate WithCurrentTime:YES DatePickerIndex:indexPath.row];
    //            break;
    //        case 2:
    //            [cell setType:ADD_DEAL_CELL_TYPE_DEFAULT];
    //            [self setFilterCell:cell];
    //            [[cell plusMinusButton] setHidden:YES];
    //            break;
    //    }
    //
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedType == FILTER_DETAIL_TYPE) {
        if (indexPath.row == 0) [[cell textLabel] setText:@"항목"];
        else if (indexPath.row == 1) [[cell textLabel] setText:@"태그"];
        else if (indexPath.row == 2) [[cell textLabel] setText:@"금액"];
    }
    else if (selectedType == FILTER_DETAIL_ACCOUNT || selectedType == FILTER_DETAIL_TAG)
        [[cell textLabel] setText:[[itemArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    else if (selectedType == FILTER_DETAIL_PRICE)
        [[cell textLabel] setText:[itemArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //    [[tableView cellForRowAtIndexPath:indexPath] resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [filterDetailDelegate didSelect:selectedType Index:indexPath.row];
    
    [tableView reloadData];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
