//
//  YCBaseContainerBaseSectionAgent.m
//  klook
//
//  Created by yancy.chen on 2019/12/4.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCBaseContainerBaseSectionAgent.h"

@implementation YCBaseContainerBaseSectionAgent

- (instancetype)initAgentWithRefreshConfig:(Class)configClass sectionTag:(NSString *)sectionTag {
    self = [super init];
    if (self) {
        _sectionTag = sectionTag;
        _configClass = configClass;
    }
    return self;
}


- (void)routerEventWithName:(NSString *)eventName sender:(id)sender userInfo:(id)userInfo {
    SEL selector = NSSelectorFromString(eventName);
    if ([self respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:userInfo];
        #pragma clang diagnostic pop
    }
}

#pragma mark - YCBaseContainerAgentProtocol

- (void)takeDataModelWithParameter:(id)parameter
                 completionHandler:(nullable void (^)(id resultData))completionHandler {
    NSLog(@"%@ 不需要异步请求数据, sectionTag:%@",NSStringFromClass([self class]), self.sectionTag);
    completionHandler(self.dataModel);
}

- (void)combinationWithSubAgentData:(id)pageDataModel {
    NSLog(@"%@ 不需要对数据进行 Combination 加工, sectionTag:%@",NSStringFromClass([self class]), self.sectionTag);
}

- (NSMutableDictionary *)takePageDataDict {
    return nil;
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

- (void)didSelectItem:(YCTableViewContainerSectionItem *)sectionItem
           atRowIndex:(NSInteger)rowIndex
            pageModel:(id)pageModel {
    

}

@synthesize displaySubAgents;

@synthesize subAgents;

@end
