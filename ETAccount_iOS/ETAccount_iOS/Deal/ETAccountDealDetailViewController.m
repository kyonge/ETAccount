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
//    [addTagViewController setSelectedTags:[self getSelectedTagsWithTargetId:dealTagTarget]];
    [addTagViewController setSelectedTags:selectedTagsArray];
    [addTagViewController setChangeTagDelegate:self];
    
    [[self navigationController] pushViewController:addTagViewController animated:YES];
}

- (void)writeToDB:(NSDictionary *)dataDic Table:(NSString *)tableName
{
    if (![ETAccountDBManager updateToTable:tableName dataDictionary:dataDic ToId:dealId]) {
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

- (BOOL)saveTagsWithTargetId:(NSInteger)targetId
{
    for (NSDictionary *tempTagDictionary in selectedTagsArray) {
        NSInteger tempTag = [[tempTagDictionary objectForKey:@"id"] integerValue];
        
        // 중복 체크
        NSString *querryString = [NSString stringWithFormat:@"SELECT TagMatch.tag_id, TagMatch.tag_target_id FROM Tag_match TagMatch WHERE TagMatch.tag_id=%ld AND Tagmatch.tag_target_id=%ld", (long)tempTag, (long)targetId];
        NSArray *keyArray = [NSArray arrayWithObjects:@"tag_id", @"tag_target_id", nil];
        
        NSArray *tagArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:keyArray];
        
        if ([tagArray count] == 0) {
            // 추가
            NSArray *objectsArray = [NSArray arrayWithObjects:
                                     [NSString stringWithFormat:@"'%ld'", (long)[[tempTagDictionary objectForKey:@"id"] integerValue]],
                                     [NSString stringWithFormat:@"'%ld'", (long)targetId], nil];
            
            NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
            
            if (![ETAccountDBManager insertToTable:@"Tag_match" dataDictionary:dataDic]) {
                return NO;
            }
        }
    }
    
    NSArray *lastSelectedArray = [self getSelectedTagsWithTargetId:dealTagTarget];
    for (NSDictionary *tempTagDictionary in lastSelectedArray) {
        // 제외된 태그 삭제
        NSInteger tempTagId = [[tempTagDictionary objectForKey:@"id"] integerValue];
        
        if (![ETUtility hasArray:selectedTagsArray hasDictionaryWithId:tempTagId]) {
            // DB에서 삭제
            NSString *querryString = [NSString stringWithFormat:@"DELETE FROM Tag_match WHERE tag_id = %ld AND tag_target_id = %ld", (long)tempTagId, (long)targetId];
            
            if (![ETUtility runQuerry:querryString FromFile:_DB]) {
                [ETUtility showAlert:@"ETAccount" Message:@"삭제하지 못했습니다." atViewController:self withBlank:NO];
            }
        }
    }
    
    return YES;
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
            
            [[cell titleTextField] setText:dealDateString];
//            [cell setDatePicker:UIDatePickerModeDateAndTime WithCurrentTime:NO DatePickerIndex:indexPath.row DateString:@""];
            if (!dealDateString || [dealDateString length] == 0)
                [cell setDatePicker:UIDatePickerModeDate WithCurrentTime:YES DatePickerIndex:0 DateString:@""];
            else [cell setDatePicker:UIDatePickerModeDate WithCurrentTime:NO DatePickerIndex:0 DateString:dealDateString];
            
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
            
            [self setTagCell:cell];
            
            break;
    }
    
    return cell;
}

@end
