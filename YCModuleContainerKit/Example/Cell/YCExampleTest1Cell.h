//
//  YCExampleTest1Cell.h
//  klook
//
//  Created by yancy.chen on 2020/1/7.
//  Copyright © 2020 klook. All rights reserved.
//

#import "YCPaddingTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YCExampleTest1CellActions <NSObject>

- (void)YCExampleTest1Cell_closeGiftCardCell;

@end

@interface YCExampleTest1Cell : YCPaddingTableViewCell

@property (nonatomic, strong) NSArray *wallets;

@end

NS_ASSUME_NONNULL_END
