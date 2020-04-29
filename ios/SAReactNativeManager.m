//
// SAReactNativeManager.m
// SensorsAnalyticsSDK
//
// Created by 彭远洋 on 2020/3/16.
// Copyright © 2020 Sensors Data Co., Ltd. All rights reserved.
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
#import <React/RCTBridge.h>
#import <React/RCTRootView.h>
#import <React/RCTUIManager.h>

#if __has_include("SensorsAnalyticsSDK.h")
#import "SensorsAnalyticsSDK.h"
#else
#import <SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>
#endif

@interface SAReactNativeManager ()

@property (nonatomic, copy) NSString *currentScreenName;
@property (nonatomic, copy) NSString *currentTitle;

@end

@implementation SAReactNativeManager

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static SAReactNativeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SAReactNativeManager alloc] init];
    });
    return manager;
}

#pragma mark - public
- (void)trackViewClick:(NSNumber *)reactTag {
    if (![[SensorsAnalyticsSDK sharedInstance] isAutoTrackEnabled]) {
        return;
    }
    // 忽略 $AppClick 事件
    if ([[SensorsAnalyticsSDK sharedInstance] isAutoTrackEventTypeIgnored:SensorsAnalyticsEventTypeAppClick]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = [[SAReactNativeManager sharedInstance] viewForTag:reactTag];
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        NSDictionary *clickProperties = [self viewClickPorperties];
        [properties addEntriesFromDictionary:clickProperties];
        properties[@"$element_content"] = [view accessibilityLabel];

        [[SensorsAnalyticsSDK sharedInstance] trackViewAppClick:view withProperties:[properties copy]];
    });
}

- (void)trackViewScreen:(nullable NSString *)url properties:(nullable NSDictionary *)properties autoTrack:(BOOL)autoTrack {
    if (url && ![url isKindOfClass:NSString.class]) {
        NSLog(@"[RNSensorsAnalytics] error: url {%@} is not String Class ！！！", url);
        return;
    }
    NSString *screenName = properties[@"$screen_name"] ?: url;
    NSString *title = properties[@"$title"];
    NSDictionary *pageProps = [self viewScreenProperties:screenName title:title];

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

    [[SensorsAnalyticsSDK sharedInstance] trackViewScreen:url withProperties:[eventProps copy]];
}

#pragma mark - SDK Method
+ (RCTRootView *)rootView {
    // RCTRootView 只能是 UIViewController 的 view，不能作为其他 View 的 SubView 使用
    UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIView *view = [root view];
    // 不是混编 React Native 项目时直接获取 RootViewController 的 view
    if ([view isKindOfClass:RCTRootView.class]) {
        return (RCTRootView *)view;
    }
    Class utils = NSClassFromString(@"SAAutoTrackUtils");
    if (!utils) {
        return nil;
    }
    SEL currentCallerSEL = NSSelectorFromString(@"currentViewController");
    if (![utils respondsToSelector:currentCallerSEL]) {
        return nil;
    }

    // 混编 React Native 项目时获取当前显示的 UIViewController 的 view
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    UIViewController *caller = [utils performSelector:currentCallerSEL];
#pragma clang diagnostic pop

    if (![caller.view isKindOfClass:RCTRootView.class]) {
        return nil;
    }
    return (RCTRootView *)caller.view;
}

#pragma mark - private
- (UIView *)viewForTag:(NSNumber *)reactTag {
    RCTRootView *rootView = [SAReactNativeManager rootView];
    RCTUIManager *manager = rootView.bridge.uiManager;
    return [manager viewForReactTag:reactTag];
}

- (NSDictionary *)viewScreenProperties:(NSString *)screenName title:(NSString *)title {
    _currentScreenName = screenName;
    _currentTitle = title ?: screenName;
    return [self viewClickPorperties];
}

- (NSDictionary *)viewClickPorperties {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    properties[@"$screen_name"] = _currentScreenName;
    properties[@"$title"] = _currentTitle;
    return [properties copy];
}

@end
