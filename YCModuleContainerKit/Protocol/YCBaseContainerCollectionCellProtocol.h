//
//  YCBaseContainerCollectionCellProtocol.h
//  klook
//
//  Created by yancy.chen on 2019/7/29.
//  Copyright © 2019 klook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCBaseContainerCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YCBaseContainerCollectionCellProtocol <NSObject, YCBaseContainerCellProtocol>

@required

// 注册 Cell 到 UICollectionView 中
- (void)registerCellWithCollectionView:(UICollectionView *)collectionView;

// 获取Cell Insets
- (UIEdgeInsets)getCellEdgeInsets;


@end

NS_ASSUME_NONNULL_END
