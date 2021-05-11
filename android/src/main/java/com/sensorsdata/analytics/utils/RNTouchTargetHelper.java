package com.sensorsdata.analytics.utils;

import android.graphics.Matrix;
import android.graphics.PointF;
import android.graphics.Rect;
import android.view.View;
import android.view.ViewGroup;
import com.facebook.react.bridge.JSApplicationIllegalArgumentException;
import com.facebook.react.bridge.UiThreadUtil;
import com.facebook.react.touch.ReactHitSlopView;
import com.facebook.react.uimanager.PointerEvents;
import com.facebook.react.uimanager.ReactCompoundView;
import com.facebook.react.uimanager.ReactCompoundViewGroup;
import com.facebook.react.uimanager.ReactPointerEventsView;

public class RNTouchTargetHelper {
    private static final float[] mEventCoords = new float[2];
    private static final Matrix mInverseMatrix = new Matrix();
    private static final float[] mMatrixTransformCoords = new float[2];
    private static final PointF mTempPoint = new PointF();

    public static int findTargetTagForTouch(float eventX, float eventY, ViewGroup viewGroup) {
        return findTargetTagAndCoordinatesForTouch(eventX, eventY, viewGroup, mEventCoords);
    }

    public static int findTargetTagAndCoordinatesForTouch(float eventX, float eventY, ViewGroup viewGroup, float[] viewCoords) {
        UiThreadUtil.assertOnUiThread();
        int targetTag = viewGroup.getId();
        viewCoords[0] = eventX;
        viewCoords[1] = eventY;
        View nativeTargetView = findTouchTargetView(viewCoords, viewGroup);
        if (nativeTargetView == null) {
            return targetTag;
        }
        View reactTargetView = findClosestReactAncestor(nativeTargetView);
        if (reactTargetView != null) {
            return getTouchTargetForView(reactTargetView, viewCoords[0], viewCoords[1]);
        }
        return targetTag;
    }

    public static View findClosestReactAncestor(View view) {
        while (view != null && view.getId() <= 0) {
            view = (View) view.getParent();
        }
        return view;
    }

    public static View findTouchTargetView(float[] eventCoords, ViewGroup viewGroup) {
        for (int i = viewGroup.getChildCount() - 1; i >= 0; i--) {
            View child = viewGroup.getChildAt(i);
            PointF childPoint = mTempPoint;
            if (isTransformedTouchPointInView(eventCoords[0], eventCoords[1], viewGroup, child, childPoint)) {
                float restoreX = eventCoords[0];
                float restoreY = eventCoords[1];
                eventCoords[0] = childPoint.x;
                eventCoords[1] = childPoint.y;
                View targetView = findTouchTargetViewWithPointerEvents(eventCoords, child);
                if (targetView != null) {
                    return targetView;
                }
                eventCoords[0] = restoreX;
                eventCoords[1] = restoreY;
            }
        }
        return viewGroup;
    }

    private static boolean isTransformedTouchPointInView(float x, float y, ViewGroup parent, View child, PointF outLocalPoint) {
        float localX = (((float) parent.getScrollX()) + x) - ((float) child.getLeft());
        float localY = (((float) parent.getScrollY()) + y) - ((float) child.getTop());
        Matrix matrix = child.getMatrix();
        if (!matrix.isIdentity()) {
            float[] localXY = mMatrixTransformCoords;
            localXY[0] = localX;
            localXY[1] = localY;
            Matrix inverseMatrix = mInverseMatrix;
            matrix.invert(inverseMatrix);
            inverseMatrix.mapPoints(localXY);
            localX = localXY[0];
            localY = localXY[1];
        }
        if ((child instanceof ReactHitSlopView) && ((ReactHitSlopView) child).getHitSlopRect() != null) {
            Rect hitSlopRect = ((ReactHitSlopView) child).getHitSlopRect();
            if (localX < ((float) (-hitSlopRect.left)) || localX >= ((float) ((child.getRight() - child.getLeft()) + hitSlopRect.right)) || localY < ((float) (-hitSlopRect.top)) || localY >= ((float) ((child.getBottom() - child.getTop()) + hitSlopRect.bottom))) {
                return false;
            }
            outLocalPoint.set(localX, localY);
            return true;
        } else if (localX < 0.0f || localX >= ((float) (child.getRight() - child.getLeft())) || localY < 0.0f || localY >= ((float) (child.getBottom() - child.getTop()))) {
            return false;
        } else {
            outLocalPoint.set(localX, localY);
            return true;
        }
    }

    private static View findTouchTargetViewWithPointerEvents(float[] eventCoords, View view) {
        PointerEvents pointerEvents = view instanceof ReactPointerEventsView ? ((ReactPointerEventsView) view).getPointerEvents() : PointerEvents.AUTO;
        if (pointerEvents == PointerEvents.NONE) {
            return null;
        }
        if (pointerEvents == PointerEvents.BOX_ONLY) {
            return view;
        }
        if (pointerEvents == PointerEvents.BOX_NONE) {
            if (view instanceof ViewGroup) {
                View targetView = findTouchTargetView(eventCoords, (ViewGroup) view);
                if (targetView != view) {
                    return targetView;
                }
                if (!(view instanceof ReactCompoundView) || ((ReactCompoundView) view).reactTagForTouch(eventCoords[0], eventCoords[1]) == view.getId()) {
                    return null;
                }
                return view;
            }
            return null;
        } else if (pointerEvents != PointerEvents.AUTO) {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.append("Unknown pointer event type: ");
            stringBuilder.append(pointerEvents.toString());
            throw new JSApplicationIllegalArgumentException(stringBuilder.toString());
        } else if ((!(view instanceof ReactCompoundViewGroup) || !((ReactCompoundViewGroup) view).interceptsTouchEvent(eventCoords[0], eventCoords[1])) && (view instanceof ViewGroup)) {
            return findTouchTargetView(eventCoords, (ViewGroup) view);
        } else {
            return view;
        }
    }

    public static int getTouchTargetForView(View targetView, float eventX, float eventY) {
        if (targetView instanceof ReactCompoundView) {
            return ((ReactCompoundView) targetView).reactTagForTouch(eventX, eventY);
        }
        return targetView.getId();
    }
}