//
//  ViewController.m
//  YCModuleContainerKitDemo
//
//  Created by Yancy Chen on 2022/11/14.
//

#import "ViewController.h"
#import "YCExampleVCPageConfig.h"
#import "YCExampleVCPageAgent.h"

@interface ViewController ()

@end

@implementation ViewController

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
