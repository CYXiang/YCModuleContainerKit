//
//  YCExampleVCPageConfig.m
//  klook
//
//  Created by yancy.chen on 2020/1/6.
//  Copyright © 2020 klook. All rights reserved.
//

#import "YCExampleVCPageConfig.h"

#import "YCExamplePageSection1Config.h"

#import "YCExampleVCPageAgent.h"
#import "YCExamplePageSection1Agent.h"
#import "YCExamplePageSection2Agent.h"

@implementation YCExampleVCPageConfig

- (NSMutableArray<YCTableViewContainerSectionItem *> *)registPageConfigWithPageDict:(NSMutableDictionary *)pageDict {

    NSArray *model = [pageDict valueForKey:NSStringFromClass([YCExampleVCPageAgent class])];
    
    NSMutableArray *items = [NSMutableArray array];
    
    {
        YCTableViewContainerSectionItem *item = [YCExamplePageSection1Config getSectionConfigWithModel:model[0] sectionTag:@"Section1"];
        [items addObject:item];
    }
    
    {
        YCTableViewContainerSectionItem *item = [YCExamplePageSection1Config getSectionConfigWithModel:model[1] sectionTag:@"Section2"];
        [items addObject:item];
    }
    
    {
        YCTableViewContainerSectionItem *item = [YCExamplePageSection1Config getSectionConfigWithModel:model[2] sectionTag:@"Section3"];
        [items addObject:item];
    }
    
    return items;
}

/// 初始化页面所需 Agent
- (NSArray<YCBaseContainerBaseSectionAgent *> *)registAllSectionAgents {
    
    YCExamplePageSection1Agent *section1Agent = [[YCExamplePageSection1Agent alloc] initAgentWithRefreshConfig:[YCExamplePageSection1Config class] sectionTag:@"Section2"];
    
    YCExamplePageSection2Agent *section2Agent = [[YCExamplePageSection2Agent alloc] initAgentWithRefreshConfig:[YCExamplePageSection1Config class] sectionTag:@"Section1"];
    
    return @[section1Agent, section2Agent];
}

@end
