//
//  YCGenerateOrderSeparateLineCell.m
//  klook
//
//  Created by yancy.chen on 2019/11/22.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCGenerateOrderSeparateLineCell.h"
#import <Masonry.h>

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
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.paddingContentView);
        make.height.mas_equalTo(16);
    }];
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
        [self.separateLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(containerCellModel);
        }];
    }
}

@end
