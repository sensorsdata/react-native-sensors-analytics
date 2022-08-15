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

package com.sensorsdata.analytics.utils;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;
import com.facebook.react.bridge.WritableMap;

import java.util.HashMap;
import java.util.Iterator;
import com.sensorsdata.analytics.android.sdk.SALog;
import org.json.JSONObject;


public class RNUtils {
    /**
     * ReadableMap 转换成 JSONObject
     */
    public static JSONObject convertToJSONObject(ReadableMap properties) {
        if (properties == null) {
            return null;
        }

        JSONObject json = null;
        ReadableNativeMap nativeMap = null;
        try {
            nativeMap = (ReadableNativeMap) properties;
            json = new JSONObject(properties.toString()).getJSONObject("NativeMap");
        } catch (Exception e) {
            SALog.printStackTrace(e);
            String superName = nativeMap.getClass().getSuperclass().getSimpleName();
            try {
                json = new JSONObject(properties.toString()).getJSONObject(superName);
            } catch (Exception e1) {
                SALog.printStackTrace(e1);
            }
        }
        return json;
    }

    /**
     * JSONObject 转换成 WritableMap
     */
    public static WritableMap convertToMap(JSONObject json) {
        if (json == null || json.length() == 0) {
            return null;
        }
        WritableMap writableMap = Arguments.createMap();
        Iterator<String> it = json.keys();
        while(it.hasNext()){
            try {
                String key = it.next();
                writableMap.putString(key, json.optString(key));
            } catch (Exception e) {
                SALog.printStackTrace(e);
            }
        }
        return writableMap;
    }

    /**
     * ReadableMap 转换成 HashMap
     */
    public static HashMap<String, Object> convertToHashMap(ReadableMap properties) {
        if (properties == null) {
            return null;
        }
        HashMap<String, Object> map = null;
        try {
            map = ((ReadableNativeMap)properties).toHashMap();
        }catch (Exception e){
            SALog.printStackTrace(e);
        }
        return map;
    }

    /**
     * merge source JSONObject to dest JSONObject
     * @param source
     * @param dest
     */
    public static void mergeJSONObject(final JSONObject source, JSONObject dest) {
        try {
            Iterator<String> sourceIterator = source.keys();
            while (sourceIterator.hasNext()) {
                String key = sourceIterator.next();
                Object value = source.get(key);
                dest.put(key, value);
            }
        } catch (Exception ex) {
            SALog.printStackTrace(ex);
        }
    }
}
