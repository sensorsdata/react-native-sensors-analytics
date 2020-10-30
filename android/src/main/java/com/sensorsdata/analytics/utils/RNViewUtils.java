package com.sensorsdata.analytics.utils;

import android.app.Activity;
import android.view.View;

import com.facebook.react.uimanager.NativeViewHierarchyManager;
import com.facebook.react.uimanager.UIImplementation;
import com.facebook.react.uimanager.UIManagerModule;
import com.facebook.react.uimanager.UIViewOperationQueue;
import java.lang.ref.SoftReference;
import com.sensorsdata.analytics.android.sdk.SALog;
import java.lang.reflect.Field;
import android.view.ViewGroup;
import android.view.View;
import android.view.ViewParent;
import org.json.JSONObject;

public class RNViewUtils {

    private static SoftReference mSoftCurrentActivityReference;
    private static String currentTitle;
    private static String currentScreenName;
    public static boolean isScreenVisiable = false;
    private static JSONObject properties = new JSONObject();

    public static View getTouchViewByTag(int viewTag) {
        try{
            Activity currentActivity = getCurrentActivity();
            if(currentActivity!=null){
                return currentActivity.findViewById(viewTag);
            }
        }catch (Exception ignored){

        }
        return null;
    }

    public static void saveScreenAndTitle(String screenName,String title){
        currentScreenName = screenName;
        currentTitle = title;
        try{
            properties.put("$title", title);
            properties.put("$screen_name", screenName);
        }catch (Exception e){

        }
    }

    public static String getTitle(){
        return currentTitle;
    }

    public static String getScreenName(){
        return currentScreenName;
    }

    /**
     * 供可视化调用，返回 $title，$screen_name
     * @return json 格式
     */
    public static String getVisualizeProperties(){
        if(!isScreenVisiable){
            return "";
        }
        return properties.toString();
    }

    public static void setScreenVisiable(boolean isVisiable){
        isScreenVisiable = isVisiable;
    }

    public static void setCurrentActivity(Activity currentActivity) {
        clearCurrentActivityReference();
        mSoftCurrentActivityReference = new SoftReference(currentActivity);
    }

    public static Activity getCurrentActivity(){
        if(mSoftCurrentActivityReference == null){
            return null;
        }
        return (Activity)mSoftCurrentActivityReference.get();
    }

    public static void clearCurrentActivityReference() {
        if(mSoftCurrentActivityReference != null){
            mSoftCurrentActivityReference.clear();
            mSoftCurrentActivityReference = null;
        }
    }
}
