//
// SAReactNativeGlobalPropertyPlugin
// RNSensorsAnalyticsModule
//
// Created by chuqiangsheng on 2025/02/27.
// Copyright © 2015-2025 Sensors Data Co., Ltd. All rights reserved.
//

import { RegisterPropertyPluginArg } from "@sensorsdata/analytics";
import { SA } from './NativeSensorsAnalyticsModule';
import { SAReactNativeUtils } from "./SAReactNativeUtils";

export interface SAReactNativeEventData {
  // 事件属性
  properties: object;

  // 事件名
  event: string;

  // 事件类型
  type: string;
}

/**
 * 定义属性插件，采集全局属性
 */
export class SAReactNativeGlobalPropertyPlugin implements RegisterPropertyPluginArg {
  // 需要采集的全局属性
  globalProperties: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType;

  constructor(properties: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType) {
    this.globalProperties = properties;
  }

  properties(eventData: SAReactNativeEventData): void {
    if (!SAReactNativeUtils.isEmpty(this.globalProperties)) {
      SAReactNativeUtils.addEntriesFromObject(eventData.properties, this.globalProperties);
    }
  }

  // 只对事件类型添加属性，不支持 item 相关
  validEventArray: string[] = ['track', 'track_signup', 'track_id_bind', 'track_id_unbind'];

  isMatchedWithFilter(eventData: SAReactNativeEventData): boolean {
    if (SAReactNativeUtils.isEmpty(this.globalProperties)) {
      return false;
    }

    return this.validEventArray.includes(eventData.type);
  }
}

/**
 * 定义属性插件，采集动态公共属性
 */
export class SAReactNativeDynamicSuperPropertyPlugin implements RegisterPropertyPluginArg {
  // 需要采集的全局属性
  dynamicProperties: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType | null;

  // constructor(properties: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType) {
  //   this.dynamicProperties = properties;
  // }

  properties(eventData: SAReactNativeEventData): void {
    if (!SAReactNativeUtils.isEmpty(this.dynamicProperties)) {
      SAReactNativeUtils.addEntriesFromObject(eventData.properties, this.dynamicProperties);
    }
  }

  // 只对事件类型添加属性，不支持 item 相关
  validEventArray: string[] = ['track', 'track_signup', 'track_id_bind', 'track_id_unbind'];

  isMatchedWithFilter(eventData: SAReactNativeEventData): boolean {
    if (SAReactNativeUtils.isEmpty(this.dynamicProperties)) {
      return false;
    }
    return this.validEventArray.includes(eventData.type);
  }
}
