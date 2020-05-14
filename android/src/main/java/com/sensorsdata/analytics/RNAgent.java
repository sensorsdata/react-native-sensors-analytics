package com.sensorsdata.analytics;

import android.view.MotionEvent;
import android.view.MotionEvent.*;
import android.view.View;
import android.view.ViewGroup;
import com.facebook.react.bridge.ReadableMap;
import com.sensorsdata.analytics.RNSensorsAnalyticsModule;
import com.sensorsdata.analytics.utils.RNViewUtils;

import com.facebook.react.uimanager.JSTouchDispatcher;
import com.facebook.react.uimanager.events.EventDispatcher;
import com.sensorsdata.analytics.android.sdk.SALog;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPI;
import com.sensorsdata.analytics.android.sdk.util.SensorsDataUtils;
import com.sensorsdata.analytics.android.sdk.SensorsDataAutoTrackHelper;
import com.sensorsdata.analytics.utils.RNTouchTargetHelper;

import java.lang.reflect.Field;
import java.util.WeakHashMap;
import java.util.HashMap;
import org.json.JSONObject;

public class RNAgent {
    private static final WeakHashMap jsTouchDispatcherViewGroupWeakHashMap = new WeakHashMap();

    public static void handleTouchEvent(
            JSTouchDispatcher jsTouchDispatcher, MotionEvent event, EventDispatcher eventDispatcher) {

        if (event.getAction() == MotionEvent.ACTION_DOWN) { // ActionDown
            ViewGroup viewGroup = (ViewGroup)jsTouchDispatcherViewGroupWeakHashMap.get(jsTouchDispatcher);
            if (viewGroup == null) {
                try {
                    Field viewGroupField = jsTouchDispatcher.getClass().getDeclaredField("mRootViewGroup");
                    viewGroupField.setAccessible(true);
                    viewGroup = (ViewGroup) viewGroupField.get(jsTouchDispatcher);
                    jsTouchDispatcherViewGroupWeakHashMap.put(jsTouchDispatcher, viewGroup);
                } catch (Exception e) {
                    SALog.printStackTrace(e);
                }
            }
            if (viewGroup != null) {
                View nativeTargetView =
                        RNTouchTargetHelper.findTouchTargetView(
                                new float[] {event.getX(), event.getY()}, viewGroup);
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
    }

    public static void trackViewScreen(String url, JSONObject properties, boolean isAuto){
        try{
            String screenName = url;
            if(properties == null){
                properties = new JSONObject();
            }
            if(properties.has("$screen_name")){
                screenName = properties.getString("$screen_name");
            }
            String title = screenName;
            if(properties.has("$title")){
                title = properties.getString("$title");
            }
            if(screenName != null){
                properties.put("$screen_name",screenName);
            }
            if(title != null){
                properties.put("$title",title);
            }
            RNViewUtils.saveScreenAndTitle(screenName,title);
            //关闭 AutoTrack
            if (isAuto && !SensorsDataAPI.sharedInstance().isAutoTrackEnabled()) {
                return;
            }
            //$AppViewScreen 被过滤
            if (isAuto && SensorsDataAPI.sharedInstance().isAutoTrackEventTypeIgnored(SensorsDataAPI.AutoTrackEventType.APP_VIEW_SCREEN)) {
                return;
            }
            SensorsDataAPI.sharedInstance().trackViewScreen(url, properties);
        }catch(Exception e){
            SALog.printStackTrace(e);
        }
    }

    public static void trackViewClick(int viewId){
        try {
            View clickView = RNViewUtils.getTouchViewByTag(viewId);
            if (clickView != null) {
                JSONObject properties = new JSONObject();
                if(RNViewUtils.getTitle() != null){
                    properties.put("$title",RNViewUtils.getTitle());
                }
                if(RNViewUtils.getScreenName() != null){
                    properties.put("$screen_name",RNViewUtils.getScreenName());
                }
                SensorsDataAPI.sharedInstance().trackViewAppClick(clickView,properties);
            }
        } catch (Exception e) {
            SALog.printStackTrace(e);
        }
    }
}
