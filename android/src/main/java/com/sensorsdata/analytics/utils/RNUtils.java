package com.sensorsdata.analytics.utils;

import android.view.View;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;
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
}
