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

/**
 * React Native 保存可点击控件列表信息
 *
 * @param reactTag  当前控件唯一标识符
 * @param clickable  当前控件可点击状态
 * @param paramters  当前控件自定义参数 （预留字段，暂不支持）
 *
*/
RCT_EXPORT_METHOD(saveViewProperties:(NSInteger)reactTag clickable:(BOOL)clickable paramters:(NSDictionary *)paramters) {
    [[SAReactNativeManager sharedInstance] prepareView:@(reactTag) clickable:clickable paramters:paramters];
}

@end
