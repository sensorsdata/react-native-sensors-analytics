//
//  RNSensorsDataModule.m
//  RNSensorsAnalyticsModule
//
//  Created by 彭远洋 on 2020/4/3.
//  Copyright © 2020 ziven.mac. All rights reserved.
//

#import "RNSensorsDataModule.h"
#import "SAReactNativeManager.h"

@implementation RNSensorsDataModule

RCT_EXPORT_MODULE(RNSensorsDataModule)

/**
 * React Native 自动采集点击事件
 *
 * @param reactTag  View 唯一标识符
 *
*/
RCT_EXPORT_METHOD(trackViewClick:(NSInteger)reactTag) {
    [[SAReactNativeManager sharedInstance] trackViewClick:@(reactTag)];
}

/**
 * React Native 自动采集页面浏览事件
 *
 * @param properties  页面相关消息
 *
*/
RCT_EXPORT_METHOD(trackViewScreen:(NSDictionary *)params) {
    // 自动采集页面浏览时 url 在 params
    NSString *url = params[@"sensorsdataurl"];
    NSDictionary *properties = params[@"sensorsdataparams"];
    [[SAReactNativeManager sharedInstance] trackViewScreen:url properties:properties autoTrack:YES];
}

@end
