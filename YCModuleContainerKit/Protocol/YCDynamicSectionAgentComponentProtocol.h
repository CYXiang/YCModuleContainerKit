//
// Created by yancy.chen on 2020/2/18.
// Copyright (c) 2020 yancy.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCValueProviderProtocol.h"

@class YCBaseContainerBaseSectionAgent;
@class YCTableViewContainerCellItem;
@class YCDynamicSectionAgent;
@protocol YCBaseContainerAgentDelegate;

NS_ASSUME_NONNULL_BEGIN

// 描述组件应该有的数据
@protocol YCDynamicSectionAgentComponentProtocol <YCValueProviderProtocol>

@required
// 组件原始数据，从接口获取到的数据
@property (nonatomic, strong) id rawData;
// 告知是否是 Section 组件
@property (nonatomic) BOOL isSectionComponent;
// 组件的字组件
@property (nonatomic, copy, readonly) NSArray<YCDynamicSectionAgentComponentProtocol> *subComponents;
// 父组件
@property (nonatomic, weak) id<YCDynamicSectionAgentComponentProtocol> parentComponent;
// 组件的 cell tag，cell tag 将会通过代码生成，同时组件中如果已经存在 cell tag 那么说明组件已经生成过，不需要生成新的 cell tag
@property (nonatomic, copy) NSString *tag;
// 容器代理
@property (nonatomic, weak) id<YCBaseContainerAgentDelegate> delegate;
// Section Config Class
@property (nonatomic, strong) Class sectionConfigClass;


// 组件类型
+ (NSString *)componentType;
// 映射组件数据
- (void)updateDataModelWithRawData;
// 添加子组件
- (void)addSubComponent:(id<YCDynamicSectionAgentComponentProtocol>)component;
// 移除子组件
- (void)removeSubComponent:(id<YCDynamicSectionAgentComponentProtocol>)component;
// 依据 tag 替换子组件
- (void)replaceSubComponent:(id<YCDynamicSectionAgentComponentProtocol>)component ofTag:(NSString *)tag;
// 将子组件从父组件中移除
- (void)removeFromParentComponent;

@optional
// 组件选中事件
- (void)componentDidSelectedRowIndex:(NSInteger)rowIndex sectionAgent:(YCBaseContainerBaseSectionAgent *)sectionAgent;
// 事件统一处理方法
- (void)routerEventWithName:(NSString *)eventName sender:(_Nullable id<YCDynamicSectionAgentComponentProtocol>)sender userInfo:(id)userInfo;
// 检查 sender 是否是该组件下的
- (BOOL)canRespondsEventForSender:(id)sender;

@end

// 组件配置接口，告诉 DynamicSectionConfig 应该如何配置一个组件的 CellItem
@protocol YCDynamicSectionAgentComponentConfigProtocol <NSObject>

// 组件类型
+ (NSString *)componentType;
// 如何生成组件的方法
+ (YCTableViewContainerCellItem *)cellItemWithDynamicAgentComponentModel:(id<YCDynamicSectionAgentComponentProtocol>)componentModel cellTag:(NSString *)cellTag;

@end

@protocol YCDynamicSectionComponentRegisterProtocol <NSObject>

// 注册组件类
- (void)registerAgentComponentClassName:(NSString *)agentComponentClassName;
// 根据数据获取组件
- (id<YCDynamicSectionAgentComponentProtocol>)componentWithType:(NSString *)componentType rawData:(id)rawData;

@end

// 这个接口决定整个 Section Agent 获取到数据后，如何组装出 KLDynamicComponent 列表提供给界面显示
// 他决定了，某个类型数据如何映射到具体的 componentType，以及使用什么原始数据
@protocol YCDynamicSectionAgentDataParserProtocol <NSObject>

@required
// 组件数据加工接口，通过原始数据生成组件配置数据
+ (NSArray<YCDynamicSectionAgentComponentProtocol> *)componentsWithData:(id)data componentRegister:(id<YCDynamicSectionComponentRegisterProtocol>)componentRegister agentDelegate:(id<YCBaseContainerAgentDelegate>)agentDelegate;

@end

@protocol YCDynamicSectionAgentConfigProtocol <NSObject>

+ (void)configDynamicSectionAgent:(YCDynamicSectionAgent *)agent;

@end

NS_ASSUME_NONNULL_END
