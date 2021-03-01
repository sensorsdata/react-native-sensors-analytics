/*
 * Created by chenru on 2021/01/05.
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

package com.sensorsdata.analytics.property;

import com.sensorsdata.analytics.property.RNPropertyManager.Interceptor;

import org.json.JSONObject;

public class LibMethodInterceptor implements Interceptor {

    public JSONObject proceed(JSONObject properties, boolean isAuto) {
        if (properties == null) {
            properties = new JSONObject();
        }
        try {
            if (!"autoTrack".equals(properties.optString("$lib_method"))) {
                if (isAuto) {
                    properties.put("$lib_method", "autoTrack");
                } else {
                    properties.put("$lib_method", "code");
                }
            }
        } catch (Exception ignored) {

        }
        return properties;
    }
}
