//
//  SAReactNativeEventProperty.h
//  RNSensorsAnalyticsModule
//
//  Created by 彭远洋 on 2020/12/31.
//  Copyright © 2020-2021 Sensors Data Co., Ltd. All rights reserved.
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

NS_ASSUME_NONNULL_BEGIN

@interface SAReactNativeEventProperty : NSObject

/// 事件属性中添加 $lib_method 和 $lib_plugin_version 属性，$lib_method 默认为 code
/// @param properties 事件自定义属性
+ (NSDictionary *)eventProperties:(nullable NSDictionary *)properties;

/// 事件属性中添加 $lib_method 和 $lib_plugin_version 属性
/// @param properties 事件自定义属性
/// @param isAuto 设置为 YES 时 $lib_method 为 autoTrack，为 NO 时 $lib_method 为 code
+ (NSDictionary *)eventProperties:(nullable NSDictionary *)properties isAuto:(BOOL)isAuto;

@end

NS_ASSUME_NONNULL_END
