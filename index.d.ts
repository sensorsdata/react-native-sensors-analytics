declare type PropertiesType = string | number | boolean | Array<string>;

declare type PropertiesObjectType = { [key: string]: PropertiesType }

declare type Config = {
  server_url: string,//数据接收地址，默认 ""
  show_log: boolean,//是否显示日志,默认 false
  ios: {//iOS 端特有配置
    max_cache_size?: number //最大缓存条数，默认 10000
  },
  global_properties?:PropertiesObjectType,// 全局属性
  auto_track: SAAutoTrackType,// 全埋点开关，默认不开启
  javascript_bridge: boolean,//H5 打通开关，默认 false
  flush_interval: number,//数据上报间隔，默认 15*1000 毫秒
  flush_bulksize: number,//数据缓存上报最大条数，默认 100 条
  encrypt: boolean,//默认 false
  android: {//Android 端特有配置
    max_cache_size?: number,//最大缓存数，默认 32*1024*1024
    jellybean?: boolean, //支持 Android 16 以下版本打通，默认 false
    sub_process_flush?: boolean //支持子进程上报，默认 false
  },
  visualized: {
    auto_track?: boolean,// 可视化开关，默认 false
    properties?: boolean // 可视化自定义属性，默认 false
  },
  heat_map: boolean     // 点击图开关，默认 false
}

declare enum SAAutoTrackType {
  START = 1,
  END = 2,
  CLICK = 4,
  VIEW_SCREEN = 8
}

/**
 * 登录
 *
 * @param loginId 登录 Id
 */
export function login(loginId: string): void;

/**
 * 退出登录
 */
export function logout(): void;

/**
 * 设置用户属性
 *
 * @param profile 用户属性
 */
export function profileSet(profile: PropertiesObjectType): void;

/**
 * 记录初次设定的属性
 *
 * @param profile 用户属性
 */
export function profileSetOnce(profile: PropertiesObjectType): void;

/**
 * 追踪事件
 *
 * @param event 事件名称
 * @param properties 事件属性
 */
export function track(event: string, properties?: PropertiesObjectType): void;

/**
 * 事件开始
 *
 * @param event 事件名称
 */
export function trackTimerStart(event: string): void;

/**
 * 事件结束
 *
 * @param event 事件名称
 * @param properties 事件属性
 */
export function trackTimerEnd(event: string, properties?: PropertiesObjectType): void;

/**
 * 清除所有事件计时器
 */
export function clearTrackTimer(): void;

/**
 * 用于记录首次安装激活、渠道追踪的事件.
 *
 * @param eventName 事件名称
 * @param properties 事件属性
 */
export function trackInstallation(eventName: string, properties?: PropertiesObjectType): void;

/**
 * 切换页面的时候调用，用于记录 $AppViewScreen 事件..
 *
 * @param url 页面 url
 * @param properties 事件属性
 */
export function trackViewScreen(url: string, properties?: PropertiesObjectType): void;

/**
 * 给一个数值类型的 Profile 增加一个数值. 只能对数值型属性进行操作，若该属性
 * 未设置，则添加属性并设置默认值为 0.
 *
 * @param property 属性名称
 * @param value 属性值
 */
export function profileIncrement(property: string, value: number): void;

/**
 * 给一个列表类型的 Profile 增加一个元素.
 *
 * @param property 属性名称
 * @param strList 属性值
 */
export function profileAppend(property: string, strList: Array<string>): void;

/**
 * 删除用户的一个 Profile.
 *
 * @param property 属性名称
 */
export function profileUnset(property: string): void;

/**
 * 删除用户所有 Profile.
 */
export function profileDelete(): void;

/**
 * Promise 方式，获取 distinctId
 */
export function getDistinctIdPromise(): Promise<string>;

/**
 * Promise 方式 getAnonymousId 获取匿名 ID.
 */
export function getAnonymousIdPromise(): Promise<string>;

/**
 * 设置的公共属性
 *
 * @param properties 公共属性
 */
export function registerSuperProperties(properties: PropertiesObjectType): void;

/**
 * 删除某个公共属性
 *
 * @param property 要删除的公共属性属性名称
 */
export function unregisterSuperProperty(property: string): void;

/**
 * 删除所有公共属性
 */
export function clearSuperProperties(): void;

/**
 * 强制发送数据到服务端
 */
export function flush(): void;

/**
 * 删除本地数据库的所有数据！！！请谨慎使用
 */
export function deleteAll(): void;

/**
/**
 * 替换“匿名 ID”
 *
 * @param anonymousId 传入的的匿名 ID，仅接受数字、下划线和大小写字母
 */
export function identify(anonymousId: string): void;
/**
 * 导出 trackTimerPause 方法给 RN 使用.
 *
 * <p>暂停事件计时器，计时单位为秒。
 *
 * @param eventName 事件的名称
 */
export function trackTimerPause(eventName: string): void;

/**
 * 导出 trackTimerResume 方法给 RN 使用.
 *
 * <p>恢复事件计时器，计时单位为秒。
 *
 * @param eventName 事件的名称
 */
export function trackTimerResume(eventName: string): void;

/**
 * 保存用户推送 ID 到用户表
 *
 * @param pushTypeKey 属性名称（例如 jgId）
 * @param pushId 推送 ID
 *     <p>使用 profilePushId("jgId", pushId) 例如极光 pushId
 *     获取方式：JPushModule.getRegistrationID(callback)
 */
export function profilePushId(pushTypeKey: string, pushId: string): void;

/**
 * 删除用户设置的 pushId
 *
 * @param pushTypeKey 属性名称（例如 jgId）
 */
export function profileUnsetPushId(pushTypeKey: string): void;

/**
 * 重置默认匿名 id
 */
export function resetAnonymousId(): void;

/**
 * 设置当前 serverUrl
 *
 * @param serverUrl 当前 serverUrl
 */
export function setServerUrl(serverUrl: string): void;

/**
 * 设置 item
 *
 * @param itemType item 类型
 * @param itemId item ID
 * @param properties item 相关属性
 */
export function itemSet(itemType: string, itemId: string, properties?: PropertiesObjectType): void;

/**
 * 删除 item
 *
 * @param itemType item 类型
 * @param itemId item ID
 */
export function itemDelete(itemType: string, itemId: string): void;

/**
 * 获取事件公共属性
 */
export function getSuperPropertiesPromise(): Promise<PropertiesObjectType>;

/**
 * 返回预置属性
 */
export function getPresetPropertiesPromise(): Promise<PropertiesObjectType>;

/**
 * 获取当前用户的 loginId 若调用前未调用 {@link #login(String)} 设置用户的 loginId，会返回 null
 *
 * @return 当前用户的 loginId
 */
export function getLoginIdPromise(): Promise<string>;

/**
 * 是否开启 AutoTrack
 *
 * @return true: 开启 AutoTrack; false：没有开启 AutoTrack
 */
export function isAutoTrackEnabledPromise(): Promise<boolean>;

/**
 * 是否开启可视化全埋点
 *
 * @return true 代表开启了可视化全埋点， false 代表关闭了可视化全埋点
 */
export function isVisualizedAutoTrackEnabledPromise(): Promise<boolean>;

/**
 * 是否开启点击图
 *
 * @return true 代表开启了点击图，false 代表关闭了点击图
 */
export function isHeatMapEnabledPromise(): Promise<boolean>;

/**
 * 设置 flush 时网络发送策略，默认 3G、4G、WI-FI 环境下都会尝试 flush
 * TYPE_NONE = 0;//NULL
 * TYPE_2G = 1;//2G
 * TYPE_3G = 1 << 1;//3G 2
 * TYPE_4G = 1 << 2;//4G 4
 * TYPE_WIFI = 1 << 3;//WIFI 8
 * TYPE_5G = 1 << 4;//5G 16
 * TYPE_ALL = 0xFF;//ALL 255
 * 例：若需要开启 4G 5G 发送数据，则需要设置 4 + 16 = 20
 */

export function setFlushNetworkPolicy(networkType: number): void;

/**
 * 记录 $AppInstall 事件，用于在 App 首次启动时追踪渠道来源，并设置追踪渠道事件的属性。
 * 这是 Sensors Analytics 进阶功能，请参考文档 https://sensorsdata.cn/manual/track_installation.html
 *
 * @param properties 渠道追踪事件的属性
 */
export function trackAppInstall(properties?: PropertiesObjectType): void;

/**
 * 注册事件动态公共属性
 * @return 动态公共属性监听对象
 */
export function registerDynamicSuperProperties(): object;


/**
 * 绑定业务 ID
 *
 * @param key ID
 * @param value 值
 */
export function bind(key: string, value: string): void;

/**
 * 解绑业务 ID
 *
 * @param key ID
 * @param value 值
 */
export function unbind(key: string, value: string): void;

/**
 * 初始化 SDK
 *
 * @param config 初始化配置，支持参数可参考{link https://manual.sensorsdata.cn/sa/latest/react-native-1574001.html#id-.ReactNativev1.13-%E5%88%9D%E5%A7%8B%E5%8C%96SDK}
 */
export function init(config: Partial<Config>): void

/************** Android only start *****************/
/**
 * 设置 App 切换到后台与下次事件的事件间隔
 * 默认值为 30*1000 毫秒
 * 若 App 在后台超过设定事件，则认为当前 Session 结束，发送 $AppEnd 事件
 *
 * @platform Android
 *
 * @param sessionIntervalTime int
 */
export function setSessionIntervalTime(sessionIntervalTime: number): void;

/**
 * 获取 App 切换到后台与下次事件的事件间隔时长设置
 * 默认值为 30*1000 毫秒
 * 若 App 在后台超过设定事件，则认为当前 Session 结束，发送 $AppEnd 事件
 *
 * @platform Android
 *
 * @return 返回设置的 SessionIntervalTime ，默认是 30s
 */
export function getSessionIntervalTimePromise(): Promise<number>;

/**
 * 设置是否允许请求网络，默认是 true
 *
 * @platform Android
 *
 * @param isRequest boolean
 */
export function enableNetworkRequest(isRequest: boolean): void;

/**
 * 是否允许请求网络，默认是 true
 *
 * @platform Android
 *
 * @return 是否允许请求网络
 */
export function isNetworkRequestEnablePromise(): Promise<boolean>;

/**
 * 开启数据采集
 */
export function enableDataCollect(): void;

/************** Android only end *****************/
