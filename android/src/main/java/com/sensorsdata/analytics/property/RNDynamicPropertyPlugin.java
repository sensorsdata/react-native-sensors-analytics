package com.sensorsdata.analytics.property;

import com.sensorsdata.analytics.R;
import com.sensorsdata.analytics.RNAgent;
import com.sensorsdata.analytics.android.sdk.internal.beans.EventType;
import com.sensorsdata.analytics.android.sdk.plugin.property.SAPropertyPlugin;
import com.sensorsdata.analytics.android.sdk.plugin.property.SAPropertyPluginPriority;

import java.util.Map;
import java.util.Set;

public class RNDynamicPropertyPlugin extends SAPropertyPlugin {
    @Override
    public void appendProperties(Map<String, Object> properties) {

    }

    @Override
    public void appendDynamicProperties(Map<String, Object> dynamicProperties) {
        if (dynamicProperties != null) {
            Map<String, Object> properties = RNAgent.getDynamicSuperProperties();
            if (properties != null && !properties.isEmpty()) {
                dynamicProperties.putAll(properties);
            }
        }
    }

    @Override
    public void eventTypeFilter(Set<EventType> eventTypeFilter) {
        eventTypeFilter.add(EventType.TRACK);
        eventTypeFilter.add(EventType.TRACK_ID_BIND);
        eventTypeFilter.add(EventType.TRACK_SIGNUP);
        eventTypeFilter.add(EventType.TRACK_ID_UNBIND);
    }

    @Override
    public SAPropertyPluginPriority priority() {
        return SAPropertyPluginPriority.LOW;
    }
}
