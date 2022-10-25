package com.sensorsdata.analytics.property;

import com.sensorsdata.analytics.android.sdk.plugin.property.SAPropertyPlugin;
import com.sensorsdata.analytics.android.sdk.plugin.property.SAPropertyPluginPriority;
import com.sensorsdata.analytics.android.sdk.plugin.property.beans.SAPropertiesFetcher;
import com.sensorsdata.analytics.android.sdk.plugin.property.beans.SAPropertyFilter;
import com.sensorsdata.analytics.utils.RNUtils;

import org.json.JSONObject;

public class RNGlobalPropertyPlugin extends SAPropertyPlugin {
    private JSONObject mGlobalProperties;

    public RNGlobalPropertyPlugin(JSONObject golbalProperties){
        mGlobalProperties = golbalProperties;
    }

    @Override
    public boolean isMatchedWithFilter(SAPropertyFilter filter) {
        return filter.getType().isTrack();
    }

    @Override
    public void properties(SAPropertiesFetcher fetcher) {
        RNUtils.mergeJSONObject(mGlobalProperties, fetcher.getProperties());
    }

    @Override
    public SAPropertyPluginPriority priority() {
        return SAPropertyPluginPriority.LOW;
    }

}
