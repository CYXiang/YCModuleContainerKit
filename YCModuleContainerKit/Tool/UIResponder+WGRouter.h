//
//  UIResponder+WGRouter.h
//  WeAblum
//
//  Created by Yancy Chen on 2022/11/7.
//  Copyright © 2022 WeAblum. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (WGRouter)

- (void)routerEventWithName:(NSString *)eventName
                   userInfo:(_Nullable id)userInfo;

- (nullable UIViewController *)wg_nestViewController;

- (void)wg_routerEventRespondsToSelector:(SEL)aSelector
                              withObject:(_Nullable id)object;

/// 此方法仅适用于 顶层VC做事件分发场景
/// @param target 响应的业务逻辑Agent
/// @param eventName 事件名称
/// @param userInfo 传入参数
- (void)routerEventWithResponderTarget:(_Nullable id)target
                             eventName:(NSString *)eventName
                              userInfo:(_Nullable id)userInfo;

@end

NS_ASSUME_NONNULL_END
