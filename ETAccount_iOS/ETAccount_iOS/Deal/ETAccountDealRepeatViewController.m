//
//  ETAccountDealRepeatViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2016. 2. 23..
//  Copyright © 2016년 Eten. All rights reserved.
//

#import "ETAccountDealRepeatViewController.h"

@interface ETAccountDealRepeatViewController ()

@end

@implementation ETAccountDealRepeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadView
{
    
}

- (void)initView
{
    pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 112, [[self view] frame].size.width - 40, [[self view] frame].size.height - 132)];
    [pageScrollView setScrollEnabled:NO];
//    [pageScrollView setBackgroundColor:[UIColor lightGrayColor]];
    [pageScrollView setDelegate:self];
    [[self view] addSubview:pageScrollView];
    
    [pageScrollView setContentSize:CGSizeMake([pageScrollView frame].size.width * 2, [pageScrollView frame].size.height)];
    [pageScrollView setPagingEnabled:YES];
    
    [periodSegmentedControl setSelectedSegmentIndex:PERIOD_MONTHLY];
    
    [self initFirstView];
    [self initSecndView];
}

- (void)initFirstView
{
    UIControl *firstView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [pageScrollView frame].size.width, [pageScrollView frame].size.height)];
    [firstView addTarget:divideCountTextField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchDown];
    [firstView addTarget:repeatCountTextField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchDown];
//    [firstView setBackgroundColor:[UIColor redColor]];
    [pageScrollView addSubview:firstView];
    
    divideCountTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, [firstView frame].size.width - 60, 30)];
    [divideCountTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [divideCountTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [divideCountTextField setPlaceholder:@"분할 수"];
    [divideCountTextField setDelegate:self];
//    [divideCountTextField addTarget:self action:@selector(changeDivideTextFiled:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [divideCountTextField addTarget:self action:@selector(changeDivideTextFiled:) forControlEvents:UIControlEventEditingDidEnd];
    [firstView addSubview:divideCountTextField];
    
    divideCountSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, 80, [divideCountTextField frame].size.width, 31)];
    [divideCountSlider setMinimumValue:2];
    [divideCountSlider setMaximumValue:12];
    [divideCountSlider addTarget:self action:@selector(changeSlider:) forControlEvents:UIControlEventValueChanged];
    [firstView addSubview:divideCountSlider];
}

- (void)initSecndView
{
    UIControl *secondView = [[UIControl alloc] initWithFrame:CGRectMake([pageScrollView frame].size.width, 0, [pageScrollView frame].size.width, [pageScrollView frame].size.height)];
    [secondView addTarget:divideCountTextField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchDown];
    [secondView addTarget:repeatCountTextField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchDown];
//    [secondView setBackgroundColor:[UIColor blueColor]];
    [pageScrollView addSubview:secondView];
    
    repeatCountTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, [secondView frame].size.width - 60, 30)];
    [repeatCountTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [repeatCountTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [repeatCountTextField setPlaceholder:@"반복 수"];
    [secondView addSubview:repeatCountTextField];
    
    UIView *displaySwitchView = [[UIView alloc] initWithFrame:CGRectMake([secondView frame].size.width / 2 - 75, 80, 151, 31)];
    [secondView addSubview:displaySwitchView];
    
    UILabel *displaySwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 31)];
    [displaySwitchLabel setText:@"횟수 표시"];
    [displaySwitchView addSubview:displaySwitchLabel];
    
    displaySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 0, 51, 31)];
    [displaySwitchView addSubview:displaySwitch];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirm:(id)sender
{
    [divideCountTextField resignFirstResponder];
    [repeatCountTextField resignFirstResponder];
    
    switch ([pageSegmentedControl selectedSegmentIndex]) {
        case 0: {
            [self divide];
            
            break;
        }
            
        case 1: {
            [self repeat];
            
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)changePage:(UISegmentedControl *)segmentedControl
{
    NSLog(@"[segmentControl selectedSegmentIndex] : %ld", (long)[segmentedControl selectedSegmentIndex]);
    [pageScrollView setContentOffset:CGPointMake([pageScrollView frame].size.width * [segmentedControl selectedSegmentIndex], 0) animated:YES];
}

- (void)changeDivideTextFiled:(UITextField *)textField
{
    [divideCountSlider setValue:[[textField text] intValue]];
}

- (void)changeSlider:(UISlider *)slider
{
    [divideCountTextField setText:[NSString stringWithFormat:@"%d", (int)[slider value]]];
}


#pragma mark - Divide Deal

- (void)divide
{
    NSInteger divideCount = [[divideCountTextField text] integerValue];
    if (divideCount <= 1) {
        [ETUtility showAlert:@"분할" Message:@"2 이상의 값을 입력해야 합니다" atViewController:self withBlank:NO];
        return;
    }
    
//    NSArray *keyArray = [NSArray arrayWithObjects:@"name", @"account_id_1", @"account_id_2", @"tag_target_id", @"description", @"'date'", @"money", nil];
    NSDate *initDealDate = [ETFormatter dateFromDateSting:dealDateString];
    NSInteger dividedCost = dealPrice / divideCount;
    
    NSString *tempCurrentDealNameString = [NSString stringWithFormat:@"%@ (1/%ld)", dealNameString, (long)divideCount];
    NSDictionary *currentDataDic = [self makeDealDictionaryWithName:tempCurrentDealNameString Left:accountLeftId Right:accountRightId
                                                                Tag:dealTagTarget Description:dealDescriptionString DateString:dealDateString Price:dividedCost];
    [self writeToDB:currentDataDic Table:@"Deal"];
    
    for (NSInteger index = 1; index < divideCount; index++) {
        NSString *tempDealNameString = [NSString stringWithFormat:@"%@ (%ld/%ld)", dealNameString, (long)index + 1, (long)divideCount];
        NSInteger tag_target = [ETAccountUtility getTagFromViewController:self];
        [super saveTagsWithTargetId:tag_target];
        
        NSTimeInterval timeInterval = [self timeIntervalWithIndex:index];
        NSDate *tempDate = [initDealDate dateByAddingTimeInterval:timeInterval];
        NSString *tempDealDateString = [ETFormatter dateStringForDeal:tempDate];
        
        NSDictionary *dataDic = [self makeDealDictionaryWithName:tempDealNameString Left:accountLeftId Right:accountRightId
                                                             Tag:tag_target Description:dealDescriptionString DateString:tempDealDateString Price:dividedCost];
        
        [self addDeal:dataDic];
    }
}


#pragma mark - Repeat Deal

- (void)repeat
{
    NSInteger repeatCount = [[repeatCountTextField text] integerValue];
    if (repeatCount <= 1) {
        [ETUtility showAlert:@"반복" Message:@"2 이상의 값을 입력해야 합니다" atViewController:self withBlank:NO];
        return;
    }
    
    NSDate *initDealDate = [ETFormatter dateFromDateSting:dealDateString];
    
    if ([displaySwitch isOn]) {
        NSString *tempCurrentDealNameString = [NSString stringWithFormat:@"%@ 1)", dealNameString];
        NSDictionary *currentDataDic = [self makeDealDictionaryWithName:tempCurrentDealNameString Left:accountLeftId Right:accountRightId
                                                                    Tag:dealTagTarget Description:dealDescriptionString DateString:dealDateString Price:dealPrice];
        [self writeToDB:currentDataDic Table:@"Deal"];
    }
    
    for (NSInteger index = 1; index < repeatCount; index++) {
        NSString *tempDealNameString = [NSString stringWithFormat:@"%@", dealNameString];
        if ([displaySwitch isOn])
            tempDealNameString = [NSString stringWithFormat:@"%@ %ld)", dealNameString, (long)index + 1];
        NSInteger tag_target = [ETAccountUtility getTagFromViewController:self];
        [super saveTagsWithTargetId:tag_target];
        
        NSTimeInterval timeInterval = [self timeIntervalWithIndex:index];
        NSDate *tempDate = [initDealDate dateByAddingTimeInterval:timeInterval];
        NSString *tempDealDateString = [ETFormatter dateStringForDeal:tempDate];
        
        NSDictionary *dataDic = [self makeDealDictionaryWithName:tempDealNameString Left:accountLeftId Right:accountRightId
                                                             Tag:tag_target Description:dealDescriptionString DateString:tempDealDateString Price:dealPrice];
        
        [self addDeal:dataDic];
    }
}


#pragma mark - Common Methods

- (NSTimeInterval)timeIntervalWithIndex:(NSInteger)index
{
    NSTimeInterval timeInterval;
    
    switch ([periodSegmentedControl selectedSegmentIndex]) {
        case PERIOD_DAILY:
            timeInterval = 60 * 60 * 24 * index;
            break;
        case PERIOD_WEEKLY:
            timeInterval = 60 * 60 * 24 * 7 * index;
            break;
        case PERIOD_MONTHLY:
            timeInterval = 60 * 60 * 24 * 30 * index;
            break;
        case PERIOD_ANNUALLY:
            timeInterval = 60 * 60 * 24 * 365 * index;
            break;
            
        default:
            break;
    }
    
    return timeInterval;
}

- (NSDictionary *)makeDealDictionaryWithName:(NSString *)dealName Left:(NSInteger)left Right:(NSInteger)right Tag:(NSInteger)tag Description:(NSString *)description DateString:(NSString *)dateString Price:(NSInteger)price
{
    NSArray *keyArray = [NSArray arrayWithObjects:@"name", @"account_id_1", @"account_id_2", @"tag_target_id", @"description", @"'date'", @"money", nil];
    
    NSArray *objectsArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"'%@'", dealName],
                             [NSNumber numberWithInteger:left], [NSNumber numberWithInteger:right],
                             [NSNumber numberWithInteger:tag],
                             [NSString stringWithFormat:@"'%@'", description],
                             [NSString stringWithFormat:@"'%@'", dateString],
                             [NSString stringWithFormat:@"%ld", (long)price], nil];
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
    
    return dataDic;
}

- (void)addDeal:(NSDictionary *)dataDic
{
    if (![ETAccountDBManager insertToTable:@"Deal" dataDictionary:dataDic]) {
        UIAlertController *errorAlertController = [ETUtility showAlert:@"ETAccount" Message:@"저장하지 못했습니다." atViewController:self withBlank:YES];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"확인", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        [errorAlertController addAction:cancelAction];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)modifyDeal:(NSDictionary *)dataDic
{
    if (![ETAccountDBManager updateToTable:@"Deal" dataDictionary:dataDic ToId:dealId]) {
        UIAlertController *errorAlertController = [ETUtility showAlert:@"ETAccount" Message:@"저장하지 못했습니다." atViewController:self withBlank:YES];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"확인", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        [errorAlertController addAction:cancelAction];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [pageSegmentedControl setSelectedSegmentIndex:[scrollView contentOffset].x / [scrollView frame].size.width];
}

@end
