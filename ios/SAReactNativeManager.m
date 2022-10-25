//
// SAReactNativeManager.m
// RNSensorsAnalyticsModule
//
// Created by 彭远洋 on 2020/3/16.
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

#import "SAReactNativeManager.h"
#import "SAReactNativeCategory.h"
#import "SAReactNativeEventProperty.h"
#import "SAReactNativeRootViewManager.h"
#import <React/RCTUIManager.h>
#import "SAReactNativeDynamicPropertyPlugin.h"
#import "SAReactNativeGlobalPropertyPlugin.h"

#pragma mark - Constants
NSString *const kSAEventScreenNameProperty = @"$screen_name";
NSString *const kSAEventTitleProperty = @"$title";
NSString *const kSAEventElementContentProperty = @"$element_content";

#pragma mark - React Native Manager
@interface SAReactNativeManager ()

@property (nonatomic, strong) NSSet *reactNativeIgnoreClasses;
@property (nonatomic, weak) SAReactNativeDynamicPropertyPlugin *dynamicPropertyPlugin;

@end

@implementation SAReactNativeManager

+ (instancetype)sharedInstance {
    static SAReactNativeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SAReactNativeManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [SAReactNativeManager addNativeIgnoreClasses];
        _reactNativeIgnoreClasses = [NSSet setWithObjects:@"RCTScrollView", @"RCTBaseTextInputView", nil];
    }
    return self;
}

- (SAReactNativeViewProperty *)viewPropertyWithReactTag:(NSNumber *)reactTag fromViewProperties:(NSSet <SAReactNativeViewProperty *>*)properties {
    if (!properties || ![reactTag isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    NSSet *tempProperties = [[NSSet alloc] initWithSet:properties copyItems:YES];
    for (SAReactNativeViewProperty *property in tempProperties) {
        if ([property isKindOfClass:[SAReactNativeViewProperty class]] && [property.reactTag isKindOfClass:[NSNumber class]] && property.reactTag.integerValue == reactTag.integerValue) {
            return property;
        }
    }
    return nil;
}

- (BOOL)clickableForView:(UIView *)view {
    if (!view) {
        return NO;
    }
    for (NSString *className in _reactNativeIgnoreClasses) {
        if ([view isKindOfClass:NSClassFromString(className)]) {
            return NO;
        }
    }

    SAReactNativeRootViewManager *rootViewManager = [SAReactNativeRootViewManager sharedInstance];
    RCTRootView *rootView = [rootViewManager currentRootView];
    NSSet<SAReactNativeViewProperty *> *viewProperties = [rootViewManager viewPropertiesWithRootTag:rootView.reactTag];
    view.sa_reactnative_screenProperties = rootView.sa_reactnative_screenProperties;

    // 兼容 Native 可视化全埋点 UISegmentedControl 整体不可圈选的场景
    if  ([view isKindOfClass:NSClassFromString(@"UISegmentedControl")]) {
        return NO;
    }

    // UISegmentedControl 只有子视图 UISegment 是可点击的
    if ([view isKindOfClass:NSClassFromString(@"UISegment")]) {
        return [self viewPropertyWithReactTag:view.superview.reactTag fromViewProperties:viewProperties].clickable;
    }

    return [self viewPropertyWithReactTag:view.reactTag fromViewProperties:viewProperties].clickable;
}

- (void)prepareView:(NSNumber *)reactTag clickable:(BOOL)clickable paramters:(NSDictionary *)paramters {
    dispatch_async(dispatch_get_main_queue(), ^{
        RCTRootView *rootView = [[SAReactNativeRootViewManager sharedInstance] currentRootView];
        [self prepareView:reactTag clickable:clickable paramters:paramters rootTag:rootView.reactTag];
    });
}

- (void)prepareView:(NSNumber *)reactTag clickable:(BOOL)clickable paramters:(NSDictionary *)paramters rootTag:(NSNumber *)rootTag {
    if (!clickable || !reactTag) {
        return;
    }
    // 每个可点击控件都需要添加对应属性，集合内存在对应属性对象即表示控件可点击
    SAReactNativeViewProperty *viewProperty = [[SAReactNativeViewProperty alloc] init];
    viewProperty.reactTag = reactTag;
    viewProperty.clickable = clickable;
    viewProperty.properties = paramters;
    [[SAReactNativeRootViewManager sharedInstance] addViewProperty:viewProperty withRootTag:rootTag];
}

- (void)setDynamicSuperProperties:(NSDictionary *)properties {
    if (!self.dynamicPropertyPlugin) {
        SAReactNativeDynamicPropertyPlugin *plugin = [[SAReactNativeDynamicPropertyPlugin alloc] init];
        [SensorsAnalyticsSDK.sharedInstance registerPropertyPlugin:plugin];
        self.dynamicPropertyPlugin = plugin;
    }
    self.dynamicPropertyPlugin.properties = properties;
}

#pragma mark - visualize
- (NSDictionary *)visualizeProperties {
    UIView *rootView = [[SAReactNativeRootViewManager sharedInstance] currentRootView];
    return rootView.sa_reactnative_screenProperties;
}

#pragma mark - AppClick
- (void)trackViewClick:(NSNumber *)reactTag {
    if (![[SensorsAnalyticsSDK sharedInstance] isAutoTrackEnabled]) {
        return;
    }
    // 忽略 $AppClick 事件
    if ([[SensorsAnalyticsSDK sharedInstance] isAutoTrackEventTypeIgnored:SensorsAnalyticsEventTypeAppClick]) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        // 通过 RCTRootView 获取 viewProperty
        SAReactNativeRootViewManager *rootViewManager = [SAReactNativeRootViewManager sharedInstance];
        RCTRootView *rootView = [rootViewManager currentRootView];
        NSSet *viewProperties = [rootViewManager viewPropertiesWithRootTag:rootView.reactTag];
        NSDictionary *screenProperties = rootView.sa_reactnative_screenProperties;

        SAReactNativeViewProperty *viewProperty = [self viewPropertyWithReactTag:reactTag fromViewProperties:viewProperties];
        id ignoreParam = viewProperty.properties[@"ignore"];
        if ([ignoreParam respondsToSelector:@selector(boolValue)] && [ignoreParam boolValue]) {
            return;
        }

        UIView *view = [rootView.bridge.uiManager viewForReactTag:reactTag];
        for (NSString *className in self.reactNativeIgnoreClasses) {
            if ([view isKindOfClass:NSClassFromString(className)]) {
                return;
            }
        }
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        NSString *content = [view.accessibilityLabel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        properties[kSAEventElementContentProperty] = content;
        [properties addEntriesFromDictionary:screenProperties];
        [properties addEntriesFromDictionary:viewProperty.properties];
        NSDictionary *newProps = [SAReactNativeEventProperty eventProperties:properties isAuto:YES];
        [[SensorsAnalyticsSDK sharedInstance] trackViewAppClick:view withProperties:newProps];
    });
}

#pragma mark - AppViewScreen
- (void)trackViewScreen:(nullable NSString *)url properties:(nullable NSDictionary *)properties autoTrack:(BOOL)autoTrack {
    if (url && ![url isKindOfClass:NSString.class]) {
        NSLog(@"[RNSensorsAnalytics] error: url {%@} is not String Class ！！！", url);
        return;
    }
    NSString *screenName = properties[kSAEventScreenNameProperty] ?: url;
    NSString *title = properties[kSAEventTitleProperty] ?: screenName;

    NSMutableDictionary *pageProps = [NSMutableDictionary dictionary];
    pageProps[kSAEventScreenNameProperty] = screenName;
    pageProps[kSAEventTitleProperty] = title;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *rootView = [SAReactNativeRootViewManager.sharedInstance currentRootView];
        rootView.sa_reactnative_screenProperties = [pageProps copy];
    });

    // 忽略 React Native 触发的 $AppViewScreen 事件
    if (autoTrack && [properties[@"SAIgnoreViewScreen"] boolValue]) {
        return;
    }

    // 检查 SDK 全埋点功能开启状态
    if (autoTrack && ![[SensorsAnalyticsSDK sharedInstance] isAutoTrackEnabled]) {
        return;
    }

    // 忽略所有 $AppViewScreen 事件
    if (autoTrack && [[SensorsAnalyticsSDK sharedInstance] isAutoTrackEventTypeIgnored:SensorsAnalyticsEventTypeAppViewScreen]) {
        return;
    }

    NSMutableDictionary *eventProps = [NSMutableDictionary dictionary];
    [eventProps addEntriesFromDictionary:pageProps];
    [eventProps addEntriesFromDictionary:properties];

    dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSDictionary *properties = [SAReactNativeEventProperty eventProperties:eventProps isAuto:autoTrack];
        [[SensorsAnalyticsSDK sharedInstance] trackViewScreen:url withProperties:properties];
#pragma clang diagnostic pop
    });
}

+ (void)configureSDKWithSettings:(NSDictionary *)settings {
    if (![settings isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *serverURL = settings[@"server_url"];
    if (![serverURL isKindOfClass:[NSString class]]) {
        return;
    }

    SAConfigOptions *options = [[SAConfigOptions alloc] initWithServerURL:serverURL launchOptions:nil];
    NSNumber *enableLog = settings[@"show_log"];
    if ([enableLog isKindOfClass:[NSNumber class]]) {
        options.enableLog = [enableLog boolValue];
    }
    NSNumber *autoTrack = settings[@"auto_track"];
    if ([autoTrack isKindOfClass:[NSNumber class]]) {
        options.autoTrackEventType = [autoTrack integerValue];
    }
    NSNumber *flushInterval = settings[@"flush_interval"];
    if ([flushInterval isKindOfClass:[NSNumber class]]) {
        options.flushInterval = [flushInterval integerValue];
    }
    NSNumber *flushBulksize = settings[@"flush_bulksize"];
    if ([flushBulksize isKindOfClass:[NSNumber class]]) {
        options.flushBulkSize = [flushBulksize integerValue];
    }
    NSNumber *enableEncrypt = settings[@"encrypt"];
    if ([enableEncrypt isKindOfClass:[NSNumber class]]) {
        options.enableEncrypt = [enableEncrypt boolValue];
    }
    NSNumber *enableJavascriptBridge = settings[@"javascript_bridge"];
    if ([enableJavascriptBridge isKindOfClass:[NSNumber class]]) {
        options.enableJavaScriptBridge = [enableJavascriptBridge boolValue];
    }
    NSDictionary *iOSSettings = settings[@"ios"];
    if ([iOSSettings isKindOfClass:[NSDictionary class]] && [iOSSettings[@"max_cache_size"] isKindOfClass:[NSNumber class]]) {
        options.maxCacheSize = [iOSSettings[@"max_cache_size"] integerValue];
    }
    NSDictionary *visualizedSettings = settings[@"visualized"];
    if ([visualizedSettings isKindOfClass:[NSDictionary class]]) {
        if ([visualizedSettings[@"auto_track"] isKindOfClass:[NSNumber class]]) {
            options.enableVisualizedAutoTrack = [visualizedSettings[@"auto_track"] boolValue];
        }
        if ([visualizedSettings[@"properties"] isKindOfClass:[NSNumber class]]) {
            options.enableVisualizedProperties = [visualizedSettings[@"properties"] boolValue];
        }
    }
    NSNumber *enableHeatMap = settings[@"heat_map"];
    if ([enableHeatMap isKindOfClass:[NSNumber class]]) {
        options.enableHeatMap = [enableHeatMap boolValue];
    }

    // 注册全局属性插件
    NSDictionary *properties = settings[@"global_properties"];
    if ([properties isKindOfClass:NSDictionary.class]) {
        SAReactNativeGlobalPropertyPlugin *propertyPlugin = [[SAReactNativeGlobalPropertyPlugin alloc] initWithProperties:properties];
        [options registerPropertyPlugin:propertyPlugin];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [SensorsAnalyticsSDK startWithConfigOptions:options];
        [self addNativeIgnoreClasses];
    });
}

+ (void)addNativeIgnoreClasses {
    @try {
        NSSet *nativeIgnoreClasses = [NSSet setWithObjects:@"RCTSwitch", @"RCTSlider", @"RCTSegmentedControl", @"RNGestureHandlerButton", @"RNCSlider", @"RNCSegmentedControl", nil];
        for (NSString *className in nativeIgnoreClasses) {
            if (NSClassFromString(className)) {
                [[SensorsAnalyticsSDK sharedInstance] ignoreViewType:NSClassFromString(className)];
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

@end
