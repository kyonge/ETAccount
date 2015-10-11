//
//  ETAccountAddTableViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 9. 20..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import "ETAccountAddTableViewController.h"

@interface ETAccountAddTableViewController ()

@end

@implementation ETAccountAddTableViewController

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
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alertController addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"취소", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [alertController addAction:cancelAction];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"AddCell";
    
    ETAccountAddTableViewCell *cell = (ETAccountAddTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ETAccountAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    switch (indexPath.row) {
        case 0:
            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
            [cell setTitle:@"날짜"];
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
            [cell setTitle:@"좌변"];
            break;
        case 4:
            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
            [cell setTitle:@"우변"];
            break;
        case 5:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            [cell setPlaceholder:@"설명"];
            break;
        case 6:
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

@end
