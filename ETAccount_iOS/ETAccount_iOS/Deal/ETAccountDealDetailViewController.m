//
//  ETAccountDealDetailViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 10. 19..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountDealDetailViewController.h"

@interface ETAccountDealDetailViewController ()

@end

@implementation ETAccountDealDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDealDetailWithDate:(NSString *)date Name:(NSString *)name Money:(NSString *)money Left:(NSInteger)left Right:(NSInteger)right Description:(NSString *)description tagTarget:(NSInteger)tagTarget Id:(NSInteger)_id
{
    dealDate = date;
    dealName = name;
    dealMoney = money;
    accountLeftId = left;
    accountRightId = right;
    dealDescription = description;
    dealTagTarget = tagTarget;
    dealId = _id;
    
    [addDealTableView reloadData];
}

#pragma mark - 델리게이트 메서드

#pragma mark Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"AddCell";
    
    ETAccountAddTableViewCell *cell = (ETAccountAddTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ETAccountAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setCellRow:indexPath.row];
    }
    
    switch (indexPath.row) {
        case 0:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            [cell setPlaceholder:@"날짜"];
            
            [cell setDatePicker:UIDatePickerModeDateAndTime];
            [[cell titleTextField] setText:dealDate];
            break;
        case 1:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            [cell setPlaceholder:@"거래명"];
            [[cell titleTextField] setText:dealName];
            
            break;
        case 2:
            [cell setType:ADD_DEAL_CELL_TYPE_NUMBERS];
            [cell setPlaceholder:@"금액"];
            
            if ([dealMoney characterAtIndex:0] == '-') {
                [[cell plusMinusButton] setTag:NUMBER_SIGN_MINUS];
                [[cell titleTextField] setTextColor:[UIColor redColor]];
                
                NSMutableString *tempDealMoney = [NSMutableString stringWithString:dealMoney];
                dealMoney = [tempDealMoney substringFromIndex:1];
            }
            
            [[cell titleTextField] setText:dealMoney];
            break;
        case 3:
            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
            
            [cell setTitle:[ETAccountDBManager getItem:@"name" OfId:accountLeftId FromTable:@"Account"]];
            break;
        case 4:
            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
            
            [cell setTitle:[ETAccountDBManager getItem:@"name" OfId:accountRightId FromTable:@"Account"]];
            break;
        case 5:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            [cell setPlaceholder:@"설명"];
            [[cell titleTextField] setText:dealDescription];
            break;
        case 6:
            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
            [cell setTitle:@"Tags"];
            break;
    }
    
    return cell;
}

@end
