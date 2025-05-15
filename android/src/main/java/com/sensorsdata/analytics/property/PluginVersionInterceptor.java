/*
 * Created by chenru on 2020/12/27.
 * Copyright 2015－2025 Sensors Data Inc.
 */

package com.sensorsdata.analytics.property;

import com.sensorsdata.analytics.RNSensorsAnalyticsPackage;
import com.sensorsdata.analytics.property.RNPropertyManager.Interceptor;

import org.json.JSONArray;
import org.json.JSONObject;

public class PluginVersionInterceptor implements Interceptor {
    private static boolean isMergePluginVersion = false;

    public JSONObject proceed(JSONObject properties, boolean isAuto){
        if(!isMergePluginVersion){
            if(properties == null){
                properties = new JSONObject();
            }else if(properties.has("$lib_plugin_version")){
                return properties;
            }
            try{
                JSONArray array = new JSONArray();
                array.put("react_native:" + RNSensorsAnalyticsPackage.VERSION);
                properties.put("$lib_plugin_version",array);
            }catch (Exception ignored){
                //ignore
            }
            isMergePluginVersion = true;
        }
        return properties;
    }
}
