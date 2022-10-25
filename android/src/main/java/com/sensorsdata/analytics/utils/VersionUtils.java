/*
 * Created by chenru on 2022/02/17.
 * Copyright 2015－2022 Sensors Data Inc.
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

import android.text.TextUtils;

import com.sensorsdata.analytics.android.sdk.SALog;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPI;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPIEmptyImplementation;

import java.lang.reflect.Field;

public class VersionUtils {
    private static final String TAG = "SA.RNVersionUtils";

    public static boolean checkSAVersion(final String requiredVersion) {
        try {
            SensorsDataAPI sensorsDataAPI = SensorsDataAPI.sharedInstance();
            Field field;
            if (sensorsDataAPI instanceof SensorsDataAPIEmptyImplementation) {
                field = sensorsDataAPI.getClass().getSuperclass().getDeclaredField("VERSION");
            } else {
                field = sensorsDataAPI.getClass().getDeclaredField("VERSION");
            }
            field.setAccessible(true);
            String version = (String) field.get(sensorsDataAPI);
            String compareVersion = version;
            if (!TextUtils.isEmpty(version)) {
                if (version.contains("-")) {
                    compareVersion = compareVersion.substring(0, compareVersion.indexOf("-"));
                }
                if (!isVersionValid(compareVersion, requiredVersion)) {
                    SALog.i(TAG, "当前神策 Android 埋点 SDK 版本 " + version + " 过低，请升级至 " + requiredVersion + " 及其以上版本后进行使用");
                    return false;
                }
            }
        } catch (Exception ex) {
            SALog.printStackTrace(ex);
            return false;
        }
        return true;
    }

    /**
     * 比较当前实际的 SA 版本和期望的 SA 最低版本
     *
     * @param saVersion 当前实际的 SA 版本
     * @param requiredVersion 期望的 SA 最低版本
     * @return false 代表实际 SA 的比期望低，true 代表符合预期
     */
    public static boolean isVersionValid(String saVersion, String requiredVersion) {
        try {
            if (saVersion.equals(requiredVersion)) {
                return true;
            } else {
                String[] saVersions = saVersion.split("\\.");
                String[] requiredVersions = requiredVersion.split("\\.");
                for (int index = 0; index < requiredVersions.length; index++) {
                    int saVersionsNum = Integer.parseInt(saVersions[index]);
                    int requiredVersionsNum = Integer.parseInt(requiredVersions[index]);
                    if (saVersionsNum != requiredVersionsNum) {
                        return saVersionsNum > requiredVersionsNum;
                    }
                }
                return false;
            }
        } catch (Exception ex) {
            // ignore
            return false;
        }
    }
}
