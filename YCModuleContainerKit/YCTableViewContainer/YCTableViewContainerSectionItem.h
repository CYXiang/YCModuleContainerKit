//
//  YCTableViewContainerSectionItem.h
//  klook
//
//  Created by yancy.chen on 2019/8/1.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCTableViewContainerCellItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTableViewContainerSectionItem : NSObject

#pragma mark - 构造 SectionItem 需要传的属性

/// 以下为 @required 必传属性

/// ViewModel 部分
@property (nonatomic, strong) NSArray<YCTableViewContainerCellItem *> *itemArray; // 数据 Model<NSArray>

/// UI 部分
@property (nonatomic, copy  ) NSString *sectionTag; // section 唯一标识 （用于区分相同 CellClass 在不同的 Section 时数据渲染）
@property (nonatomic, assign) CGFloat sectionHeight; ///< section高度

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithItemArray:(NSArray<YCTableViewContainerCellItem *> *)itemArray
                       sectionTag:(NSString *)sectionTag;

/// 以下为 @optional 可选属性

//@property (nonatomic, copy  , nullable) NSString *headerViewClassStr; // headerViewClassStr 类名
@property (nonatomic, strong, nullable) id information;  ///< 附加信息，可选使用

#pragma mark - 给 BaseContainerManager 使用
- (void)registerSectionCellForTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
