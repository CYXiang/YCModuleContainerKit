//
//  YCBaseContainerAgentDelegate.h
//  klook
//
//  Created by yancy.chen on 2019/11/11.
//  Copyright © 2019 klook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCBaseContainerSectionConfigProtocol.h"
#import "YCValueProviderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YCBaseContainerAgentDelegate <YCValueProviderProtocol>

/// 获取Agent所在VC
- (UIViewController *)takeSuperController;

/// 获取ContainerManager
- (YCTableViewContainerManager *)takeContainerManager;

/// 更新请求参数并重新发送网络请求，数据回来刷新整个页面
/// @param parameter 参数模型
/// @param callback 接口返回数据
- (void)reloadPageDataWithParameter:(id)parameter callback:(void(^)(id dataModel))callback;

/// 更新请求参数并重新发送网络请求，数据回来刷新指定Sections
- (void)reloadPageDataWithParameter:(id)parameter refreshTags:(NSArray *)tags;

/// 刷新容器
- (void)reloadPageData;

- (void)reloadPageDataWithPageModel:(NSMutableDictionary *)pageModel;

/// 刷新Section
- (void)reloadSectionWithDataModel:(id)model
                       configClass:(Class<YCBaseContainerSectionConfigProtocol>)configClass
                        refreshTag:(NSString *)refreshTag;
/// 刷新特定 Section 下的部分 Cell
- (void)reloadCellsWithDataModels:(NSArray *)models
                      configClass:(Class<YCBaseContainerSectionConfigProtocol>)configClass
                        ofSection:(id)section;

/// 刷新特定section 下models对应的cells
/// withoutAnimation 是否强制关闭rowAnimation
- (void)reloadCellsWithDataModels:(NSArray *)models
                      configClass:(Class<YCBaseContainerSectionConfigProtocol>)configClass
                        ofSection:(id)section
                 withoutAnimation:(BOOL)withoutAnimation;

/// 滚动到指定Cell
- (void)scrollToCellWithSectionTag:(NSString *)sectionTag
                           cellTag:(NSString *)cellTag
                  atScrollPosition:(UITableViewScrollPosition)scrollPosition
                          animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
