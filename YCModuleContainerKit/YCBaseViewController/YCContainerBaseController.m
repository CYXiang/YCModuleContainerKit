//
//  YCContainerBaseController.m
//  klook
//
//  Created by yancy.chen on 2019/11/1.
//  Copyright © 2019 klook. All rights reserved.
//

#import "YCContainerBaseController.h"
#import "YCBaseContainerAgentDelegate.h"
#import "YCDynamicBaseContainerSectionConfigProtocol.h"

@interface YCContainerBaseController ()<YCBaseContainerAgentDelegate>

@property (nonatomic, strong) id<YCBaseContainerAgentProtocol> containerAgent;
@property (nonatomic, strong) id<YCBaseContainerPageConfigProtocol> pageConfig;
@property (nonatomic, strong) YCTableViewContainerManager *containerManager;
@property (nonatomic, strong) NSMutableDictionary *pageDataDict;

@end

@implementation YCContainerBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.containerManager.tableView];
    self.containerManager.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)configVCWithAgent:(id<YCBaseContainerAgentProtocol>)containerAgent
               pageConfig:(id<YCBaseContainerPageConfigProtocol>)pageConfig {
    self.pageConfig = pageConfig;
    self.containerAgent = containerAgent;
    self.containerAgent.delegate = self;
    if ([pageConfig respondsToSelector:@selector(registAllSectionAgents)]) {
        self.containerAgent.subAgents = [pageConfig registAllSectionAgents];
    }
}

#pragma mark - YCTableViewContainerDataSource

- (NSMutableArray<YCTableViewContainerSectionItem *> *)configTableContainerWithSectionItems {
//    if (!self.pageDataDict) {
        self.pageDataDict = [self.containerAgent takePageDataDict];
//    }
    NSMutableArray<YCTableViewContainerSectionItem *> *pageItems = [self.pageConfig registPageConfigWithPageDict:self.pageDataDict];
    // 更新displaySubAgents
    [self.containerAgent.displaySubAgents removeAllObjects];
    for (YCBaseContainerBaseSectionAgent *agent in self.containerAgent.subAgents) {
        for (YCTableViewContainerSectionItem *item in pageItems) {
            if ([agent.sectionTag isEqualToString:item.sectionTag]) {
                [self.containerAgent.displaySubAgents addObject:agent];
            }
        }
    }
    return pageItems;
}

- (void)containerManager:(YCTableViewContainerManager *)containerManager didSelectItem:(YCTableViewContainerSectionItem *)sectionItem atRowIndex:(NSInteger)rowIndex {
    [self.containerAgent didSelectItem:sectionItem atRowIndex:rowIndex pageModel:self.containerAgent.dataModel];
}

#pragma mark - YCBaseContainerAgentDelegate

- (YCContainerBaseController *)takeSuperController {
    return self;
}

- (YCTableViewContainerManager *)takeContainerManager {
    return self.containerManager;
}

- (void)reloadPageDataWithParameter:(id)parameter callback:(nonnull void (^)(id _Nonnull))callback {

    [self.containerAgent takeDataModelWithParameter:parameter completionHandler:^(id _Nonnull resultData) {
        callback(resultData);
    }];
}

- (void)reloadPageDataWithParameter:(id)parameter refreshTags:(NSArray *)tags {
    
    __weak __typeof__ (self) weakSelf = self;
    [self.containerAgent takeDataModelWithParameter:parameter completionHandler:^(id  _Nonnull resultData) {
        [weakSelf.pageConfig reloadPageWithModel:[self.containerAgent takePageDataDict] sectionsTag:tags containerManager:weakSelf.containerManager];
    }];
}

- (void)reloadPageData {
    [self.containerManager tableViewContainerReloadData];
}

- (void)reloadPageDataWithPageModel:(NSMutableDictionary *)pageModel {
    self.pageDataDict = pageModel;
    [self.containerManager tableViewContainerReloadData];
}

- (void)reloadSectionWithDataModel:(id)model
                       configClass:(Class)configClass
                        refreshTag:(NSString *)refreshTag {
    SEL reloadModelSel = @selector(reloadSectionWithModel:sectionTag:containerManager:);
    SEL reloadModelsSel = @selector(reloadSectionsWithModels:sectionTag:containerManager:);
    SEL reloadSel = nil;
    if ([configClass respondsToSelector:reloadModelSel]) {
        reloadSel = reloadModelSel;
    } else if ([configClass respondsToSelector:reloadModelsSel]) {
        reloadSel = reloadModelsSel;
    }
    if (reloadSel) {
        IMP reloadIMP = [configClass methodForSelector:reloadSel];
        void (*reloadFunc)(id, SEL, id, id, id) = (void *) reloadIMP;
        reloadFunc(configClass, reloadSel, model, refreshTag, _containerManager);
    } else {
        NSAssert(NO, @"sectionConfig 类没实现刷新方法");
    }
}

/// 刷新Section
- (void)reloadCellsWithDataModels:(NSArray *)models
                      configClass:(Class)configClass
                        ofSection:(id)section
{
    SEL reloadCellsSel = @selector(reloadCellsWithModels:inSection:containerManager:);
    if ([configClass respondsToSelector:reloadCellsSel]) {
        IMP reloadCellImp = [configClass methodForSelector:reloadCellsSel];
        void (*reloadCellFunc)(id, SEL, id, id, id) = (void *) reloadCellImp;
        reloadCellFunc(configClass, reloadCellsSel, models, section, self.containerManager);
    }
}

- (void)reloadCellsWithDataModels:(NSArray *)models
                      configClass:(Class)configClass
                        ofSection:(id)section
                 withoutAnimation:(BOOL)withoutAnimation
{
    SEL reloadCellsSel = @selector(reloadCellsWithModels:inSection:containerManager:withoutAnimation:);
    if ([configClass respondsToSelector:reloadCellsSel]) {
        IMP reloadCellImp = [configClass methodForSelector:reloadCellsSel];
        void (*reloadCellFunc)(id, SEL, id, id, id, BOOL) = (void *) reloadCellImp;
        reloadCellFunc(configClass, reloadCellsSel, models, section, self.containerManager,withoutAnimation);
    }
}

- (void)scrollToCellWithSectionTag:(NSString *)sectionTag
                           cellTag:(NSString *)cellTag
                  atScrollPosition:(UITableViewScrollPosition)scrollPosition
                          animated:(BOOL)animated {
    [self.containerManager scrollToCellWithSectionTag:sectionTag cellTag:cellTag atScrollPosition:scrollPosition animated:animated];
}

#pragma mark - YCValueProviderProtocol

- (NSDictionary *)provideValueForScenarioName:(NSString *)scenarioName {
    return [self provideValueWithSubItemsForScenarioName:scenarioName];
}

- (NSDictionary *)provideValueWithSubItemsForScenarioName:(NSString *)scenarioName {
    if ([self.containerAgent respondsToSelector:@selector(provideValueWithSubItemsForScenarioName:)]) {
        return [self.containerAgent provideValueWithSubItemsForScenarioName:scenarioName];
    } else if ([self.containerAgent respondsToSelector:@selector(provideValueForScenarioName:)]) {
        return [self.containerAgent provideValueForScenarioName:scenarioName];
    }
    return nil;
}

- (BOOL)checkValueForScenarioName:(NSString *)scenarioName {
    return [self checkValueWithSubItemsForScenarioName:scenarioName stopOnFirstFail:NO];
}

- (BOOL)checkValueWithSubItemsForScenarioName:(NSString *)scenarioName stopOnFirstFail:(BOOL)stopOnFirstFail {
    if ([self.containerAgent respondsToSelector:@selector(checkValueWithSubItemsForScenarioName:stopOnFirstFail:)]) {
        return [self.containerAgent checkValueWithSubItemsForScenarioName:scenarioName stopOnFirstFail:stopOnFirstFail];
    } else if ([self.containerAgent respondsToSelector:@selector(checkValueForScenarioName:)]) {
        return [self.containerAgent checkValueForScenarioName:scenarioName];
    }
    return YES;
}

#pragma mark - event response

- (void)routerEventWithResponderTarget:(_Nullable id)target
                             eventName:(NSString *)eventName
                              userInfo:(_Nullable id)userInfo {
    [self routerEventWithName:eventName responderTarget:target sender:nil userInfo:userInfo];
}


- (void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo {
    [self routerEventWithName:eventName sender:nil userInfo:userInfo];
}

- (void)routerEventWithName:(NSString *)eventName sender:(_Nullable id)sender userInfo:(id)userInfo {
    [self routerEventWithName:eventName responderTarget:nil sender:sender userInfo:userInfo];
}

- (void)routerEventWithName:(NSString *)eventName responderTarget:(id)responderTarget sender:(_Nullable id)sender userInfo:(id)userInfo {
    SEL selector = NSSelectorFromString(eventName);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self.containerAgent respondsToSelector:selector]) {
        [self.containerAgent performSelector:selector withObject:userInfo];
    } else {
        [self.containerAgent routerEventWithName:eventName sender:sender userInfo:userInfo];
    }
#pragma clang diagnostic pop

}

#pragma mark - Getter

- (YCTableViewContainerManager *)containerManager {
    if (!_containerManager) {
        _containerManager = [[YCTableViewContainerManager alloc] init];
        _containerManager.tableView.backgroundColor = [UIColor clearColor];
        _containerManager.dataSource = self;
        _containerManager.delegate = self;
        _containerManager.tableView.estimatedRowHeight = 0;
        _containerManager.tableView.estimatedSectionFooterHeight = 0;
        _containerManager.tableView.estimatedSectionHeaderHeight = 0;
    }
    return _containerManager;
}

@end
