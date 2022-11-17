//
//  YCExampleTest1Cell.m
//  klook
//
//  Created by yancy.chen on 2020/1/7.
//  Copyright © 2020 klook. All rights reserved.
//

#import "YCExampleTest1Cell.h"
#import "UIResponder+WGRouter.h"
#import <Masonry.h>

@interface YCExampleTest1Cell ()

@property (nonatomic, assign) CGFloat containerWidth;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) NSMutableArray *walletButtons;
@property (nonatomic, strong) NSMutableArray *separatViews;
@property (nonatomic, strong) UIView *lastView;

@end

@implementation YCExampleTest1Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self installViews];
    return self;
}

- (void)installViews
{
    self.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.containerWidth = [UIScreen mainScreen].bounds.size.width-2*16;
    self.backgroundColor = [UIColor grayColor];
    [self.paddingContentView addSubview:self.containerView];
    [self.containerView addSubview:self.giftImageView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.closeButton];
    [self.containerView addSubview:self.detailLabel];
    
    self.closeButton.frame = CGRectMake(self.containerWidth-8-24, 8, 24, 24);
    self.giftImageView.frame = CGRectMake(16, 22, 24, 24);
    
    NSString *title = @"礼品卡";
    self.titleLabel.text = title;
    CGFloat maxTitleWidth = self.containerWidth-40-48;
    CGSize titleSize = [title sizeWithFont:self.titleLabel.font];
    self.titleLabel.frame = CGRectMake(40, 24, maxTitleWidth, titleSize.height);
    CGFloat containerViewHeight = CGRectGetMaxY(self.titleLabel.frame)+16;
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.paddingContentView);
        make.height.equalTo(@(containerViewHeight));
    }];
}

- (void)updateViews
{
    if (self.wallets.count == 1) {
        self.detailLabel.text = @"You have HKD 1,000 Gift Cards. For using Cash Credit, you need to switch your payment currency from VND to HKD.";
    } else if (self.wallets.count > 1) {
        self.detailLabel.text = @"礼品卡";
    }
    CGFloat detailLabelWidth = self.containerWidth-2*16;
    CGSize detailSize = [self.detailLabel.text sizeWithFont:self.detailLabel.font];
    self.detailLabel.frame = CGRectMake(16, CGRectGetMaxY(self.titleLabel.frame)+10, detailLabelWidth, detailSize.height);
    self.lastView = self.detailLabel;
    
    for (UIView *walletBtn in self.walletButtons) {
        [walletBtn removeFromSuperview];
    }
    [self.walletButtons removeAllObjects];
    for (UIView *view in self.separatViews) {
        [view removeFromSuperview];
    }
    [self.separatViews removeAllObjects];
    
    CGFloat containerViewHeight = CGRectGetMaxY(self.lastView.frame)+24;
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(containerViewHeight));
    }];
    
}


- (void)tapCloseButton
{
    [self routerEventWithResponderTarget:self.responseAgent eventName:NSStringFromSelector(@selector(YCExampleTest1Cell_closeGiftCardCell)) userInfo:nil];
}

#pragma mark - Setter

- (void)setWallets:(NSArray *)wallets
{
    _wallets = wallets;
    [self updateViews];
}

#pragma mark - Getter

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIImageView *)giftImageView
{
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_giftcard_cash"]];
    }
    return _giftImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor yellowColor];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont  systemFontOfSize:14];
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_closeButton setImage:[[UIImage imageNamed:@"ico_close_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(tapCloseButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (NSMutableArray *)walletButtons
{
    if (!_walletButtons) {
        _walletButtons = [NSMutableArray array];
    }
    return _walletButtons;
}

- (NSMutableArray *)separatViews
{
    if (!_separatViews) {
        _separatViews = [NSMutableArray array];
    }
    return _separatViews;
}

- (void)addSubview:(UIView *)view
{
    //如果是_UITableViewCellSeparatorView就不让添加
    if (![view isKindOfClass:[NSClassFromString(@"_UITableViewCellSeparatorView") class]] && view)
    {
        [super addSubview:view];
    }
}

#pragma mark - YCBaseContainerTableViewCellProtocol

- (void)setContainerCellModel:(id)containerCellModel {

    self.wallets = containerCellModel;
}

@end
