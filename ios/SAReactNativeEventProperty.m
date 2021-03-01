//
//  SAReactNativeEventProperty.m
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

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "SAReactNativeEventProperty.h"
#import "RNSensorsAnalyticsModule.h"

NSString *const kSALibPluginVersionKey = @"$lib_plugin_version";

@implementation SAReactNativeEventProperty

+ (NSDictionary *)eventProperties:(NSDictionary *)properties {
    return [self eventProperties:properties isAuto:NO];
}

+ (NSDictionary *)eventProperties:(NSDictionary *)properties isAuto:(BOOL)isAuto {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result addEntriesFromDictionary:properties];
    NSString *libMethod = @"code";
    if (isAuto || [result[@"$lib_method"] isEqualToString:@"autoTrack"]) {
        // 当自定义属性中设置的 $lib_method 为 autoTrack 时有效，其他内容时 $lib_method 为 code
        // isAuto：当触发事件为全埋点时，$lib_method 为 autoTrack 且不可修改
        libMethod = @"autoTrack";
    }
    result[@"$lib_method"] = libMethod;
    if (result[kSALibPluginVersionKey]) {
        return result;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result[kSALibPluginVersionKey] = @[kSAReactNativePluginVersion];
    });
    return result;
}

@end
