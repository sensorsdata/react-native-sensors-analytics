//
// SAReactNativeManager.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAReactNativeManager : NSObject

@property (nonatomic, copy, readonly) NSString *currentScreenName;

+ (instancetype)sharedInstance;

/**
 @abstract
 触发 React Native 点击事件

 @param reactTag  React Native 分配的唯一标识符
 */
- (void)trackViewClick:(NSNumber *)reactTag;

/**
 @abstract
 触发 React Native 页面浏览事件

 @param url  页面路径
 @param properties  自定义页面属性
 @param autoTrack  是否为自动埋点
 */
- (void)trackViewScreen:(nullable NSString *)url properties:(nullable NSDictionary *)properties autoTrack:(BOOL)autoTrack;

@end

NS_ASSUME_NONNULL_END
