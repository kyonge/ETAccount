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

@synthesize addDealDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSelectedTagsArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSelectedTagsArray
{
    selectedTagsArray = [self getSelectedTagsWithTargetId:dealTagTarget];
}

- (void)initDealDetailWithDate:(NSString *)date Name:(NSString *)name Money:(NSString *)money Left:(NSInteger)left Right:(NSInteger)right Description:(NSString *)description tagTarget:(NSInteger)tagTarget Id:(NSInteger)_id
{
    dealDateString = date;
    dealNameString = name;
    dealPrice = [money integerValue];
    accountLeftId = left;
    accountRightId = right;
    dealDescriptionString = description;
    dealTagTarget = tagTarget;
    dealId = _id;
    
    isAccountLeftFilled = YES;
    isAccountRightFilled = YES;
    
    [addDealTableView reloadData];
}


#pragma mark - Tag 컨트롤

- (NSInteger)getTag
{
    return dealTagTarget;
}

- (void)openAddTagViewController
{
    ETAccountAddTagViewController *addTagViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"ETAccountAddTagViewController"];
    [addTagViewController setSelectedTags:[self getSelectedTagsWithTargetId:dealTagTarget]];
    [addTagViewController setChangeTagDelegate:self];
    
    [[self navigationController] pushViewController:addTagViewController animated:YES];
}

- (void)writeToDB:(NSDictionary *)dataDic
{
    if (![ETAccountDBManager updateToTable:@"Deal" dataDictionary:dataDic ToId:dealId]) {
        UIAlertController *errorAlertController = [ETUtility showAlert:@"ETAccount" Message:@"저장하지 못했습니다." atViewController:self withBlank:YES];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"확인", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        [errorAlertController addAction:cancelAction];
    }
    
    [addDealDelegate didAddDeal];
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - 델리게이트 메서드

#pragma mark Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"AddCell";
    
    ETAccountAddTableViewCell *cell = (ETAccountAddTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setAddDealCellDelegate:self];
    
    if (cell == nil) {
        cell = [[ETAccountAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setCellSection:indexPath.section];
    
    switch (indexPath.section) {
        case 0:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            [cell setPlaceholder:@"날짜"];
            
            [cell setDatePicker:UIDatePickerModeDateAndTime];
            [[cell titleTextField] setText:dealDateString];
            
            break;
        case 1:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            [cell setPlaceholder:@"거래명"];
            [[cell titleTextField] setText:dealNameString];
            
            break;
        case 2: {
            [cell setType:ADD_DEAL_CELL_TYPE_NUMBERS];
            [cell setPlaceholder:@"금액"];
            
            // 가격
            NSString *dealCost = [NSString stringWithFormat:@"%ld", (long)dealPrice];
            
            if ([dealCost characterAtIndex:0] == '-') {
                [[cell plusMinusButton] setTag:NUMBER_SIGN_MINUS];
                [[cell titleTextField] setTextColor:[UIColor redColor]];

                NSMutableString *tempDealMoney = [NSMutableString stringWithString:dealCost];
                dealCost = [tempDealMoney substringFromIndex:1];
            }

            [[cell titleTextField] setText:dealCost];
            
            break;
        }
        case 3:
            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
            
            if (indexPath.row == 0)
                [cell setTitle:[ETAccountDBManager getItem:@"name" OfId:accountLeftId FromTable:@"Account"]];
            else if (indexPath.row == 1)
                [cell setTitle:[ETAccountDBManager getItem:@"name" OfId:accountRightId FromTable:@"Account"]];
            
            break;
        case 4:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            [cell setPlaceholder:@"설명"];
            [[cell titleTextField] setText:dealDescriptionString];
            
            break;
        case 5:
            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
            
//            if ([selectedTagsArray count] > 0) {
//                NSString *tagString = [[selectedTagsArray objectAtIndex:0] objectForKey:@"name"];
//                
//                for (NSInteger index = 1; index < [selectedTagsArray count]; index++)
//                    tagString = [NSString stringWithFormat:@"%@, %@", tagString, [[selectedTagsArray objectAtIndex:index] objectForKey:@"name"]];
//                
//                [cell setTitle:tagString];
//            }
//            else [cell setTitle:@"태그 추가"];
            [self setTagCell:cell];
            
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma ETAccountChangeTagDelegate

- (void)didChangeSelectedTagsArray:(NSArray *)newSelectedArray
{
    selectedTagsArray = newSelectedArray;
    
    [addDealTableView reloadData];
}

@end
