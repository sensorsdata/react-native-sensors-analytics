import { NativeModules} from 'react-native';

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
 * 退出登录
 */
function logout () {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.logout && RNSensorsAnalyticsModule.logout();
}

/**
 * 设置用户属性
 *
 * @param profile 类型 {}
 * Sex
 * Age
 */
function profileSet (profile) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.profileSet && RNSensorsAnalyticsModule.profileSet(profile);
}

/**
 * 记录初次设定的属性
 *
 * @param profile 类型 {}
 */
function profileSetOnce (profile) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.profileSetOnce && RNSensorsAnalyticsModule.profileSetOnce(profile);
}


/**
 * 追踪事件
 *
 * @param event 事件名称，类型 String
 * @param properties 事件属性，类型 {}
 */
function track (event, properties) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.track && RNSensorsAnalyticsModule.track(event, properties);
}

/**
 * 事件开始
 *
 * @param event 事件名称，类型 String
 */
function trackTimerStart (event) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.trackTimerStart && RNSensorsAnalyticsModule.trackTimerStart(event);
}

/**
 * 事件结束
 *
 * @param event 事件名称，类型 String
 * @param properties 事件属性，类型 {}
 */
function trackTimerEnd (event, properties) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.trackTimerEnd && RNSensorsAnalyticsModule.trackTimerEnd(event, properties);
}

/**
 * 清除所有事件计时器
 */
function clearTrackTimer(){
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.clearTrackTimer && RNSensorsAnalyticsModule.clearTrackTimer();
}

/**
 * 用于记录首次安装激活、渠道追踪的事件.
 *
 * @param eventName 事件名称，类型 String
 * @param properties 事件属性，类型 {}
 */
function trackInstallation(eventName, properties){
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.trackInstallation && RNSensorsAnalyticsModule.trackInstallation(eventName, properties);
}

/**
 * 切换页面的时候调用，用于记录 $AppViewScreen 事件..
 *
 * @param url 类型 String
 * @param properties 事件属性，类型 {}
 */
function trackViewScreen(url, properties){
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.trackViewScreen && RNSensorsAnalyticsModule.trackViewScreen(url, properties);
}

/**
 * 给一个数值类型的 Profile 增加一个数值. 只能对数值型属性进行操作，若该属性
 * 未设置，则添加属性并设置默认值为 0.
 *
 * @param property 属性名称，类型 String
 * @param value 属性值，类型 Number
 */
function profileIncrement (property, value) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.profileIncrement && RNSensorsAnalyticsModule.profileIncrement(property, value);
}

/**
 * 给一个列表类型的 Profile 增加一个元素.
 *
 * @param property 属性名称，类型 String
 * @param strList 属性值，类型 []
 */
function profileAppend (property, strList) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.profileAppend && RNSensorsAnalyticsModule.profileAppend(property, strList);
}

/**
 * 删除用户的一个 Profile.
 *
 * @param property 属性名称，类型 String
 */
function profileUnset (property) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.profileUnset && RNSensorsAnalyticsModule.profileUnset(property);
}

/**
 * 删除用户所有 Profile.
 */
function profileDelete () {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.profileDelete && RNSensorsAnalyticsModule.profileDelete();
}

/**
 * Promise 方式，获取 distinctId
 */
function getDistinctIdPromise (){
  if(RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.getDistinctIdPromise){
  return new Promise(function(resolve,reject){
      RNSensorsAnalyticsModule.getDistinctIdPromise().then(
                (result) =>{
                    resolve(result);
                }
            ).catch((msg,error)=>{
              reject(msg,error);
            });
      }
    )};
}

/**
 * Promise 方式 getAnonymousId 获取匿名 ID.
 */
function getAnonymousIdPromise () {
  if(RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.getAnonymousIdPromise){
  return new Promise(function(resolve,reject){
      RNSensorsAnalyticsModule.getAnonymousIdPromise().then(
                (result) =>{
                    resolve(result);
                }
            ).catch((msg,error)=>{
              reject(msg,error);
            });
      }
    )};
}

/**
 * 设置的公共属性
 *
 * @param properties 公共属性，类型 {}
 */
function registerSuperProperties (properties) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.registerSuperProperties && RNSensorsAnalyticsModule.registerSuperProperties(properties);
}

/**
 * 删除某个公共属性
 *
 * @param property 要删除的公共属性属性名称，类型 String
 */
function unregisterSuperProperty (property) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.unregisterSuperProperty && RNSensorsAnalyticsModule.unregisterSuperProperty(property);
}

/**
 * 删除所有公共属性
 */
function clearSuperProperties () {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.clearSuperProperties && RNSensorsAnalyticsModule.clearSuperProperties();
}

/**
 * 强制发送数据到服务端
 */
function flush () {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.flush && RNSensorsAnalyticsModule.flush();
}

/**
 * 删除本地数据库的所有数据！！！请谨慎使用
 */
function deleteAll () {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.deleteAll && RNSensorsAnalyticsModule.deleteAll();
}

/**
 * 调用 track 接口，并附加渠道信息.
 *
 * @param eventName 事件名称，类型 String
 * @param properties 事件属性，类型 {}
 */
function trackChannelEvent (eventName, properties) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.trackChannelEvent && RNSensorsAnalyticsModule.trackChannelEvent(eventName, properties);
}

/**
 * 替换“匿名 ID”
 *
 * @param anonymousId 传入的的匿名 ID，仅接受数字、下划线和大小写字母，类型 String
 */
function identify (anonymousId) {
  RNSensorsAnalyticsModule && RNSensorsAnalyticsModule.identify && RNSensorsAnalyticsModule.identify(anonymousId);
}

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
  trackChannelEvent,
  identify,
  sa: RNSensorsAnalyticsModule,
};
