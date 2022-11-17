//
//  YCContainerBaseExampleVC.m
//  klook
//
//  Created by yancy.chen on 2020/1/6.
//  Copyright © 2020 klook. All rights reserved.
//

#import "YCContainerBaseExampleVC.h"
#import "YCExampleVCPageConfig.h"
#import "YCExampleVCPageAgent.h"

@interface YCContainerBaseExampleVC ()

@end

@implementation YCContainerBaseExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];

    /// 初始化
    YCExampleVCPageConfig *config = [YCExampleVCPageConfig new];
    
    YCExampleVCPageAgent *pageAgent = [[YCExampleVCPageAgent alloc] initAgentWithRefreshConfig:[YCExampleVCPageConfig class]];
    
    [self configVCWithAgent:pageAgent pageConfig:config];
    
    __weak __typeof__ (self) weakSelf = self;
    [self.containerAgent takeDataModelWithParameter:@"apiModel" completionHandler:^(id  _Nonnull resultData) {
        // 刷新界面
        [weakSelf.containerManager tableViewContainerReloadData];
    }];
    
}

@end
