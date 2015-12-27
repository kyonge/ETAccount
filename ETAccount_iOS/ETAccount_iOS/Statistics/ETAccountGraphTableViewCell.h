//
//  ETAccountGraphTableViewCell.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 27..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETAccountGraphView.h"

@interface ETAccountGraphTableViewCell : UITableViewCell {
    IBOutlet ETAccountGraphView *graphView;
}

@property (readwrite) ETAccountGraphView *graphView;

@end
