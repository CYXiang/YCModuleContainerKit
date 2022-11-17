//
//  YCPaddingTableViewCell.m
//  klook
//
//  Created by yancy.chen on 2019/8/5.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCPaddingTableViewCell.h"
#import "UITableView+WGEasyRegister.h"
#import <Masonry.h>

@interface YCPaddingTableViewCell ()

@property (nonatomic, weak  ) id responseAgent;

@end

@implementation YCPaddingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.paddingContentView];
        
        [self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UIView *)paddingContentView {
    if (!_paddingContentView) {
        _paddingContentView = [UIView new];
        _paddingContentView.backgroundColor = [UIColor whiteColor];
    }
    return _paddingContentView;
}

#pragma mark -YCBaseContainerTableViewCellProtocol

- (void)yc_registerCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[self class]];
}

- (void)setContainerCellModel:(id)containerCellModel {
    // 子类实现
}

- (void)setCellEdgeInsets:(UIEdgeInsets)insets {
    _paddingViewEdge = insets;
    
    [self.paddingContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(insets.top);
        make.left.equalTo(self.contentView).offset(insets.left);
        make.right.equalTo(self.contentView).offset(-insets.right);
        make.bottom.equalTo(self.contentView).offset(-insets.bottom);
    }];
}

- (void)responseTarget:(id)sectionAgent {
    if (sectionAgent) {
        self.responseAgent = sectionAgent;
    }
}

@end
