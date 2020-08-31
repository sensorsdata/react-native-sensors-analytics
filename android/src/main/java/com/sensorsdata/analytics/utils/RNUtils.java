package com.sensorsdata.analytics.utils;

import android.view.View;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;
import com.facebook.react.bridge.WritableMap;
import java.util.Iterator;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPI;
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
}
