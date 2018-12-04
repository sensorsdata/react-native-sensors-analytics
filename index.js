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
 * 设置用户属性
 *
 * @param profile 用户属性
 * Sex
 * Age
 */
function profileSet (profile) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.profileSet && RNSensorsAnalyticsModule.profileSet(profile);
}

/**
 * 记录初次设定的属性
 *
 * @param profile
 */
function profileSetOnce (profile) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.profileSetOnce && RNSensorsAnalyticsModule.profileSetOnce(profile);
}


/**
 * 追踪事件
 *
 * @param event
 * @param properties
 */
function track (event, properties) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.track && RNSensorsAnalyticsModule.track(event, properties);
}

/**
 * 事件开始
 *
 * @param event
 */
function trackTimerStart (event) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.trackTimerStart && RNSensorsAnalyticsModule.trackTimerStart(event);
}

/**
 * 事件结束
 *
 * @param event
 * @param properties
 */
function trackTimerEnd (event, properties) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.trackEnd && RNSensorsAnalyticsModule.trackEnd(event, properties);
}


export default {
  login,
  profileSet,
  profileSetOnce,
  track,
  trackTimerStart,
  trackTimerEnd,
  sa: RNSensorsAnalyticsModule,
};
