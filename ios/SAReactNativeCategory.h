//
//  SAReactNativeCategory.h
//  RNSensorsAnalyticsModule
//
// Created by 彭远洋 on 2020/10/26.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - View Property
@interface SAReactNativeViewProperty : NSObject

/// View 唯一标识符
@property (nonatomic, strong) NSNumber *reactTag;
/// View 可点击状态
@property (nonatomic, assign) BOOL clickable;
/// View 自定义属性
@property (nonatomic, strong) NSDictionary *properties;

@end

@interface UIView (SAReactNative)

/// 用于记录 view 关联的页面信息
@property (nonatomic, copy) NSDictionary *sa_reactnative_screenProperties;

@end

@interface UIViewController (SAReactNative)

/// 触发页面浏览时, 记录页面信息 (和 RCTRootView 关联: rctRootView.reactViewController)
@property (nonatomic, copy) NSDictionary *sa_reactnative_screenProperties;

/// 用于记录 view 自定义属性 (和 RCTRootView 关联: rctRootView.reactViewController)
@property (nonatomic, copy) NSSet<SAReactNativeViewProperty *> *sa_reactnative_viewProperties;

@end

NS_ASSUME_NONNULL_END
