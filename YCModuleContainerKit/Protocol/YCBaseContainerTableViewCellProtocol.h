//
//  YCBaseContainerTableViewCellProtocol.h
//  klook
//
//  Created by yancy.chen on 2019/7/29.
//  Copyright © 2019 klook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCBaseContainerCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YCBaseContainerTableViewCellProtocol <YCBaseContainerCellProtocol>

@optional

// 注册 Cell 到 UITableView 中 (如果是Nib的Cell必须实现这个方法)
- (void)yc_registerCellForTableView:(UITableView *)tableView;

// 设置 Insets
- (void)setCellEdgeInsets:(UIEdgeInsets)insets;

/// 这个方法在 heightForRowAtIndexPath 阶段调用
- (CGFloat)yc_customRowHeightWithModel:(id)containerCellModel;

/// 获取Cell高度，这个方法在注册Cell的阶段调用，提前存储Cell高度用于定位
- (CGFloat)yc_getRowHeight:(id)containerCellModel;

// 事件响应处理对象（不设则默认是 pageAgent）
- (void)responseTarget:(id)sectionAgent;

// Cell tag 用于关联数据和事件
@property (nonatomic, copy) NSString *cellTag;

@end

NS_ASSUME_NONNULL_END
