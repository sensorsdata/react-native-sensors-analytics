# sensorsdata-analytics-react-native

# 1.安装 React Native 模块

## 1.1 npm 安装 sensorsdata-analytics-react-native 模块

```sh
npm install sensorsdata-analytics-react-native
```

## 1.2 `link` sensorsdata-analytics-react-native 模块（React Native 0.60 以下版本）

```sh
react-native link sensorsdata-analytics-react-native
```
## 1.3 配置 package.json
在 package.json 文件增加如下配置:
```sh
"scripts": {
      "postinstall": "node node_modules/sensorsdata-analytics-react-native/SensorsDataRNHook.js -run"
}
```

## 1.4 执行 npm install 命令
   ```sh
   npm install
   ```

### 详细文档请参考：[Android & iOS SDK 在 React Native 中使用说明](https://www.sensorsdata.cn/manual/sdk_reactnative.html)


## License

Copyright 2015－2020 Sensors Data Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

**同时，我们禁止一切基于神策数据开源 SDK 的商业活动！**
