//
//  YCBaseContainerBasePageAgent.h
//  klook
//
//  Created by yancy.chen on 2019/12/4.
//  Copyright © 2019 klook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCBaseContainerPageConfigProtocol.h"
#import "YCBaseContainerAgentProtocol.h"
#import "YCBaseContainerAgentDelegate.h"
#import "YCBaseContainerBaseSectionAgent.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^YCSubAgentsHandler)(id param);

@interface YCBaseContainerBasePageAgent : NSObject<YCBaseContainerAgentProtocol>

- (instancetype)initAgentWithRefreshConfig:(Class)configClass;

@property (nonatomic, assign,readonly) Class<YCBaseContainerPageConfigProtocol> configClass;

/// 代理
@property (nonatomic, weak  ) id<YCBaseContainerAgentDelegate> delegate;

/// 页面层级数据字典（理论上可以包含页面内所有SubAgent与页面接口返回的数据）
@property (nonatomic, strong) NSMutableDictionary *pageDataDict;

/// 内部数据模型（页面接口返回的数据）
@property (nonatomic, strong) id dataModel;

/// 所以subAgent的异步请求都成功回调时，回调此block
@property (nonatomic, copy  ) YCSubAgentsHandler subAgentsCallback;

/// 页面所有模块的子Agent（不会过滤）
@property (nonatomic, strong) NSArray<YCBaseContainerBaseSectionAgent *> *subAgents;

/// 页面所有显示模块的子Agent（会过滤已经移除Section模块的Agent）
@property (nonatomic, strong) NSMutableArray<YCBaseContainerBaseSectionAgent *> *displaySubAgents;

/// 遍历 SubAgent 加工数据（同步）
/// @param pageDataModel 页面数据模型
- (void)traversalSubAgentsWithPageDataModel:(id)pageDataModel;

/// 遍历拉取 SubAgent 数据（异步）
/// @param parameter 参数
/// @param completionHandler 集合数据后回调
- (void)traversalSubAgentsWithParameter:(id)parameter
                      completionHandler:(nullable void (^)(id resultData))completionHandler;

@end

NS_ASSUME_NONNULL_END
