//
//  ETAccountGraphInnerView.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 27..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountGraphInnerView.h"

@implementation ETAccountGraphDataItem

- (NSString *)description
{
    return [NSString stringWithFormat:@"itemIndex : %ld itemName : %@   itemRealValue: %ld  itemValue : %ld", (long)[self itemIndex], [self itemName], (long)[self itemRealValue], (long)[self itemValue]];
}

@end


@implementation ETAccountGraphInnerView

//+ (Class)layerClass {
//    return [CATiledLayer class];
//}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

#pragma mark - Private Methods

- (CGFloat)getAbsoluteLocationWithRelativeValue:(NSInteger)relativeValue
{
    CGFloat standardHeight = CGRectGetHeight(self.bounds) - 20;
    
    return (standardHeight - 20) * (100 - relativeValue) / 100.0 + 20;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = [self gridLineWidth];
    [[self gridLineColor] setStroke];
    
    [path moveToPoint:CGPointMake(20.0, 0.0)];
    [path addLineToPoint:CGPointMake(20.0, height)];
    [path stroke];
    
    CGFloat locationYZero = [self getAbsoluteLocationWithRelativeValue:[self zeroPositionX]];
    [path moveToPoint:CGPointMake(0.0, locationYZero)];
    [path addLineToPoint:CGPointMake(width, locationYZero)];
    [path stroke];
    
    switch ([self graphKind]) {
        case ETACCOUNT_GRAPH_KIND_SQUARE: {
//            NSLog(@"%ld -> %f", (long)[self zeroPositionX], locationYZero);
            for (ETAccountGraphDataItem *item in [self graphInnerDataArray]) {
//                NSLog(@"item : %@", item);
                NSInteger index = [[self graphInnerDataArray] indexOfObject:item];
                CGFloat locationY = [self getAbsoluteLocationWithRelativeValue:[item itemValue]];
//                NSLog(@"%ld -> %f", (long)[item itemValue], locationY);
                
                UIBezierPath *path;
                [[item itemColor] setFill];
                CGFloat relativeLocationX = 40.0 + 40.0 * index;
                
                if (locationYZero < locationY) {
                    path = [UIBezierPath bezierPathWithRect:CGRectMake(relativeLocationX, locationYZero, 20, locationY - locationYZero)];
                }
                else {
                    path = [UIBezierPath bezierPathWithRect:CGRectMake(relativeLocationX, locationY, 20, locationYZero - locationY)];
                }
                [path fill];
                
                UILabel *nameLabel = [[UILabel alloc] init];
                [nameLabel setTextAlignment:NSTextAlignmentCenter];
                [nameLabel setFont:[UIFont systemFontOfSize:8]];
                [nameLabel setText:[item itemName]];
                [nameLabel sizeToFit];
                
                UILabel *priceLabel = [[UILabel alloc] init];
                [priceLabel setTextAlignment:NSTextAlignmentCenter];
                [priceLabel setFont:[UIFont systemFontOfSize:8]];
                [priceLabel setText:[ETFormatter moneyFormatFromString:[NSString stringWithFormat:@"%ld", (long)[item itemRealValue]]]];
                [priceLabel sizeToFit];
                
                CGFloat nameLabelWidth = [nameLabel frame].size.width;
                CGFloat nameLabelHeight = [nameLabel frame].size.height;
                
                CGFloat priceLabelWidth = [priceLabel frame].size.width;
                CGFloat priceLabelHeight = [priceLabel frame].size.height;
                
                if (locationY > locationYZero) [nameLabel setFrame:CGRectMake(relativeLocationX + 10 - nameLabelWidth / 2, locationY + nameLabelHeight, nameLabelWidth, nameLabelHeight)];
                else [nameLabel setFrame:CGRectMake(relativeLocationX + 10 - nameLabelWidth / 2, locationY - priceLabelHeight - nameLabelHeight, nameLabelWidth, nameLabelHeight)];
                [self addSubview:nameLabel];
                
                if (locationY > locationYZero) [priceLabel setFrame:CGRectMake(relativeLocationX + 10 - priceLabelWidth / 2, locationY, priceLabelWidth, priceLabelHeight)];
                else [priceLabel setFrame:CGRectMake(relativeLocationX + 10 - priceLabelWidth / 2, locationY - priceLabelHeight, priceLabelWidth, priceLabelHeight)];
                [self addSubview:priceLabel];
            }
            break;
            
        case ETACCOUNT_GRAPH_KIND_LINE: {
            for (ETAccountGraphDataItem *item in [self graphInnerDataArray]) {
//                NSLog(@"item : %@", item);
                NSInteger absoluteIndex = [[self graphInnerDataArray] indexOfObject:item];
                NSInteger index = [item itemIndex];
                CGFloat locationY = [self getAbsoluteLocationWithRelativeValue:[item itemValue]];
//                NSLog(@"%ld -> %f", (long)[item itemValue], locationY);
                
                if (absoluteIndex < [[self graphInnerDataArray] count] - 1) {
                    NSInteger nextIndex = [[[self graphInnerDataArray] objectAtIndex:absoluteIndex + 1] itemIndex];
                    if (index == nextIndex)
                        continue;
                }
                
                UIBezierPath *path;path = [UIBezierPath bezierPath];
                [path setLineWidth:1.0];
                [[item itemColor] setStroke];
                CGFloat relativeLocationX = 40.0 + 40.0 * index;
                
                [path setLineCapStyle:kCGLineCapRound];
                
                UIButton *pointButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [pointButton setBackgroundColor:[item itemColor]];
                [pointButton setFrame:CGRectMake(relativeLocationX + 8.0, locationY - 2.0, 4.0, 4.0)];
                [pointButton setTag:index];
                [self addSubview:pointButton];
                
                if (index == 0) {
                    lastStrokePoint = CGPointMake(relativeLocationX + 10.0, locationY);
                    [path moveToPoint:lastStrokePoint];
                }
                else {
                    [path moveToPoint:lastStrokePoint];
                    lastStrokePoint = CGPointMake(relativeLocationX + 10.0, locationY);
                    [path addLineToPoint:lastStrokePoint];
                    [path stroke];
                }
                
                UILabel *nameLabel = [[UILabel alloc] init];
                [nameLabel setTextAlignment:NSTextAlignmentCenter];
                [nameLabel setFont:[UIFont systemFontOfSize:8]];
                [nameLabel setText:[item itemName]];
                [nameLabel sizeToFit];
                
                UILabel *priceLabel = [[UILabel alloc] init];
                [priceLabel setTextAlignment:NSTextAlignmentCenter];
                [priceLabel setFont:[UIFont systemFontOfSize:8]];
                [priceLabel setText:[ETFormatter moneyFormatFromString:[NSString stringWithFormat:@"%ld", (long)[item itemRealValue]]]];
                [priceLabel sizeToFit];
                
                CGFloat nameLabelWidth = [nameLabel frame].size.width;
                CGFloat nameLabelHeight = [nameLabel frame].size.height;
                
                CGFloat priceLabelWidth = [priceLabel frame].size.width;
                CGFloat priceLabelHeight = [priceLabel frame].size.height;
                
                if (locationY > locationYZero) [nameLabel setFrame:CGRectMake(relativeLocationX + 10 - nameLabelWidth / 2, locationY + nameLabelHeight, nameLabelWidth, nameLabelHeight)];
                else [nameLabel setFrame:CGRectMake(relativeLocationX + 10 - nameLabelWidth / 2, locationY - priceLabelHeight - nameLabelHeight, nameLabelWidth, nameLabelHeight)];
                [self addSubview:nameLabel];
                
                if (locationY > locationYZero) [priceLabel setFrame:CGRectMake(relativeLocationX + 10 - priceLabelWidth / 2, locationY, priceLabelWidth, priceLabelHeight)];
                else [priceLabel setFrame:CGRectMake(relativeLocationX + 10 - priceLabelWidth / 2, locationY - priceLabelHeight, priceLabelWidth, priceLabelHeight)];
                [self addSubview:priceLabel];
            }
            break;
        }
            
        default:
            break;
        }
    }
}


#pragma mark 초기화

- (void)setDefaults
{
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = YES;
    
    self.gridLineWidth = 0.5;
    self.gridLineColor = [UIColor blueColor];
}

@end
