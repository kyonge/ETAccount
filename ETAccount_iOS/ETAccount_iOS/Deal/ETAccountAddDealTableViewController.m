//
//  ETAccountAddDealTableViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 9. 20..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import "ETAccountAddDealTableViewController.h"

@interface ETAccountAddDealTableViewController ()

@end

@implementation ETAccountAddDealTableViewController

@synthesize addDealDelegate;

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

- (IBAction)close:(id)sender
{
    UIAlertController *alertController = [ETUtility showAlert:@"ETAccount" Message:@"저장하지 않고 닫으시겠습니까?" atViewController:self withBlank:YES];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"닫기", @"Close action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [addDealDelegate didAddDeal];
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alertController addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"취소", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [alertController addAction:cancelAction];
}

- (IBAction)selectOk:(id)sender
{
    // 거래 명
    NSIndexPath *nameIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    NSString *dealName = [[[addDealTableView cellForRowAtIndexPath:nameIndex] titleTextField] text];
    dealName = [NSString stringWithFormat:@"'%@'", dealName];
    
    if(!dealName || [dealName length] == 0) {
        [ETUtility showAlert:@"ETAccount" Message:@"거래명을 입력해주세요" atViewController:self withBlank:YES];
        return;
    }
    
    // 거래 날짜
    NSIndexPath *dateIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    NSString *dealDate = [[[addDealTableView cellForRowAtIndexPath:dateIndex] titleTextField] text];
    dealDate = [NSString stringWithFormat:@"'%@'", dealDate];
    
    // 가격
    NSIndexPath *costIndex = [NSIndexPath indexPathForRow:0 inSection:2];
    NSString *dealCost = [[[addDealTableView cellForRowAtIndexPath:costIndex] titleTextField] text];
    if ([[(ETAccountAddTableViewCell *)[addDealTableView cellForRowAtIndexPath:costIndex] plusMinusButton] tag] == NUMBER_SIGN_MINUS)
        dealCost = [NSString stringWithFormat:@"-%@", dealCost];
    if ([dealCost integerValue] == 0) {
        [ETUtility showAlert:@"ETAccount" Message:@"가격정보가 없습니다" atViewController:self withBlank:NO];
        return;
    }
    
    // 좌변
    if (!isAccountLeftFilled) {
        [ETUtility showAlert:@"ETAccount" Message:@"좌변이 비어있습니다" atViewController:self withBlank:NO];
        return;
    }
    
    // 우변
    if (!isAccountRightFilled) {
        [ETUtility showAlert:@"ETAccount" Message:@"우변이 비어있습니다" atViewController:self withBlank:NO];
        return;
    }
    
    // 거래 설명
    NSIndexPath *descriptionIndex = [NSIndexPath indexPathForRow:0 inSection:4];
    NSString *dealDescription = [[[addDealTableView cellForRowAtIndexPath:descriptionIndex] titleTextField] text];
    dealDescription = [NSString stringWithFormat:@"'%@'", dealDescription];
    
    NSArray *keyArray = [NSArray arrayWithObjects:@"name", @"account_id_1", @"account_id_2", @"tag_target_id", @"description", @"'date'", @"money", nil];
    NSArray *objectsArray = [NSArray arrayWithObjects:dealName,
                             [NSNumber numberWithInteger:accountLeftId], [NSNumber numberWithInteger:accountRightId],
                             [NSNumber numberWithInteger:0], // Tag_Target_Id (미구현)
                             dealDescription, dealDate, dealCost, nil];
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
    [self writeToDB:dataDic];
}

- (void)writeToDB:(NSDictionary *)dataDic
{
    if (![ETAccountDBManager insertToTable:@"Deal" dataDictionary:dataDic]) {
        UIAlertController *errorAlertController = [ETUtility showAlert:@"ETAccount" Message:@"저장하지 못했습니다." atViewController:self withBlank:YES];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"확인", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        [errorAlertController addAction:cancelAction];
    }
    
    [addDealDelegate didAddDeal];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 델리게이트 메서드

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"일시";
        case 1:
            return @"거래명";
        case 2:
            return @"금액";
        case 3:
            return @"항목";
        case 4:
            return @"설명";
        case 5:
            return @"태그";
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3)
        return 2;
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"AddCell";
    
    ETAccountAddTableViewCell *cell = (ETAccountAddTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ETAccountAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setCellRow:indexPath.row];
    }

    switch (indexPath.section) {
        case 0:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            [cell setPlaceholder:@"날짜"];
            
            [cell setDatePicker:UIDatePickerModeDate];
            break;
        case 1:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            [cell setPlaceholder:@"거래명"];
            break;
        case 2:
            [cell setType:ADD_DEAL_CELL_TYPE_NUMBERS];
            [cell setPlaceholder:@"금액"];
            break;
        case 3:
            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
            
            if (indexPath.row == 0) {
                if (isAccountLeftFilled)
                    [cell setTitle:[ETAccountDBManager getItem:@"name" OfId:accountLeftId FromTable:@"Account"]];
                else
                    [cell setTitle:@"좌변"];
            }
            else if (indexPath.row == 1) {
                if (isAccountRightFilled)
                    [cell setTitle:[ETAccountDBManager getItem:@"name" OfId:accountRightId FromTable:@"Account"]];
                else
                    [cell setTitle:@"우변"];
            }
            break;
            
        case 4:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            [cell setPlaceholder:@"설명"];
            break;
        case 5:
            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
            [cell setTitle:@"Tags"];
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ETAccountAddTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *tempVenueDictionary = [currentVenueArray objectAtIndex:indexPath.row];
//    NSInteger tempRank = [[currentRankArray objectAtIndex:indexPath.row] integerValue];
//    
//    [POVenueSummaryCellController setVenueSummaryCell:cell dictionary:tempVenueDictionary withRank:tempRank BigSize:NO];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] resignFirstResponder];
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
        case 2:
//            [cell setType:ADD_DEAL_CELL_TYPE_NUMBERS];
//            [cell setPlaceholder:@"금액"];
            break;
        case 3: {
            if (indexPath.row == 0)
                direction = ACCOUNT_DIRECTION_LEFT;
            else if(indexPath.row == 1)
                direction = ACCOUNT_DIRECTION_RIGHT;
            
            ETAccountAddAccountTableViewController *itemAddTableViewController = [[ETAccountAddAccountTableViewController alloc] init];
            [itemAddTableViewController setAddDelegate:self];
            [[self navigationController] pushViewController:itemAddTableViewController animated:YES];
            break;
        }
        case 4:
//            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
//            [cell setPlaceholder:@"설명"];
            break;
        case 5:
//            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
//            [cell setTitle:@"Tags"];
            break;
    }
    
    [tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark ETAccountAddAccountDelegate

- (void)didSelectAccount:(NSInteger)accountId
{
    if (direction == ACCOUNT_DIRECTION_LEFT) {
        isAccountLeftFilled = YES;
        accountLeftId = accountId;
    }
    else if (direction == ACCOUNT_DIRECTION_RIGHT) {
        isAccountRightFilled = YES;
        accountRightId = accountId;
    }
    
    [addDealTableView reloadData];
}

@end
