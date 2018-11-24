# sa-sdk-ios-reactnative
the official iOS SDK React Native file for Sensors Analytics

# 1. iOS SDK 在 React Native 中使用说明

## 1.1 集成 Sensors Analytics iOS SDK

集成方式可查看 [iOS SDK 使用说明](https://www.sensorsdata.cn/manual/ios_sdk.html)

# 2. 在 React Native 上使用代码埋点

## 2.1 添加神策模块文件
```
npm install @sensors.data/react-native-sensors-analytics 
react-native link @sensors.data/react-native-sensors-analytics 
```

## 2.2 在 js 文件中导入神策模块

在具体的 js 文件中导入神策模块（RNSensorsAnalyticsModule），导入模块示例如下：

```objectivec
import { NativeModules } from 'react-native';
const RNSensorsAnalyticsModule=NativeModules.RNSensorsAnalyticsModule;
```

添加导入模块后便可进行代码埋点。

## 2.3 添加埋点事件

在具体的位置添加事件埋点，以按钮点击时触发事件为例：

其中对应的事件名为：RN_AddToFav 对应的事件属性为：ProductID 和 UserLevel

```objectivec
<Button
title="Button"
onPress={()=>
RNSensorsAnalyticsModule.track("RN_AddToFav",{"ProductID":
123456,"UserLevel":"VIP"})
</Button>
```

# 3. 在 React Native 上使用全埋点

## 3.1 开启自动采集

在原生页面的 Appdelegate.h 文件中，初始化 SDK 之后，可通过 `enableAutoTrack:` 接口打开自动采集功能

```objectivec
// 打开自动采集, 并指定追踪哪些 AutoTrack 事件
[[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:SensorsAnalyticsEventTypeAppStart |
SensorsAnalyticsEventTypeAppEnd |
SensorsAnalyticsEventTypeAppViewScreen |
SensorsAnalyticsEventTypeAppClick];
```

## 3.2 开启 React Native 页面控件的自动采集（$AppClick）

1、对于直接集成源代码的开发者，可以在编译选项 Preprocessor Macros 中定义选项 SENSORS_ANALYTICS_REACT_NATIVE=1 开启。

2、对于使用 Cocoapods 集成 Sensors Analytics SDK 的开发者，推荐使用 pod 'SensorsAnalyticsSDK', :subspecs => ['ENABLE_REACT_NATIVE_APPCLICK'] 集成方式开启，或者修改 Pod 中 `SensorsAnalyticsSDK` 项目的编译选项。

## License

Copyright 2015－2017 Sensors Data Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
