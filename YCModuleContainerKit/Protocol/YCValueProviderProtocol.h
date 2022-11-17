//
// Created by yancy.chen on 2020/3/1.
// Copyright (c) 2020 yancy.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 这个接口描述可以获取值
// 主要描述两种场景下的值获取和校验，获取当前对象的值，获取当前对象以及他的子对象的值
// 场景名映射到具体的业务场景，例如 commit，show something
// 进行校验的场景，具体的实现者可能会对 UI 或是数据进行相应的更新
// 获取值时不应该进行校验，因为校验会导致 UI 的更新或数据的变化
@protocol YCValueProviderProtocol <NSObject>

@optional
// 通过业务场景获取值，所有的值通过字典组合而成
- (NSDictionary *)provideValueForScenarioName:(NSString *)scenarioName;
// 通过业务场景获取所有子 item 的 value，并通过字典返回
// 主意如果子 item 中的字典索引如果有重复，那么将会按照组件顺序覆盖
- (NSDictionary *)provideValueWithSubItemsForScenarioName:(NSString *)scenarioName;

// 通过业务场景获取值，所有的值通过字典组合而成
- (BOOL)checkValueForScenarioName:(NSString *)scenarioName;
// 通过业务场景获取所有子 item 的 value，并通过字典返回
// 主意如果子 item 中的字典索引如果有重复，那么将会按照组件顺序覆盖
- (BOOL)checkValueWithSubItemsForScenarioName:(NSString *)scenarioName stopOnFirstFail:(BOOL)stopOnFirstFail;

@end

NS_ASSUME_NONNULL_END
