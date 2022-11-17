//
//  YCBaseContainerAgentProtocol.h
//  klook
//
//  Created by yancy.chen on 2019/11/6.
//  Copyright © 2019 klook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCValueProviderProtocol.h"

@protocol YCBaseContainerAgentDelegate;
@class YCBaseContainerBaseSectionAgent;

NS_ASSUME_NONNULL_BEGIN

@protocol YCBaseContainerAgentProtocol <YCValueProviderProtocol>

@required

/// 代理
@property (nonatomic, weak  ) id<YCBaseContainerAgentDelegate> delegate;

/// 内部数据模型（页面接口返回的数据）
@property (nonatomic, strong) id dataModel;

/// 页面所有模块的子Agent（不会过滤）
@property (nonatomic, strong) NSArray<YCBaseContainerBaseSectionAgent *> *subAgents;

/// 页面所有显示模块的子Agent（会过滤已经移除Section模块的Agent）
@property (nonatomic, strong) NSMutableArray<YCBaseContainerBaseSectionAgent *> *displaySubAgents;

/// 获取模块显示数据
- (NSMutableDictionary *)takePageDataDict;


/// 加工页面数据后渲染页面（同步方式）
/// @param pageData 原始页面数据模型（包括请求参数、回调数据）
- (void)combinationWithSubAgentData:(id)pageDataModel;


/// 通过参数获取模块显示数据（异步方式）
/// @param parameter 原始页面数据模型（可以包括请求参数、回调数据）
/// @param completionHandler 异步回调
- (void)takeDataModelWithParameter:(id)parameter
                 completionHandler:(nullable void (^)(id resultData))completionHandler;

/// 校验模块数据是否有效
- (BOOL)verifyModuleResult;


/// 校验不通过时的错误信息
- (NSString * _Nullable)errorMessage;


/// 提交模块数据
- (NSDictionary * _Nullable)commitModuleResult;

/// 事件统一处理方法
- (void)routerEventWithName:(NSString *)eventName sender:(_Nullable id)sender userInfo:(id)userInfo;

/// 点击Cell处理方法
- (void)didSelectItem:(YCTableViewContainerSectionItem *)sectionItem
           atRowIndex:(NSInteger)rowIndex
            pageModel:(id)pageModel;

@end

NS_ASSUME_NONNULL_END
