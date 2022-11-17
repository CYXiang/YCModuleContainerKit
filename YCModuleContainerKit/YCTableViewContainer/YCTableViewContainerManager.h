//
//  YCTableViewContainerManager.h
//  klook
//
//  Created by yancy.chen on 2019/8/1.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCTableViewContainerSectionItem.h"

@class YCTableViewContainerManager;

NS_ASSUME_NONNULL_BEGIN

@protocol YCTableViewContainerDataSource <NSObject>

@required

- (NSMutableArray<YCTableViewContainerSectionItem *> *)configTableContainerWithSectionItems;

@end

@protocol YCTableViewContainerDelegate <NSObject, UITableViewDelegate>

@optional

- (void)containerManager:(YCTableViewContainerManager *)containerManager
           didSelectItem:(YCTableViewContainerSectionItem *)sectionItem
              atRowIndex:(NSInteger)rowIndex;

@end


@interface YCTableViewContainerManager : NSObject

@property (nonatomic, weak  ) id<YCTableViewContainerDataSource> dataSource;
@property (nonatomic, weak  ) id<YCTableViewContainerDelegate> delegate;

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) NSMutableArray<YCTableViewContainerSectionItem *> *sectionItemArray;

#pragma mark - 更新视图相关方法

- (void)tableViewContainerReloadData;

/**
 * 刷新指定 Section 中的数据
 * @param cellItems 需要刷新的 Cell
 * @param sectionTag 所属 Section Tag
 * @param rowAnimation 刷新动画
 * @param cancelAnimation 是否强制关闭动画
 */
- (void)reloadSectionWithCellItems:(NSArray<YCTableViewContainerCellItem *> *)cellItems
                        sectionTag:(NSString *)sectionTag
                      rowAnimation:(UITableViewRowAnimation)rowAnimation
                   cancelAnimation:(BOOL)cancelAnimation;

/**
 * 刷新指定 Sections 中的数据
 * @param sectionItems 需要刷新的 Sections
 * @param sectionsTag 需要刷新的 Section tag 列表
 * @param rowAnimation 刷新动画
 * @param cancelAnimation 是否强制关闭动画
 */
- (void)reloadSectionWithSectionItems:(NSArray<YCTableViewContainerSectionItem *> *)sectionItems
                          sectionsTag:(NSArray<NSString *> *)sectionsTag
                         rowAnimation:(UITableViewRowAnimation)rowAnimation
                      cancelAnimation:(BOOL)cancelAnimation;

/**
 * 下面这两个刷新方法使用 rowAnimation 的动画作为刷新动画
 */
- (void)reloadSectionWithCellItems:(NSArray<YCTableViewContainerCellItem *> *)cellItems
                        sectionTag:(NSString *)sectionTag
                      rowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)reloadSectionWithSectionItems:(NSArray<YCTableViewContainerSectionItem *> *)sectionItems
                          sectionsTag:(NSArray<NSString *> *)sectionsTag
                         rowAnimation:(UITableViewRowAnimation)rowAnimation;

/**
 * 下面这两个刷新方法默认关闭动画
 */
- (void)reloadSectionWithCellItems:(NSArray<YCTableViewContainerCellItem *> *)cellItems
                        sectionTag:(NSString *)sectionTag;

- (void)reloadSectionWithSectionItems:(NSArray<YCTableViewContainerSectionItem *> *)sectionItems
                          sectionsTag:(NSArray<NSString *> *)sectionsTag;

/**
  * 使用 models 替换 Section Tag 下 Section 的 Cell 的数据
  * 并且只更新 updatedTags 保存的下的 Cell Tag 的 Cell
  *
  * - 这里会触发批量更新
  *   1. 首先根据 models 以及 Section Tag 下 Section 的 itemArray 计算出所有差异
  *   2. 去掉 Cell Tag 不在 updatedTags 中的数据
  *   3. 完成更新
  *
  * @param models 最终结果 models，也就是刷新完成后，Section 最终数据结果
  * @param updatedTags 实际需要产生变化的 tags
  * @param sectionTag 所属 section  tag
  * @param rowAnimation 刷新动画
  */
- (void)batchUpdateCellsDataWithNewModels:(NSArray *)models
                              updatedTags:(NSArray *)updatedTags
                             inSectionTag:(NSString *)sectionTag
                             rowAnimation:(UITableViewRowAnimation)rowAnimation;

/// 刷新指定数据对应的cells
/// @param models 数据源
/// @param updatedTag
/// @param sectionTag
/// @param rowAnimation
/// @param withoutAnimation  NO: 表示使用默认动画，YES：表示强制关闭动画
- (void)batchUpdateCellsDataWithNewModels:(NSArray *)models
                              updatedTags:(NSArray *)updatedTags
                             inSectionTag:(NSString *)sectionTag
                             rowAnimation:(UITableViewRowAnimation)rowAnimation
                         withoutAnimation:(BOOL)withoutAnimation;

#pragma mark - 动态操作视图Section相关方法

/**
 动态插入一个 Section （注意处理数组越界问题）
 
 @param sectionItem 模块Item
 @param sectionIndex 位置Index
 */
- (void)insertSectionWithSectionItem:(YCTableViewContainerSectionItem *)sectionItem
                        sectionIndex:(NSInteger)sectionIndex;

/**
 动态在 sectionTag 上方插入一个 Section
 */
- (void)insertSectionWithSectionItem:(YCTableViewContainerSectionItem *)sectionItem
                     aboveSectionTag:(NSString *)sectionTag;

/**
 动态在 sectionTag 下方插入一个 Section
 */
- (void)insertSectionWithSectionItem:(YCTableViewContainerSectionItem *)sectionItem
                     underSectionTag:(NSString *)sectionTag;

/**
 动态移除指定 Section
 */
- (void)removeSectionWithSectionTag:(NSString *)sectionTag;

#pragma mark - 其他

/**
 滚动到指定 Cell
 */
- (void)scrollToCellWithSectionTag:(NSString *)sectionTag
                           cellTag:(NSString *)cellTag
                  atScrollPosition:(UITableViewScrollPosition)scrollPosition
                          animated:(BOOL)animated;


/// 获取SectionIndex
- (NSInteger)findIndexWithSectionTag:(NSString *)sectionTag;

/// 获取指定cell的IndexPath
- (nullable NSIndexPath *)findIndexPathWithSectionTag:(NSString *)sectionTag cellTag:(NSString *)cellTag;

/// 获取指定Cell的实例
- (nullable UITableViewCell *)findTableViewCellWithSectionTag:(NSString *)sectionTag cellTag:(NSString *)cellTag;


@end

NS_ASSUME_NONNULL_END
