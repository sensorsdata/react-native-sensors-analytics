# 1.使用 npm 方式 install 神策 SDK 

对于 React Native 开发的应用，可以使用 npm 方式集成神策 SDK。

## 1.1 npm 安装 react-native-sensors-analytics 模块

```sh
npm install @sensors.data/react-native-sensors-analytics
```

## 1.2 `link` react-native-sensors-analytics 模块


```sh
react-native link @sensors.data/react-native-sensors-analytics 
```


# 2. Android 端

## 2.1 集成神策的 gradle 插件、初始化 SDK 
**第一步：**在 **project** 级别的 build.gradle 文件中添加 Sensors Analytics android-gradle-plugin 依赖：
```android
buildscript {
repositories {
jcenter()
//添加 Sensors Analytics maven 库地址
maven {
url 'https://dl.bintray.com/zouyuhan/maven'
}
}
dependencies {
classpath 'com.android.tools.build:gradle:2.2.3'
//添加神策分析 android-gradle-plugin 依赖
classpath 'com.sensorsdata.analytics.android:android-gradle-plugin2:2.2.1'
}
}

allprojects {
repositories {
jcenter()
//添加 Sensors Analytics maven 库地址
maven {
url 'https://dl.bintray.com/zouyuhan/maven'
}
}
}
```

如下示例图：
![](https://www.sensorsdata.cn/manual/img/android_sdk_autotrack_1.png)

**第二步：**在 **主 module** 的 build.gradle 文件中添加 com.sensorsdata.analytics.android 插件、神策分析 SDK 依赖：

```android
apply plugin: 'com.android.application'
//添加 com.sensorsdata.analytics.android 插件
apply plugin: 'com.sensorsdata.analytics.android'

dependencies {
implementation 'com.android.support:appcompat-v7:25.1.1'
//添加 Sensors Analytics SDK 依赖
implementation 'com.sensorsdata.analytics.android:SensorsAnalyticsSDK:2.1.2'
}
```
SensorsAnalyticsSDK 的最新版本号请参考 [github 更新日志](https://github.com/sensorsdata/sa-sdk-android/releases)。

如下示例图：
![](https://www.sensorsdata.cn/manual/img/android_sdk_autotrack_2.png)

**第三步：** 在程序的入口 **Application** 的 `onCreate()` 中调用 `SensorsDataAPI.sharedInstance()` 初始化 SDK：

```java
public class App extends Application {

// debug 模式的数据接收地址 （测试，测试项目）
final static String SA_SERVER_URL_DEBUG = "【测试项目】数据接收地址";

// release 模式的数据接收地址（发版，正式项目）
final static String SA_SERVER_URL_RELEASE = "【正式项目】数据接收地址";

// SDK Debug 模式选项
//   SensorsDataAPI.DebugMode.DEBUG_OFF - 关闭 Debug 模式
//   SensorsDataAPI.DebugMode.DEBUG_ONLY - 打开 Debug 模式，校验数据，但不进行数据导入
//   SensorsDataAPI.DebugMode.DEBUG_AND_TRACK - 打开 Debug 模式，校验数据，并将数据导入到 Sensors Analytics 中
// TODO 注意！请不要在正式发布的 App 中使用 DEBUG_AND_TRACK /DEBUG_ONLY 模式！ 请使用 DEBUG_OFF 模式！！！

// debug 时，初始化 SDK 使用测试项目数据接收 URL 、使用 DEBUG_AND_TRACK 模式；release 时，初始化 SDK 使用正式项目数据接收 URL 、使用 DEBUG_OFF 模式。
private boolean isDebugMode;

@Override
public void onCreate() {
super.onCreate();
// 在 Application 的 onCreate 初始化神策 SDK
initSensorsDataSDK(this);
}

/**
* 初始化 SDK 、开启自动采集
*/
private void initSensorsDataSDK(Context context) {
try {
// 初始化 SDK
SensorsDataAPI.sharedInstance(
context,                                                                                  // 传入 Context
(isDebugMode = isDebugMode(context)) ? SA_SERVER_URL_DEBUG : SA_SERVER_URL_RELEASE,       // 数据接收的 URL
isDebugMode ? SensorsDataAPI.DebugMode.DEBUG_AND_TRACK : SensorsDataAPI.DebugMode.DEBUG_OFF); // Debug 模式选项

// 打开自动采集, 并指定追踪哪些 AutoTrack 事件
List<SensorsDataAPI.AutoTrackEventType> eventTypeList = new ArrayList<>();
eventTypeList.add(SensorsDataAPI.AutoTrackEventType.APP_START);// $AppStart（启动事件）
eventTypeList.add(SensorsDataAPI.AutoTrackEventType.APP_END);// $AppEnd（退出事件）
eventTypeList.add(SensorsDataAPI.AutoTrackEventType.APP_CLICK);// $AppClick（原生控件点击事件）
SensorsDataAPI.sharedInstance().enableAutoTrack(eventTypeList);

//初始化SDK后，开启 RN 页面控件点击事件的自动采集
SensorsDataAPI.sharedInstance().enableReactNativeAutoTrack();
} catch (Exception e) {
e.printStackTrace();
}
}

/**
* @param context App 的 Context
* @return debug return true,release return false
* 用于判断是 debug 包，还是 relase 包
*/
public static boolean isDebugMode(Context context) {
try {
ApplicationInfo info = context.getApplicationInfo();
return (info.flags & ApplicationInfo.FLAG_DEBUGGABLE) != 0;
} catch (Exception e) {
e.printStackTrace();
return false;
}
}
}

```

## 2.2 开启自动采集

初始化 SDK 之后，可通过 `enableAutoTrack()` 方法 开启自动采集：

```java
try {
// 打开自动采集, 并指定追踪哪些 AutoTrack 事件
List<SensorsDataAPI.AutoTrackEventType> eventTypeList = new ArrayList<>();
// $AppStart
eventTypeList.add(SensorsDataAPI.AutoTrackEventType.APP_START);
// $AppEnd
eventTypeList.add(SensorsDataAPI.AutoTrackEventType.APP_END);
// $AppViewScreen
eventTypeList.add(SensorsDataAPI.AutoTrackEventType.APP_VIEW_SCREEN);
// $AppClick
eventTypeList.add(SensorsDataAPI.AutoTrackEventType.APP_CLICK);
SensorsDataAPI.sharedInstance().enableAutoTrack(eventTypeList);
} catch (Exception e) {
e.printStackTrace();
}
```

## 2.3 开启 React Native 页面控件的自动采集（$AppClick）

[1.7.14](https://github.com/sensorsdata/sa-sdk-android/releases/tag/v1.7.14) 及以后的版本， 支持在初始化 SDK 之后，通过 `enableReactNativeAutoTrack()` 方法开启 RN 页面控件点击事件的自动采集。

```java
//初始化SDK后，开启 RN 页面控件点击事件的自动采集
SensorsDataAPI.sharedInstance().enableReactNativeAutoTrack();
```




# 3. iOS 端
## 3.1 集成并初始化 SDK

**第一步：** 使用 CocoaPods 集成：

```
pod 'SensorsAnalyticsSDK'
```
**第二步：** 
在程序的入口（如 AppDelegate.m ）中引入 `SensorsAnalyticsSDK.h`，并在初始化方法（如 `- application:didFinishLaunchingWithOptions:launchOptions` ）中调用 `sharedInstanceWithServerURL:andLaunchOptions:andDebugMode:` 初始化 SDK。


```C
#import "SensorsAnalyticsSDK.h"

#ifdef DEBUG
#define SA_SERVER_URL @"<#【测试项目】数据接收地址#>"
#define SA_DEBUG_MODE SensorsAnalyticsDebugAndTrack
#else
#define SA_SERVER_URL @"<#【正式项目】数据接收地址#>"
#define SA_DEBUG_MODE SensorsAnalyticsDebugOff
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

[self initSensorsAnalyticsWithLaunchOptions:launchOptions];
return YES;
}

- (void)initSensorsAnalyticsWithLaunchOptions:(NSDictionary *)launchOptions {
// 初始化 SDK
[SensorsAnalyticsSDK sharedInstanceWithServerURL:SA_SERVER_URL
andLaunchOptions:launchOptions

// 打开自动采集, 并指定追踪哪些 AutoTrack 事件
[[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:SensorsAnalyticsEventTypeAppStart|
SensorsAnalyticsEventTypeAppEnd|
SensorsAnalyticsEventTypeAppClick];

}
```
## 3.2 开启全埋点
开发者集成 Sensors Analytics SDK 后，SDK 可以自动采集一些用户行为，如 App 启动、退出等，开发者可以通过 enableAutoTrack: 接口打开自动采集功能:

```C
// 打开自动采集, 并指定追踪哪些 AutoTrack 事件
[[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:SensorsAnalyticsEventTypeAppStart|
SensorsAnalyticsEventTypeAppEnd|
SensorsAnalyticsEventTypeAppViewScreen|
SensorsAnalyticsEventTypeAppClick];
```

## 3.3 开启 React Native 页面控件的自动采集（$AppClick）

1、对于直接集成源代码的开发者，可以在编译选项 Preprocessor Macros 中定义选项 
`SENSORS_ANALYTICS_REACT_NATIVE=1`
开启。

（对于直接集成 SDK 工程的项目，需要在 SDK 对应的 project 中修改编译选项，在 Preprocessor Macros 中定义选项 
`SENSORS_ANALYTICS_REACT_NATIVE=1`）

2、对于使用 Cocoapods 集成神策分析 SDK 的开发者，推荐使用:

```
pod 'SensorsAnalyticsSDK', :subspecs => ['ENABLE_REACT_NATIVE_APPCLICK']
```

集成方式开启，或者修改 Pod 中 `SensorsAnalyticsSDK` 项目的编译选项，如下图：

![](https://www.sensorsdata.cn/manual/img/ios_autotrack_1.png)



# 4. 在 React Native 上使用代码埋点

## 4.1 在 js 文件中导入神策模块

在具体的 js 文件中导入神策模块（RNSensorsAnalyticsModule），导入模块示例如下：

```java
import { NativeModules } from 'react-native';
const RNSensorsAnalyticsModule = NativeModules.RNSensorsAnalyticsModule;
```

添加导入模块后便可进行代码埋点。

## 4.2 添加埋点事件

在具体的位置添加事件埋点，以按钮点击时触发事件为例：

其中对应的事件名为：RN_AddToFav 对应的事件属性为：ProductID 和 UserLevel

```html
<Button
title="Button"
onPress={() =>
RNSensorsAnalyticsModule.track("RN_AddToFav",{"ProductID":123456,"UserLevel":"VIP"})}>
</Button>
```

具体操作如下图所示：

![](https://www.sensorsdata.cn/manual/img/android_sdk_reactnative_3.png)

__$AppClick（ React Native 元素点击）事件的预置属性：__

| 字段名称           | 类型   | 显示名 | 说明     | 版本    |
| :------------- | :--- | :----- | :----- | :----- |
| $element_type | 字符串  | 元素类型 | 控件的类型（ RNView ）  |     |
| $element_content | 字符串  | 元素内容 | 控件文本内容 |       |





