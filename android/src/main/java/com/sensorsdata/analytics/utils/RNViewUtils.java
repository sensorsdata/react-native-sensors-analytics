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

import android.app.Activity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;

import org.json.JSONObject;

import java.lang.ref.WeakReference;
import java.util.WeakHashMap;

public class RNViewUtils {

    private static WeakReference mWeakCurrentActivityReference;
    private static String currentTitle;
    private static String currentScreenName;
    public static boolean isScreenVisiable = false;
    private static JSONObject screenProperties;
    private static WeakReference onTouchViewReference;
    private static WeakHashMap<Activity, JSONObject> mScreenMap = new WeakHashMap<>();

    public static void setOnTouchView(View nativeTargetView) {
        onTouchViewReference = new WeakReference(nativeTargetView);
    }

    public static View getViewByTag(int viewTag) {
        View clickView = null;
        try {
            Activity currentActivity = getCurrentActivity();
            if (currentActivity != null) {
                clickView = currentActivity.findViewById(viewTag);
            }
            if (clickView == null) {
                clickView = getTouchViewByTag(viewTag);
            }
        } catch (Exception ignored) {

        }
        return clickView;
    }

    private static View getTouchViewByTag(int viewTag) {
        if (onTouchViewReference != null) {
            View onTouchView = (View) onTouchViewReference.get();
            if (onTouchView != null) {
                View clickView = getClickView(viewTag, onTouchView);
                if (clickView == null && (onTouchView instanceof ViewGroup)) {
                    clickView = getClickViewInChild(viewTag, (ViewGroup) onTouchView);
                }
                return clickView;
            }
        }
        return null;
    }


    private static View getClickView(int viewId, View onTouchView) {
        View currentView = onTouchView;
        while (currentView.getId() != viewId) {
            ViewParent parent = currentView.getParent();
            if (!(parent instanceof View)) {
                return null;
            }
            currentView = (View) parent;
        }
        return currentView;
    }

    private static View getClickViewInChild(int viewId, ViewGroup currentView) {
        int currentViewCount = currentView.getChildCount();
        for (int i = 0; i < currentViewCount; i++) {
            View childView = currentView.getChildAt(i);
            if (childView != null) {
                if (childView.getId() == viewId) {
                    return childView;
                }
                if (childView instanceof ViewGroup) {
                    View clickView = getClickViewInChild(viewId, (ViewGroup) childView);
                    if (clickView != null) {
                        return clickView;
                    }
                }
            }
        }
        return null;
    }

    public static void saveScreenAndTitle(String screenName, String title) {
        currentScreenName = screenName;
        currentTitle = title;
        try {
            screenProperties = new JSONObject();
            screenProperties.put("$title", title);
            screenProperties.put("$screen_name", screenName);
            screenProperties.put("isSetRNViewTag", true);//标识当前页面已区分 RNView 和原生 View
        } catch (Exception ignored) {

        }
        Activity currentActivity;
        if ((currentActivity = getCurrentActivity()) != null) {
            mScreenMap.put(currentActivity, screenProperties);
        }
    }

    public static String getTitle() {
        return currentTitle;
    }

    public static String getScreenName() {
        return currentScreenName;
    }

    /**
     * 供可视化调用，返回 $title，$screen_name，勿删
     *
     * @return json 格式
     */
    public static String getVisualizeProperties() {
        //当前页面不可见或无 $screen_name $title 时，可视化获取原生页面信息
        if (!isScreenVisiable || screenProperties == null) {
            return "";
        }
        return screenProperties.toString();
    }

    public static void setScreenVisiable(boolean isVisiable) {
        isScreenVisiable = isVisiable;
    }

    private static void setCurrentActivity(Activity currentActivity) {
        clearCurrentActivityReference();
        mWeakCurrentActivityReference = new WeakReference(currentActivity);
        JSONObject properties = mScreenMap.get(currentActivity);
        if (properties != null && properties.has("$screen_name")) {
            saveScreenAndTitle(properties.optString("$screen_name"), properties.optString("$title"));
        } else {
            currentScreenName = null;
            currentTitle = null;
            screenProperties = null;
        }
    }

    private static Activity getCurrentActivity() {
        if (mWeakCurrentActivityReference == null) {
            return null;
        }
        return (Activity) mWeakCurrentActivityReference.get();
    }

    public static void clearCurrentActivityReference() {
        if (mWeakCurrentActivityReference != null) {
            mWeakCurrentActivityReference.clear();
            mWeakCurrentActivityReference = null;
        }
    }

    public static void onActivityResumed(Activity currentActivity) {
        setScreenVisiable(true);
        setCurrentActivity(currentActivity);
    }

    public static void onActivityPaused() {
        setScreenVisiable(false);
    }
}
