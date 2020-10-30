package com.sensorsdata.analytics;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by yang on 2017/4/6
 */

public class RNSensorsAnalyticsPackage implements ReactPackage {
    public static final String VERSION = "2.0.5";
    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        //在你们的Package中 添加神策原生模块
        modules.add(new RNSensorsAnalyticsModule(reactContext));
        modules.add(new RNSensorsDataModule(reactContext));
        return modules;
    }


    public List<Class<? extends JavaScriptModule>> createJSModules() {
        return Collections.emptyList();
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }
}
