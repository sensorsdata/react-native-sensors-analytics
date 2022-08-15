/*
 * Created by yang on 2017/4/5
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


import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.sensorsdata.analytics.android.sdk.SALog;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPI;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPIEmptyImplementation;
import com.sensorsdata.analytics.property.LibMethodInterceptor;
import com.sensorsdata.analytics.property.PluginVersionInterceptor;
import com.sensorsdata.analytics.property.RNDynamicPropertyPlugin;
import com.sensorsdata.analytics.property.RNPropertyManager;
import com.sensorsdata.analytics.utils.RNUtils;
import com.sensorsdata.analytics.utils.RNViewUtils;
import com.sensorsdata.analytics.utils.VersionUtils;

import org.json.JSONObject;


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
 */

public class RNSensorsDataModule extends ReactContextBaseJavaModule {

    private RNDynamicPropertyPlugin mDynamicPlugin;

    public RNSensorsDataModule(ReactApplicationContext reactContext) {
        super(reactContext);
        try {
            reactContext.addLifecycleEventListener(new SensorsDataLifecycleListener());
        } catch (Exception e) {

        }
        RNAgent.ignoreView();
        RNPropertyManager.addInterceptor(new PluginVersionInterceptor());
        RNPropertyManager.addInterceptor(new LibMethodInterceptor());
    }

    private static final String MODULE_NAME = "RNSensorsDataModule";
    private static final String TAG = "SA.RNSensorsDataModule";

    /**
     * 返回一个字符串名字，这个名字在 JavaScript (RN)端标记这个模块。
     */
    @Override
    public String getName() {
        return MODULE_NAME;
    }

    @ReactMethod
    public void trackViewClick(int viewId) {
        RNAgent.trackViewClick(viewId);
    }

    @ReactMethod
    public void trackViewScreen(ReadableMap params) {
        try {
            if (params != null) {
                JSONObject jsonParams = RNUtils.convertToJSONObject(params);
                JSONObject properties = null;
                if (jsonParams.has("sensorsdataparams")) {
                    properties = jsonParams.optJSONObject("sensorsdataparams");
                }
                String url = null;
                if (jsonParams.has("sensorsdataurl")) {
                    url = jsonParams.getString("sensorsdataurl");
                }
                if (url == null) {
                    return;
                }
                RNAgent.trackViewScreen(url, properties, true);
            }
        } catch (Exception e) {
            SALog.printStackTrace(e);
        }
    }

    @ReactMethod
    public void saveViewProperties(int viewId, boolean clickable, ReadableMap viewProperties) {
        RNAgent.saveViewProperties(viewId, clickable, viewProperties);
    }

    @ReactMethod
    public void setDynamicSuperProperties(ReadableMap dynamicSuperProperties) {
        RNAgent.setDynamicSuperProperties(RNUtils.convertToJSONObject(dynamicSuperProperties));
    }

    @ReactMethod
    public void registerDynamicPlugin() {
        if (!VersionUtils.checkSAVersion("6.4.3")) {
            SALog.i(TAG, "请升级 Android SDK 至「6.4.3」及以上版本");
            return;
        }
        if (mDynamicPlugin == null && !(SensorsDataAPI.sharedInstance() instanceof SensorsDataAPIEmptyImplementation)) {
            mDynamicPlugin = new RNDynamicPropertyPlugin();
            SensorsDataAPI.sharedInstance().registerPropertyPlugin(mDynamicPlugin);
        }
    }

    class SensorsDataLifecycleListener implements LifecycleEventListener {
        public void onHostResume() {
            RNViewUtils.onActivityResumed(getCurrentActivity());
        }

        public void onHostPause() {
            RNViewUtils.onActivityPaused();
        }

        public void onHostDestroy() {

        }
    }
}
