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
#import "SAReactNativeSwizzler.h"
#import "SAReactNativeRootViewManager.h"

static void *const kSensorsAnalyticsRNScreenPropertiesKey = (void *)&kSensorsAnalyticsRNScreenPropertiesKey;
static void *const kSensorsAnalyticsRNViewPropertiesKey = (void *)&kSensorsAnalyticsRNViewPropertiesKey;

@implementation SAReactNativeViewProperty

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    SAReactNativeViewProperty *property = [[[self class] allocWithZone:zone] init];
    property.reactTag = self.reactTag;
    property.clickable = self.clickable;
    property.properties = self.properties;
    return property;
}

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

@implementation RCTRootView (SAReactNative)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // React Native 0.66.0 及以后版本的 RCTRootView 指定构造器方法
        SEL originalSEL = NSSelectorFromString(@"initWithFrame:bridge:moduleName:initialProperties:");
        SEL swizzleSEL = @selector(sa_reactnative_initWithFrame:bridge:moduleName:initialProperties:);

        if (![RCTRootView instancesRespondToSelector:originalSEL]) {
            // React Native 0.66.0 以前版本的 RCTRootView 指定构造器方法
            originalSEL = @selector(initWithBridge:moduleName:initialProperties:);
            swizzleSEL = @selector(sa_reactnative_initWithBridge:moduleName:initialProperties:);
        }

        [RCTRootView sa_reactnative_swizzle:originalSEL withSelector:swizzleSEL];
    });
}

- (instancetype)sa_reactnative_initWithBridge:(RCTBridge *)bridge
                                   moduleName:(NSString *)moduleName
                            initialProperties:(NSDictionary *)initialProperties {
    RCTRootView *rootView = [self sa_reactnative_initWithBridge:bridge
                                                     moduleName:moduleName
                                              initialProperties:initialProperties];
    [SAReactNativeRootViewManager.sharedInstance addRootView:rootView];
    return rootView;
}


- (instancetype)sa_reactnative_initWithFrame:(CGRect)frame
                                     bridge:(RCTBridge *)bridge
                                 moduleName:(NSString *)moduleName
                          initialProperties:(nullable NSDictionary *)initialProperties {
    RCTRootView *rootView = [self sa_reactnative_initWithFrame:frame
                                                        bridge:bridge
                                                    moduleName:moduleName
                                             initialProperties:initialProperties];
    [SAReactNativeRootViewManager.sharedInstance addRootView:rootView];
    return rootView;
}

@end
