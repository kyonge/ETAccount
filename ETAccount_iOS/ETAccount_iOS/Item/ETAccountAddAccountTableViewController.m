//
//  ETAccountAddAccountTableViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 10. 16..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountAddAccountTableViewController.h"

@interface ETAccountAddAccountTableViewController ()

@end

@implementation ETAccountAddAccountTableViewController

@synthesize addDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initItemList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initItemList
{
    //현재는 전체 로드 : 날짜순 조건 추가, 동적 로딩 추가
    
    NSString *querryString = @"SELECT Account.id, Account.name, Account.'order' FROM Account ORDER BY Account.'order'";
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"name", @"order", nil];
    
    itemArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
}


#pragma maek - 추가

- (void)showAddAccountAlertControllerFromTableView:(UITableView *)tableView
{
    UIAlertController *addTagAlertControl = [UIAlertController
                                             alertControllerWithTitle:@"항목 추가"
                                             message:@"항목명을 입력해주세요"
                                             preferredStyle:UIAlertControllerStyleAlert];
    [addTagAlertControl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"항목명"];
        [textField setKeyboardType:UIKeyboardTypeDefault];
        newAccountTextField = textField;
    }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"추가", @"Close action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self addNewAccount:[newAccountTextField text] TableView:tableView];
                               }];
    [addTagAlertControl addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"취소", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [addTagAlertControl addAction:cancelAction];
    
    [self presentViewController:addTagAlertControl animated:YES completion:nil];
}

- (void)addNewAccount:(NSString *)tagName TableView:(UITableView*)tableView
{
//    NSArray *keyArray = [NSArray arrayWithObject:@"name"];
//    NSArray *objectsArray = [NSArray arrayWithObject:[NSString stringWithFormat:@"'%@'", tagName]];
//    
//    NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
//    [self writeToDB:dataDic];
    
    [self initItemList];
    [tableView reloadData];
}


#pragma maek - 델리게이트 메서드

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [itemArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AccountTableViewCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [itemArray count])
        [[cell textLabel] setText:@"신규 항목 추가"];
    else
        [[cell textLabel] setText:[[itemArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [itemArray count])
        [self showAddAccountAlertControllerFromTableView:tableView];
    else {
        [addDelegate didSelectAccount:[[[itemArray objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue]];
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
    [tableView reloadData];
//    [challengerDelegate searchChallengerNick:[challengerListArray objectAtIndex:indexPath.row]];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteTagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                               title:@"Delete"
                                                                             handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                 if (![ETAccountDBManager deleteFromTable:@"Tag" OfId:[[[itemArray objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue]]) {
//                                                                                     UIAlertController *errorAlertController = [ETUtility showAlert:@"ETAccount" Message:@"삭제하지 못했습니다." atViewController:self withBlank:YES];
//                                                                                     UIAlertAction *cancelAction = [UIAlertAction
//                                                                                                                    actionWithTitle:NSLocalizedString(@"확인", @"Cancel action")
//                                                                                                                    style:UIAlertActionStyleCancel
//                                                                                                                    handler:nil];
//                                                                                     [errorAlertController addAction:cancelAction];
                                                                                     [ETUtility showAlert:@"ETAccount" Message:@"삭제하지 못했습니다." atViewController:self withBlank:NO];
                                                                                 }
                                                                                 
                                                                                 [tableView setEditing:NO animated:NO];
                                                                             }];
    [deleteTagAction setBackgroundColor:[UIColor redColor]];
    
    [tableView setEditing:YES animated:NO];
    return [NSArray arrayWithObject:deleteTagAction];
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
