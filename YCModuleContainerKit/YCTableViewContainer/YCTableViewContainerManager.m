//
//  YCTableViewContainerManager.m
//  klook
//
//  Created by yancy.chen on 2019/8/1.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCTableViewContainerManager.h"
#import "UITableView+WGEasyRegister.h"

@implementation NSArray (BoundSafe)

- (nullable id)yc_objectAtIndex:(NSInteger)index {
    if (index + 1 > (NSInteger)self.count || index < 0) {
        return nil;
    }
    return self[index];
}

@end

@interface YCTableViewContainerManager ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<YCTableViewContainerSectionItem *> *sectionItemArray;
@property (nonatomic, strong) NSMutableDictionary *cellHeightsDictionary; ///< 用于缓存Cell高度字典

@end


@implementation YCTableViewContainerManager

- (void)tableViewContainerReloadData {
    
    if ([self.dataSource respondsToSelector:@selector(configTableContainerWithSectionItems)]) {
        NSArray<YCTableViewContainerSectionItem *> *items = [self.dataSource configTableContainerWithSectionItems];
        
        [self.sectionItemArray removeAllObjects];
        [self.sectionItemArray addObjectsFromArray:[self checkSectionItemsValid:items]];
        
        // 统一注册 Cell
        for (YCTableViewContainerSectionItem *sectionItem in items) {
            [sectionItem registerSectionCellForTableView:self.tableView];
        }
        
        [self.tableView reloadData];
        
        for (NSInteger i = 0; i<items.count; i++) {
            YCTableViewContainerSectionItem *sectionItem = items[i];
            for (NSInteger j = 0; j<sectionItem.itemArray.count; j++) {
                YCTableViewContainerCellItem *cellItem = sectionItem.itemArray[j];
                [cellItem dequeueTableViewCellWithIndexPath:[NSIndexPath indexPathForRow:j inSection:i] tableView:self.tableView];
            }
        }
        
    } else {
        NSAssert(NO, @"需要实现 configTableContainerWithSectionItems 方法");
    }
}

- (NSArray<YCTableViewContainerSectionItem *> *)checkSectionItemsValid:(NSArray<YCTableViewContainerSectionItem *> *)sections {
    if (!sections.count) {
        return [NSArray array];
    }
#if DEBUG
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:sections.count];
    for (YCTableViewContainerSectionItem *section in sections) {
        NSAssert([section isKindOfClass:YCTableViewContainerSectionItem.class], @"存在非 YCTableViewContainerSectionItem 实例");
        NSAssert(section.sectionTag.length, @"setionTag 不能为空值！！！");
        NSAssert(![array containsObject:section.sectionTag], @"setionTag 重复: %@", section.sectionTag);
        [array addObject:section.sectionTag];
    }
    return sections;
#else
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:sections.count];
    for (YCTableViewContainerSectionItem *section in sections) {
        // 过滤无效 Section
        if ([section isKindOfClass:YCTableViewContainerSectionItem.class]) {
            [array addObject:section];
        }
    }
    return [array copy];
#endif
 
}

/**
 刷新指定 Section 数据
 */
- (void)reloadSectionWithCellItems:(NSArray<YCTableViewContainerCellItem *> *)cellItems
                        sectionTag:(NSString *)sectionTag {
    [self reloadSectionWithCellItems:cellItems
                          sectionTag:sectionTag
                        rowAnimation:UITableViewRowAnimationAutomatic
                     cancelAnimation:YES];
}

- (void)reloadSectionWithCellItems:(NSArray<YCTableViewContainerCellItem *> *)cellItems
                        sectionTag:(NSString *)sectionTag
                      rowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self reloadSectionWithCellItems:cellItems
                          sectionTag:sectionTag
                        rowAnimation:rowAnimation
                     cancelAnimation:NO];
}

- (void)reloadSectionWithCellItems:(NSArray<YCTableViewContainerCellItem *> *)cellItems
                        sectionTag:(NSString *)sectionTag
                      rowAnimation:(UITableViewRowAnimation)rowAnimation
                   cancelAnimation:(BOOL)cancelAnimation {
    NSInteger sectionNum = -1;
    YCTableViewContainerSectionItem *item = nil;
    
    for (NSInteger i = 0; i < self.sectionItemArray.count; i++) {
        item = self.sectionItemArray[i];
        if ([item.sectionTag isEqualToString:sectionTag]) {
            item.itemArray = cellItems;
            sectionNum = i;
            break;
        }
    }

    if (sectionNum == -1) {
        NSAssert(NO, @"没有找到 sectionTag : %@",sectionTag);
    } else {
        for (YCTableViewContainerCellItem *sectionItem in cellItems) {
            [sectionItem registerCellForTableView:self.tableView];
        }
        if (cancelAnimation) {
            [UIView performWithoutAnimation:^{
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionNum] withRowAnimation:rowAnimation];
            }];
        } else {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionNum] withRowAnimation:rowAnimation];
        }
    }
}

- (void)reloadSectionWithSectionItems:(NSArray<YCTableViewContainerSectionItem *> *)sectionItems
                          sectionsTag:(NSArray<NSString *> *)sectionsTag {
    [self reloadSectionWithSectionItems:sectionItems
                            sectionsTag:sectionsTag
                           rowAnimation:UITableViewRowAnimationFade
                        cancelAnimation:YES];
}

- (void)reloadSectionWithSectionItems:(NSArray<YCTableViewContainerSectionItem *> *)sectionItems
                          sectionsTag:(NSArray<NSString *> *)sectionsTag
                         rowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self reloadSectionWithSectionItems:sectionItems
                            sectionsTag:sectionsTag
                           rowAnimation:rowAnimation
                        cancelAnimation:NO];
}


- (void)reloadSectionWithSectionItems:(NSArray<YCTableViewContainerSectionItem *> *)sectionItems
                          sectionsTag:(NSArray<NSString *> *)sectionsTag
                         rowAnimation:(UITableViewRowAnimation)rowAnimation
                      cancelAnimation:(BOOL)cancelAnimation {
    NSMutableArray *sectionsArray = [NSMutableArray array];
        
    for (NSInteger i = 0; i < sectionsTag.count; i ++) {
        NSString *sectionTag = sectionsTag[i];
        for (NSInteger j = 0; j < self.sectionItemArray.count; j++) {
            YCTableViewContainerSectionItem *item = self.sectionItemArray[j];
            if ([item.sectionTag isEqualToString:sectionTag]) {
                [sectionsArray addObject:@(j)];
                for (YCTableViewContainerSectionItem *newItem in sectionItems) {
                    if ([newItem.sectionTag isEqualToString:sectionTag]) {
                        [self.sectionItemArray replaceObjectAtIndex:j withObject:newItem];
                    }
                }
                break;
            }
        }
    }

    if (sectionsArray.count == 0) {
        NSAssert(NO, @"没有找到 sectionTag : %@",sectionsTag);
    } else {
        for (YCTableViewContainerSectionItem *sectionItem in sectionItems) {
            [sectionItem registerSectionCellForTableView:self.tableView];
        }
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (NSNumber *index in sectionsArray) {
            [set addIndex:index.integerValue];

        }
        if (cancelAnimation) {
            [UIView performWithoutAnimation:^{
                [self.tableView reloadSections:set withRowAnimation:rowAnimation];
            }];
        } else {
            [self.tableView reloadSections:set withRowAnimation:rowAnimation];
        }
    }
}

- (void)batchUpdateCellsDataWithNewModels:(NSArray *)models
                              updatedTags:(NSArray *)updatedTags
                             inSectionTag:(NSString *)sectionTag
                             rowAnimation:(UITableViewRowAnimation)rowAnimation
                         withoutAnimation:(BOOL)withoutAnimation {
    NSUInteger sectionIndex = NSNotFound;
    YCTableViewContainerSectionItem *sectionItem = [self sectionItemWithSectionTag:sectionTag outIndex:&sectionIndex];
    if (!sectionItem || sectionIndex == NSNotFound) {
        NSAssert(NO, @"没有找到 sectionTag : %@", sectionTag);
        return;
    }
    NSMutableArray *itemTagsToDelete = @[].mutableCopy;
    NSMutableArray *itemTagsToReplace = @[].mutableCopy;
    NSMutableArray *itemTagsToAdd = @[].mutableCopy;
    NSMutableArray *indexPathesToDelete = @[].mutableCopy;
    NSMutableArray *indexPathesToReplace = @[].mutableCopy;
    NSMutableArray *indexPathesToAdd = @[].mutableCopy;
    NSMutableDictionary *itemTagDict = @{}.mutableCopy;
    for (YCTableViewContainerCellItem *cellItem in models) {
        if (cellItem.cellTag.length == 0) {
            continue;
        }
        [itemTagsToAdd addObject:cellItem.cellTag];
        itemTagDict[cellItem.cellTag] = cellItem;
    }
    for (YCTableViewContainerCellItem *cellItem in sectionItem.itemArray) {
        YCTableViewContainerCellItem *itemInDict = itemTagDict[cellItem.cellTag];
        [itemTagsToAdd removeObject:cellItem.cellTag];
        if (itemInDict) {
            [itemTagsToReplace addObject:cellItem.cellTag];
        } else {
            [itemTagsToDelete addObject:cellItem.cellTag];
        }
    }
    // 参考 UITableView 的文档：
    // https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/TableView_iPhone/ManageInsertDeleteRow/ManageInsertDeleteRow.html
    // table view 在批量更新的时候，先 delete 和 reload，然后 insert
    // 所以 delete，reload 依赖 table view 原有的数据，insert 依赖新的数据
    for (YCTableViewContainerCellItem *cellItem in sectionItem.itemArray) {
        if (![updatedTags containsObject:cellItem.cellTag]) {
            continue;
        }
        if ([itemTagsToDelete containsObject:cellItem.cellTag]) {
            [indexPathesToDelete addObject:[NSIndexPath indexPathForRow:[sectionItem.itemArray indexOfObject:cellItem] inSection:sectionIndex]];
        }
        if ([itemTagsToReplace containsObject:cellItem.cellTag]) {
            [indexPathesToReplace addObject:[NSIndexPath indexPathForRow:[sectionItem.itemArray indexOfObject:cellItem] inSection:sectionIndex]];
        }
    }
    for (YCTableViewContainerCellItem *cellItem in models) {
        if (![updatedTags containsObject:cellItem.cellTag]) {
            continue;
        }
        if ([itemTagsToAdd containsObject:cellItem.cellTag]) {
            [indexPathesToAdd addObject:[NSIndexPath indexPathForRow:[models indexOfObject:cellItem] inSection:sectionIndex]];
        }
    }
    sectionItem.itemArray = models.copy;
    [sectionItem registerSectionCellForTableView:self.tableView];
    if (withoutAnimation) {
        [UIView performWithoutAnimation:^{
            // delete
            [self.tableView beginUpdates];
            
            [self.tableView deleteRowsAtIndexPaths:indexPathesToDelete withRowAnimation:rowAnimation];
            // add
            [self.tableView insertRowsAtIndexPaths:indexPathesToAdd withRowAnimation:rowAnimation];
            // replace
            [self.tableView reloadRowsAtIndexPaths:indexPathesToReplace withRowAnimation:rowAnimation];
            [self.tableView endUpdates];
        }];
    } else {
        // delete
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths:indexPathesToDelete withRowAnimation:rowAnimation];
        // add
        [self.tableView insertRowsAtIndexPaths:indexPathesToAdd withRowAnimation:rowAnimation];
        // replace
        [self.tableView reloadRowsAtIndexPaths:indexPathesToReplace withRowAnimation:rowAnimation];
        [self.tableView endUpdates];
    }
}

- (void)batchUpdateCellsDataWithNewModels:(NSArray *)models
                              updatedTags:(NSArray *)updatedTags
                             inSectionTag:(NSString *)sectionTag
                             rowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self batchUpdateCellsDataWithNewModels:models
                                updatedTags:updatedTags
                               inSectionTag:sectionTag
                               rowAnimation:rowAnimation
                           withoutAnimation:NO];
}

#pragma mark - 动态操作视图Section相关方法

/**
 动态插入一个 Section （注意处理数组越界问题）
 
 @param sectionItem 模块Item
 @param sectionIndex 位置Index
 */
- (void)insertSectionWithSectionItem:(YCTableViewContainerSectionItem *)sectionItem
                        sectionIndex:(NSInteger)sectionIndex {
    
    [sectionItem registerSectionCellForTableView:self.tableView];
    
    if (sectionIndex < 0) {
        sectionIndex = 0;
    }
    if (sectionIndex > self.sectionItemArray.count) {
        sectionIndex = self.sectionItemArray.count;
    }
    // 插入数据
    [self.sectionItemArray insertObject:sectionItem atIndex:sectionIndex];
    
    // 插入Section
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
}

/**
 动态在 sectionTag 上方插入一个 Section
 */
- (void)insertSectionWithSectionItem:(YCTableViewContainerSectionItem *)sectionItem
                     aboveSectionTag:(NSString *)sectionTag {
    
    NSInteger index = [self findIndexWithSectionTag:sectionTag];
    if (index == NSNotFound) {
        NSAssert(NO, @"请检查传入 sectionTag 是否存在！");
    } else {
        [self insertSectionWithSectionItem:sectionItem sectionIndex:(index - 1)];
    }
}

/**
 动态在 sectionTag 下方插入一个 Section
 */
- (void)insertSectionWithSectionItem:(YCTableViewContainerSectionItem *)sectionItem
                     underSectionTag:(NSString *)sectionTag {
    
    NSInteger index = [self findIndexWithSectionTag:sectionTag];
    if (index == NSNotFound) {
        NSAssert(NO, @"请检查传入 sectionTag 是否存在！");
    } else {
        [self insertSectionWithSectionItem:sectionItem sectionIndex:(index + 1)];
    }

}

/**
 动态移除指定 Section
 */
- (void)removeSectionWithSectionTag:(NSString *)sectionTag {
    
    NSInteger index = [self findIndexWithSectionTag:sectionTag];
    if (index == NSNotFound) {
        NSAssert(NO, @"请检查传入 sectionTag 是否存在！");
    } else {
        [self.sectionItemArray removeObjectAtIndex:index];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    }

}

- (void)scrollToCellWithSectionTag:(NSString *)sectionTag
                           cellTag:(NSString *)cellTag
                  atScrollPosition:(UITableViewScrollPosition)scrollPosition
                          animated:(BOOL)animated {
    
    NSIndexPath *idx = [self findIndexPathWithSectionTag:sectionTag cellTag:cellTag];
    if (idx) {
        [self.tableView scrollToRowAtIndexPath:idx atScrollPosition:scrollPosition animated:animated];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionItemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    YCTableViewContainerSectionItem *sectionItem = self.sectionItemArray[section];
    return sectionItem.itemArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    YCTableViewContainerSectionItem *sectionItem = [self.sectionItemArray yc_objectAtIndex:indexPath.section];
    YCTableViewContainerCellItem *cellItem = [sectionItem.itemArray yc_objectAtIndex:indexPath.row];
    
    cell = [cellItem dequeueTableViewCellWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YCTableViewContainerSectionItem *item = [self.sectionItemArray objectAtIndex:indexPath.section];
    
    if ([self.delegate respondsToSelector:@selector(containerManager:didSelectItem:atRowIndex:)]) {
        [self.delegate containerManager:self didSelectItem:item atRowIndex:indexPath.row];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = UITableViewAutomaticDimension;
    
    YCTableViewContainerSectionItem *sectionItem = [self.sectionItemArray objectAtIndex:indexPath.section];
    YCTableViewContainerCellItem *cellItem = [sectionItem.itemArray objectAtIndex:indexPath.row];

    rowHeight = [cellItem heightForRowAtIndexPath:indexPath tableView:tableView];
    if (rowHeight == 0) { // 高度为0时，手动调用方法，计算高度。
        [self tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    // TODO:
    if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.delegate tableView:tableView heightForHeaderInSection:section];
    }

    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    // TODO:
    if ([self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [self.delegate tableView:tableView heightForFooterInSection:section];
    }

    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // TODO:
    if ([self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.delegate tableView:tableView viewForHeaderInSection:section];
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    // TODO:
    if ([self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.delegate tableView:tableView viewForFooterInSection:section];
    }

    return nil;
}

// 缓存Cell高度
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.cellHeightsDictionary setObject:@(cell.frame.size.height) forKey:indexPath];
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

// 获取Cell缓存估算高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *heightNumber = [self.cellHeightsDictionary objectForKey:indexPath];
    CGFloat height = heightNumber ? [tableView iOS10EstimatedHeightCheck:heightNumber.floatValue] : UITableViewAutomaticDimension;
    
    return height;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

#pragma mark - dataSource,delegate 转发

/**
 * 如果self,dataSource,delegate有实现就返回YES.
 */
- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) {
        return YES;
    } else if ([self.dataSource respondsToSelector:aSelector]) {
        return YES;
    } else if ([self.delegate respondsToSelector:aSelector]) {
        return YES;
    } else {
        return NO;
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.dataSource respondsToSelector:aSelector]) {
        return self.dataSource;
    } else if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    } else {
        return nil;
    }
}

#pragma mark - private method

- (NSInteger)findIndexWithSectionTag:(NSString *)sectionTag {
    
    for (NSInteger i = 0; i < self.sectionItemArray.count; i++) {
        YCTableViewContainerSectionItem *item = self.sectionItemArray[i];
        if ([item.sectionTag isEqualToString:sectionTag]) {
            return i;
        }
    }
    return NSNotFound;
}

- (NSIndexPath *)findIndexPathWithSectionTag:(NSString *)sectionTag cellTag:(NSString *)cellTag {
    
    NSInteger sectionIndex = -1;
    NSInteger rowIndex = -1;
    YCTableViewContainerSectionItem *sectionItem = nil;
    
    // 获取 section 位置
    for (NSInteger i = 0; i < self.sectionItemArray.count; i++) {
        YCTableViewContainerSectionItem *item = self.sectionItemArray[i];
        if ([item.sectionTag isEqualToString:sectionTag]) {
            sectionIndex = i;
            sectionItem = item;
            break;
        }
    }
    if (!sectionItem) {
        NSAssert(NO, @"没有找到 sectionTag : %@",sectionTag);
        return nil;
    }
    
    // 获取 Row 位置
    for (NSInteger i = 0; i < sectionItem.itemArray.count; i++) {
        YCTableViewContainerCellItem *item = sectionItem.itemArray[i];
        if ([item.cellTag isEqualToString:cellTag]) {
            rowIndex = i;
            break;
        }
    }
    
    if (rowIndex == -1) {
        NSAssert(NO, @"没有找到 cellTag : %@",cellTag);
        return nil;
    } else {
        return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
    }
}

- (UITableViewCell *)findTableViewCellWithSectionTag:(NSString *)sectionTag cellTag:(NSString *)cellTag {
    
    NSIndexPath *indexPath = [self findIndexPathWithSectionTag:sectionTag cellTag:cellTag];
    if (indexPath) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        return cell;
    } else {
        return nil;
    }
    
}

- (YCTableViewContainerSectionItem *)sectionItemWithSectionTag:(NSString *)sectionTag outIndex:(NSUInteger *)pIndex {
    // 获取 section 位置
    for (NSUInteger i = 0; i < self.sectionItemArray.count; i++) {
        YCTableViewContainerSectionItem *item = self.sectionItemArray[i];
        if ([item.sectionTag isEqualToString:sectionTag]) {
            if (pIndex != NULL) {
                *pIndex = i;
            }
            return item;
        }
    }
    return nil;
}


#pragma mark - getter/setter

- (NSMutableArray<YCTableViewContainerSectionItem *> *)sectionItemArray {
    if (!_sectionItemArray) {
        _sectionItemArray = [NSMutableArray array];
    }
    return _sectionItemArray;
}

- (NSMutableDictionary *)cellHeightsDictionary {
    if (!_cellHeightsDictionary) {
        _cellHeightsDictionary = [NSMutableDictionary dictionary];
    }
    return _cellHeightsDictionary;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

@end
