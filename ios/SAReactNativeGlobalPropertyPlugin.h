//
//  SAReactNativeGlobalPropertyPlugin.h
//  RNSensorsAnalyticsModule
//
//  Created by  储强盛 on 2022/10/9.
//  Copyright © 2015-2022 Sensors Data Co., Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>
#if __has_include(<SensorsAnalyticsSDK/SAPropertyPlugin.h>)
#import <SensorsAnalyticsSDK/SAPropertyPlugin.h>
#else
#import "SAPropertyPlugin.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SAReactNativeGlobalPropertyPlugin : SAPropertyPlugin

/// 全局属性插件
///
/// 全局属性，所有事件都会包含
///
/// @param properties 自定义属性
- (instancetype)initWithProperties:(NSDictionary *)properties NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
