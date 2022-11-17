//
//  YCTableViewContainerSectionItem.m
//  klook
//
//  Created by yancy.chen on 2019/8/1.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCTableViewContainerSectionItem.h"

@implementation YCTableViewContainerSectionItem

- (instancetype)initWithItemArray:(NSArray<YCTableViewContainerCellItem *> *)itemArray
                       sectionTag:(NSString *)sectionTag {
    if (self = [super init]) {
        self.itemArray = [self checkCellItemValid:itemArray];;
        self.sectionTag = sectionTag;
    }
    return self;
}

- (NSArray<YCTableViewContainerCellItem *> *)checkCellItemValid:(NSArray<YCTableViewContainerCellItem *> *)itemArray {
    if (!itemArray.count) {
        return [NSArray array];
    }
#if DEBUG
    NSMutableArray *mutItems = [NSMutableArray arrayWithCapacity:itemArray.count];
    for (YCTableViewContainerCellItem *item in itemArray) {
        NSAssert([item isKindOfClass:YCTableViewContainerCellItem.class], @"Invalid type");
        NSAssert(item.cellTag.length, @"cellTag 不能为空值！！！");
        NSAssert(![mutItems containsObject:item.cellTag], @"Repeat cellTag");
        [mutItems addObject:item.cellTag];
    }
    return itemArray;
#else
    NSMutableArray *mutItems = [NSMutableArray arrayWithCapacity:itemArray.count];
    for (YCTableViewContainerCellItem *item in itemArray) {
        // 过滤无效CellItem
        if ([item isKindOfClass:YCTableViewContainerCellItem.class]) {
            [mutItems addObject:item];
        }
    }
    return [mutItems copy];
#endif
}

- (void)registerSectionCellForTableView:(UITableView *)tableView {
    if (tableView) {
        for (YCTableViewContainerCellItem *cellItem in self.itemArray) {
            if (![cellItem isKindOfClass:YCTableViewContainerCellItem.class]) {
                return;
            }
            [cellItem registerCellForTableView:tableView];
        }
    } else {
        NSAssert(NO, @"tableView 不能为空 ！！");
    }
}

- (CGFloat)sectionHeight {
    CGFloat height = 0.0;
    for (YCTableViewContainerCellItem *cellItem in self.itemArray) {
        if (cellItem.cellHeight > 0) {
            height += cellItem.cellHeight;
        }
    }
    return height;
}

@end
