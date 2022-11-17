//
//  YCExamplePageSection1Config.m
//  klook
//
//  Created by yancy.chen on 2020/1/7.
//  Copyright © 2020 klook. All rights reserved.
//

#import "YCExamplePageSection1Config.h"
#import "YCGenerateOrderSeparateLineCell.h"
#import "YCExampleTest1Cell.h"

@implementation YCExamplePageSection1Config

+ (YCTableViewContainerSectionItem *)getSectionConfigWithModel:(NSArray *)model
                                                    sectionTag:(NSString *)sectionTag {

    NSMutableArray *cellItemArray = [NSMutableArray array];
    
    if (model.count > 0) {
        YCTableViewContainerCellItem *cellItem = [YCTableViewContainerCellItem itemWithModel:model cell:YCExampleTest1Cell.class tag:@"GiftCardCell"];
        cellItem.cellEdgeInsets = UIEdgeInsetsMake(16, 16, 0, 16);
        [cellItemArray addObject:cellItem];
    }
    
    {
        YCTableViewContainerCellItem *cellItem = [YCTableViewContainerCellItem itemWithModel:@"" cell:YCGenerateOrderSeparateLineCell.class tag:@"SeparateLine"];
        [cellItemArray addObject:cellItem];
    }
    
    YCTableViewContainerSectionItem *sectionItem = [[YCTableViewContainerSectionItem alloc] initWithItemArray:cellItemArray sectionTag:sectionTag];
    return sectionItem;
    
}

+ (void)reloadSectionWithModel:(NSArray *)model
                    sectionTag:(NSString *)sectionTag
              containerManager:(YCTableViewContainerManager *)containerManager {
        
    YCTableViewContainerSectionItem *sectionItem = [self getSectionConfigWithModel:model sectionTag:sectionTag];
    
    [containerManager reloadSectionWithCellItems:sectionItem.itemArray sectionTag:sectionTag];
}

@end
