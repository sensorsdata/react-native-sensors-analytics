//
// NativeSensorsAnalyticsModule
// RNSensorsAnalyticsModule
//
// Created by chuqiangsheng on 2025/02/18.
// Copyright © 2015-2025 Sensors Data Co., Ltd. All rights reserved.
//

import type { TurboModule } from 'react-native/Libraries/TurboModule/RCTExport';
import { TurboModuleRegistry } from 'react-native';

type SAPropertiesType = string | boolean | number | Array<string> | Date | Function;

export type SAPropertiesObjectType = { [key: string]: SAPropertiesType }

/**
 * HarmonyOS 初始化配置
 */
export type SAConfigOptions = {
    server_url: string,//数据接收地址，默认 ""
    show_log: boolean,//是否显示日志,默认 false
    harmony: {// HarmonyOS 端特有配置
        max_cache_size?: number //最大缓存条数，默认 10000
    },
    global_properties?: SAPropertiesObjectType,// 全局属性
    javascript_bridge: boolean,//H5 打通开关，默认 false
    flush_interval: number,//数据上报间隔，默认 15*1000 毫秒
    flush_bulksize: number,//数据缓存上报最大条数，默认 100 条
}

declare enum SAAutoTrackType {
    START = 1,
    END = 2,
    CLICK = 4,
    VIEW_SCREEN = 8
}

export interface Spec extends TurboModule {

    /**
     * 登录
     *
     * @param loginId 登录 Id
     */
    login(loginId: string): void;

    /**
     * 退出登录
     */
    logout(): void;

    /**
     * 设置用户属性
     *
     * @param profile 用户属性
     */
    profileSet(profile: SAPropertiesObjectType): void;

    /**
     * 记录初次设定的属性
     *
     * @param profile 用户属性
     */
    profileSetOnce(profile: SAPropertiesObjectType): void;

    /**
     * 追踪事件
     *
     * @param event 事件名称
     * @param properties 事件属性
     */
    track(event: string, properties?: SAPropertiesObjectType): void;

    /**
     * 事件开始
     *
     * @param event 事件名称
     */
    trackTimerStart(event: string): void;

    /**
     * 事件结束
     *
     * @param event 事件名称
     * @param properties 事件属性
     */
    trackTimerEnd(event: string, properties?: SAPropertiesObjectType): void;

    /**
     * 清除所有事件计时器
     */
    clearTrackTimer(): void;

    /**
     * 切换页面的时候调用，用于记录 $AppViewScreen 事件..
     *
     * @param url 页面 url
     * @param properties 事件属性
     */
    trackViewScreen(url: string, properties?: SAPropertiesObjectType): void;

    /**
     * 给一个数值类型的 Profile 增加一个数值. 只能对数值型属性进行操作，若该属性
     * 未设置，则添加属性并设置默认值为 0.
     *
     * @param property 属性名称
     * @param value 属性值
     */
    profileIncrement(property: string, value: number): void;

    /**
     * 给一个列表类型的 Profile 增加一个元素.
     *
     * @param property 属性名称
     * @param strList 属性值
     */
    profileAppend(property: string, strList: Array<string>): void;

    /**
     * 删除用户的一个 Profile.
     *
     * @param property 属性名称
     */
    profileUnset(property: string): void;

    /**
     * 删除用户所有 Profile.
     */
    profileDelete(): void;

    /**
     * Promise 方式，获取 distinctId
     */
    getDistinctIdPromise(): Promise<string>;

    /**
     * Promise 方式 getAnonymousId 获取匿名 ID.
     */
    getAnonymousIdPromise(): Promise<string>;

    /**
     * 设置的公共属性
     *
     * @param properties 公共属性
     */
    registerSuperProperties(properties: SAPropertiesObjectType): void;

    /**
     * 删除某个公共属性
     *
     * @param property 要删除的公共属性属性名称
     */
    unregisterSuperProperty(property: string): void;

    /**
     * 删除所有公共属性
     */
    clearSuperProperties(): void;

    /**
     * 强制发送数据到服务端
     */
    flush(): void;

    /**
     * 删除本地数据库的所有数据！！！请谨慎使用
     */
    deleteAll(): void;

    /**
    /**
     * 替换“匿名 ID”
     *
     * @param anonymousId 传入的的匿名 ID，仅接受数字、下划线和大小写字母
     */
    identify(anonymousId: string): void;
    /**
     * 导出 trackTimerPause 方法给 RN 使用.
     *
     * <p>暂停事件计时器，计时单位为秒。
     *
     * @param eventName 事件的名称
     */
    trackTimerPause(eventName: string): void;

    /**
     * 导出 trackTimerResume 方法给 RN 使用.
     *
     * <p>恢复事件计时器，计时单位为秒。
     *
     * @param eventName 事件的名称
     */
    trackTimerResume(eventName: string): void;

    /**
     * 重置默认匿名 id
     */
    resetAnonymousId(): void;

    /**
     * 设置 item
     *
     * @param itemType item 类型
     * @param itemId item ID
     * @param properties item 相关属性
     */
    itemSet(itemType: string, itemId: string, properties?: SAPropertiesObjectType): void;

    /**
     * 删除 item
     *
     * @param itemType item 类型
     * @param itemId item ID
     */
    itemDelete(itemType: string, itemId: string): void;

    /**
     * 返回预置属性
     */
    getPresetPropertiesPromise(): Promise<SAPropertiesObjectType>;

    /**
     * 获取当前用户的 loginId 若调用前未调用 {@link #login(String)} 设置用户的 loginId，会返回 null
     *
     * @return 当前用户的 loginId
     */
    getLoginIdPromise(): Promise<string>;

    /**
     * 记录 $AppInstall 事件，用于在 App 首次启动时追踪渠道来源，并设置追踪渠道事件的属性。
     * 这是 Sensors Analytics 进阶功能，请参考文档 https://sensorsdata.cn/manual/track_installation.html
     *
     * @param properties 渠道追踪事件的属性
     */
    trackAppInstall(properties?: SAPropertiesObjectType): void;

    /**
     * 注册事件动态公共属性
     * @return 动态公共属性监听对象
     */
    setDynamicSuperProperties(properties: SAPropertiesObjectType): void;


    /**
     * 绑定业务 ID
     *
     * @param key ID
     * @param value 值
     */
    bind(key: string, value: string): void;

    /**
     * 解绑业务 ID
     *
     * @param key ID
     * @param value 值
     */
    unbind(key: string, value: string): void;

    /**
     * 初始化 SDK
     *
     * @param config 初始化配置，支持参数可参考{link https://manual.sensorsdata.cn/sa/latest/react-native-1574001.html#id-.ReactNativev1.13-%E5%88%9D%E5%A7%8B%E5%8C%96SDK}
     */
    init(config: Partial<SAConfigOptions>): void

    /**
     * 获取当前平台
     * 
     * 非 SA 接口，内部使用，方便 js 调用区分平台
     * @return 鸿蒙返回 HarmonyOS，其他返回 null
     */
    currentPlatform(): string;
}

export default TurboModuleRegistry.get<Spec>(
    'NativeSensorsAnalyticsModule',
) as Spec | null;