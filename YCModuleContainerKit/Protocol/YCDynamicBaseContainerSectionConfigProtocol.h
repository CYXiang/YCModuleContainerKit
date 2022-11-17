//
// Created by yancy.chen on 2020/2/20.
// Copyright (c) 2020 yancy.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCTableViewContainerSectionItem;
@class YCTableViewContainerManager;
@protocol YCDynamicSectionAgentComponentProtocol;

NS_ASSUME_NONNULL_BEGIN

// 用于描述 Dynamic Section Config 如何构造和加载数据
@protocol YCDynamicBaseContainerSectionConfigProtocol <NSObject>

@required
// 注册所有的组件
+ (void)registerAllComponents;
// 注册组件配置类，组件配置类用于配置组件数据应该如何加载
+ (void)registerComponentConfigClassName:(NSString *)componentConfigClassName;
// 注册组件配置类，组件配置类用于配置组件数据应该如何加载
// 通过 Register 协议注册
+ (void)registerComponentConfigsInRegisterClassName:(NSString *)componentConfigRegisterClassName;
// 所有已注册的组件
+ (NSDictionary *)allRegisteredComponents;

// 获取所有的 Section 组件数据
+ (NSArray<YCTableViewContainerSectionItem *> *)getSectionsWithModels:(NSArray<YCDynamicSectionAgentComponentProtocol> *)models
                                                           sectionTag:(NSString *)sectionTag;

@optional

// 刷新所有 models 中的 Section 的组件数据
+ (void)reloadSectionsWithModels:(NSArray <YCDynamicSectionAgentComponentProtocol> *)models
                      sectionTag:(NSString *)sectionTag
                containerManager:(YCTableViewContainerManager *)containerManager;

// 刷新某个 Section Tag 下的部分 Cell
+ (void)reloadCellsWithModels:(NSArray <YCDynamicSectionAgentComponentProtocol> *)models
                    inSection:(id<YCDynamicSectionAgentComponentProtocol>)sectionComponent
             containerManager:(YCTableViewContainerManager *)containerManager;

+ (void)reloadCellsWithModels:(NSArray <YCDynamicSectionAgentComponentProtocol> *)models
                    inSection:(id<YCDynamicSectionAgentComponentProtocol>)sectionComponent
             containerManager:(YCTableViewContainerManager *)containerManager
             withoutAnimation:(BOOL)withoutAnimation;

@end

// 提供给 `YCDynamicBaseContainerSectionConfigProtocol` 使用的组件注册对象
// 一次可以注册多个组件，可以将组件按业务分组注册到 Section Config 中
@protocol YCDynamicComponentConfigClassRegisterProtocol <NSObject>

// 注册方法，在这个方法中写如何注册 Component Config
+ (void)registerWithDynamicSectionConfig:(id<YCDynamicBaseContainerSectionConfigProtocol>)sectionConfig;

@end


NS_ASSUME_NONNULL_END
