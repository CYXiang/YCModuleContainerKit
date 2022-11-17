//
//  YCBaseContainerSectionConfigProtocol.h
//  klook
//
//  Created by yancy.chen on 2019/11/11.
//  Copyright © 2019 klook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCTableViewContainerManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YCBaseContainerSectionConfigProtocol <NSObject>

@required

+ (YCTableViewContainerSectionItem *)getSectionConfigWithModel:(nullable id)model
                                                    sectionTag:(NSString *)sectionTag;

@optional
/// 注册模块内所有 Cell Agent
//+ (NSArray<YCBaseContainerBaseAgent *> *)registAllCellsAgents;

/// 该模块可以被独立刷新时需要实现
+ (void)reloadSectionWithModel:(id)model
                    sectionTag:(NSString *)sectionTag
              containerManager:(YCTableViewContainerManager *)containerManager;

@end

NS_ASSUME_NONNULL_END
