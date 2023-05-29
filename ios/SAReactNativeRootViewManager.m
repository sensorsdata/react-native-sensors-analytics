//
// SAReactNativeRootViewManager.m
// RNSensorsAnalyticsModule
//
// Created by yuqiang on 2021/11/25.
// Copyright © 2020-2021 Sensors Data Co., Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "SAReactNativeRootViewManager.h"
#import <React/RCTUIManager.h>

void sensors_reactnative_dispatch_safe_sync(dispatch_queue_t queue,DISPATCH_NOESCAPE dispatch_block_t block) {
    if ((dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)) == dispatch_queue_get_label(queue)) {
        block();
    } else {
        dispatch_sync(queue, block);
    }
}

@interface SAReactNativeRootViewManager ()

@property (nonatomic, strong) NSPointerArray *rootViews;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableSet *> *viewProperties;
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation SAReactNativeRootViewManager

+ (instancetype)sharedInstance {
    static SAReactNativeRootViewManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SAReactNativeRootViewManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _rootViews = [NSPointerArray weakObjectsPointerArray];
        _viewProperties = [NSMutableDictionary dictionary];
        _serialQueue = dispatch_queue_create("cn.SensorsData.SAReactNativeRootViewManagerQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - rootView

- (void)addRootView:(RCTRootView *)rootView {
    [self compact];
    [self.rootViews addPointer:(__bridge void * _Nullable)(rootView)];
}

- (RCTRootView *)currentRootView {
    NSArray<RCTRootView *> *rootViews = self.rootViews.allObjects;
    // 倒序遍历, 获取最上层正在显示的 RCTRootView
    for (RCTRootView *rootView in rootViews.reverseObjectEnumerator) {
        BOOL isVisible = rootView.alpha > 0.01 && !rootView.isHidden;
        if (isVisible && rootView.window) {
            return rootView;
        }
    }
    // RCTRootView 初始化后, RN 插件就会触发页面浏览事件, 但此时 RCTRootView 可能还未显示到页面上
    // 所以此处取最后一个 RCTRootView 作为兼容逻辑
    return rootViews.lastObject;
}

#pragma mark - viewProperties

- (void)addViewProperty:(SAReactNativeViewProperty *)property withRootTag:(NSNumber *)rootTag {
    if (!property || !rootTag) {
        return;
    }

    sensors_reactnative_dispatch_safe_sync(self.serialQueue, ^{
        NSMutableSet *viewProperties = self.viewProperties[rootTag];
        if (!viewProperties) {
            viewProperties = [NSMutableSet set];
            self.viewProperties[rootTag] = viewProperties;
        }
        [viewProperties addObject:property];
    });
}

- (NSSet<SAReactNativeViewProperty *> *)viewPropertiesWithRootTag:(NSNumber *)rootTag {
    __block NSSet *viewProperties = nil;
    sensors_reactnative_dispatch_safe_sync(self.serialQueue, ^{
        NSSet *tempProperties = self.viewProperties[rootTag];
        if (tempProperties) {
            viewProperties = [[NSSet alloc] initWithSet:tempProperties copyItems:YES];
        }
    });
    return viewProperties;
}

#pragma mark - utils

- (void)compact {
    // NSPointerArray 内部有个标记 needsCompaction, 当 needsCompaction 为 true 时, compact 才会生效
    // 向 NSPointerArray 添加一个正常元素, 该元素在后面被释放时, needsCompaction 不会变化
    // 向 NSPointerArray 主动添加 NULL 时, needsCompaction 标记会被设置为 true
    // 所以调用 compact 前需要先添加一个 NULL
    // https://stackoverflow.com/questions/31322290/nspointerarray-weird-compaction
    [self.rootViews addPointer:NULL];
    [self.rootViews compact];

    // 清除没有 RCTRootView 的 viewProperty
    NSMutableSet *rootTags = [NSMutableSet set];
    for (RCTRootView *rootView in self.rootViews) {
        [rootTags addObject:rootView.reactTag];
    }

    sensors_reactnative_dispatch_safe_sync(self.serialQueue, ^{
        NSMutableSet *removeTags = [NSMutableSet setWithArray:[self.viewProperties allKeys]];
        [removeTags minusSet:rootTags];
        [self.viewProperties removeObjectsForKeys:removeTags.allObjects];
    });
}

@end
