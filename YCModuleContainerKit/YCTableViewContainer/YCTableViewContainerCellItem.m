//
//  YCTableViewContainerCellItem.m
//  klook
//
//  Created by yancy.chen on 2019/8/1.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCTableViewContainerCellItem.h"
#import "YCBaseContainerTableViewCellProtocol.h"
#import "UITableView+WGEasyRegister.h"

@interface YCTableViewContainerCellItem ()


@end

@implementation YCTableViewContainerCellItem

+ (instancetype)itemWithModel:(id)model
                         cell:(Class)cell
                          tag:(NSString *)tag {
    
    YCTableViewContainerCellItem *cellItem = [[YCTableViewContainerCellItem alloc] initWithDataModel:model cellClass:cell cellTag:tag];
    
    return cellItem;
}

+ (instancetype)itemWithCellSettingHandler:(kTableViewCellSettingHandler)cellSetting
                                 cellClass:(Class)cellClass
                                       tag:(NSString *)tag {
    
    YCTableViewContainerCellItem *cellItem = [[YCTableViewContainerCellItem alloc] init];
    cellItem.cellClass = cellClass;
    cellItem.cellTag = tag;
    cellItem.cellSetting = cellSetting;
    
    return cellItem;
}

+ (instancetype)itemWithCellSettingHandler2:(kTableViewCellSettingHandler2)cellSetting
                                  cellClass:(Class)cellClass
                                        tag:(NSString *)tag {
    
    YCTableViewContainerCellItem *cellItem = [[YCTableViewContainerCellItem alloc] init];
    cellItem.cellClass = cellClass;
    cellItem.cellTag = tag;
    cellItem.cellSetting2 = cellSetting;
    
    return cellItem;
}

- (instancetype)initWithDataModel:(id)dataModel
                        cellClass:(Class)cellClass
                          cellTag:(NSString *)cellTag {
    self = [super init];
    if (self) {
        NSAssert(cellClass && cellTag.length, @"Invalid parameters");
        NSAssert([cellClass isSubclassOfClass:UITableViewCell.class], @"Invaild cell type");
        _cellClass = cellClass;
        _cellTag = cellTag;
        _model = dataModel;
    }
    return self;
}

- (void)registerCellForTableView:(UITableView *)tableView {
    id<YCBaseContainerTableViewCellProtocol> tableViewCell = [self.cellClass new];
    
    if ([tableViewCell respondsToSelector:@selector(yc_registerCellForTableView:)]) {
        [tableViewCell yc_registerCellForTableView:tableView];
    } else {
        [tableView registerClass:self.cellClass];
    }
}

- (UITableViewCell *)dequeueTableViewCellWithIndexPath:(NSIndexPath *)indexPath
                                             tableView:(UITableView *)tableView {

    UITableViewCell<YCBaseContainerTableViewCellProtocol> *tableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.cellClass)
                                                                                                           forIndexPath:indexPath];

    if ([tableViewCell respondsToSelector:@selector(setCellEdgeInsets:)]) {
        [tableViewCell setCellEdgeInsets:self.cellEdgeInsets];
    }
    
    if (self.cellSetting) {
        self.cellSetting(tableViewCell);
    } else if (self.cellSetting2) {
        __weak __typeof__ (self) weakSelf = self;
        self.cellSetting2(tableViewCell,weakSelf);
    } else if ([tableViewCell respondsToSelector:@selector(setContainerCellModel:)]) {
        [tableViewCell setContainerCellModel:self.model];
    }

    if ([tableViewCell respondsToSelector:@selector(setCellTag:)]) {
        tableViewCell.cellTag = self.cellTag;
    }
    
    if ([tableViewCell respondsToSelector:@selector(yc_getRowHeight:)]) {
        self.cellHeight = [tableViewCell yc_getRowHeight:self.model];
    }
    
    return tableViewCell;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
                         tableView:(UITableView *)tableView {
    CGFloat rowHeight = UITableViewAutomaticDimension;
    
    id<YCBaseContainerTableViewCellProtocol> tableViewCell = [self.cellClass new];
    if ([tableViewCell respondsToSelector:@selector(yc_customRowHeightWithModel:)]) {
        rowHeight = [tableViewCell yc_customRowHeightWithModel:self.model];
    }
    
    return rowHeight;
}

@end
