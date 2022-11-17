//
//  YCExamplePageSection1Agent.m
//  klook
//
//  Created by yancy.chen on 2020/1/7.
//  Copyright © 2020 klook. All rights reserved.
//

#import "YCExamplePageSection1Agent.h"

@implementation YCExamplePageSection1Agent

- (void)combinationWithSubAgentData:(NSMutableArray *)pageDataModel {
    
    // 这里可以更改接口返回数据 ...
    [pageDataModel replaceObjectAtIndex:1 withObject:@[@1, @1, @1, @1, @1]];
    
}

- (void)YCExampleTest1Cell_closeGiftCardCell {
    
    NSLog(@"点击了 %@ 的关闭按钮", self.sectionTag);
}

@end
