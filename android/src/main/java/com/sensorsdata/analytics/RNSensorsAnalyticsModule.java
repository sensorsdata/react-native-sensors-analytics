/*
 * Created by chenru on 2019/08/27.
 * Copyright 2015－2021 Sensors Data Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.sensorsdata.analytics;


import android.text.TextUtils;
import android.util.Log;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.sensorsdata.analytics.android.sdk.SAConfigOptions;
import com.sensorsdata.analytics.android.sdk.SALog;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPI;
import com.sensorsdata.analytics.property.RNPropertyManager;
import com.sensorsdata.analytics.property.RNGlobalPropertyPlugin;
import com.sensorsdata.analytics.utils.RNUtils;
import com.sensorsdata.analytics.utils.VersionUtils;

import org.json.JSONObject;

import java.util.HashSet;


/**
 * Created by yang on 2017/4/5
 * <p>
 * 参数类型在@ReactMethod注明的方法中，会被直接映射到它们对应的JavaScript类型
 * String -> String
 * ReadableMap -> Object
 * Boolean -> Bool
 * Integer -> Number
 * Double -> Number
 * Float -> Number
 * Callback -> function
 * ReadableArray -> Array
 */

public class RNSensorsAnalyticsModule extends ReactContextBaseJavaModule {

    public RNSensorsAnalyticsModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    private static final String MODULE_NAME = "RNSensorsAnalyticsModule";
    private static final String LOGTAG = "SA.RN";

    /**
     * 返回一个字符串名字，这个名字在 JavaScript (RN)端标记这个模块。
     */
    @Override
    public String getName() {
        return MODULE_NAME;
    }


    /**
     * 参数类型在@ReactMethod注明的方法中，会被直接映射到它们对应的JavaScript类型
     * String -> String
     * ReadableMap -> Object
     * Boolean -> Bool
     * Integer -> Number
     * Double -> Number
     * Float -> Number
     * Callback -> function
     * ReadableArray -> Array
     * <p>
     * 导出 track 方法给 RN 使用.
     *
     * @param eventName 事件名称
     * @param properties 事件的具体属性
     * <p>
     * RN 中使用示例：（记录 RN_AddToFav 事件，事件属性 "ProductID":123456,"UserLevel":"VIP"）
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.track("RN_AddToFav",{"ProductID":123456,"UserLevel":"VIP"})}>
     * </Button>
     */
    @ReactMethod
    public void track(String eventName, ReadableMap properties) {
        try {
            SensorsDataAPI.sharedInstance().track(eventName, RNPropertyManager.mergeProperty(RNUtils.convertToJSONObject(properties)));
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 trackTimerStart 方法给 RN 使用.
     * <p>
     * 初始化事件的计时器，默认计时单位为秒(计时开始).
     *
     * @param eventName 事件的名称.
     * <p>
     * RN 中使用示例：（计时器事件名称 viewTimer ）
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.trackTimerStart("viewTimer")}>
     * </Button>
     */
    @ReactMethod
    public void trackTimerStart(String eventName) {
        try {
            SensorsDataAPI.sharedInstance().trackTimerStart(eventName);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 trackTimerEnd 方法给 RN 使用.
     * <p>
     * 初始化事件的计时器，默认计时单位为毫秒(计时结束，并触发事件)
     *
     * @param eventName 事件的名称.
     * <p>
     * RN 中使用示例：（计时器事件名称 viewTimer ）
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.trackTimerEnd("viewTimer",{"ProductID":123456,"UserLevel":"VIP"})}>
     * </Button>
     */
    @ReactMethod
    public void trackTimerEnd(String eventName, ReadableMap properties) {
        try {
            SensorsDataAPI.sharedInstance().trackTimerEnd(eventName, RNPropertyManager.mergeProperty(RNUtils.convertToJSONObject(properties)));
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 clearTrackTimer 方法给 RN 使用.
     * <p>
     * 清除所有事件计时器
     * <p>
     * RN 中使用示例：（保存用户的属性 "sex":"男"）
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.clearTrackTimer()}>
     * </Button>
     */
    @ReactMethod
    public void clearTrackTimer() {
        try {
            SensorsDataAPI.sharedInstance().clearTrackTimer();
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }


    /**
     * 导出 login 方法给 RN 使用.
     *
     * @param loginId RN 中使用示例：
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.login("developer@sensorsdata.cn")}>
     * </Button>
     */
    @ReactMethod
    public void login(String loginId) {
        try {
            SensorsDataAPI.sharedInstance().login(loginId, RNPropertyManager.mergeProperty(null));
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 logout 方法给 RN 使用.
     * <p>
     * RN 中使用示例：
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.logout()}>
     * </Button>
     */
    @ReactMethod
    public void logout() {
        try {
            SensorsDataAPI.sharedInstance().logout();
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 trackInstallation 方法给 RN 使用.
     * <p>
     * 用于记录首次安装激活、渠道追踪的事件.
     *
     * @param eventName 事件名.
     * @param properties 事件属性.
     * <p>
     * RN 中使用示例：（ 这里事件名为 AppInstall ,事件的渠道属性 "$utm_source":"渠道A","$utm_campaign":"广告A" ）
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.trackInstallation("AppInstall",{"$utm_source":"渠道A","$utm_campaign":"广告A"})}>
     * </Button>
     */
    @ReactMethod
    public void trackInstallation(String eventName, ReadableMap properties) {
        try {
            SensorsDataAPI.sharedInstance().trackInstallation(eventName, RNUtils.convertToJSONObject(properties));
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 trackViewScreen 方法给 RN 使用.
     * <p>
     * 此方法用于 RN 中切换页面的时候调用，用于记录 $AppViewScreen 事件.
     *
     * @param url 页面的 url  记录到 $url 字段中.
     * @param properties 页面的属性.
     * <p>
     * 注：为保证记录到的 $AppViewScreen 事件和 Auto Track 采集的一致，
     * 需要传入 $title（页面的标题） 、$screen_name （页面的名称，即 包名.类名）字段.
     * <p>
     * RN 中使用示例：
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.trackViewScreen(url, {"$title":"RN主页","$screen_name":"cn.sensorsdata.demo.RNHome"})}>
     * </Button>
     */
    @ReactMethod
    public void trackViewScreen(String url, ReadableMap properties) {
        try {
            RNAgent.trackViewScreen(url, RNUtils.convertToJSONObject(properties), false);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 profileSet 方法给 RN 使用.
     *
     * @param properties 用户属性
     * <p>
     * RN 中使用示例：（保存用户的属性 "sex":"男"）
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.profileSet({"sex":"男"})}>
     * </Button>
     */
    @ReactMethod
    public void profileSet(ReadableMap properties) {
        try {
            SensorsDataAPI.sharedInstance().profileSet(RNUtils.convertToJSONObject(properties));
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 profileSetOnce 方法给 RN 使用.
     * <p>
     * 首次设置用户的一个或多个 Profile.
     * 与profileSet接口不同的是，如果之前存在，则忽略，否则，新创建.
     *
     * @param properties 属性列表
     * <p>
     * RN 中使用示例：（保存用户的属性 "sex":"男"）
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.profileSetOnce({"sex":"男"})}>
     * </Button>
     */
    @ReactMethod
    public void profileSetOnce(ReadableMap properties) {
        try {
            SensorsDataAPI.sharedInstance().profileSetOnce(RNUtils.convertToJSONObject(properties));
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }


    /**
     * 导出 profileIncrement 方法给 RN 使用.
     * <p>
     * 给一个数值类型的Profile增加一个数值. 只能对数值型属性进行操作，若该属性
     * 未设置，则添加属性并设置默认值为0.
     *
     * @param property 属性名称
     * @param value 属性的值，值的类型只允许为 Number .
     * <p>
     * RN 中使用示例：
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.profileIncrement("money",10)}>
     * </Button>
     */
    @ReactMethod
    public void profileIncrement(String property, Double value) {
        try {
            SensorsDataAPI.sharedInstance().profileIncrement(property, value);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 profileAppend 方法给 RN 使用.
     * <p>
     * 给一个列表类型的 Profile 增加一个元素.
     *
     * @param property 属性名称.
     * @param strList 新增的元素.
     * <p>
     * RN 中使用示例：
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.profileAppend("VIP",["Gold","Diamond"])}>
     * </Button>
     */
    @ReactMethod
    public void profileAppend(String property, ReadableArray strList) {
        try {
            HashSet<String> strSet = new HashSet<>();
            for (int i = 0; i < strList.size(); i++) {
                strSet.add(strList.getString(i));
            }
            SensorsDataAPI.sharedInstance().profileAppend(property, strSet);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 profileUnset 方法给 RN 使用.
     * <p>
     * 删除用户的一个 Profile.
     *
     * @param property 属性名称.
     * <p>
     * RN 中使用示例：
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.profileUnset("sex")}>
     * </Button>
     */
    @ReactMethod
    public void profileUnset(String property) {
        try {
            SensorsDataAPI.sharedInstance().profileUnset(property);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 profileDelete 方法给 RN 使用.
     * <p>
     * 删除用户所有 Profile.
     * <p>
     * RN 中使用示例：
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.profileDelete()}>
     * </Button>
     */
    @ReactMethod
    public void profileDelete() {
        try {
            SensorsDataAPI.sharedInstance().profileDelete();
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 getDistinctId 方法给 RN 使用.
     * <p>
     * 获取当前的 DistinctId.
     * <p>
     * successCallback 优先返回 mLoginId ，否则返回 mAnonymousId
     * <p>
     * RN 中使用示例：
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.getDistinctId(success=>{
     * console.log(success)
     * },
     * error=>{
     * console.log(error)
     * })
     * }>
     * </Button>
     */
    @ReactMethod
    public void getDistinctId(Callback successCallback, Callback errorCallback) {
        try {
            String mLoginId = SensorsDataAPI.sharedInstance().getLoginId();
            if (!TextUtils.isEmpty(mLoginId)) {
                successCallback.invoke(mLoginId);
            } else {
                successCallback.invoke(SensorsDataAPI.sharedInstance().getAnonymousId());
            }
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
            errorCallback.invoke(e.getMessage());
        }
    }

    /**
     * 导出 getDistinctIdPromise 方法给 RN 使用.
     * <p>
     * Promise 方式，获取 distinctId
     * <p>
     * RN 中使用示例：
     * async  getDistinctIdPromise() {
     * var distinctId = await RNSensorsAnalyticsModule.getDistinctIdPromise()
     * };
     */
    @ReactMethod
    public void getDistinctIdPromise(Promise promise) {
        if (promise == null) {
            return;
        }
        try {
            String mLoginId = SensorsDataAPI.sharedInstance().getLoginId();
            if (!TextUtils.isEmpty(mLoginId)) {
                promise.resolve(mLoginId);
            } else {
                promise.resolve(SensorsDataAPI.sharedInstance().getAnonymousId());
            }
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
            promise.reject("getDistinctId failed", e);
        }
    }

    /**
     * 导出 getAnonymousIdPromise 方法给 RN 使用.
     * <p>
     * Promise 方式 getAnonymousId 获取匿名 ID.
     * <p>
     * RN 中使用示例：
     * async  getAnonymousIdPromise() {
     * var anonymousId = await RNSensorsAnalyticsModule.getAnonymousIdPromise()
     * };
     */
    @ReactMethod
    public void getAnonymousIdPromise(Promise promise) {
        if (promise == null) {
            return;
        }
        try {
            promise.resolve(SensorsDataAPI.sharedInstance().getAnonymousId());
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
            promise.reject("getAnonymousId failed", e);
        }
    }

    /**
     * 导出 registerSuperProperties 方法给 RN 使用.
     *
     * @param properties 要设置的公共属性
     * <p>
     * RN 中使用示例：（设置公共属性 "Platform":"Android"）
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.registerSuperProperties({"Platform":"Android"})}>
     * </Button>
     */
    @ReactMethod
    public void registerSuperProperties(ReadableMap properties) {
        try {
            SensorsDataAPI.sharedInstance().registerSuperProperties(RNUtils.convertToJSONObject(properties));
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 unregisterSuperProperty 方法给 RN 使用.
     *
     * @param property 要删除的公共属性属性
     * <p>
     * RN 中使用示例：（删除公共属性 "Platform"）
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.unregisterSuperProperty("Platform")}>
     * </Button>
     */
    @ReactMethod
    public void unregisterSuperProperty(String property) {
        try {
            SensorsDataAPI.sharedInstance().unregisterSuperProperty(property);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 clearSuperProperties 方法给 RN 使用.
     * <p>
     * RN 中使用示例：（删除所有已设置的公共属性）
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.clearSuperProperties()}>
     * </Button>
     */
    @ReactMethod
    public void clearSuperProperties() {
        try {
            SensorsDataAPI.sharedInstance().clearSuperProperties();
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 flush 方法给 RN 使用.
     * <p>
     * RN 中使用示例：（强制发送数据到服务端）
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.flush()}>
     * </Button>
     */
    @ReactMethod
    public void flush() {
        try {
            SensorsDataAPI.sharedInstance().flush();
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 deleteAll 方法给 RN 使用.
     * <p>
     * RN 中使用示例：（删除本地数据库的所有数据！！！请谨慎使用）
     * <Button
     * title="Button"
     * onPress={()=>
     * RNSensorsAnalyticsModule.deleteAll()}>
     * </Button>
     */
    @ReactMethod
    public void deleteAll() {
        try {
            SensorsDataAPI.sharedInstance().deleteAll();
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 identify 方法给 RN 使用.
     * <p>
     * RN 中使用示例：
     * <Button title="Button" onPress={()=>
     * RNSensorsAnalyticsModule.identify(anonymousId)}>
     * </Button>
     */
    @ReactMethod
    public void identify(String anonymousId) {
        try {
            SensorsDataAPI.sharedInstance().identify(anonymousId);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }


    /**
     * 导出 trackTimerPause 方法给 RN 使用.
     * <p>暂停事件计时器，计时单位为秒。
     *
     * @param eventName 事件的名称
     */
    @ReactMethod
    public void trackTimerPause(String eventName) {
        try {
            SensorsDataAPI.sharedInstance().trackTimerPause(eventName);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 导出 trackTimerResume 方法给 RN 使用.
     * <p>恢复事件计时器，计时单位为秒。
     *
     * @param eventName 事件的名称
     */
    @ReactMethod
    public void trackTimerResume(String eventName) {
        try {
            SensorsDataAPI.sharedInstance().trackTimerResume(eventName);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 保存用户推送 ID 到用户表
     *
     * @param pushTypeKey 属性名称（例如 jgId）
     * @param pushId 推送 ID
     * <p>使用 profilePushId("jgId", pushId) 例如极光 pushId
     * 获取方式：JPushModule.getRegistrationID(callback)
     */
    @ReactMethod
    public void profilePushId(String pushTypeKey, String pushId) {
        try {
            SensorsDataAPI.sharedInstance().profilePushId(pushTypeKey, pushId);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 删除用户设置的 pushId
     *
     * @param pushTypeKey 属性名称（例如 jgId）
     */
    @ReactMethod
    public void profileUnsetPushId(String pushTypeKey) {
        try {
            SensorsDataAPI.sharedInstance().profileUnsetPushId(pushTypeKey);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 重置默认匿名 id
     */
    @ReactMethod
    public void resetAnonymousId() {
        try {
            SensorsDataAPI.sharedInstance().resetAnonymousId();
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 设置当前 serverUrl
     *
     * @param serverUrl 当前 serverUrl
     */
    @ReactMethod
    public void setServerUrl(String serverUrl) {
        try {
            SensorsDataAPI.sharedInstance().setServerUrl(serverUrl);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 设置 item
     *
     * @param itemType item 类型
     * @param itemId item ID
     * @param properties item 相关属性
     */
    @ReactMethod
    public void itemSet(final String itemType, final String itemId, ReadableMap properties) {
        try {
            SensorsDataAPI.sharedInstance().itemSet(itemType, itemId, RNUtils.convertToJSONObject(properties));
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 删除 item
     *
     * @param itemType item 类型
     * @param itemId item ID
     */
    @ReactMethod
    public void itemDelete(final String itemType, final String itemId) {
        try {
            SensorsDataAPI.sharedInstance().itemDelete(itemType, itemId);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 获取事件公共属性
     */
    @ReactMethod
    public void getSuperPropertiesPromise(Promise promise) {
        if (promise == null) {
            return;
        }
        try {
            JSONObject properties = SensorsDataAPI.sharedInstance().getSuperProperties();
            WritableMap map = RNUtils.convertToMap(properties);
            if (map != null) {
                promise.resolve(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
            promise.reject("getSuperProperties failed", e);
        }
    }

    /**
     * 返回预置属性
     */
    @ReactMethod
    public void getPresetPropertiesPromise(Promise promise) {
        if (promise == null) {
            return;
        }
        try {
            JSONObject properties = SensorsDataAPI.sharedInstance().getPresetProperties();
            WritableMap map = RNUtils.convertToMap(properties);
            if (map != null) {
                promise.resolve(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
            promise.reject("getPresetProperties failed", e);
        }
    }

    /**
     * 获取当前用户的 loginId 若调用前未调用 {@link #login(String)} 设置用户的 loginId，会返回 null
     *
     * @return 当前用户的 loginId
     */
    @ReactMethod
    public void getLoginIdPromise(Promise promise) {
        if (promise == null) {
            return;
        }
        try {
            promise.resolve(SensorsDataAPI.sharedInstance().getLoginId());
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
            promise.reject("getLoginId failed", e);
        }
    }

    /**
     * 设置 App 切换到后台与下次事件的事件间隔
     * 默认值为 30*1000 毫秒
     * 若 App 在后台超过设定事件，则认为当前 Session 结束，发送 $AppEnd 事件
     *
     * @param sessionIntervalTime int
     */
    @ReactMethod
    public void setSessionIntervalTime(int sessionIntervalTime) {
        SensorsDataAPI.sharedInstance().setSessionIntervalTime(sessionIntervalTime);
    }

    /**
     * 获取 App 切换到后台与下次事件的事件间隔时长设置
     * 默认值为 30*1000 毫秒
     * 若 App 在后台超过设定事件，则认为当前 Session 结束，发送 $AppEnd 事件
     *
     * @return 返回设置的 SessionIntervalTime ，默认是 30s
     */
    @ReactMethod
    public void getSessionIntervalTimePromise(Promise promise) {
        if (promise == null) {
            return;
        }
        try {
            promise.resolve(SensorsDataAPI.sharedInstance().getSessionIntervalTime());
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
            promise.reject("getSessionIntervalTime failed", e);
        }
    }

    /**
     * 是否开启 AutoTrack
     *
     * @return true: 开启 AutoTrack; false：没有开启 AutoTrack
     */
    @ReactMethod
    public void isAutoTrackEnabledPromise(Promise promise) {
        if (promise == null) {
            return;
        }
        try {
            promise.resolve(SensorsDataAPI.sharedInstance().isAutoTrackEnabled());
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
            promise.reject("isAutoTrackEnabled failed", e);
        }
    }

    /**
     * 是否开启可视化全埋点
     *
     * @return true 代表开启了可视化全埋点， false 代表关闭了可视化全埋点
     */
    @ReactMethod
    public void isVisualizedAutoTrackEnabledPromise(Promise promise) {
        if (promise == null) {
            return;
        }
        try {
            promise.resolve(SensorsDataAPI.sharedInstance().isVisualizedAutoTrackEnabled());
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
            promise.reject("isVisualizedAutoTrackEnabled failed", e);
        }
    }

    /**
     * 是否开启点击图
     *
     * @return true 代表开启了点击图，false 代表关闭了点击图
     */
    @ReactMethod
    public void isHeatMapEnabledPromise(Promise promise) {
        if (promise == null) {
            return;
        }
        try {
            promise.resolve(SensorsDataAPI.sharedInstance().isHeatMapEnabled());
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
            promise.reject("isHeatMapEnabled failed", e);
        }
    }

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
    @ReactMethod
    public void setFlushNetworkPolicy(int networkType) {
        try {
            SensorsDataAPI.sharedInstance().setFlushNetworkPolicy(networkType);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 设置是否允许请求网络，默认是 true
     *
     * @param isRequest boolean
     */
    @ReactMethod
    public void enableNetworkRequest(boolean isRequest) {
        try {
            SensorsDataAPI.sharedInstance().enableNetworkRequest(isRequest);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 是否允许请求网络，默认是 true
     *
     * @return 是否允许请求网络
     */
    @ReactMethod
    public void isNetworkRequestEnablePromise(Promise promise) {
        if (promise == null) {
            return;
        }
        try {
            promise.resolve(SensorsDataAPI.sharedInstance().isNetworkRequestEnable());
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
            promise.reject("isNetworkRequestEnable failed", e);
        }
    }

    /**
     * 记录 $AppInstall 事件，用于在 App 首次启动时追踪渠道来源，并设置追踪渠道事件的属性。
     * 这是 Sensors Analytics 进阶功能，请参考文档 https://sensorsdata.cn/manual/track_installation.html
     *
     * @param properties 渠道追踪事件的属性
     */
    @ReactMethod
    public void trackAppInstall(ReadableMap properties) {
        try {
            //解决版本限制,防止集成旧版本 SDK 没有 trackAppInstall() 方法.
            SensorsDataAPI.sharedInstance().trackInstallation("$AppInstall", RNUtils.convertToJSONObject(properties));
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 开启数据采集
     */
    @ReactMethod
    @Deprecated
    public void enableDataCollect() {
        SALog.i(LOGTAG, "enableDataCollect() 方法已在 「6.4.0」版本删除!可升级致该版本后使用延迟初始化方案");
    }

    /**
     * 绑定业务
     *
     * @param key ID
     * @param value 值
     */
    @ReactMethod
    public void bind(String key, String value) {
        try {
            SensorsDataAPI.sharedInstance().bind(key, value);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    /**
     * 解绑业务
     *
     * @param key ID
     * @param value 值
     */
    @ReactMethod
    public void unbind(String key, String value) {
        try {
            SensorsDataAPI.sharedInstance().unbind(key, value);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(LOGTAG, e.toString() + "");
        }
    }

    @ReactMethod
    public void init(ReadableMap config) {
        if (getCurrentActivity() == null) {
            return;
        }
        try {
            JSONObject configJson = RNUtils.convertToJSONObject(config);
            SAConfigOptions saConfigOptions;
            if (configJson == null) {
                saConfigOptions = new SAConfigOptions("");
            } else {
                saConfigOptions = new SAConfigOptions(configJson.optString("server_url"));
                saConfigOptions.enableLog(configJson.optBoolean("show_log"))
                        .enableEncrypt(configJson.optBoolean("encrypt"))
                        .setAutoTrackEventType(configJson.optInt("auto_track", 0))
                        .setFlushBulkSize(configJson.optInt("flush_bulksize", 100))
                        .setFlushInterval(configJson.optInt("flush_interval", 15000));
                if (VersionUtils.checkSAVersion("6.4.3")) {
                    final JSONObject globalProperties = configJson.optJSONObject("global_properties");
                    saConfigOptions.registerPropertyPlugin(new RNGlobalPropertyPlugin(globalProperties));
                }
                JSONObject androidConfig = configJson.optJSONObject("android");
                boolean javascriptBridge = configJson.optBoolean("javascript_bridge", false);
                boolean isSupportJellybean = false;
                if (androidConfig != null && androidConfig.length() > 0) {
                    saConfigOptions.setMaxCacheSize(androidConfig.optLong("max_cache_size", 32 * 1024 * 1024));
                    if (androidConfig.optBoolean("sub_process_flush", false)) {
                        saConfigOptions.enableSubProcessFlushData();
                    }
                    isSupportJellybean = androidConfig.optBoolean("jellybean", false);
                }
                if (javascriptBridge) {
                    saConfigOptions.enableJavaScriptBridge(isSupportJellybean);
                }

                JSONObject visualizedConfig = configJson.optJSONObject("visualized");
                if (visualizedConfig != null && visualizedConfig.length() > 0) {
                    saConfigOptions.enableVisualizedAutoTrack(visualizedConfig.optBoolean("auto_track", false));
                    saConfigOptions.enableVisualizedProperties(visualizedConfig.optBoolean("properties", false));
                }
                saConfigOptions.enableHeatMap(configJson.optBoolean("heat_map", false));
            }
            SensorsDataAPI.startWithConfigOptions(getCurrentActivity(), saConfigOptions);
            SALog.i(LOGTAG, "init success");
        } catch (Exception e) {
            SALog.i(LOGTAG, "SDK init failed:" + e.getMessage());
        }
    }
}
