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
#import <React/RCTUIManager.h>

#if __has_include(<SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>)
#import <SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>
#else
#import "SensorsAnalyticsSDK.h"
#endif

#pragma mark - Constants
NSString *const kSAEventScreenNameProperty = @"$screen_name";
NSString *const kSAEventTitleProperty = @"$title";
NSString *const kSAEventElementContentProperty = @"$element_content";

#pragma mark - View Property
@interface SAReactNativeViewProperty : NSObject

/// View 唯一标识符
@property (nonatomic, strong) NSNumber *reactTag;
/// View 可点击状态
@property (nonatomic, assign) BOOL clickable;
/// View 自定义属性
@property (nonatomic, strong) NSDictionary *properties;

@end

@implementation SAReactNativeViewProperty

- (NSString *)description {
    return [NSString stringWithFormat:@"%@; reactTag: %@; clickable: %@; properties: %@", [super description], self.reactTag, @(self.clickable), self.properties];
}

@end

#pragma mark - React Native Manager
@interface SAReactNativeManager ()

@property (nonatomic, copy) NSDictionary *screenProperties;
@property (nonatomic, strong) NSSet *reactNativeIgnoreClasses;
@property (nonatomic, strong) NSMutableSet<SAReactNativeViewProperty *> *viewProperties;

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
        NSSet *nativeIgnoreClasses = [NSSet setWithObjects:@"RCTSwitch", @"RCTSlider", @"RCTSegmentedControl", @"RNGestureHandlerButton", @"RNCSlider", @"RNCSegmentedControl", nil];
        for (NSString *className in nativeIgnoreClasses) {
            if (NSClassFromString(className)) {
                [[SensorsAnalyticsSDK sharedInstance] ignoreViewType:NSClassFromString(className)];
            }
        }
        _reactNativeIgnoreClasses = [NSSet setWithObjects:@"RCTScrollView", @"RCTBaseTextInputView", nil];
        _viewProperties = [[NSMutableSet alloc] init];
        _isRootViewVisible = NO;
    }
    return self;
}

- (UIView *)viewWithReactTag:(NSNumber *)reactTag {
    RCTRootView *rootView = [self rootView];
    RCTUIManager *manager = rootView.bridge.uiManager;
    return [manager viewForReactTag:reactTag];
}

- (SAReactNativeViewProperty *)viewPropertyWithReactTag:(NSNumber *)reactTag {
    __block SAReactNativeViewProperty *viewProperty;
    [_viewProperties enumerateObjectsUsingBlock:^(SAReactNativeViewProperty *obj, BOOL * _Nonnull stop) {
        if (obj.reactTag.integerValue == reactTag.integerValue) {
            viewProperty = obj;
            *stop = YES;
        }
    }];
    return viewProperty;
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
    SAReactNativeViewProperty *viewProperties = [self viewPropertyWithReactTag:view.reactTag];

    // 兼容 Native 可视化全埋点 UISegmentedControl 整体不可圈选的场景
    if  ([view isKindOfClass:NSClassFromString(@"UISegmentedControl")]) {
        view.sa_reactnative_screenProperties = _screenProperties;
        return NO;
    }

    // UISegmentedControl 只有子视图 UISegment 是可点击的
    if ([view isKindOfClass:NSClassFromString(@"UISegment")]) {
        SAReactNativeViewProperty *superviewProperties = [self viewPropertyWithReactTag:view.superview.reactTag];
        view.sa_reactnative_screenProperties = _screenProperties;
        return superviewProperties.clickable;
    }

    if (viewProperties.clickable) {
        // 可点击控件需要将当前页面信息保存在 sa_reactnative_screenProperties 中，在可视化全埋点时使用
        view.sa_reactnative_screenProperties = _screenProperties;
        return YES;
    }
    return NO;
}

- (BOOL)prepareView:(NSNumber *)reactTag clickable:(BOOL)clickable paramters:(NSDictionary *)paramters {
    if (!clickable) {
        return NO;
    }
    if (!reactTag) {
        return NO;
    }
    // 每个可点击控件都需要添加对应属性，集合内存在对应属性对象即表示控件可点击
    SAReactNativeViewProperty *viewProperty = [[SAReactNativeViewProperty alloc] init];
    viewProperty.reactTag = reactTag;
    viewProperty.clickable = clickable;
    viewProperty.properties = paramters;
    [_viewProperties addObject:viewProperty];
    return YES;
}

#pragma mark - visualize
- (NSDictionary *)visualizeProperties {
    return _isRootViewVisible ? _screenProperties : nil;
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

    SAReactNativeViewProperty *viewProperties = [self viewPropertyWithReactTag:reactTag];
    if ([viewProperties.properties[@"ignore"] boolValue]) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = [self viewWithReactTag:reactTag];
        for (NSString *className in self.reactNativeIgnoreClasses) {
            if ([view isKindOfClass:NSClassFromString(className)]) {
                return;
            }
        }
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        NSString *content = [view.accessibilityLabel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        properties[kSAEventElementContentProperty] = content;
        [properties addEntriesFromDictionary:self.screenProperties];
        [properties addEntriesFromDictionary:viewProperties.properties];
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
        self.screenProperties = pageProps;
    });

    if (autoTrack && ![[SensorsAnalyticsSDK sharedInstance] isAutoTrackEnabled]) {
        return;
    }
    // 忽略 $AppViewScreen 事件
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

#pragma mark - Find RCTRootView
- (RCTRootView *)rootView {
    UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    RCTRootView *rootView = [self findRootViewFromController:root];
    // 如果当前 RootViewController 中有 RCTRootView，就直接返回查找到的 RCTRootView
    if (rootView) {
        return rootView;
    }
    // 混编 React Native 项目时获取当前显示的 UIViewController 中的 RCTRootView
    UIViewController *current = [[SensorsAnalyticsSDK sharedInstance] currentViewController];
    return [self findRootViewFromController:current];
}

- (RCTRootView *)findRootViewFromController:(UIViewController *)controller {
    if (!controller) {
        return nil;
    }
    if ([controller.view isKindOfClass:RCTRootView.class]) {
        return (RCTRootView *)controller.view;
    }
    for (UIView *subview in controller.view.subviews) {
        if ([subview isKindOfClass:RCTRootView.class]) {
            return (RCTRootView *)subview;
        }
    }
    return nil;
}

@end
