package com.sensorsdata.analytics.utils;

import android.view.View;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.uimanager.NativeViewHierarchyManager;
import com.facebook.react.uimanager.UIImplementation;
import com.facebook.react.uimanager.UIManagerModule;
import com.facebook.react.uimanager.UIViewOperationQueue;
import java.lang.ref.WeakReference;
import com.sensorsdata.analytics.android.sdk.SALog;
import java.lang.reflect.Field;
import android.view.ViewGroup;
import android.view.View;
import android.view.ViewParent;

public class RNViewUtils {

    private static WeakReference onTouchViewReference;
    private static String currentTitle;
    private static String currentScreenName;

    public static void setOnTouchView(View nativeTargetView) {
        onTouchViewReference = new WeakReference(nativeTargetView);
    }

    public static View getViewByTag(ReactContext reactContext, int viewTag) {
        NativeViewHierarchyManager manager = getNativeViewHierarchyManager(reactContext);
        if (manager == null) {
            return null;
        }
        return manager.resolveView(viewTag);
    }

    public static View getTouchViewByTag(int viewTag) {
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

    public static View getClickView(int viewId, View onTouchView) {
        View currentView = onTouchView;
        while (currentView.getId() != viewId) {
            ViewParent parent = currentView.getParent();
            if (parent == null || !(parent instanceof View)) {
                return null;
            }
            currentView = (View) parent;
        }
        return currentView;
    }

    public static View getClickViewInChild(int viewId, ViewGroup currentView) {
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
                } else {
                    continue;
                }
            }
        }
        return null;
    }

    public static NativeViewHierarchyManager getNativeViewHierarchyManager(
            ReactContext reactContext) {
        try {
            // 获取 UIImplementation
            UIManagerModule uiManager = reactContext.getNativeModule(UIManagerModule.class);
            UIImplementation uiImplementation = uiManager.getUIImplementation();
            // 获取 UIImplementation#mOperationsQueue
            Field mOperationsQueueField =
                    uiImplementation.getClass().getDeclaredField("mOperationsQueue");
            mOperationsQueueField.setAccessible(true);
            UIViewOperationQueue uiViewOperationQueue =
                    (UIViewOperationQueue) mOperationsQueueField.get(uiImplementation);
            // 获取 UIViewOperationQueue#NativeViewHierarchyManager
            Field mNativeViewHierarchyManagerField =
                    UIViewOperationQueue.class.getDeclaredField("mNativeViewHierarchyManager");
            mNativeViewHierarchyManagerField.setAccessible(true);
            NativeViewHierarchyManager mNativeViewHierarchyManager =
                    (NativeViewHierarchyManager) mNativeViewHierarchyManagerField.get(uiViewOperationQueue);
            return mNativeViewHierarchyManager;
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
            return null;
        } catch (IllegalAccessException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void saveScreenAndTitle(String screenName,String title){
        currentScreenName = screenName;
        currentTitle = title;
    }

    public static String getTitle(){
        return currentTitle;
    }

    public static String getScreenName(){
        return currentScreenName;
    }
}
