/*
 * Created by chenru on 2020/12/27.
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

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class RNPropertyManager {

    public static List<Interceptor> interceptors = new ArrayList<>();

    public static void addInterceptor(Interceptor interceptor){
        interceptors.add(interceptor);
    }

    public static JSONObject mergeProperty(JSONObject properties){
        return mergeProperty(properties, false);
    }

    public static JSONObject mergeProperty(JSONObject properties, boolean isAuto){
        for(Interceptor interceptor:interceptors){
            properties = interceptor.proceed(properties, isAuto);
        }
        return properties;
    }

    interface Interceptor{
        JSONObject proceed(JSONObject properties, boolean isAuto);
    }
}