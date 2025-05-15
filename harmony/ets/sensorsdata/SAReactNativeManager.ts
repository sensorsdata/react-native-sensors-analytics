//
// SAReactNativeManager
// RNSensorsAnalyticsModule
//
// Created by chuqiangsheng on 2025/02/18.
// Copyright © 2015-2025 Sensors Data Co., Ltd. All rights reserved.
//

import { TimeTracker } from "@sensorsdata/analytics";
import { SA } from './NativeSensorsAnalyticsModule';

// 当前版本号
const kSAReactNativePluginVersion: string = "3.0.2";

// react_native 插件版本号前缀
const kSARNLibPrefix: string = "react_native";

// 采集插件版本号
const kSALibPluginVersionKey: string = "$lib_plugin_version"

export class SAReactNativeManager extends Object {
  private trackTimerList: Map<string, Promise<TimeTracker>> = new Map();
  private isFirstTrack: boolean = true;

  fetchTrackTimer(evetName: string): Promise<TimeTracker> | null {
    if (evetName && typeof evetName === 'string') {
      if (this.trackTimerList.has(evetName)) {
        return this.trackTimerList.get(evetName);
      }
    }
    return null;
  }

  async insertTrackTimer(trackTimer: Promise<TimeTracker>) {
    if (!trackTimer) {
      return;
    }
    this.trackTimerList.set((await trackTimer).event, trackTimer);
  }

  cleanTrackTimer(evetName?: string) {
    if (evetName) {
      this.trackTimerList.delete(evetName);
    } else {
      this.trackTimerList.clear();
    }

  }

  buildLibPluginVersion(properties: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType | null): SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType {
    // 首次触发事件，采集插件属性
    if (this.isFirstTrack) {
      if (properties === undefined || properties === null) {
        properties = {};
      }
      properties[kSALibPluginVersionKey] = [`${kSARNLibPrefix}:${kSAReactNativePluginVersion}`]
      this.isFirstTrack = false;
    }
    return properties;
  }
}