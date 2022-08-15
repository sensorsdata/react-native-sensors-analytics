package com.sensorsdata.analytics.property;

import com.sensorsdata.analytics.RNAgent;
import com.sensorsdata.analytics.android.sdk.internal.beans.EventType;
import com.sensorsdata.analytics.android.sdk.plugin.property.SAPropertyPlugin;
import com.sensorsdata.analytics.android.sdk.plugin.property.SAPropertyPluginPriority;
import com.sensorsdata.analytics.android.sdk.plugin.property.beans.SAPropertiesFetcher;
import com.sensorsdata.analytics.android.sdk.plugin.property.beans.SAPropertyFilter;
import com.sensorsdata.analytics.utils.RNUtils;

import org.json.JSONObject;

public class RNDynamicPropertyPlugin extends SAPropertyPlugin {

    @Override
    public boolean isMatchedWithFilter(SAPropertyFilter filter) {
        return filter.getType() == EventType.TRACK
                || filter.getType() == EventType.TRACK_ID_BIND
                || filter.getType() == EventType.TRACK_ID_UNBIND
                || filter.getType() == EventType.TRACK_SIGNUP;
    }

    @Override
    public void properties(SAPropertiesFetcher fetcher) {
        JSONObject properties = fetcher.getProperties();
        if (properties != null) {
            JSONObject dynamicProperties = RNAgent.getDynamicSuperProperties();
            if (dynamicProperties != null && dynamicProperties.length() > 0) {
                RNUtils.mergeJSONObject(dynamicProperties, properties);
            }
        }
    }

    @Override
    public SAPropertyPluginPriority priority() {
        return SAPropertyPluginPriority.LOW;
    }
}
