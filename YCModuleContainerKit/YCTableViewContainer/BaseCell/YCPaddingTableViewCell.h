//
//  YCPaddingTableViewCell.h
//  klook
//
//  Created by yancy.chen on 2019/8/5.
//  Copyright © 2019 klook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCBaseContainerTableViewCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCPaddingTableViewCell : UITableViewCell<YCBaseContainerTableViewCellProtocol>

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, assign, readonly) UIEdgeInsets paddingViewEdge;
@property (nonatomic, weak  , readonly) id responseAgent;

@end

NS_ASSUME_NONNULL_END
