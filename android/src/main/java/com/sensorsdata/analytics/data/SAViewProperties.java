/*
 * Created by chenru on 2020/04/22.
 * Copyright 2015－2025 Sensors Data Inc.
 */

package com.sensorsdata.analytics.data;

import android.content.Context;
import android.view.View;
import android.widget.ScrollView;

import com.facebook.react.bridge.ReadableMap;
import com.sensorsdata.analytics.android.sdk.SALog;
import com.sensorsdata.analytics.utils.RNUtils;

import org.json.JSONObject;

public class SAViewProperties {
    private final static String TAG = "SAViewProperties";
    private boolean clickable;
    public JSONObject properties;
    private int tagKey = 0;
    private boolean isSupportSDKVersion = true;

    public SAViewProperties(boolean clickable, ReadableMap params) {
        this.clickable = clickable;
        this.properties = RNUtils.convertToJSONObject(params);
    }

    public void setViewClickable(View view) {
        try {
            if (view != null && !(view instanceof ScrollView)) {
                view.setClickable(clickable);
            }
        } catch (Exception e) {
            SALog.i(TAG, "clickable error:" + e.getMessage());
        }
    }

    public void setViewTag(View view) {
        try {
            if (view != null && isSupportSDKVersion) {
                if (tagKey == 0) {
                    Context context = view.getContext();
                    tagKey = context.getResources().getIdentifier("sensors_analytics_tag_view_rn_key", "id", context.getPackageName());
                }
                if (tagKey != 0) {
                    view.setTag(tagKey, true);
                } else {
                    isSupportSDKVersion = false;
                }
            }
        } catch (Exception e) {
            SALog.i(TAG, "RNView setTag error:" + e.getMessage());
        }
    }
}
