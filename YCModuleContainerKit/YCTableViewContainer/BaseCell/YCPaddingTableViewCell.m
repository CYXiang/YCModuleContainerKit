//
//  YCPaddingTableViewCell.m
//  klook
//
//  Created by yancy.chen on 2019/8/5.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCPaddingTableViewCell.h"
#import "UITableView+WGEasyRegister.h"

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
        self.paddingContentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
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
    
    self.paddingContentView.frame = CGRectMake(insets.left, insets.top, self.contentView.frame.size.width - insets.left - insets.right, self.contentView.frame.size.height + insets.top + insets.bottom);
}

- (void)responseTarget:(id)sectionAgent {
    if (sectionAgent) {
        self.responseAgent = sectionAgent;
    }
}

@end
