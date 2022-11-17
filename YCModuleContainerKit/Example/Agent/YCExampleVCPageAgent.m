//
//  YCExampleVCPageAgent.m
//  klook
//
//  Created by yancy.chen on 2020/1/6.
//  Copyright © 2020 klook. All rights reserved.
//

#import "YCExampleVCPageAgent.h"

/// YCBaseContainer使用
NSString *const kContainerPageParameter = @"pageParameter";
NSString *const kContainerPageDataModel = @"pageDataModel";

@implementation YCExampleVCPageAgent

- (void)takeDataModelWithParameter:(id)parameter
                 completionHandler:(nullable void (^)(id resultData))completionHandler {

    // 模拟网络延迟回调
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 1.保存网络回调数据
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:@[@[], @[@1, @2], @[@1, @2]]];
        self.dataModel = dataArray;
        [self.pageDataDict setValue:self.dataModel forKey:NSStringFromClass([self class])];
        
        // 2.遍历子模块加工数据（同步）
        [self traversalSubAgentsWithPageDataModel:self.dataModel];

        // 3.回调并刷新整个页面
        completionHandler(self.pageDataDict);

        // 4.遍历子模块加工数据（异步）<按需使用>
        NSMutableDictionary *pram = [NSMutableDictionary dictionary];
        [pram setValue:@"self.settlementParameter" forKey:kContainerPageParameter];
        [pram setValue:self.dataModel forKey:kContainerPageDataModel];
        // 遍历子Agent的 takeDataModelWithParameter 方法
        __weak __typeof__ (self) weakSelf = self;
        [self traversalSubAgentsWithParameter:pram completionHandler:^(id _Nonnull resultData) {
            // 所有子Agent都成功回调
            [weakSelf.pageDataDict addEntriesFromDictionary:resultData];
            if (weakSelf.subAgentsCallback) {
                weakSelf.subAgentsCallback(weakSelf.pageDataDict);
            }
        }];
        
    });
    
}

// 没有子Agent时，可以在pageAgent拦截（不能重名）

//- (void)YCExampleTest1Cell_closeGiftCardCell {
//    NSLog(@"点击了关闭按钮在pageAgent响应");
//}


@end
