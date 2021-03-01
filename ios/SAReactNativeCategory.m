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
#import "SAReactNativeswizzler.h"
#import "SAReactNativeManager.h"
#import <objc/runtime.h>
#import <React/RCTUIManager.h>

#pragma mark - UIView Category
@implementation UIView (SAReactNative)

- (NSDictionary *)sa_reactnative_screenProperties {
    return objc_getAssociatedObject(self, @"SensorsAnalyticsRNScreenProperties");
}

- (void)setSa_reactnative_screenProperties:(NSDictionary *)sa_reactnative_screenProperties {
    objc_setAssociatedObject(self, @"SensorsAnalyticsRNScreenProperties", sa_reactnative_screenProperties, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

#pragma mark - UIViewController Category
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
    if ([self isReactRootView:self.view]) {
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
        if ([self isReactRootView:controler.view]) {
            self.sa_reactnative_isReferrerRootView = YES;
        }
    }
}

- (void)sa_reactnative_viewDidDisappear:(BOOL)animated {
    [self sa_reactnative_viewDidDisappear:animated];

    // 当前 Controller 为 React Native 根视图时，消失时将标志位设置为 NO
    if ([self isReactRootView:self.view]) {
        [[SAReactNativeManager sharedInstance] setIsRootViewVisible:NO];
        return;
    }

    // 当前 Controller 的 referrer 为 React Native 根视图时，消失时将标志位设置为 YES
    if (self.sa_reactnative_isReferrerRootView) {
        [[SAReactNativeManager sharedInstance] setIsRootViewVisible:YES];
        return;
    }
}

- (BOOL)isReactRootView:(UIView *)view {
    if ([view isReactRootView]) {
        return YES;
    }
    for (UIView *subview in view.subviews) {
        if ([subview isReactRootView]) {
            return YES;
        }
    }
    return NO;
}

@end
