//
//  UITableView+WGEasyRegister.m
//  WeAblum
//
//  Created by Yancy Chen on 2022/11/7.
//  Copyright © 2022 WeAblum. All rights reserved.
//

#import "UITableView+WGEasyRegister.h"

@implementation UITableView (WGEasyRegister)

- (void)registerNibClass:(Class)cellClass
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil];
    
    [self registerNib:nib forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)registerClass:(Class)cellClass
{
    [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)configureHeaderFooterView
{
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, 0, CGFLOAT_MIN);
    self.tableHeaderView = headerView;

    UIView *footerView = [UIView new];
    footerView.frame = CGRectMake(0, 0, 0, CGFLOAT_MIN);
    self.tableFooterView = footerView;
}

- (BOOL)isVaildRangForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.numberOfSections) {
        return NO;
    }
    if (indexPath.row >= [self numberOfRowsInSection:indexPath.section]) {
        return NO;
    }
    return YES;
}

- (CGFloat)iOS10EstimatedHeightCheck:(CGFloat)height {
    // iOS10 预估高度小值1时会Carsh
    if (@available(iOS 11.0, *)) return height;
    if (@available(iOS 10.0, *)) {
        height = height < 1.0f ? 1.1 : height;
    }
    return height;
}

@end
