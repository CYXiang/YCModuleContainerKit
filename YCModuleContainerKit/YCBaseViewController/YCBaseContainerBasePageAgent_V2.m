//
//  YCBaseContainerBasePageAgent_V2.m
//  klook
//
//  Created by yancy.chen on 2020/02/18.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCBaseContainerBasePageAgent_V2.h"
#import "YCTableViewContainerSectionItem.h"

@interface YCBaseContainerBasePageAgent_V2 ()

@end

@implementation YCBaseContainerBasePageAgent_V2

- (instancetype)initAgentWithRefreshConfig:(Class)configClass {
    self = [super init];
    if (self) {
        _configClass = configClass;
    }
    return self;
}

#pragma mark - YCBaseContainerAgentProtocol

- (NSMutableDictionary *)takePageDataDict {
    NSMutableDictionary *pageDataDict = @{
            NSStringFromClass(self.class): self.dataModel
    }.mutableCopy;
    for (YCBaseContainerBaseSectionAgent *subAgent in self.subAgents) {
        pageDataDict[subAgent.sectionTag] = subAgent.dataModel;
    }
    return pageDataDict.mutableCopy;
}

- (void)takeDataModelWithParameter:(id)parameter
                 completionHandler:(nullable void (^)(id resultData))completionHandler {
    completionHandler(self.dataModel);
}

- (void)combinationWithSubAgentData:(id)pageDataModel {
    
}

- (BOOL)verifyModuleResult {
    return YES;
}

- (NSString *)errorMessage {
    return @"";
}

- (NSDictionary *)commitModuleResult {
//    NSAssert(NO, @"子类需要重载此方法");
    return nil;
}

#pragma mark - public method

- (void)traversalSubAgentsWithPageDataModel:(id)pageDataModel {
    if (self.subAgents.count > 0) {
        for (YCBaseContainerBaseSectionAgent *subAgent in self.subAgents) {
            subAgent.delegate = self.delegate;
            [subAgent combinationWithSubAgentData:pageDataModel];
        }
    }
}

- (void)traversalSubAgentsWithParameter:(id)parameter
                      completionHandler:(nullable void (^)(id resultData))completionHandler {

    if (self.subAgents.count > 0) {
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

        NSMutableDictionary *subAgentDataDict = @{}.mutableCopy;
        for (YCBaseContainerBaseSectionAgent *subAgent in self.subAgents) {
            subAgent.delegate = self.delegate;
            dispatch_group_enter(group);
            __weak typeof(subAgent) weakSubAgent = subAgent;
            if ([subAgent respondsToSelector:@selector(takeDataModelWithParameter:completionHandler:)]) {
                [subAgent takeDataModelWithParameter:parameter completionHandler:^(id _Nonnull dataModel) {
                    if (dataModel) {
                        [subAgentDataDict setValue:dataModel forKey:weakSubAgent.sectionTag];
                    }
                    dispatch_group_leave(group);
                }];
            }
        }
        
        dispatch_group_notify(group, queue, ^{
           dispatch_async(dispatch_get_main_queue(), ^{
               NSLog(@"subAgents数据已全部回调");
               completionHandler(subAgentDataDict);
           });
        });
    }
}

- (void)didSelectItem:(YCTableViewContainerSectionItem *)sectionItem
           atRowIndex:(NSInteger)rowIndex pageModel:(id)pageModel {
    if (self.subAgents.count > 0) {
        for (YCBaseContainerBaseSectionAgent *agent in self.subAgents) {
            if ([agent.sectionTag isEqualToString:sectionItem.sectionTag]) {
                // 转发到模块处理
                [agent didSelectItem:sectionItem atRowIndex:rowIndex pageModel:self.dataModel];
            }
        }
    }
}

- (void)routerEventWithName:(NSString *)eventName sender:(id)sender userInfo:(id)userInfo {
    SEL selector = NSSelectorFromString(eventName);
    if ([self respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:userInfo];
        #pragma clang diagnostic pop
    } else {
        for (YCBaseContainerBaseSectionAgent *subAgent in self.subAgents) {
            [subAgent routerEventWithName:eventName sender:sender userInfo:userInfo];
        }
    }
}

- (NSDictionary *)provideValueWithSubItemsForScenarioName:(NSString *)scenarioName {
    NSMutableDictionary *valueDict = @{}.mutableCopy;
    if ([self respondsToSelector:@selector(provideValueForScenarioName:)]) {
        [valueDict addEntriesFromDictionary:[self provideValueForScenarioName:scenarioName]];
    }
    for (id<YCValueProviderProtocol> agent in self.subAgents) {
        if ([agent respondsToSelector:@selector(provideValueWithSubItemsForScenarioName:)]) {
            [valueDict addEntriesFromDictionary:[agent provideValueWithSubItemsForScenarioName:scenarioName]];
        } else if ([agent respondsToSelector:@selector(provideValueForScenarioName:)]) {
            [valueDict addEntriesFromDictionary:[agent provideValueForScenarioName:scenarioName]];
        }
    }
    return valueDict.copy;
}

- (BOOL)checkValueWithSubItemsForScenarioName:(NSString *)scenarioName stopOnFirstFail:(BOOL)stopOnFirstFail {
    BOOL result = YES;
    if ([self respondsToSelector:@selector(checkValueForScenarioName:)]) {
        result = [self checkValueForScenarioName:scenarioName];
        if (!result && stopOnFirstFail) {
            return result;
        }
    }
    for (id<YCValueProviderProtocol> agent in self.subAgents) {
        if ([agent respondsToSelector:@selector(checkValueWithSubItemsForScenarioName:stopOnFirstFail:)]) {
            result &= [agent checkValueWithSubItemsForScenarioName:scenarioName stopOnFirstFail:stopOnFirstFail];
        } else if ([agent respondsToSelector:@selector(checkValueForScenarioName:)]) {
            result &= [agent checkValueForScenarioName:scenarioName];
        }
        if (!result && stopOnFirstFail) {
            return result;
        }
    }
    return result;
}

#pragma mark - getter

- (NSMutableDictionary *)pageDataDict {
    if (!_pageDataDict) {
        _pageDataDict = [NSMutableDictionary dictionary];
    }
    return _pageDataDict;
}

- (NSMutableArray<YCBaseContainerBaseSectionAgent *> *)displaySubAgents {
    if (!_displaySubAgents) {
        _displaySubAgents = [NSMutableArray array];
    }
    return _displaySubAgents;
}

@end
