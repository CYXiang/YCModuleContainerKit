//
//  YCContainerBaseController.h
//  klook
//
//  Created by yancy.chen on 2019/11/1.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCBaseContainerPageConfigProtocol.h"
#import "YCBaseContainerSectionConfigProtocol.h"
#import "YCTableViewContainerManager.h"
#import "YCBaseContainerBasePageAgent.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCContainerBaseController : UIViewController <YCTableViewContainerDataSource, YCTableViewContainerDelegate>

@property (nonatomic, strong, readonly) id<YCBaseContainerAgentProtocol> containerAgent;
@property (nonatomic, strong, readonly) id<YCBaseContainerPageConfigProtocol> pageConfig;
@property (nonatomic, strong, readonly) YCTableViewContainerManager *containerManager;

- (void)configVCWithAgent:(id<YCBaseContainerAgentProtocol> _Nonnull)containerAgent
               pageConfig:(id<YCBaseContainerPageConfigProtocol> _Nonnull)pageConfig;

- (void)routerEventWithName:(NSString *)eventName sender:(_Nullable id)sender userInfo:(id)userInfo;
- (void)routerEventWithName:(NSString *)eventName responderTarget:(_Nullable id)responderTarget sender:(_Nullable id)sender userInfo:(id)userInfo;

@end

NS_ASSUME_NONNULL_END
