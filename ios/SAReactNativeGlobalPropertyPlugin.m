//
//  SAReactNativeGlobalPropertyPlugin.m
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

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "SAReactNativeGlobalPropertyPlugin.h"

@interface SAReactNativeGlobalPropertyPlugin()
@property (nonatomic, copy) NSDictionary<NSString *, id> *globleProperties;
@end

@implementation SAReactNativeGlobalPropertyPlugin

- (instancetype)initWithProperties:(NSDictionary *)properties {
    self = [super init];
    if (self) {
        self.globleProperties = properties;
    }
    return self;
}

- (BOOL)isMatchedWithFilter:(id<SAPropertyPluginEventFilter>)filter {
    // 支持 track、Signup、Bind、Unbind
    return filter.type & SAEventTypeDefault;
}

- (SAPropertyPluginPriority)priority {
    return SAPropertyPluginPriorityLow;
}

- (NSDictionary<NSString *,id> *)properties {
    return [self.globleProperties copy];
}

@end
