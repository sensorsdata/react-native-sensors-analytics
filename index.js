import { NativeModules } from 'react-native';

const { RNSensorsAnalyticsModule } = NativeModules;

/**
 * 登录
 *
 * @param loginId
 */
function login (loginId) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.login && RNSensorsAnalyticsModule.login(loginId);
}

/**
 * 注销
 */
function logout () {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.logout && RNSensorsAnalyticsModule.logout();
}

/**
 * 设置用户属性
 *
 * @param profile 用户属性
 * Sex
 * Age
 */
function set (profile) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.set && RNSensorsAnalyticsModule.set(profile);
}

/**
 * 记录初次设定的属性
 *
 * @param profile
 */
function setOnce (profile) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.setOnce && RNSensorsAnalyticsModule.setOnce(profile);
}

/**
 * 开启自动追踪
 *
 * @param eventTypeList 自动采集的类型, eg: ['AppStart', 'AppEnd', 'AppClick', 'AppViewScreen']
 */
function enableAutoTrack (eventTypeList) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.enableAutoTrack && RNSensorsAnalyticsModule.enableAutoTrack(eventTypeList);
}

/**
 * 开启自动追踪,支持 React Native
 *
 * 只支持 Android，iOS 把 Podfile 改成 `pod 'SensorsAnalyticsSDK', :subspecs => ['ENABLE_REACT_NATIVE_APPCLICK']`
 */
function enableReactNativeAutoTrack () {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.enableReactNativeAutoTrack && RNSensorsAnalyticsModule.enableReactNativeAutoTrack();
}

/**
 * 追踪事件
 *
 * @param event
 * @param properties
 */
function track (event, properties,dyproperty = getDynamicProperties()) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.track && RNSensorsAnalyticsModule.track(event, properties,dyproperty);
}

/**
 * 事件开始
 *
 * @param event
 */
function trackBegin (event) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.trackBegin && RNSensorsAnalyticsModule.trackBegin(event);
}

/**
 * 事件结束
 *
 * @param event
 * @param properties
 */
function trackEnd (event, properties) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.trackEnd && RNSensorsAnalyticsModule.trackEnd(event, properties);
}

/**
 * 渠道追踪
 *
 * @param event
 * @param properties
 */
function trackInstallation (event, properties = null) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.trackInstallation && RNSensorsAnalyticsModule.trackInstallation(event, properties);
}

/** 
 * crash 追踪
 */
function trackAppCrash () {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.trackCrash && RNSensorsAnalyticsModule.trackCrash();
}

export default {
  login,
  logout,
  set,
  setOnce,
  enableAutoTrack,
  enableReactNativeAutoTrack,
  track,
  trackBegin,
  trackEnd,
  trackInstallation,
  trackAppCrash,
  sa: RNSensorsAnalyticsModule,
};
