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

#import "SAReactNativeswizzler.h"
#import <objc/runtime.h>


@interface UIView(SAReactNative)
@property (nonatomic, copy) NSDictionary *sa_reactnative_screenProperties;
@end

@implementation UIView(SAReactNative)

- (NSDictionary *)sa_reactnative_screenProperties {
    return objc_getAssociatedObject(self, @"SensorsAnalyticsRNScreenProperties");
}

- (void)setSa_reactnative_screenProperties:(NSDictionary *)sa_reactnative_screenProperties {
    objc_setAssociatedObject(self, @"SensorsAnalyticsRNScreenProperties", sa_reactnative_screenProperties, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@interface SAReactNativeManager ()

@property (nonatomic, copy) NSDictionary *screenProperties;
@property (nonatomic, strong) NSSet *ignoreClasses;
@property (nonatomic, strong) NSMutableSet *clickableViewTags;
@property (nonatomic, assign) BOOL isRootViewVisible;

@end

@interface UIViewController (SAReactNative)

@property (nonatomic, assign) BOOL sa_reactnative_isReferrerRootView;

@end

@implementation UIViewController (SAReactNative)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIViewController sa_reactnative_swizzleMethod:@selector(viewDidAppear:)
                                            withMethod:@selector(sa_reactnative_viewDidAppear:)
                                                 error:NULL];

        [UIViewController sa_reactnative_swizzleMethod:@selector(viewDidDisappear:)
                                            withMethod:@selector(sa_reactnative_viewDidDisappear:)
                                                 error:NULL];
    });
}

- (BOOL)sa_reactnative_isReferrerRootView {
    NSNumber *result = objc_getAssociatedObject(self, @"sa_reactnative_isReferrerRootView");
    return result.boolValue;
}

- (void)setSa_reactnative_isReferrerRootView:(BOOL)isRootView {
    objc_setAssociatedObject(self, @"sa_reactnative_isReferrerRootView", @(isRootView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sa_reactnative_viewDidAppear:(BOOL)animated {
    [self sa_reactnative_viewDidAppear:animated];

    if ([self isKindOfClass:UIAlertController.class]) {
        return;
    }
    // 当前 Controller 为 React Native 根视图时，设置标志位为 YES
    if ([self.view isReactRootView]) {
        [[SAReactNativeManager sharedInstance] setIsRootViewVisible:YES];
        return;
    }

    //检查 referrer 是否为 React Native 根视图
    UIViewController *referrer = self.presentingViewController;
    if (!referrer) {
        return;
    }

    // 当前 Controller 不为 React Native 根视图时， isRootViewVisible 肯定为 NO
    [[SAReactNativeManager sharedInstance] setIsRootViewVisible:NO];

    if ([referrer isKindOfClass:UITabBarController.class]) {
        UIViewController *controller = [(UITabBarController *)referrer selectedViewController];
        [self checkReferrerController:controller];
    } else {
        [self checkReferrerController:referrer];
    }
}

- (void)checkReferrerController:(UIViewController *)controler {
    if ([controler isKindOfClass:UINavigationController.class]) {
        UIViewController *vc = [(UINavigationController *)controler viewControllers].lastObject;
        if ([vc.view isReactRootView]) {
            self.sa_reactnative_isReferrerRootView = YES;
        }
    } else if ([controler isKindOfClass:UIViewController.class]) {
        if ([controler.view isReactRootView]) {
            self.sa_reactnative_isReferrerRootView = YES;
        }
    }
}

- (void)sa_reactnative_viewDidDisappear:(BOOL)animated {
    [self sa_reactnative_viewDidDisappear:animated];

    // 当前 Controller 为 React Native 根视图时，消失时将标志位设置为 NO
    if ([self.view isReactRootView]) {
        [[SAReactNativeManager sharedInstance] setIsRootViewVisible:NO];
        return;
    }

    // 当前 Controller 的 referrer 为 React Native 根视图时，消失时将标志位设置为 YES
    if (self.sa_reactnative_isReferrerRootView) {
        [[SAReactNativeManager sharedInstance] setIsRootViewVisible:YES];
        return;
    }
}

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

- (instancetype)init {
    self = [super init];
    if (self) {
        NSSet *ignoreClasses = [NSSet setWithObjects:@"RCTSwitch", @"RCTSlider", @"RCTSegmentedControl", @"RNGestureHandlerButton", @"RNCSlider", @"RNCSegmentedControl", nil];
        for (NSString *className in ignoreClasses) {
            if (NSClassFromString(className)) {
                [[SensorsAnalyticsSDK sharedInstance] ignoreViewType:NSClassFromString(className)];
            }
        }
        _ignoreClasses = [NSSet setWithObjects:@"RCTScrollView", nil];
        _clickableViewTags = [[NSMutableSet alloc] init];
        _isRootViewVisible = NO;
    }
    return self;
}

#pragma mark - visualize
- (NSDictionary *)visualizeProperties {
    return _isRootViewVisible ? self.screenProperties : nil;
}

- (BOOL)clickableForView:(UIView *)view {
    if ([_ignoreClasses containsObject:NSStringFromClass(view.class)]) {
        return NO;
    }
    BOOL clickable = [_clickableViewTags containsObject:view.reactTag];
    if (clickable) {
        view.sa_reactnative_screenProperties = self.screenProperties;
    }
    return clickable;
}

- (BOOL)prepareView:(NSNumber *)reactTag clickable:(BOOL)clickable paramters:(NSDictionary *)paramters {
    if (!clickable) {
        return NO;
    }
    [_clickableViewTags addObject:reactTag];
    return YES;
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
        UIView *view = [[SAReactNativeManager sharedInstance] viewForTag:reactTag];
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        [properties addEntriesFromDictionary:self.screenProperties];
        properties[@"$element_content"] = [view.accessibilityLabel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        [[SensorsAnalyticsSDK sharedInstance] trackViewAppClick:view withProperties:[properties copy]];
    });
}

#pragma mark - AppViewScreen
- (void)trackViewScreen:(nullable NSString *)url properties:(nullable NSDictionary *)properties autoTrack:(BOOL)autoTrack {
    if (url && ![url isKindOfClass:NSString.class]) {
        NSLog(@"[RNSensorsAnalytics] error: url {%@} is not String Class ！！！", url);
        return;
    }
    NSString *screenName = properties[@"$screen_name"] ?: url;
    NSString *title = properties[@"$title"] ?: screenName;
    NSMutableDictionary *pageProps = [NSMutableDictionary dictionary];
    pageProps[@"$screen_name"] = screenName;
    pageProps[@"$title"] = title;
    self.screenProperties = pageProps;

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

@end
