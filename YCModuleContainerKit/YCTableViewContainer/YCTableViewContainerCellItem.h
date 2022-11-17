//
//  YCTableViewContainerCellItem.h
//  klook
//
//  Created by yancy.chen on 2019/8/1.
//  Copyright © 2019 klook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCTableViewContainerCellItem;

NS_ASSUME_NONNULL_BEGIN

typedef void(^kTableViewCellSettingHandler)(UITableViewCell *cell);
typedef void(^kTableViewCellSettingHandler2)(UITableViewCell *cell, YCTableViewContainerCellItem *cellItem);

@interface YCTableViewContainerCellItem : NSObject

#pragma mark - 构造 SectionItem 需要传的属性

/// 以下为 @required 必传属性

/// Data 部分
@property (nonatomic, strong) id model; ///< 数据 Model


/// UI 部分
@property (nonatomic, strong) Class cellClass; ///< Cell 类
@property (nonatomic, copy  ) NSString *cellTag; ///< cell 唯一标识 （用于区分相同 CellClass 在不同的 index 时数据渲染）
@property (nonatomic, assign) CGFloat cellHeight; ///< Cell高度

@property (nonatomic, copy  ) kTableViewCellSettingHandler cellSetting;

@property (nonatomic, copy  ) kTableViewCellSettingHandler2 cellSetting2;

/// 以下为 @optional 可选属性

@property (nonatomic, assign) UIEdgeInsets cellEdgeInsets;

//- (instancetype)init NS_UNAVAILABLE;
//+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)itemWithModel:(id)model
                         cell:(Class)cell
                          tag:(NSString *)tag;

+ (instancetype)itemWithCellSettingHandler:(kTableViewCellSettingHandler)cellSetting
                                 cellClass:(Class)cellClass
                                       tag:(NSString *)tag;

+ (instancetype)itemWithCellSettingHandler2:(kTableViewCellSettingHandler2)cellSetting
                                  cellClass:(Class)cellClass
                                        tag:(NSString *)tag;

- (instancetype)initWithDataModel:(id)dataModel
                        cellClass:(Class)cellClass
                          cellTag:(NSString *)cellTag;

#pragma mark - 给 BaseContainerManager 使用

- (void)registerCellForTableView:(UITableView *)tableView;

- (UITableViewCell *)dequeueTableViewCellWithIndexPath:(NSIndexPath *)indexPath
                                             tableView:(UITableView *)tableView;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
                         tableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
