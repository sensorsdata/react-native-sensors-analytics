//
// RNSensorsAnalyticsModule
// RNSensorsAnalyticsModule
//
// Created by chuqiangsheng on 2025/02/18.
// Copyright © 2015-2025 Sensors Data Co., Ltd. All rights reserved.
//

import { TurboModule } from '@rnoh/react-native-openharmony/ts';
import { SA } from './NativeSensorsAnalyticsModule';
import sensors, { InitPara } from '@sensorsdata/analytics';
import { SAReactNativeManager } from './SAReactNativeManager'
import { UITurboModuleContext } from '@rnoh/react-native-openharmony/src/main/ets/RNOH/RNOHContext';
import { common } from '@kit.AbilityKit';
import { SAReactNativeDynamicSuperPropertyPlugin, SAReactNativeGlobalPropertyPlugin } from './SAReactNativeGlobalPropertyPlugin';
import { SAReactNativeUtils } from './SAReactNativeUtils';

export class RNSensorsAnalyticsModule extends TurboModule implements SA.NativeSensorsAnalyticsModule.Spec {
  private moduleManager: SAReactNativeManager;
  private context: common.UIAbilityContext;
  private dynamicPropertyPlugin: SAReactNativeDynamicSuperPropertyPlugin | undefined = undefined;

  constructor(protected ctx: UITurboModuleContext) {
    super(ctx);
    this.context = ctx.uiAbilityContext;
    this.moduleManager = new SAReactNativeManager();
  }

  login(loginId: string): void {
    sensors.login(loginId);
  }

  logout(): void {
    sensors.logout();
  }

  track(event: string, properties: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType): void {
    sensors.track(event, properties);
  }

  trackTimerStart(event: string): void {
    const timer = sensors.trackTimerStart(event);
    this.moduleManager.insertTrackTimer(timer);
  }

  trackTimerEnd(event: string, properties: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType): void {
    const timer = this.moduleManager.fetchTrackTimer(event);
    if (timer) {
      sensors.trackTimerEnd(timer, properties);
      this.moduleManager.cleanTrackTimer(event);
    }
  }

  clearTrackTimer(): void {
    sensors.clearAllTrackTimer()
    this.moduleManager.cleanTrackTimer();
  }

  trackTimerPause(eventName: string): void {
    const timer = this.moduleManager.fetchTrackTimer(eventName);
    sensors.trackTimerPause(timer);
  }

  trackTimerResume(eventName: string): void {
    const timer = this.moduleManager.fetchTrackTimer(eventName);
    sensors.trackTimerResume(timer);
  }

  trackViewScreen(url: string, properties: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType): void {
    sensors.trackViewScreen({
      $screen_name: url,
    }, properties);
  }

  profileSet(profile: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType): void {
    sensors.setProfile(profile);
  }

  profileSetOnce(profile: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType): void {
    sensors.setOnceProfile(profile);
  }

  profileIncrement(property: string, value: number): void {
    sensors.incrementProfile({ property: value });
  }

  profileAppend(property: string, strList: string[]): void {
    sensors.appendProfile({ property: strList });
  }

  profileUnset(property: string): void {
    sensors.unsetProfile(property);
  }

  profileDelete(): void {
    sensors.deleteProfile({});
  }

  async getDistinctIdPromise(): Promise<string> {
    return await sensors.getDistinctID();
  }

  async getAnonymousIdPromise(): Promise<string> {
    return await sensors.getAnonymousID();
  }

  registerSuperProperties(properties: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType): void {
    sensors.register(properties);
  }

  unregisterSuperProperty(property: string): void {
    sensors.clearAllRegister([property])
  }

  clearSuperProperties(): void {
    sensors.clearAllRegister();
  }

  flush(): void {
    sensors.flush();
  }

  deleteAll(): void {
    sensors.deleteAll();
  }

  identify(anonymousId: string): void {
    sensors.identify(anonymousId);
  }

  resetAnonymousId(): void {
    sensors.resetAnonymousIdentity();
  }

  itemSet(itemType: string, itemId: string, properties: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType): void {
    sensors.setItem(itemType, itemId, properties);
  }

  itemDelete(itemType: string, itemId: string): void {
    sensors.deleteItem(itemType, itemId);
  }

  async getPresetPropertiesPromise(): Promise<SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType> {
    return await sensors.getPresetProperties();
  }

  async getLoginIdPromise(): Promise<string> {
    return await sensors.getLoginID();
  }

  trackAppInstall(properties: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType): void {
    sensors.trackAppInstall(properties);
  }

  setDynamicSuperProperties(properties: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType): void {
    if (SAReactNativeUtils.isEmpty(properties)) {
      return;
    }

    // 注册属性插件，采集动态公共属性
    if (this.dynamicPropertyPlugin === undefined) {
      const plugin = new SAReactNativeDynamicSuperPropertyPlugin();
      sensors.registerPropertyPlugin(plugin);
      this.dynamicPropertyPlugin = plugin;
    }
    this.dynamicPropertyPlugin.dynamicProperties = properties;
  }

  bind(key: string, value: string): void {
    sensors.bind(key, value);
  }

  unbind(key: string, value: string): void {
    sensors.unbind(key, value);
  }

  init(config: SA.NativeSensorsAnalyticsModule.SAConfigOptions): void {

    let rnConfig: InitPara = {
      context: this.context,
      server_url: config.server_url,
      show_log: config.show_log,
      // 是否开启采集位置信息，需要 app 授权，默认 false
      enable_track_location: false,
      // 开启 App 打通 H5
      app_js_bridge: config.javascript_bridge,
      batch_send: {}
    };
    if (config.harmony && config.harmony.max_cache_size) {
      rnConfig.batch_send.max_cache_size = config.harmony.max_cache_size;
    }
    if (config.flush_interval) {
      rnConfig.batch_send.flush_interval = config.flush_interval;
    }
    if (config.flush_bulksize) {
      rnConfig.batch_send.flush_bulk_size = config.flush_bulksize;
    }
    sensors.init(rnConfig);

    // 注册属性插件，采集全局属性
    if (!SAReactNativeUtils.isEmpty(config.global_properties)) {
      const plugin = new SAReactNativeGlobalPropertyPlugin(config.global_properties);
      sensors.registerPropertyPlugin(plugin);
    }
  }

  currentPlatform(): string {
    return 'HarmonyOS';
  }
}