/*
 * Created by chenru on 2019/08/27.
 * Copyright 2015－2025 Sensors Data Inc.
 */

package com.sensorsdata.analytics;

import android.util.SparseArray;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;

import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.JSTouchDispatcher;
import com.facebook.react.uimanager.events.EventDispatcher;
import com.sensorsdata.analytics.android.sdk.SALog;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPI;
import com.sensorsdata.analytics.data.SAViewProperties;
import com.sensorsdata.analytics.property.RNPropertyManager;
import com.sensorsdata.analytics.utils.RNTouchTargetHelper;
import com.sensorsdata.analytics.utils.RNUtils;
import com.sensorsdata.analytics.utils.RNViewUtils;

import org.json.JSONObject;

import java.lang.reflect.Field;
import java.lang.ref.WeakReference;
import java.util.WeakHashMap;

public class RNAgent {
    private static final WeakHashMap<JSTouchDispatcher, WeakReference<ViewGroup>> jsTouchDispatcherViewGroupWeakHashMap = new WeakHashMap<>();
    private static SparseArray<SAViewProperties> viewPropertiesArray = new SparseArray();
    private static JSONObject mDynamicSuperProperties;

    public static void handleTouchEvent(
            JSTouchDispatcher jsTouchDispatcher, MotionEvent event, EventDispatcher eventDispatcher) {
        try {
            if (event.getAction() == MotionEvent.ACTION_DOWN) { // ActionDown
                WeakReference<ViewGroup> weakViewGroupRef = jsTouchDispatcherViewGroupWeakHashMap.get(jsTouchDispatcher);
                ViewGroup viewGroup = weakViewGroupRef != null ? weakViewGroupRef.get() : null;
                if (viewGroup == null) {
                    try {
                        Field viewGroupField = jsTouchDispatcher.getClass().getDeclaredField("mRootViewGroup");
                        viewGroupField.setAccessible(true);
                        viewGroup = (ViewGroup) viewGroupField.get(jsTouchDispatcher);
                        // 解决内存泄漏：存入 WeakReference
                        if (viewGroup != null) {
                            jsTouchDispatcherViewGroupWeakHashMap.put(jsTouchDispatcher, new WeakReference<>(viewGroup));
                        }
                    } catch (Exception e) {
                        SALog.printStackTrace(e);
                    }
                }
                if (viewGroup != null) {
                    View nativeTargetView =
                            RNTouchTargetHelper.findTouchTargetView(
                                    new float[]{event.getX(), event.getY()}, viewGroup);
                    if (nativeTargetView != null) {
                        View reactTargetView = RNTouchTargetHelper.findClosestReactAncestor(nativeTargetView);
                        if (reactTargetView != null) {
                            nativeTargetView = reactTargetView;
                        }
                    }
                    if (nativeTargetView != null) {
                        RNViewUtils.setOnTouchView(nativeTargetView);
                    }
                }
            }
        } catch (Exception ignored) {

        }
    }

    static void trackViewScreen(String url, JSONObject properties, boolean isAuto) {
        try {
            String screenName = url;
            if (properties == null) {
                properties = new JSONObject();
            }
            if (properties.has("$screen_name")) {
                screenName = properties.getString("$screen_name");
            }
            String title = screenName;
            if (properties.has("$title")) {
                title = properties.getString("$title");
            }
            if (screenName != null) {
                properties.put("$screen_name", screenName);
            }
            if (title != null) {
                properties.put("$title", title);
            }
            RNViewUtils.saveScreenAndTitle(screenName, title);
            if (isAuto && (properties.optBoolean("SAIgnoreViewScreen", false)
                    || !SensorsDataAPI.sharedInstance().isAutoTrackEnabled()
                    || SensorsDataAPI.sharedInstance().isAutoTrackEventTypeIgnored(SensorsDataAPI.AutoTrackEventType.APP_VIEW_SCREEN))) {
                return;
            }
            SensorsDataAPI.sharedInstance().trackViewScreen(url, RNPropertyManager.mergeProperty(properties, isAuto));
        } catch (Exception e) {
            SALog.printStackTrace(e);
        }
    }

    static void trackViewClick(int viewId) {
        try {
            //关闭 AutoTrack
            if (!SensorsDataAPI.sharedInstance().isAutoTrackEnabled()) {
                return;
            }
            //$AppClick 被过滤
            if (SensorsDataAPI.sharedInstance().isAutoTrackEventTypeIgnored(SensorsDataAPI.AutoTrackEventType.APP_CLICK)) {
                return;
            }
            View clickView = RNViewUtils.getViewByTag(viewId);
            if (clickView != null) {
                JSONObject properties = new JSONObject();
                if (RNViewUtils.getTitle() != null) {
                    properties.put("$title", RNViewUtils.getTitle());
                }
                if (RNViewUtils.getScreenName() != null) {
                    properties.put("$screen_name", RNViewUtils.getScreenName());
                }
                SAViewProperties viewProperties = viewPropertiesArray.get(viewId);
                if (viewProperties != null && viewProperties.properties != null && viewProperties.properties.length() > 0) {
                    if (viewProperties.properties.optBoolean("ignore", false)) {
                        return;
                    }
                    viewProperties.properties.remove("ignore");
                    RNUtils.mergeJSONObject(viewProperties.properties, properties);
                }
                SensorsDataAPI.sharedInstance().trackViewAppClick(clickView, RNPropertyManager.mergeProperty(properties, true));
            }
        } catch (Exception e) {
            SALog.printStackTrace(e);
        }
    }

    static void saveViewProperties(int viewId, boolean clickable, ReadableMap viewProperties) {
        if (clickable) {
            viewPropertiesArray.put(viewId, new SAViewProperties(clickable, viewProperties));
        }
    }

    /**
     * 添加 View 调用,Android 插件调用,勿删
     *
     * @param view View
     * @param index index
     */
    public static void addView(View view, int index) {
        SAViewProperties properties = viewPropertiesArray.get(view.getId());
        if (properties != null) {
            properties.setViewClickable(view);
            properties.setViewTag(view);
        }
    }

    /**
     * 忽略 Slider、Switch Android SDK 的采集逻辑，统一通过 Recat Native 采集
     */
    static void ignoreView() {
        try {
            SensorsDataAPI.sharedInstance().ignoreViewType(Class.forName("com.facebook.react.views.switchview.ReactSwitch"));
        } catch (Exception e) {
            //ignored
        }
        try {
            SensorsDataAPI.sharedInstance().ignoreViewType(Class.forName("com.facebook.react.views.slider.ReactSlider"));
        } catch (Exception e) {
            //ignored
        }
        try {
            SensorsDataAPI.sharedInstance().ignoreViewType(Class.forName("com.reactnativecommunity.slider.ReactSlider"));
        } catch (Exception e) {
            //ignored
        }
    }

    public static JSONObject getDynamicSuperProperties() {
        return mDynamicSuperProperties;
    }

    static void setDynamicSuperProperties(JSONObject dynamicSuperProperties) {
        mDynamicSuperProperties = dynamicSuperProperties;
    }
}
