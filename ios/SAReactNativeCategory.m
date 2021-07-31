//
//  SAReactNativeCategory.m
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

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "SAReactNativeCategory.h"
#import <objc/runtime.h>

static void *const kSensorsAnalyticsRNScreenPropertiesKey = (void *)&kSensorsAnalyticsRNScreenPropertiesKey;
static void *const kSensorsAnalyticsRNViewPropertiesKey = (void *)&kSensorsAnalyticsRNViewPropertiesKey;

@implementation SAReactNativeViewProperty

- (NSString *)description {
    return [NSString stringWithFormat:@"%@; reactTag: %@; clickable: %@; properties: %@", [super description], self.reactTag, (self.clickable ? @"YES" : @"NO"), self.properties];
}

@end

#pragma mark - UIView Category
@implementation UIView (SAReactNative)

- (NSDictionary *)sa_reactnative_screenProperties {
    return objc_getAssociatedObject(self, kSensorsAnalyticsRNScreenPropertiesKey);
}

- (void)setSa_reactnative_screenProperties:(NSDictionary *)sa_reactnative_screenProperties {
    objc_setAssociatedObject(self, kSensorsAnalyticsRNScreenPropertiesKey, sa_reactnative_screenProperties, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

#pragma mark - UIViewController Category
@implementation UIViewController (SAReactNative)

- (NSDictionary *)sa_reactnative_screenProperties {
    return objc_getAssociatedObject(self, kSensorsAnalyticsRNScreenPropertiesKey);
}

- (void)setSa_reactnative_screenProperties:(NSDictionary *)sa_reactnative_screenProperties {
    objc_setAssociatedObject(self, kSensorsAnalyticsRNScreenPropertiesKey, sa_reactnative_screenProperties, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSSet<SAReactNativeViewProperty *> *)sa_reactnative_viewProperties {
    return objc_getAssociatedObject(self, kSensorsAnalyticsRNViewPropertiesKey);
}

- (void)setSa_reactnative_viewProperties:(NSSet<SAReactNativeViewProperty *> *)sa_reactnative_viewProperties {
    objc_setAssociatedObject(self, kSensorsAnalyticsRNViewPropertiesKey, sa_reactnative_viewProperties, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
