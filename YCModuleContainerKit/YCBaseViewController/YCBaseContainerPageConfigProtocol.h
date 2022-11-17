//
//  YCBaseContainerPageConfigProtocol.h
//  klook
//
//  Created by yancy.chen on 2019/11/1.
//  Copyright © 2019 klook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCTableViewContainerManager.h"
#import "YCBaseContainerBaseSectionAgent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YCBaseContainerPageConfigProtocol <NSObject>

@required

/// 注册页面配置
/// @param model 数据
- (NSMutableArray<YCTableViewContainerSectionItem *> *)registPageConfigWithPageDict:(NSMutableDictionary *)pageDict;

/// 初始化页面所有模块 Agent
- (NSArray<YCBaseContainerBaseSectionAgent *> *)registAllSectionAgents;

@optional

/// 获取页面 SectionItems
- (NSMutableArray<YCTableViewContainerSectionItem *> *)takePageSectionItems;

/// 需要单独刷新某些模块时需要实现
/// @param model 数据Model
/// @param sectionsTag 模块Tag
/// @param containerManager 容器Manager
- (void)reloadPageWithModel:(id)model
                sectionsTag:(NSArray *)sectionsTag
           containerManager:(YCTableViewContainerManager *)containerManager;

@end

NS_ASSUME_NONNULL_END
