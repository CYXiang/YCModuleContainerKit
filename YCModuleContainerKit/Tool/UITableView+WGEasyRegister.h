//
//  UITableView+WGEasyRegister.h
//  WeAblum
//
//  Created by Yancy Chen on 2022/11/7.
//  Copyright © 2022 WeAblum. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (WGEasyRegister)

- (void)registerNibClass:(Class)cellClass;

- (void)registerClass:(Class)cellClass;

- (void)configureHeaderFooterView;

- (BOOL)isVaildRangForIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)iOS10EstimatedHeightCheck:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
