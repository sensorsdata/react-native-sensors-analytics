import { NativeModules, TurboModuleRegistry } from 'react-native';
// index.ts
import NativeSensorsAnalyticsModule from "./src/NativeSensorsAnalyticsModule";

const { RNSensorsAnalyticsModule, RNSensorsDataModule } = NativeModules;

// 默认使用原有的 NativeModules 实现
let SensorsAnalyticsModule = RNSensorsAnalyticsModule;
let SensorsDataModule = RNSensorsDataModule;

// 判断是否为鸿蒙平台
if (NativeSensorsAnalyticsModule) {
  try {
    if (NativeSensorsAnalyticsModule.currentPlatform && NativeSensorsAnalyticsModule.currentPlatform() === 'HarmonyOS') {
      // 鸿蒙加载神策鸿蒙 TurboModul，即 NativeSensorsAnalyticsModule
      SensorsAnalyticsModule = NativeSensorsAnalyticsModule;
      SensorsDataModule = NativeSensorsAnalyticsModule;
    }
  } catch (e) {
    // 获取失败则继续使用原有实现
  }
}

const SAAutoTrackType = {
  START: 1,
  END: 2,
  CLICK: 4,
  VIEW_SCREEN: 8
}
/**
 * 登录
 *
 * @param loginId
 */
function login(loginId) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.login &&
    SensorsAnalyticsModule.login(loginId);
}

/**
 * 退出登录
 */
function logout() {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.logout &&
    SensorsAnalyticsModule.logout();
}

/**
 * 设置用户属性
 *
 * @param profile 类型 {}
 * Sex
 * Age
 */
function profileSet(profile) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.profileSet &&
    SensorsAnalyticsModule.profileSet(profile);
}

/**
 * 记录初次设定的属性
 *
 * @param profile 类型 {}
 */
function profileSetOnce(profile) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.profileSetOnce &&
    SensorsAnalyticsModule.profileSetOnce(profile);
}


/**
 * 追踪事件
 *
 * @param event 事件名称，类型 String
 * @param properties 事件属性，类型 {}
 */
function track(event, properties) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.track &&
    SensorsAnalyticsModule.track(event, properties);
}

/**
 * 事件开始
 *
 * @param event 事件名称，类型 String
 */
function trackTimerStart(event) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.trackTimerStart &&
    SensorsAnalyticsModule.trackTimerStart(event);
}

/**
 * 事件结束
 *
 * @param event 事件名称，类型 String
 * @param properties 事件属性，类型 {}
 */
function trackTimerEnd(event, properties) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.trackTimerEnd &&
    SensorsAnalyticsModule.trackTimerEnd(event, properties);
}

/**
 * 清除所有事件计时器
 */
function clearTrackTimer() {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.clearTrackTimer &&
    SensorsAnalyticsModule.clearTrackTimer();
}

/**
 * 用于记录首次安装激活、渠道追踪的事件.
 * 旧版接口，HarmonyOS 不支持
 *
 * @param eventName 事件名称，类型 String
 * @param properties 事件属性，类型 {}
 */
function trackInstallation(eventName, properties) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.trackInstallation &&
    SensorsAnalyticsModule.trackInstallation(eventName, properties);
}

/**
 * 切换页面的时候调用，用于记录 $AppViewScreen 事件..
 *
 * @param url 类型 String
 * @param properties 事件属性，类型 {}
 */
function trackViewScreen(url, properties) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.trackViewScreen &&
    SensorsAnalyticsModule.trackViewScreen(url, properties);
}

/**
 * 给一个数值类型的 Profile 增加一个数值. 只能对数值型属性进行操作，若该属性
 * 未设置，则添加属性并设置默认值为 0.
 *
 * @param property 属性名称，类型 String
 * @param value 属性值，类型 Number
 */
function profileIncrement(property, value) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.profileIncrement &&
    SensorsAnalyticsModule.profileIncrement(property, value);
}

/**
 * 给一个列表类型的 Profile 增加一个元素.
 *
 * @param property 属性名称，类型 String
 * @param strList 属性值，类型 []
 */
function profileAppend(property, strList) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.profileAppend &&
    SensorsAnalyticsModule.profileAppend(property, strList);
}

/**
 * 删除用户的一个 Profile.
 *
 * @param property 属性名称，类型 String
 */
function profileUnset(property) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.profileUnset &&
    SensorsAnalyticsModule.profileUnset(property);
}

/**
 * 删除用户所有 Profile.
 */
function profileDelete() {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.profileDelete &&
    SensorsAnalyticsModule.profileDelete();
}

/**
 * Promise 方式，获取 distinctId
 */
async function getDistinctIdPromise() {
  if (SensorsAnalyticsModule && SensorsAnalyticsModule.getDistinctIdPromise) {
    try {
      return await SensorsAnalyticsModule.getDistinctIdPromise();
    } catch (e) {
      console.log(e);
    }
  }
}

/**
 * Promise 方式 getAnonymousId 获取匿名 ID.
 */
async function getAnonymousIdPromise() {
  if (SensorsAnalyticsModule && SensorsAnalyticsModule.getAnonymousIdPromise) {
    try {
      return await SensorsAnalyticsModule.getAnonymousIdPromise();
    } catch (e) {
      console.log(e);
    }
  }
}

/**
 * 设置的公共属性
 *
 * @param properties 公共属性，类型 {}
 */
function registerSuperProperties(properties) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.registerSuperProperties &&
    SensorsAnalyticsModule.registerSuperProperties(properties);
}

/**
 * 删除某个公共属性
 *
 * @param property 要删除的公共属性属性名称，类型 String
 */
function unregisterSuperProperty(property) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.unregisterSuperProperty &&
    SensorsAnalyticsModule.unregisterSuperProperty(property);
}

/**
 * 删除所有公共属性
 */
function clearSuperProperties() {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.clearSuperProperties &&
    SensorsAnalyticsModule.clearSuperProperties();
}

/**
 * 强制发送数据到服务端
 */
function flush() {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.flush &&
    SensorsAnalyticsModule.flush();
}

/**
 * 删除本地数据库的所有数据！！！请谨慎使用
 */
function deleteAll() {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.deleteAll &&
    SensorsAnalyticsModule.deleteAll();
}

/**
 * 替换“匿名 ID”
 *
 * @param anonymousId 传入的的匿名 ID，仅接受数字、下划线和大小写字母，类型 String
 */
function identify(anonymousId) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.identify &&
    SensorsAnalyticsModule.identify(anonymousId);
}
/**
 * 导出 trackTimerPause 方法给 RN 使用.
 *
 * <p>暂停事件计时器，计时单位为秒。
 *
 * @param eventName 事件的名称
 */
function trackTimerPause(eventName) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.trackTimerPause &&
    SensorsAnalyticsModule.trackTimerPause(eventName);
}

/**
 * 导出 trackTimerResume 方法给 RN 使用.
 *
 * <p>恢复事件计时器，计时单位为秒。
 *
 * @param eventName 事件的名称
 */
function trackTimerResume(eventName) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.trackTimerResume &&
    SensorsAnalyticsModule.trackTimerResume(eventName);
}

/**
 * 保存用户推送 ID 到用户表
 * HarmonyOS 暂不支持此接口
 *
 * @param pushTypeKey 属性名称（例如 jgId）
 * @param pushId 推送 ID
 *     <p>使用 profilePushId("jgId", pushId) 例如极光 pushId
 *     获取方式：JPushModule.getRegistrationID(callback)
 */
function profilePushId(pushTypeKey, pushId) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.profilePushId &&
    SensorsAnalyticsModule.profilePushId(pushTypeKey, pushId);
}

/**
 * 删除用户设置的 pushId
 * HarmonyOS 暂不支持此接口
 *
 * @param pushTypeKey 属性名称（例如 jgId）
 */
function profileUnsetPushId(pushTypeKey) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.profileUnsetPushId &&
    SensorsAnalyticsModule.profileUnsetPushId(pushTypeKey);
}

/**
 * 重置默认匿名 id
 */
function resetAnonymousId() {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.resetAnonymousId &&
    SensorsAnalyticsModule.resetAnonymousId();
}

/**
 * 设置当前 serverUrl
 * HarmonyOS 暂不支持此接口
 *
 * @param serverUrl 当前 serverUrl
 */
function setServerUrl(serverUrl) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.setServerUrl &&
    SensorsAnalyticsModule.setServerUrl(serverUrl);
}

/**
 * 设置 item
 *
 * @param itemType item 类型
 * @param itemId item ID
 * @param properties item 相关属性
 */
function itemSet(itemType, itemId, properties) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.itemSet &&
    SensorsAnalyticsModule.itemSet(itemType, itemId, properties);
}

/**
 * 删除 item
 *
 * @param itemType item 类型
 * @param itemId item ID
 */
function itemDelete(itemType, itemId) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.itemDelete &&
    SensorsAnalyticsModule.itemDelete(itemType, itemId);
}

/**
 * 获取事件公共属性
 * HarmonyOS 暂不支持此接口
 * 
 * @return 返回事件公共属性
 */
async function getSuperPropertiesPromise() {
  if (SensorsAnalyticsModule && SensorsAnalyticsModule.getSuperPropertiesPromise) {
    try {
      return await SensorsAnalyticsModule.getSuperPropertiesPromise();
    } catch (e) {
      console.log(e);
    }
  }
}

/**
 * 返回预置属性
 */
async function getPresetPropertiesPromise() {
  if (SensorsAnalyticsModule && SensorsAnalyticsModule.getPresetPropertiesPromise) {
    try {
      return await SensorsAnalyticsModule.getPresetPropertiesPromise();
    } catch (e) {
      console.log(e);
    }
  }
}

/**
 * 获取当前用户的 loginId 若调用前未调用 {@link #login(String)} 设置用户的 loginId，会返回 null
 *
 * @return 当前用户的 loginId
 */
async function getLoginIdPromise() {
  if (SensorsAnalyticsModule && SensorsAnalyticsModule.getLoginIdPromise) {
    try {
      return await SensorsAnalyticsModule.getLoginIdPromise();
    } catch (e) {
      console.log(e);
    }
  }
}

/**
 * 是否开启 AutoTrack
 * HarmonyOS 暂不支持此接口
 *
 * @return true: 开启 AutoTrack; false：没有开启 AutoTrack
 */
async function isAutoTrackEnabledPromise() {
  if (SensorsAnalyticsModule && SensorsAnalyticsModule.isAutoTrackEnabledPromise) {
    try {
      return await SensorsAnalyticsModule.isAutoTrackEnabledPromise();
    } catch (e) {
      console.log(e);
    }
  }
}

/**
 * 是否开启可视化全埋点
 * HarmonyOS 暂不支持此接口
 *
 * @return true 代表开启了可视化全埋点， false 代表关闭了可视化全埋点
 */
async function isVisualizedAutoTrackEnabledPromise() {
  if (SensorsAnalyticsModule && SensorsAnalyticsModule.isVisualizedAutoTrackEnabledPromise) {
    try {
      return await SensorsAnalyticsModule.isVisualizedAutoTrackEnabledPromise();
    } catch (e) {
      console.log(e);
    }
  }
}

/**
 * 是否开启点击图
 * HarmonyOS 暂不支持此接口
 *
 * @return true 代表开启了点击图，false 代表关闭了点击图
 */
async function isHeatMapEnabledPromise() {
  if (SensorsAnalyticsModule && SensorsAnalyticsModule.isHeatMapEnabledPromise) {
    try {
      return await SensorsAnalyticsModule.isHeatMapEnabledPromise();
    } catch (e) {
      console.log(e);
    }
  }
}

/**
 * 设置 flush 时网络发送策略，默认 3G、4G、WI-FI 环境下都会尝试 flush
 * HarmonyOS 暂不支持此接口
 * 
 * TYPE_NONE = 0;//NULL
 * TYPE_2G = 1;//2G
 * TYPE_3G = 1 << 1;//3G 2
 * TYPE_4G = 1 << 2;//4G 4
 * TYPE_WIFI = 1 << 3;//WIFI 8
 * TYPE_5G = 1 << 4;//5G 16
 * TYPE_ALL = 0xFF;//ALL 255
 * HarmonyOS 暂不支持此接口
 * 例：若需要开启 4G 5G 发送数据，则需要设置 4 + 16 = 20
 */

function setFlushNetworkPolicy(networkType) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.setFlushNetworkPolicy &&
    SensorsAnalyticsModule.setFlushNetworkPolicy(networkType);
}

/**
 * 记录 $AppInstall 事件，用于在 App 首次启动时追踪渠道来源，并设置追踪渠道事件的属性。
 * 这是 Sensors Analytics 进阶功能，请参考文档 https://sensorsdata.cn/manual/track_installation.html
 *
 * @param properties 渠道追踪事件的属性
 */
function trackAppInstall(properties) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.trackAppInstall &&
    SensorsAnalyticsModule.trackAppInstall(properties);
}

function registerDynamicSuperProperties() {
  var dynamicProxy = {};
  // 鸿蒙新版直接支持，没必要判断，Androd/iOS 使用原有的接口，使用 registerDynamicPlugin 实现
  if (!NativeSensorsAnalyticsModule.currentPlatform || NativeSensorsAnalyticsModule.currentPlatform() !== 'HarmonyOS') {
    SensorsDataModule && SensorsDataModule.registerDynamicPlugin && SensorsDataModule.registerDynamicPlugin();
  }

  try {
    Object.defineProperty(dynamicProxy, 'properties', {
      set: function (value) {
        if (typeof value === 'object') {
          SensorsDataModule && SensorsDataModule.setDynamicSuperProperties && SensorsDataModule.setDynamicSuperProperties(value);
        }
      }
    });
  } catch (e) {
    console.log(e)
  }
  return dynamicProxy;
}

function bind(key, value) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.bind &&
    SensorsAnalyticsModule.bind(key, value);
}

function unbind(key, value) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.unbind &&
    SensorsAnalyticsModule.unbind(key, value);
}

function init(config) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.init &&
    SensorsAnalyticsModule.init(config);
  SensorsDataModule && SensorsDataModule.registerDynamicPlugin && SensorsDataModule.registerDynamicPlugin();
}

/************** Android only start *****************/
/**
 * 设置 App 切换到后台与下次事件的事件间隔
 * 默认值为 30*1000 毫秒
 * 若 App 在后台超过设定事件，则认为当前 Session 结束，发送 $AppEnd 事件
 *
 * @param sessionIntervalTime int
 */
function setSessionIntervalTime(sessionIntervalTime) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.setSessionIntervalTime &&
    SensorsAnalyticsModule.setSessionIntervalTime(sessionIntervalTime);
}

/**
 * 获取 App 切换到后台与下次事件的事件间隔时长设置
 * 默认值为 30*1000 毫秒
 * 若 App 在后台超过设定事件，则认为当前 Session 结束，发送 $AppEnd 事件
 *
 * @return 返回设置的 SessionIntervalTime ，默认是 30s
 */
async function getSessionIntervalTimePromise() {
  if (SensorsAnalyticsModule && SensorsAnalyticsModule.getSessionIntervalTimePromise) {
    try {
      return await SensorsAnalyticsModule.getSessionIntervalTimePromise();
    } catch (e) {
      console.log(e);
    }
  }
}

/**
 * 设置是否允许请求网络，默认是 true
 *
 * @param isRequest boolean
 */
function enableNetworkRequest(isRequest) {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.enableNetworkRequest &&
    SensorsAnalyticsModule.enableNetworkRequest(isRequest);
}

/**
 * 是否允许请求网络，默认是 true
 *
 * @return 是否允许请求网络
 */
async function isNetworkRequestEnablePromise() {
  if (SensorsAnalyticsModule && SensorsAnalyticsModule.isNetworkRequestEnablePromise) {
    try {
      return await SensorsAnalyticsModule.isNetworkRequestEnablePromise();
    } catch (e) {
      console.log(e);
    }
  }
}

/**
 * 开启数据采集
 */
function enableDataCollect() {
  SensorsAnalyticsModule &&
    SensorsAnalyticsModule.enableDataCollect &&
    SensorsAnalyticsModule.enableDataCollect();
}

/************** Android only end *****************/
export { SAAutoTrackType }
export const RNSensorsAnalyticsTurboModule = NativeSensorsAnalyticsModule;

export default {
  login,
  logout,
  profileSet,
  profileSetOnce,
  profileIncrement,
  profileAppend,
  profileUnset,
  profileDelete,
  track,
  trackTimerStart,
  trackTimerEnd,
  clearTrackTimer,
  trackInstallation,
  trackViewScreen,
  getDistinctIdPromise,
  getAnonymousIdPromise,
  registerSuperProperties,
  unregisterSuperProperty,
  clearSuperProperties,
  flush,
  deleteAll,
  identify,
  trackTimerPause,
  trackTimerResume,
  profilePushId,
  profileUnsetPushId,
  resetAnonymousId,
  setServerUrl,
  itemSet,
  itemDelete,
  getSuperPropertiesPromise,
  getPresetPropertiesPromise,
  getLoginIdPromise,
  setSessionIntervalTime,
  getSessionIntervalTimePromise,
  isAutoTrackEnabledPromise,
  isVisualizedAutoTrackEnabledPromise,
  isHeatMapEnabledPromise,
  setFlushNetworkPolicy,
  enableNetworkRequest,
  isNetworkRequestEnablePromise,
  trackAppInstall,
  init,
  enableDataCollect,
  registerDynamicSuperProperties,
  bind,
  unbind,
  sa: RNSensorsAnalyticsModule,
};
