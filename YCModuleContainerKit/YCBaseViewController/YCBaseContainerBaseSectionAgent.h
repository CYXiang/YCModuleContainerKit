//
//  YCBaseContainerBaseSectionAgent.h
//  klook
//
//  Created by yancy.chen on 2019/12/4.
//  Copyright © 2019 klook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCBaseContainerSectionConfigProtocol.h"
#import "YCBaseContainerAgentProtocol.h"
#import "YCBaseContainerAgentDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCBaseContainerBaseSectionAgent : NSObject<YCBaseContainerAgentProtocol>

- (instancetype)initAgentWithRefreshConfig:(Class)configClass
                                sectionTag:(NSString *)sectionTag;

/// 代理
@property (nonatomic, weak  ) id<YCBaseContainerAgentDelegate> delegate;

@property (nonatomic, copy  , readonly) NSString *sectionTag;
@property (nonatomic, assign, readonly) Class<YCBaseContainerSectionConfigProtocol> configClass;

/// 内部数据模型
@property (nonatomic, strong) id dataModel;

/// 事件统一处理方法
- (void)routerEventWithName:(NSString *)eventName sender:(_Nullable id)sender userInfo:(id)userInfo;

/// 点击Cell处理方法
- (void)didSelectItem:(YCTableViewContainerSectionItem *)sectionItem
           atRowIndex:(NSInteger)rowIndex
            pageModel:(id)pageModel;

@end

NS_ASSUME_NONNULL_END
