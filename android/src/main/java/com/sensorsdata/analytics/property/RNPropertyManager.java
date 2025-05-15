/*
 * Created by chenru on 2020/12/27.
 * Copyright 2015－2025 Sensors Data Inc.
 */

package com.sensorsdata.analytics.property;

import org.json.JSONObject;

import java.util.Vector;
import java.util.List;

public class RNPropertyManager {

    public static Vector<Interceptor> interceptors = new Vector<>();

    public static void addInterceptor(Interceptor interceptor){
        interceptors.add(interceptor);
    }

    public static JSONObject mergeProperty(JSONObject properties){
        return mergeProperty(properties, false);
    }

    public static JSONObject mergeProperty(JSONObject properties, boolean isAuto){
        for(Interceptor interceptor:interceptors){
            properties = interceptor.proceed(properties, isAuto);
        }
        return properties;
    }

    interface Interceptor{
        JSONObject proceed(JSONObject properties, boolean isAuto);
    }
}
