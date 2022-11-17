//
//  YCExamplePageSection2Agent.m
//  klook
//
//  Created by yancy.chen on 2020/1/7.
//  Copyright © 2020 klook. All rights reserved.
//

#import "YCExamplePageSection2Agent.h"

@implementation YCExamplePageSection2Agent

- (void)takeDataModelWithParameter:(NSDictionary *)parameter
                 completionHandler:(void (^ __nullable)(id resultData))completionHandler {
    
    // 这里是异步拉取数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 新的数据返回
        NSArray *array = @[@1, @1, @1, @1];
        
        // 刷新自身模块数据
        [self.delegate reloadSectionWithDataModel:array configClass:self.configClass refreshTag:self.sectionTag];
        
        completionHandler(array);
    });
    
    
}

- (void)YCExampleTest1Cell_closeGiftCardCell {
    
    NSLog(@"点击了 %@ 的关闭按钮", self.sectionTag);
}

@end
