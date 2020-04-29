#! node option
// 系统变量
var path = require("path"),
    fs = require("fs"),
    dir = path.resolve(__dirname, "..");
var reactNavigationPath = dir + '/react-navigation',
    reactNavigationPath3X = dir + '/@react-navigation/native/src',
    reactNavigationPath4X = dir + '/@react-navigation/native/lib/module';
// 自定义变量
// RN 控制点击事件 Touchable.js 源码文件
var RNClickFilePath = dir + '/react-native/Libraries/Components/Touchable/Touchable.js';

// click 需 hook 的自执行代码
var sensorsdataClickHookCode = "(function(thatThis){ try {var ReactNative = require('react-native');thatThis.props.onPress && ReactNative.NativeModules.RNSensorsDataModule.trackViewClick(ReactNative.findNodeHandle(thatThis))} catch (error) { throw new Error('SensorsData RN Hook Code 调用异常: ' + error);}})(this); /* SENSORSDATA HOOK */ ";

// hook 代码实现点击事件采集
sensorsdataHookClickRN = function () {
    // 读取文件内容
    var fileContent = fs.readFileSync(RNClickFilePath, 'utf8');
    // 已经 hook 过了，不需要再次 hook
    if (fileContent.indexOf('SENSORSDATA HOOK') > -1) {
        return;
    }
    // 获取 hook 的代码插入的位置
    var hookIndex = fileContent.indexOf("this.touchableHandlePress(");
    // 判断文件是否异常，不存在 touchableHandlePress 方法，导致无法 hook 点击事件
    if (hookIndex == -1) {
        throw "Can't not find touchableHandlePress function";
    };
    // 插入 hook 代码
    var hookedContent = `${fileContent.substring(0, hookIndex)}\n${sensorsdataClickHookCode}\n${fileContent.substring(hookIndex)}`;
    // 备份 Touchable.js 源文件
    fs.renameSync(RNClickFilePath, `${RNClickFilePath}_sensorsdata_backup`);
    // 重写 Touchable.js 文件
    fs.writeFileSync(RNClickFilePath, hookedContent, 'utf8');
};
// 恢复被 hook 过的代码
sensorsdataResetRN = function (resetFilePath) {
    // 读取文件内容
    var fileContent = fs.readFileSync(resetFilePath, "utf8");
    // 未被 hook 过代码，不需要处理
    if (fileContent.indexOf('SENSORSDATA HOOK') == -1) {
        return;
    }
    // 检查备份文件是否存在
    var backFilePath = `${resetFilePath}_sensorsdata_backup`;
    if (!fs.existsSync(backFilePath)) {
        throw `File: ${backFilePath} not found, Please rm -rf node_modules and npm install again`;
    }
    // 将备份文件重命名恢复 + 自动覆盖被 hook 过的同名 Touchable.js 文件
    fs.renameSync(backFilePath, resetFilePath);
};



addTryCatch = function (functionBody) {
    functionBody = functionBody.replace(/this/g, 'thatThis');
    return "(function(thatThis){\n" +
        "    try{\n        " + functionBody +
        "    \n    } catch (error) { throw new Error('SensorsData RN Hook Code 调用异常: ' + error);}\n" +
        "})(this); /* SENSORSDATA HOOK */";
}


// hook 代码实现 PageView 事件采集;


navigationString3 = function (prevStateVarName, currentStateVarName, actionName) {
    var script = `function $$$getActivePageName$$$(navigationState){
            if(!navigationState)
                return null;
            const route = navigationState.routes[navigationState.index];
            if(route.routes){
                return $$$getActivePageName$$$(route);
            }else{
                if(route.params) {
            if(!route.params["sensorsdataurl"]){
              route.params.sensorsdataurl = route.routeName;
            }
                    return route.params; 
                } else {
             route.params = {sensorsdataurl:route.routeName};
          }
          return route.params;
            }
        }
        `;

    if (actionName) {
        script = `${script}
                                    var type = ${actionName}.type;
                                    var iosOnPageShow = false;
        
                                    if (require('react-native').Platform.OS === 'android') {
                                        if(type == 'Navigation/SET_PARAMS' || type == 'Navigation/COMPLETE_TRANSITION') {
                                            return;
                                        }
                                    } else if (require('react-native').Platform.OS === 'ios') {
                                        if(type == 'Navigation/BACK' && (${currentStateVarName} && !${currentStateVarName}.isTransitioning)) {
                                            iosOnPageShow = true;
                                        } else if (!(type == 'Navigation/SET_PARAMS' || type == 'Navigation/COMPLETE_TRANSITION')) {
                                            iosOnPageShow = true;
                                        }
                                        if (!iosOnPageShow) {
                                            return;
                                        }
                                    }


                                            `;
    }

    script = `${script} var params = $$$getActivePageName$$$(${currentStateVarName});
            if (require('react-native').Platform.OS === 'android') {
                if (${prevStateVarName}){
                    var prevParams = $$$getActivePageName$$$(${prevStateVarName});
                    if (params.sensorsdataurl == prevParams.sensorsdataurl){
                          return;
                    }
                 }
                require('react-native').NativeModules.RNSensorsDataModule.trackViewScreen(params);
            } else if (require('react-native').Platform.OS === 'ios') {
                if (!${actionName} || iosOnPageShow) {
                    require('react-native').NativeModules.RNSensorsDataModule.trackViewScreen(params);
                }
            }`;
    return script;
};
navigationEventString = function () {
    var script = `if(require('react-native').Platform.OS !== 'ios') {
            return;
          }
          if(payload && payload.state && payload.state.key && payload.state.routeName && payload.state.key != payload.state.routeName) {
            if(payload.state.params) {
                if(!payload.state.params.sensorsdataurl){
                    payload.state.params.sensorsdataurl = payload.state.routeName;
                }
            }else{
                payload.state.params = {sensorsdataurl:payload.state.routeName};
            }
            if(type == 'didFocus') {
                require('react-native').NativeModules.RNSensorsDataModule.trackViewScreen(payload.state.params);
            }
          }
          `;
    return script;
};
navigationString = function (currentStateVarName, actionName) {
    var script = `function $$$getActivePageName$$$(navigationState){
            if(!navigationState)
                return null;
            const route = navigationState.routes[navigationState.index];
            if(route.routes){
                return $$$getActivePageName$$$(route);
            }else{
                    if(route.params) {
                if(!route.params["sensorsdataurl"]){
                  route.params.sensorsdataurl = route.routeName;
                }
                        return route.params;
                    } else {
                 route.params = {sensorsdataurl:route.routeName};
              }
              return route.params;
            }
        }
        `;

    if (actionName) {
        script = `${script}
                          var type = ${actionName}.type;
                          if(type == 'Navigation/SET_PARAMS' || type == 'Navigation/COMPLETE_TRANSITION') {
                                return;
                          }
                          `;
    }

    script = `${script} var params = $$$getActivePageName$$$(${currentStateVarName});
            if (require('react-native').Platform.OS === 'android') {
            require('react-native').NativeModules.RNSensorsDataModule.trackViewScreen(params);}`;
    return script;
};


/**
    * hook react navigation
    * type: 1\2\3 对应的三个不同的兼容模式的 RN 文件
    * reset 判断是否是重置还是 hook,true 为重置
*/
injectReactNavigation = function (dirPath, type, reset = false) {
    if (!dirPath.endsWith('/')) {
        dirPath += '/';
    }
    if (type == 1) {
        var createNavigationContainerJsFilePath = `${dirPath}src/createNavigationContainer.js`;
        var getChildEventSubscriberJsFilePath = `${dirPath}src/getChildEventSubscriber.js`;
        if (!fs.existsSync(createNavigationContainerJsFilePath)) {
            return
        }
        if (!fs.existsSync(getChildEventSubscriberJsFilePath)) {
            return;
        }
        // common.modifyFile(createNavigationContainerJsFilePath, onNavigationStateChangeTransformer);
        if (reset) {
            sensorsdataResetRN(createNavigationContainerJsFilePath);
            sensorsdataResetRN(getChildEventSubscriberJsFilePath);
        } else {
            // 读取文件内容
            var content = fs.readFileSync(createNavigationContainerJsFilePath, 'utf8');
            // 已经 hook 过了，不需要再次 hook
            if (content.indexOf('SENSORSDATA HOOK') > -1) {
                return;
            }
            // 获取 hook 的代码插入的位置
            var index = content.indexOf("if (typeof this.props.onNavigationStateChange === 'function') {");
            if (index == -1)
                throw "index is -1";
            content = content.substring(0, index) + addTryCatch(navigationString('nav', 'action')) + '\n' + content.substring(index)
            var didMountIndex = content.indexOf('componentDidMount() {');
            if (didMountIndex == -1)
                throw "didMountIndex is -1";
            var forEachIndex = content.indexOf('this._actionEventSubscribers.forEach(subscriber =>', didMountIndex);
            var clojureEnd = content.indexOf(';', forEachIndex);
            // 插入 hook 代码
            content = content.substring(0, forEachIndex) + '{' +
                addTryCatch(navigationString('this.state.nav', null)) + '\n' +
                content.substring(forEachIndex, clojureEnd + 1) +
                '}' + content.substring(clojureEnd + 1);
            // 备份 navigation 源文件
            fs.renameSync(createNavigationContainerJsFilePath, `${createNavigationContainerJsFilePath}_sensorsdata_backup`);
            // 重写文件
            fs.writeFileSync(createNavigationContainerJsFilePath, content, 'utf8');

            // common.modifyFile(getChildEventSubscriberJsFilePath, onEventSubscriberTransformer);
            var content = fs.readFileSync(getChildEventSubscriberJsFilePath, 'utf8');
            // 已经 hook 过了，不需要再次 hook
            if (content.indexOf('SENSORSDATA HOOK') > -1) {
                return;
            }
            // 获取 hook 的代码插入的位置
            var script = "const emit = (type, payload) => {";
            var index = content.indexOf(script);
            if (index == -1)
                throw "index is -1";
            content = content.substring(0, index + script.length) + addTryCatch(navigationEventString()) + '\n' + content.substring(index + script.length);
            // 备份 navigation 源文件
            fs.renameSync(getChildEventSubscriberJsFilePath, `${getChildEventSubscriberJsFilePath}_sensorsdata_backup`);
            // 重写文件
            fs.writeFileSync(getChildEventSubscriberJsFilePath, content, 'utf8');
        }

    } else if (type == 2) {
        const createAppContainerJsFilePath = `${dirPath}/createAppContainer.js`;
        if (!fs.existsSync(createAppContainerJsFilePath)) {
            return;
        }
        if (reset) {
            sensorsdataResetRN(createAppContainerJsFilePath);
        } else {
            // common.modifyFile(createAppContainerJsFilePath, onNavigationStateChangeTransformer3);
            // 读取文件内容
            var content = fs.readFileSync(createAppContainerJsFilePath, 'utf8');
            // 已经 hook 过了，不需要再次 hook
            if (content.indexOf('SENSORSDATA HOOK') > -1) {
                return;
            }
            var index = content.indexOf("if (typeof this.props.onNavigationStateChange === 'function') {");
            if (index == -1)
                throw "index is -1";
            content = content.substring(0, index) + addTryCatch(navigationString3('prevNav', 'nav', 'action')) + '\n' + content.substring(index)
            var didMountIndex = content.indexOf('componentDidMount() {');
            if (didMountIndex == -1)
                throw "didMountIndex is -1";
            var forEachIndex = content.indexOf('this._actionEventSubscribers.forEach(subscriber =>', didMountIndex);
            if (forEachIndex == -1) {
                forEachIndex = content.indexOf(
                    'this._actionEventSubscribers.forEach((subscriber) =>',
                    didMountIndex,
                );
            }
            var clojureEnd = content.indexOf(';', forEachIndex);
            content = content.substring(0, forEachIndex) + '{' +
                addTryCatch(navigationString3(null, 'this.state.nav', null)) + '\n' +
                content.substring(forEachIndex, clojureEnd + 1) +
                '}' + content.substring(clojureEnd + 1);
            // 备份 navigation 源文件
            fs.renameSync(createAppContainerJsFilePath, `${createAppContainerJsFilePath}_sensorsdata_backup`);
            // 重写文件
            fs.writeFileSync(createAppContainerJsFilePath, content, 'utf8');
        }
    }
}
sensorsdataHookViewRN = function () {
    injectReactNavigation(reactNavigationPath, 1);
    injectReactNavigation(reactNavigationPath3X, 2);
    injectReactNavigation(reactNavigationPath4X, 2)
};

// 恢复被 hook 的 view 文件
sensorsdataResetViewRN = function () {
    injectReactNavigation(reactNavigationPath, 1, true);
    injectReactNavigation(reactNavigationPath3X, 2, true);
    injectReactNavigation(reactNavigationPath4X, 2, true)
};

// 全部 hook 文件恢复
resetAllSensorsdataHookRN = function () {
    sensorsdataResetRN(RNClickFilePath);
    sensorsdataResetViewRN();
};
// 命令行
switch (process.argv[2]) {
    case '-run':
         sensorsdataHookClickRN(RNClickFilePath);
         sensorsdataHookViewRN();
        break;
    case '-reset':
        resetAllSensorsdataHookRN();
        break;
    default:
        console.log('can not find this options: ' + process.argv[2]);
}

