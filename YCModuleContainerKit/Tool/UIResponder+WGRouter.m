//
//  UIResponder+WGRouter.m
//  WeAblum
//
//  Created by Yancy Chen on 2022/11/7.
//  Copyright © 2022 WeAblum. All rights reserved.
//

#import "UIResponder+WGRouter.h"

@implementation UIResponder (WGRouter)

- (void)routerEventWithName:(NSString *)eventName
                   userInfo:(id)userInfo {
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

- (void)routerEventWithResponderTarget:(_Nullable id)target
                             eventName:(NSString *)eventName
                              userInfo:(_Nullable id)userInfo {
    [[self nextResponder] routerEventWithResponderTarget:target eventName:eventName userInfo:userInfo];
}

- (nullable UIViewController *)wg_nestViewController {
    UIResponder *responder = self.nextResponder;
    while (responder && ![responder isKindOfClass:UIViewController.class]) {
        responder = responder.nextResponder;
    }
    return (UIViewController *)responder;
}

- (void)wg_routerEventRespondsToSelector:(SEL)aSelector
                              withObject:(_Nullable id)object {
    if ([[self nextResponder] respondsToSelector:aSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[self nextResponder] performSelector:aSelector withObject:object];
#pragma clang diagnostic pop
    } else {
        [[self nextResponder] wg_routerEventRespondsToSelector:aSelector withObject:object];
    }
}

@end
