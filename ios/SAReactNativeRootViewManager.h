//
// SAReactNativeRootViewManager.h
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

#import <UIKit/UIKit.h>
#import "SAReactNativeCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface SAReactNativeRootViewManager : NSObject

#pragma mark - rootView

/// 防止在缓存 RCTRootView 时, 命中 SA 未初始化的断言
/// SA SDK 初始化前就创建 RCTRootView --> 加载 SAReactNativeManager --> 调用 - [SensorsAnalyticsSDK ignoreViewType:]
/// 所以此处使用单例, 不通过 SAReactNativeManager 去缓存 RCTRootView, 避免提前加载 SAReactNativeManager
+ (instancetype)sharedInstance;

/// 缓存 RCTRootView
/// @param rootView rootView
- (void)addRootView:(RCTRootView *)rootView;

/// 获取当前正在显示的 RCTRootView
- (RCTRootView *)currentRootView;

#pragma mark - viewProperties

/// 缓存 RN 页面中的元素信息
/// @param property 元素信息
/// @param rootTag 当前 RN 页面 RCTRootView 对应的 reactTag
- (void)addViewProperty:(SAReactNativeViewProperty *)property withRootTag:(NSNumber *)rootTag;

/// 获取 RN 页面中的元素信息
/// @param rootTag 当前 RN 页面 RCTRootView 对应的 reactTag
- (NSSet<SAReactNativeViewProperty *> *)viewPropertiesWithRootTag:(NSNumber *)rootTag;

@end

NS_ASSUME_NONNULL_END
