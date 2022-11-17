//
//  YCBaseContainerBasePageAgent.m
//  klook
//
//  Created by yancy.chen on 2019/12/4.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCBaseContainerBasePageAgent.h"
#import "YCTableViewContainerSectionItem.h"

@interface YCBaseContainerBasePageAgent ()

@property (nonatomic, strong) __block NSMutableDictionary *subAgentDataDict;

@end

@implementation YCBaseContainerBasePageAgent

- (instancetype)initAgentWithRefreshConfig:(Class)configClass {
    self = [super init];
    if (self) {
        _configClass = configClass;
    }
    return self;
}

#pragma mark - YCBaseContainerAgentProtocol

- (NSMutableDictionary *)takePageDataDict {
    return self.pageDataDict;
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
            [subAgent combinationWithSubAgentData:pageDataModel];
        }
    }
}

- (void)traversalSubAgentsWithParameter:(id)parameter
                      completionHandler:(nullable void (^)(id resultData))completionHandler {

    if (self.subAgents.count > 0) {
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        
        [self.subAgentDataDict removeAllObjects];
        for (YCBaseContainerBaseSectionAgent *subAgent in self.subAgents) {
            subAgent.delegate = self.delegate;
            dispatch_group_enter(group);
            __weak typeof(subAgent) weakSubAgent = subAgent;
            if ([subAgent respondsToSelector:@selector(takeDataModelWithParameter:completionHandler:)]) {
                [subAgent takeDataModelWithParameter:parameter completionHandler:^(id _Nonnull dataModel) {
                    if (dataModel) {
                        [self.subAgentDataDict setValue:dataModel forKey:weakSubAgent.sectionTag];
                    }
                    dispatch_group_leave(group);
                }];
            }
        }
        
        dispatch_group_notify(group, queue, ^{
           dispatch_async(dispatch_get_main_queue(), ^{
               NSLog(@"subAgents数据已全部回调");
               completionHandler(self.subAgentDataDict);
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

#pragma mark - getter

- (NSMutableDictionary *)subAgentDataDict {
    if (!_subAgentDataDict) {
        _subAgentDataDict = [NSMutableDictionary dictionary];
    }
    return _subAgentDataDict;
}

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
