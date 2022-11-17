//
//  YCGenerateOrderSeparateLineCell.m
//  klook
//
//  Created by yancy.chen on 2019/11/22.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCGenerateOrderSeparateLineCell.h"

@interface YCGenerateOrderSeparateLineCell ()

@property (nonatomic, strong) UIView *separateLine;

@end

@implementation YCGenerateOrderSeparateLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupContent];
    }
    return self;
}

- (void)setupContent {
    [self.paddingContentView addSubview:self.separateLine];
    self.separateLine.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 16);
}

- (UIView *)separateLine {
    if (!_separateLine) {
        _separateLine = [UIView new];
        _separateLine.backgroundColor = [UIColor greenColor];
    }
    return _separateLine;
}

- (void)setContainerCellModel:(id)containerCellModel {
    if ([containerCellModel isKindOfClass:[NSNumber class]]) {
        NSNumber *num = containerCellModel;
        self.separateLine.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, num.floatValue);
    }
}

@end
