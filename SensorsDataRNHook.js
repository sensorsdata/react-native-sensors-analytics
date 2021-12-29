#! node option
// 系统变量
var path = require("path"),
  fs = require("fs"),
  dir = path.resolve(__dirname, "..");
var userPackageJson = require("../../package.json");
var ignoreScreen = false;
if (userPackageJson && userPackageJson['sensorsData'] && userPackageJson['sensorsData']['ignoreScreen']) {
    ignoreScreen = true;
}
var reactNavigationPath = dir + '/react-navigation',
  reactNavigationPath3X = dir + '/@react-navigation/native/src',
  reactNavigationPath4X = dir + '/@react-navigation/native/lib/module',
  reactNavigationPath5X = dir + '/@react-navigation/core/src/BaseNavigationContainer.tsx';
// 自定义变量

var reactNavigationReduxCreatePath = [dir + '/react-navigation-redux-helpers/src/reduxify-navigator.js',
dir + '/react-navigation-redux-helpers/src/create-redux-container.js'];
var reactNavigationReduxMiddlePath = dir + '/react-navigation-redux-helpers/src/middleware.js';
var RNClickFilePath = dir + '/react-native/Libraries/Components/Touchable/Touchable.js';
var RNClickPressabilityFilePath = dir + '/react-native/Libraries/Pressability/Pressability.js';
var RNClickableFiles = [dir + '/react-native/Libraries/Renderer/src/renderers/native/ReactNativeFiber.js',
dir + '/react-native/Libraries/Renderer/src/renderers/native/ReactNativeFiber-dev.js',
dir + '/react-native/Libraries/Renderer/src/renderers/native/ReactNativeFiber-prod.js',
dir + '/react-native/Libraries/Renderer/src/renderers/native/ReactNativeFiber-profiling.js',
dir + '/react-native/Libraries/Renderer/ReactNativeFiber-dev.js',
dir + '/react-native/Libraries/Renderer/ReactNativeFiber-prod.js',
dir + '/react-native/Libraries/Renderer/oss/ReactNativeRenderer-dev.js',
dir + '/react-native/Libraries/Renderer/oss/ReactNativeRenderer-prod.js',
dir + '/react-native/Libraries/Renderer/ReactNativeStack-dev.js',
dir + '/react-native/Libraries/Renderer/ReactNativeStack-prod.js',
dir + '/react-native/Libraries/Renderer/oss/ReactNativeRenderer-profiling.js',
dir + '/react-native/Libraries/Renderer/ReactNativeRenderer-dev.js',
dir + '/react-native/Libraries/Renderer/ReactNativeRenderer-prod.js',
dir + '/react-native/Libraries/Renderer/implementations/ReactNativeRenderer-profiling.js',
dir + '/react-native/Libraries/Renderer/implementations/ReactNativeRenderer-dev.js',
dir + '/react-native/Libraries/Renderer/implementations/ReactNativeRenderer-prod.js'];
// RN 控制 slider 的文件
var RNSliderFiles = [dir + '/react-native/Libraries/Components/Slider/Slider.js',
dir + '/react-native/Libraries/Components/Slider/Slider.js',
dir + '/@react-native-community/slider/js/Slider.js',
dir + '/@react-native-community/slider/dist/Slider.js',
dir + '/@react-native-community/js/Slider.js',
dir + '/@react-native-community/src/js/Slider.js'];
// RN 控制 switch 的文件
var RNSwitchFiles = [dir + '/react-native/Libraries/Components/Switch/Switch.js'];
// RN 控制 SegmentedControl 的文件
var RNSegmentedControlFilePath = [dir + '/react-native/Libraries/Components/SegmentedControlIOS/SegmentedControlIOS.ios.js',
dir + '/@react-native-community/segmented-control/js/SegmentedControl.ios.js'];
// RN 控制 GestureButtons 的文件
var RNGestureButtonsFilePaths = [dir + '/react-native-gesture-handler/GestureButtons.js',
dir + '/react-native-gesture-handler/src/components/GestureButtons.tsx'];
// click 需 hook 的自执行代码
var sensorsdataClickHookCode = "(function(thatThis){ \n"
                               +"  try {\n"
                               +"    var ReactNative = require('react-native');\n"
                               +"    var dataModule = ReactNative.NativeModules.RNSensorsDataModule;\n"
                               +"    thatThis.props.onPress && dataModule && dataModule.trackViewClick && dataModule.trackViewClick(ReactNative.findNodeHandle(thatThis))\n"
                               +"  } catch (error) { throw new Error('SensorsData RN Hook Code 调用异常: ' + error);}\n"
                               +"})(this); /* SENSORSDATA HOOK */ ";
var sensorsdataClickHookPressabilityCode = " var tag = event.currentTarget && event.currentTarget._nativeTag?event.currentTarget._nativeTag:event.currentTarget;+\n"
                                            +"(function(thatThis){\n"
                                            +"  if(thatThis){\n"
                                            +"    try {\n"
                                            +"      var ReactNative = require('react-native');\n"
                                            +"      var dataModule = ReactNative.NativeModules.RNSensorsDataModule;\n"
                                            +"      dataModule && dataModule.trackViewClick && dataModule.trackViewClick(thatThis);\n"
                                            +"    }catch (error){\n"
                                            +"      throw new Error('SensorsData RN Hook Code 调用异常: ' + error);}}}\n"
                                            +")(tag); /* SENSORSDATA HOOK */ ";
var sensorsdataSliderHookCode = "(function(thatThis){\n"
                               +"  try {\n"
                               +"    var ReactNative = require('react-native');\n"
                               +"    var dataModule = ReactNative.NativeModules.RNSensorsDataModule;\n"
                               +"    dataModule && dataModule.trackViewClick && dataModule.trackViewClick(event.nativeEvent.target);\n"
                               +"  } catch (error) { \n"
                               +"      throw new Error('SensorsData RN Hook Code 调用异常: ' + error);\n"
                               +"  }\n"
                               +"})(this); /* SENSORSDATA HOOK */";
var sensorsdataSegmentedControlHookCode = "if(this.props.onChange != null || this.props.onValueChange != null){\n"
                               +"(function(thatThis){\n"
                               +"  try {\n"
                               +"    var ReactNative = require('react-native');\n"
                               +"    var dataModule = ReactNative.NativeModules.RNSensorsDataModule;\n"
                               +"    dataModule && dataModule.trackViewClick && dataModule.trackViewClick(event.nativeEvent.target);\n"
                               +"  } catch (error) { \n"
                               +"      throw new Error('SensorsData RN Hook Code 调用异常: ' + error);}\n"
                               +"})(this); /* SENSORSDATA HOOK */}";
var sensorsdataSwitchHookCode = "if(this.props.onChange != null || this.props.onValueChange != null){\n"
                               +"  (function(thatThis){ \n"
                               +"    try {\n"
                               +"      var ReactNative = require('react-native');\n"
                               +"      var dataModule = ReactNative.NativeModules.RNSensorsDataModule;\n"
                               +"      dataModule && dataModule.trackViewClick && dataModule.trackViewClick(ReactNative.findNodeHandle(thatThis));\n"
                               +"    } catch (error) { throw new Error('SensorsData RN Hook Code 调用异常: ' + error);}\n"
                               +"  })(this); /* SENSORSDATA HOOK */}";
var sensorsdataSwitchHookCode66 = "if(nativeSwitchRef.current && onValueChange){\n"
                               + "  (function(thatThis){ \n"
                               + "    try {\n"
                               + "      var ReactNative = require('react-native');\n"
                               + "      var dataModule = ReactNative.NativeModules.RNSensorsDataModule;\n"
                               + "      dataModule && dataModule.trackViewClick && dataModule.trackViewClick(ReactNative.findNodeHandle(nativeSwitchRef.current));\n"
                               + "    } catch (error) { throw new Error('SensorsData RN Hook Code 调用异常: ' + error);}\n"
                               + "  })(this); /* SENSORSDATA HOOK */}";
var sensorsdataImportReactNativeHookCode ="import ReactNative from 'react-native';\n";
var sensorsdataNavigation5HookCode = `

	  function getCurrentRouteName(){
        let state = getRootState();
          if (state === undefined) {
            return undefined;
          }
        while (state.routes[state.index].state !== undefined) {
            state = state.routes[state.index].state as NavigationState;
          }
          return state.routes[state.index].name;
      }
	function getParams(state:any):any{
		if(!state){
		   return null;
		 }
		 var route = state.routes[state.index];
		 var params = route.params;
		 if(route.state){
		   var p = getParams(route.state);
		   if(p){
		     params = p;
		   }
		 }
		return params;
	}
	function trackViewScreen(state: any): void {
		if (!state) {
		  return;
		}
		var route = state.routes[state.index];
		if (route.name === 'Root') {
		  trackViewScreen(route.state);
		  return;
		}
		var screenName = getCurrentRouteName();
		var params = getParams(state);
		var saProperties = {};
		if (params) {
		  if (!params.sensorsdataurl) {
		    saProperties.sensorsdataurl = screenName;
		  }else{
		    saProperties.sensorsdataurl = params.sensorsdataurl;
		  }
		  if(params.sensorsdataparams){
		    saProperties.sensorsdataparams = JSON.parse(JSON.stringify(params.sensorsdataparams));
		  }
		} else {
		    saProperties.sensorsdataurl = screenName;
		}
	    if(${ignoreScreen}){
          if(saProperties.sensorsdataparams){
            saProperties.sensorsdataparams.SAIgnoreViewScreen = true;
          }else{
            saProperties.sensorsdataparams = {SAIgnoreViewScreen : true};
          }
        }
		var dataModule = ReactNative?.NativeModules?.RNSensorsDataModule;
		dataModule?.trackViewScreen && dataModule.trackViewScreen(saProperties);
	}
	trackViewScreen(getRootState());
	/* SENSORSDATA HOOK */ `;

var sensorsDataHookReduxCreateCode =
  `   function getParams(route){
        if(!route){
          return null;
        }
        var childRoute = route.routes[route.index];
        var params = childRoute.params;
        if(childRoute.routes){
          var p = getParams(childRoute);
          if(p){
            params = p;
          }
        }
        return params;
      }
    function getScreenName(route){
        if(!route){
          return null;
        }
        var childRoute = route.routes[route.index];
        var screenName = childRoute.routeName;
        if(childRoute.routes){
          var name = getScreenName(childRoute);
          if(name){
            screenName = name;
          }
        }
        return screenName;
      }
      function trackViewScreen(route){
        if (!route) {
          return;
        }
        var childRoute = route.routes[route.index];
        if (route.name === 'Root') {
          trackViewScreen(childRoute);
          return;
        }
        var screenName = getScreenName(route);
        var params = getParams(route);
		var saProperties = {};
		if (params) {
		  if (!params.sensorsdataurl) {
		    saProperties.sensorsdataurl = screenName;
		  }else{
	        saProperties.sensorsdataurl = params.sensorsdataurl;
	      }
		  if(params.sensorsdataparams){
		    saProperties.sensorsdataparams = JSON.parse(JSON.stringify(params.sensorsdataparams));
		  }
		} else {
		    saProperties.sensorsdataurl = screenName;
		}
	    if(${ignoreScreen}){
          if(saProperties.sensorsdataparams){
            saProperties.sensorsdataparams.SAIgnoreViewScreen = true;
          }else{
            saProperties.sensorsdataparams = {SAIgnoreViewScreen : true};
          }
        }
		var dataModule = ReactNative?.NativeModules?.RNSensorsDataModule;
		dataModule?.trackViewScreen && dataModule.trackViewScreen(saProperties);
      }
      trackViewScreen(this.props.state);
      /* SENSORSDATA HOOK */
      `;

var sensorsDataHookReduxMiddleCode = `
    if(oldState !== newState){
      var type = action.type;
      if(type === 'Navigation/BACK' ||
          type === 'Navigation/NAVIGATE' ||
           type === 'Navigation/POP' ||
           type === 'Navigation/POP_TO_TOP' ||
           type === 'Navigation/PUSH' ||
           type === 'Navigation/RESET' ||
           type === 'Navigation/REPLACE' ||
           type === 'Navigation/GO_BACK' ||
           type === 'Navigation/JUMP_TO' ||
           type === 'Navigation/OPEN_DRAWER' ||
           type === 'Navigation/CLOSE_DRAWER'){
        function getParams(route){
          if(!route){
            return null;
          }
          var childRoute = route.routes[route.index];
          var params = childRoute.params;
          if(childRoute.routes){
            var p = getParams(childRoute);
            if(p){
              params = p;
            }
          }
          return params;
        }
      function getScreenName(route){
          if(!route){
            return null;
          }
          var childRoute = route.routes[route.index];
          var screenName = childRoute.routeName;
          if(childRoute.routes){
            var name = getScreenName(childRoute);
            if(name){
              screenName = name;
            }
          }
          return screenName;
        }
        function trackViewScreen(route){
          if (!route) {
            return;
          }
          var childRoute = route.routes[route.index];
          if (route.name === 'Root') {
            trackViewScreen(childRoute);
            return;
          }
          var screenName = getScreenName(route);
          var params = getParams(route);
		  var saProperties = {};
		  if (params) {
		    if (!params.sensorsdataurl) {
		      saProperties.sensorsdataurl = screenName;
		    }else{
	          saProperties.sensorsdataurl = params.sensorsdataurl;
	        }
		    if(params.sensorsdataparams){
		      saProperties.sensorsdataparams = JSON.parse(JSON.stringify(params.sensorsdataparams));
		    }
		  } else {
		    saProperties.sensorsdataurl = screenName;
		  }
	      if(${ignoreScreen}){
	          if(saProperties.sensorsdataparams){
	            saProperties.sensorsdataparams.SAIgnoreViewScreen = true;
	          }else{
	            saProperties.sensorsdataparams = {SAIgnoreViewScreen : true};
	          }
          }
		  var dataModule = ReactNative?.NativeModules?.RNSensorsDataModule;
		  dataModule?.trackViewScreen && dataModule.trackViewScreen(saProperties);
        }
        trackViewScreen(navStateSelector(newState));
        /* SENSORSDATA HOOK */
      }
    }
`;

// hook click
sensorsdataHookClickRN = function () {
  if (fs.existsSync(RNClickFilePath)) {
    // 读取文件内容
    var fileContent = fs.readFileSync(RNClickFilePath, 'utf8');
    // 已经 hook 过了，不需要再次 hook
    if (fileContent.indexOf('SENSORSDATA HOOK') > -1) {
      return;
    }
    console.log(`found Touchable.js: ${RNClickFilePath}`);
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
    console.log(`modify Touchable.js succeed`);
  }
};

// hook 0.62 0.63 click
sensorsdataHookPressabilityClickRN = function () {
  if (fs.existsSync(RNClickPressabilityFilePath)) {
    // 读取文件内容
    var fileContent = fs.readFileSync(RNClickPressabilityFilePath, 'utf8');
    // 已经 hook 过了，不需要再次 hook
    if (fileContent.indexOf('SENSORSDATA HOOK') > -1) {
      return;
    }
    console.log(`found Pressability.js: ${RNClickPressabilityFilePath}`);
    // 获取 hook 的代码插入的位置
    var scriptStr = 'onPress(event);';
    var hookIndex = fileContent.lastIndexOf(scriptStr);
    // 判断文件是否异常，不存在 touchableHandlePress 方法，导致无法 hook 点击事件
    if (hookIndex == -1) {
      throw "Can't not find onPress(event); code";
    };
    // 插入 hook 代码
    var hookedContent = `${fileContent.substring(
      0,
      hookIndex
    )}\n${sensorsdataClickHookPressabilityCode}\n${fileContent.substring(
      hookIndex
    )}`;
    // 备份 Pressability.js 源文件
    fs.renameSync(RNClickPressabilityFilePath, `${RNClickPressabilityFilePath}_sensorsdata_backup`);
    // 重写 Pressability.js 文件
    fs.writeFileSync(RNClickPressabilityFilePath, hookedContent, 'utf8');
    console.log(`modify Pressability.js succeed`);
  }
};


// hook navigation 5.x
sensorsdataHookNavigation5 = function () {
  if (fs.existsSync(reactNavigationPath5X)) {
    // 读取文件内容
    var fileContent = fs.readFileSync(reactNavigationPath5X, 'utf8');
    // 已经 hook 过了，不需要再次 hook
    if (fileContent.indexOf('SENSORSDATA HOOK') > -1) {
      return;
    }
    console.log(`found BaseNavigationContainer.tsx: ${reactNavigationPath5X}`);
    // 获取 hook 的代码插入的位置
    var scriptStr = 'isFirstMountRef.current = false;';
    var hookIndex = fileContent.lastIndexOf(scriptStr);
    // 判断文件是否异常，不存在代码，导致无法 hook 点击事件
    if (hookIndex == -1) {
      throw "navigation Can't not find `isFirstMountRef.current = false;` code";
    }

    // 插入 hook 代码
    var hookedContent = `${fileContent.substring(0,hookIndex
    )}\n${sensorsdataNavigation5HookCode}\n${fileContent.substring(hookIndex)}`;
    // BaseNavigationContainer.tsx
    fs.renameSync(
      reactNavigationPath5X,
      `${reactNavigationPath5X}_sensorsdata_backup`
    );
    hookedContent = sensorsdataImportReactNativeHookCode + hookedContent;
    // BaseNavigationContainer.tsx
    fs.writeFileSync(reactNavigationPath5X, hookedContent, 'utf8');
    console.log(`modify BaseNavigationContainer.tsx succeed`);
  }
};

// hook react-navigation-redux-helper create
sensorsdataHookNavigationReduxCreate = function (reset = false) {
  reactNavigationReduxCreatePath.forEach(function (onefile) {
    if (fs.existsSync(onefile)) {
      // 读取文件内容
      var fileContent = fs.readFileSync(onefile, 'utf8');
      if (reset) {
        // 未被 hook 过代码，不需要处理
        if (fileContent.indexOf('SENSORSDATA HOOK') == -1) {
          return;
        }
        // 检查备份文件是否存在
        var backFilePath = `${onefile}_sensorsdata_backup`;
        if (!fs.existsSync(backFilePath)) {
          throw `File: ${backFilePath} not found, Please rm -rf node_modules and npm install again`;
        }
        // 将备份文件重命名恢复 + 自动覆盖被 hook 过的同名文件
        fs.renameSync(backFilePath, onefile);
        console.log(`found and reset js: ${onefile}`);
      } else {
        // 已经 hook 过了，不需要再次 hook
        if (fileContent.indexOf('SENSORSDATA HOOK') > -1) {
          return;
        }
        console.log(`found redux : ${onefile}`);
        // 获取 hook 的代码插入的位置
        var scriptStr = 'initializeListeners(key, this.props.state);';
        var hookIndex = fileContent.indexOf(scriptStr);
        // 判断文件是否异常，不存在 touchableHandlePress 方法，导致无法 hook 点击事件
        if (hookIndex == -1) {
          throw "Can't not find code \"initializeListeners(key, this.props.state);\"";
        }
        // 插入 hook 代码
        var hookedContent = sensorsdataImportReactNativeHookCode + `${fileContent.substring(
          0,
          hookIndex + scriptStr.length
        )}\n${sensorsDataHookReduxCreateCode}\n${fileContent.substring(
          hookIndex + scriptStr.length
        )}`;
        // 备份源文件
        fs.renameSync(onefile, `${onefile}_sensorsdata_backup`);
        // 重写文件
        fs.writeFileSync(onefile, hookedContent, 'utf8');
        console.log(`modify redux succeed`);
      }
    }
  });
};

// hook react-navigation-redux-helper middle
sensorsdataHookNavigationReduxMiddle = function () {
  if (fs.existsSync(reactNavigationReduxMiddlePath)) {
    // 读取文件内容
    var fileContent = fs.readFileSync(reactNavigationReduxMiddlePath, 'utf8');
    // 已经 hook 过了，不需要再次 hook
    if (fileContent.indexOf('SENSORSDATA HOOK') > -1) {
      return;
    }
    console.log(`found middleware.js: ${reactNavigationReduxMiddlePath}`);
    // 获取 hook 的代码插入的位置
    var scriptStr = 'const newState = store.getState();';
    var hookIndex = fileContent.indexOf(scriptStr);
    // 判断文件是否异常，不存在该代码，导致无法 hook 点击事件
    if (hookIndex == -1) {
      throw "Can't not find code \"const newState = store.getState();\n";
    }
    // 插入 hook 代码
    var hookedContent = sensorsdataImportReactNativeHookCode + `${fileContent.substring(
      0,
      hookIndex + scriptStr.length
    )}\n${sensorsDataHookReduxMiddleCode}\n${fileContent.substring(
      hookIndex + scriptStr.length
    )}`;
    // 备份 middleware.js 源文件
    fs.renameSync(
      reactNavigationReduxMiddlePath,
      `${reactNavigationReduxMiddlePath}_sensorsdata_backup`
    );
    // 重写 middleware.js 文件
    fs.writeFileSync(reactNavigationReduxMiddlePath, hookedContent, 'utf8');
    console.log(`modify middleware.js succeed`);
  }
};

// hook slider
sensorsdataHookSliderRN = function (reset = false) {
  RNSliderFiles.forEach(function (onefile) {
    if (fs.existsSync(onefile)) {
      // 读取文件内容
      var fileContent = fs.readFileSync(onefile, 'utf8');
      if (reset) {
        // 未被 hook 过代码，不需要处理
        if (fileContent.indexOf('SENSORSDATA HOOK') == -1) {
          return;
        }
        // 检查备份文件是否存在
        var backFilePath = `${onefile}_sensorsdata_backup`;
        if (!fs.existsSync(backFilePath)) {
          throw `File: ${backFilePath} not found, Please rm -rf node_modules and npm install again`;
        }
        // 将备份文件重命名恢复 + 自动覆盖被 hook 过的同名文件
        fs.renameSync(backFilePath, onefile);
        console.log(`found and reset Slider.js: ${onefile}`);
      } else {
        // 已经 hook 过了，不需要再次 hook
        if (fileContent.indexOf('SENSORSDATA HOOK') > -1) {
          return;
        }
        console.log(`found Slider.js: ${onefile}`);
        // 获取 hook 的代码插入的位置
        var scriptStr = 'onSlidingComplete(event.nativeEvent.value);';
        var hookIndex = fileContent.indexOf(scriptStr);
        // 判断文件是否异常，不存在 touchableHandlePress 方法，导致无法 hook 点击事件
        if (hookIndex == -1) {
          throw "Can't not find onSlidingComplete function";
        }
        // 插入 hook 代码
        var hookedContent = `${fileContent.substring(
          0,
          hookIndex + scriptStr.length
        )}\n${sensorsdataSliderHookCode}\n${fileContent.substring(
          hookIndex + scriptStr.length
        )}`;
        // 备份源文件
        fs.renameSync(onefile, `${onefile}_sensorsdata_backup`);
        // 重写文件
        fs.writeFileSync(onefile, hookedContent, 'utf8');
        console.log(`modify Slider.js succeed`);
      }
    }
  });
};
// hook switch
sensorsdataHookSwitchRN = function (reset = false) {
  RNSwitchFiles.forEach(function (onefile) {
    if (fs.existsSync(onefile)) {
      // 读取文件内容
      var fileContent = fs.readFileSync(onefile, 'utf8');
      if (reset) {
        // 未被 hook 过代码，不需要处理
        if (fileContent.indexOf('SENSORSDATA HOOK') == -1) {
          return;
        }
        // 检查备份文件是否存在
        var backFilePath = `${onefile}_sensorsdata_backup`;
        if (!fs.existsSync(backFilePath)) {
          throw `File: ${backFilePath} not found, Please rm -rf node_modules and npm install again`;
        }
        // 将备份文件重命名恢复 + 自动覆盖被 hook 过的同名文件
        fs.renameSync(backFilePath, onefile);
        console.log(`found and reset Switch.js: ${onefile}`);
      } else {
        // 已经 hook 过了，不需要再次 hook
        if (fileContent.indexOf('SENSORSDATA HOOK') > -1) {
          return;
        }
        console.log(`found Switch.js: ${onefile}`);
        // 特殊情况的单独插入
        // if (this.props.onValueChange != null) {
        var scriptStr = 'if (this.props.onValueChange != null) {';
        var hookIndex = fileContent.indexOf(scriptStr);
        if (hookIndex > -1) {
          // 插入 hook 代码
          var hookedContent = `${fileContent.substring(
            0,
            hookIndex
          )}\n${sensorsdataSwitchHookCode}\n${fileContent.substring(
            hookIndex
          )}`;
          // 备份源文件
          fs.renameSync(onefile, `${onefile}_sensorsdata_backup`);
          // 重写文件
          fs.writeFileSync(onefile, hookedContent, 'utf8');
          console.log(`modify Switch.js: ${onefile}`);
        } else {
          // 获取 hook 的代码插入的位置
          scriptStr = 'this.props.onValueChange(event.nativeEvent.value);';
          hookIndex = fileContent.indexOf(scriptStr);
          var hookcontent;
          if (hookIndex == -1) {
            scriptStr = 'onValueChange?.(event.nativeEvent.value);';
            hookIndex = fileContent.indexOf(scriptStr);
            hookcontent = sensorsdataSwitchHookCode66;
          } else {
            hookcontent = sensorsdataSwitchHookCode;
          }
          // 判断文件是否异常，不存在 touchableHandlePress 方法，导致无法 hook 点击事件
          if (hookIndex == -1) {
            throw "Can't not find onValueChange function";
          }
          // 插入 hook 代码
          var hookedContent = `${fileContent.substring(
            0,
            hookIndex + scriptStr.length
          )}\n${hookcontent}\n${fileContent.substring(
            hookIndex + scriptStr.length
          )}`;
          // 备份源文件
          fs.renameSync(onefile, `${onefile}_sensorsdata_backup`);
          // 重写文件
          fs.writeFileSync(onefile, hookedContent, 'utf8');
          console.log(`modify Switch.js succeed`);
        }
      }
    }
  });
};
// hook SegmentedControl
sensorsdataHookSegmentedControlRN = function (reset = false) {
  RNSegmentedControlFilePath.forEach(function (onefile) {
    if (fs.existsSync(onefile)) {
      // 读取文件内容
      var fileContent = fs.readFileSync(onefile, 'utf8');
      if (reset) {
        // 未被 hook 过代码，不需要处理
        if (fileContent.indexOf('SENSORSDATA HOOK') == -1) {
          return;
        }
        // 检查备份文件是否存在
        var backFilePath = `${onefile}_sensorsdata_backup`;
        if (!fs.existsSync(backFilePath)) {
          throw `File: ${backFilePath} not found, Please rm -rf node_modules and npm install again`;
        }
        // 将备份文件重命名恢复 + 自动覆盖被 hook 过的同名文件
        fs.renameSync(backFilePath, onefile);
        console.log(`found and reset SegmentedControl.js: ${onefile}`);
      } else {
        // 已经 hook 过了，不需要再次 hook
        if (fileContent.indexOf('SENSORSDATA HOOK') > -1) {
          return;
        }
        console.log(`found SegmentedControl.js: ${onefile}`);
        // 获取 hook 的代码插入的位置
        var scriptStr = 'this.props.onValueChange(event.nativeEvent.value);';
        var hookIndex = fileContent.indexOf(scriptStr);
        // 判断文件是否异常，不存在 touchableHandlePress 方法，导致无法 hook 点击事件
        if (hookIndex == -1) {
          throw "Can't not find onValueChange function";
        }
        // 插入 hook 代码
        var hookedContent = `${fileContent.substring(
          0,
          hookIndex + scriptStr.length
        )}\n${sensorsdataSegmentedControlHookCode}\n${fileContent.substring(
          hookIndex + scriptStr.length
        )}`;
        // 备份 Touchable.js 源文件
        fs.renameSync(onefile, `${onefile}_sensorsdata_backup`);
        // 重写 Touchable.js 文件
        fs.writeFileSync(onefile, hookedContent, 'utf8');
        console.log(`modify SegmentedControl.js succeed`);
      }
    }
  });
};
// hook GestureButtons
sensorsdataHookGestureButtonsRN = function (reset = false) {
  RNGestureButtonsFilePaths.forEach(function (onefile) {
    if (fs.existsSync(onefile)) {
      // 读取文件内容
      var fileContent = fs.readFileSync(onefile, 'utf8');
      if (reset) {
        // 未被 hook 过代码，不需要处理
        if (fileContent.indexOf('SENSORSDATA HOOK') == -1) {
          return;
        }
        // 检查备份文件是否存在
        var backFilePath = `${onefile}_sensorsdata_backup`;
        if (!fs.existsSync(backFilePath)) {
          throw `File: ${backFilePath} not found, Please rm -rf node_modules and npm install again`;
        }
        // 将备份文件重命名恢复 + 自动覆盖被 hook 过的同名文件
        fs.renameSync(backFilePath, onefile);
        console.log(`found and reset GestureButtons: ${onefile}`);
      } else {
        // 已经 hook 过了，不需要再次 hook
        if (fileContent.indexOf('SENSORSDATA HOOK') > -1) {
          return;
        }
        console.log(`found GestureButtons: ${onefile}`);
        // 获取 hook 的代码插入的位置
        var scriptStr = 'this.props.onPress(active);';
        var hookIndex = fileContent.indexOf(scriptStr);
        // 判断文件是否异常，不存在 this.props.onPress(active); 导致无法 hook 点击事件
        if (hookIndex == -1) {
          throw "Can't not find this.props.onPress(active); ";
        }
        // 插入 hook 代码
        var hookedContent = `${fileContent.substring(
          0,
          hookIndex + scriptStr.length,
        )}\n${sensorsdataClickHookCode}\n${fileContent.substring(
          hookIndex + scriptStr.length,
        )}`;
        // 备份目标源文件
        fs.renameSync(
          onefile,
          `${onefile}_sensorsdata_backup`,
        );
        // 重写修改后的文件
        fs.writeFileSync(onefile, hookedContent, 'utf8');
        console.log(`modify GestureButtons succeed`);
      }
    }
  });
};

// hook clickable
sensorsdataHookClickableRN = function (reset = false) {
  RNClickableFiles.forEach(function (onefile) {
    if (fs.existsSync(onefile)) {
      if (reset) {
        // 读取文件内容
        var fileContent = fs.readFileSync(onefile, 'utf8');
        // 未被 hook 过代码，不需要处理
        if (fileContent.indexOf('SENSORSDATA HOOK') == -1) {
          return;
        }
        // 检查备份文件是否存在
        var backFilePath = `${onefile}_sensorsdata_backup`;
        if (!fs.existsSync(backFilePath)) {
          throw `File: ${backFilePath} not found, Please rm -rf node_modules and npm install again`;
        }
        // 将备份文件重命名恢复 + 自动覆盖被 hook 过的同名文件
        fs.renameSync(backFilePath, onefile);
        console.log(`found and reset clickable: ${onefile}`);
      } else {
        // 读取文件内容
        var content = fs.readFileSync(onefile, 'utf8');
        // 已经 hook 过了，不需要再次 hook
        if (content.indexOf('SENSORSDATA HOOK') > -1) {
          return;
        }
        console.log(`found clickable.js: ${onefile}`);
        // 获取 hook 的代码插入的位置
        var objRe = /ReactNativePrivateInterface\.UIManager\.createView\([\s\S]{1,60}\.uiViewClassName,[\s\S]*?\)[,;]/;
        var match = objRe.exec(content);
        if (!match) {
          objRe = /UIManager\.createView\([\s\S]{1,60}\.uiViewClassName,[\s\S]*?\)[,;]/;
          match = objRe.exec(content);
        }
        if (!match) {
          throw "can't inject clickable js";
        }
        var lastParentheses = content.lastIndexOf(')', match.index);
        var nextCommaIndex = content.indexOf(',', match.index);
        if (nextCommaIndex == -1)
          throw "can't inject clickable js, and nextCommaIndex is -1";
        var tagName = lastArgumentName(content, nextCommaIndex).trim();
        var functionBody = `
         var saElement;
         if(typeof internalInstanceHandle !== 'undefined'){
             saElement = internalInstanceHandle;
         }else if(typeof workInProgress !== 'undefined'){
             saElement = workInProgress;
         }else if(typeof thatThis._currentElement !== 'undefined'){
             saElement = thatThis._currentElement;
         }
         var eachProgress = function (workInProgress){
           if(workInProgress == null){
             return;
           }
           var props;
           if(workInProgress.memoizedProps){
             props = workInProgress.memoizedProps;
           }else if(workInProgress.props){
             props = workInProgress.props;
           }
           if(props && props.sensorsdataparams){
             return props.sensorsdataparams;
           }else {
             if(!props ||
                !workInProgress.type ||
                workInProgress.type.displayName === 'TouchableOpacity' ||
                workInProgress.type.displayName === 'TouchableHighlight' ||
                workInProgress.type.displayName === 'TouchableWithoutFeedback'||
                workInProgress.type.displayName === 'TouchableNativeFeedback'||
                workInProgress.type.displayName === 'Pressable'||
                workInProgress.type.name === 'TouchableOpacity' ||
                workInProgress.type.name === 'TouchableHighlight' ||
                workInProgress.type.name === 'TouchableNativeFeedback'||
                workInProgress.type.name === 'TouchableWithoutFeedback'||
                workInProgress.type.displayName === undefined||
                workInProgress.type.name === undefined ||
                !props.onPress){
	                 if(workInProgress.return){
	                   return eachProgress(workInProgress.return);
	                 }else{
	                   if(workInProgress._owner && workInProgress._owner._currentElement){
	                     return eachProgress(workInProgress._owner._currentElement);
	                   }else{
	                     return eachProgress(workInProgress._owner);
	                   }
	                 }
	              }
           }
         };
         var elementProps;
         if(saElement && saElement.memoizedProps){
	        elementProps = saElement.memoizedProps;
	     }else if(saElement && saElement.props){
	        elementProps = saElement.props;
	     }
	     if(elementProps){
	         // iOS 兼容 SegmentedControl 逻辑
	        var isSegmentedControl = (saElement &&
	                                    (saElement.type === 'RNCSegmentedControl' ||
	                                    saElement.type === 'RCTSegmentedControl' ||
	                                    saElement.type.name === 'RNCSegmentedControl' ||
	                                    saElement.type.name === 'RCTSegmentedControl' ||
	                                    saElement.type.displayName === 'RNCSegmentedControl' ||
	                                    saElement.type.displayName === 'RCTSegmentedControl'));
	         if(elementProps.onStartShouldSetResponder || isSegmentedControl) {
		         var saProps = eachProgress(saElement);
		         var ReactNative = require('react-native');
		         var dataModule = ReactNative.NativeModules.RNSensorsDataModule;

             if(dataModule && dataModule.saveRootViewProperties) {
               var saRootTag;
               if(typeof nativeTopRootTag !== 'undefined') {
                 saRootTag = nativeTopRootTag;
               } else if(typeof rootContainerInstance !== 'undefined') {
                 saRootTag = rootContainerInstance;
               } else if(typeof renderExpirationTime !== 'undefined') {
                 saRootTag = renderExpirationTime;
               } else if(typeof renderLanes !== 'undefined') {
                 saRootTag = renderLanes;
               }
               if (saRootTag && (typeof saRootTag === 'number')) {
                 dataModule.saveRootViewProperties(${tagName}, true , saProps, saRootTag);
                 return;
               }
             }  
             dataModule && dataModule.saveViewProperties && dataModule.saveViewProperties(${tagName}, true , saProps);
	     }
     }`;
        var call = addTryCatch(functionBody);
        var lastReturn = content.lastIndexOf('return', match.index);
        var splitIndex = match.index;
        if (lastReturn > lastParentheses) {
          splitIndex = lastReturn;
        }
        var hookedContent = `${content.substring(
          0,
          splitIndex
        )}\n${call}\n${content.substring(splitIndex)}`;

        // 备份源文件
        fs.renameSync(onefile, `${onefile}_sensorsdata_backup`);
        // 重写文件
        fs.writeFileSync(onefile, hookedContent, 'utf8');
        console.log(`modify clickable.js succeed`);
      }
    }
  });
};
// 恢复被 hook 过的代码
sensorsdataResetRN = function (resetFilePath) {
  // 判断需要被恢复的文件是否存在
  if (!fs.existsSync(resetFilePath)) {
    return;
  }
  var fileContent = fs.readFileSync(resetFilePath, 'utf8');
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
  console.log(`found and reset file: ${resetFilePath}`);
};

// 工具函数- add try catch
addTryCatch = function (functionBody) {
  functionBody = functionBody.replace(/this/g, 'thatThis');
  return (
    '(function(thatThis){\n' +
    '    try{\n        ' +
    functionBody +
    "    \n    } catch (error) { throw new Error('SensorsData RN Hook Code 调用异常: ' + error);}\n" +
    '})(this); /* SENSORSDATA HOOK */'
  );
};
// 工具函数 - 计算位置
function lastArgumentName (content, index) {
  --index;
  var lastComma = content.lastIndexOf(',', index);
  var lastParentheses = content.lastIndexOf('(', index);
  var start = Math.max(lastComma, lastParentheses);
  return content.substring(start + 1, index + 1);
}

// hook 代码片段实现 PageView 事件采集;
navigationString3 = function (
  prevStateVarName,
  currentStateVarName,
  actionName
) {
  var script = `
            function $$$getActivePageName$$$(navigationState){
              if(!navigationState)
                return null;
              const route = navigationState.routes[navigationState.index];
              if(route.routes){
                return $$$getActivePageName$$$(route);
              }else{
                var saProperties = {};
                if(route.params) {
                  if(!route.params.sensorsdataurl){
                    saProperties.sensorsdataurl = route.routeName;
                  }else{
                    saProperties.sensorsdataurl = route.params.sensorsdataurl;
                  }
				  if(route.params.sensorsdataparams){
				     saProperties.sensorsdataparams = JSON.parse(JSON.stringify(route.params.sensorsdataparams));
				  }
                } else {
                  saProperties = {sensorsdataurl:route.routeName};
                }
                return saProperties;
              }
            }`;

  if (actionName) {
    script = `
    ${script}
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
    }`;
  }

  script = `
  ${script} var params = $$$getActivePageName$$$(${currentStateVarName});
	      if(${ignoreScreen}){
	          if(params.sensorsdataparams){
	            params.sensorsdataparams.SAIgnoreViewScreen = true;
	          }else{
	            params.sensorsdataparams = {SAIgnoreViewScreen : true};
	          }
          }
    if (require('react-native').Platform.OS === 'android') {
        if (${prevStateVarName}){
            var prevParams = $$$getActivePageName$$$(${prevStateVarName});
            if (params.sensorsdataurl == prevParams.sensorsdataurl){
                  return;
            }
         }
         var ReactNative = require('react-native');
         var dataModule = ReactNative.NativeModules.RNSensorsDataModule;
         dataModule && dataModule.trackViewScreen && dataModule.trackViewScreen(params);
    } else if (require('react-native').Platform.OS === 'ios') {
        if (!${actionName} || iosOnPageShow) {
            var ReactNative = require('react-native');
            var dataModule = ReactNative.NativeModules.RNSensorsDataModule;
            dataModule && dataModule.trackViewScreen && dataModule.trackViewScreen(params);
        }
    }`;
  return script;
};
navigationEventString = function () {
  var script = `if(require('react-native').Platform.OS !== 'ios') {
            return;
          }
          if(payload && payload.state && payload.state.key && payload.state.routeName && payload.state.key != payload.state.routeName) {
            var saProperties = {};
            if(payload.state.params) {
                if(!payload.state.params.sensorsdataurl){
                    saProperties.sensorsdataurl = payload.state.routeName;
                }else{
                    saProperties.sensorsdataurl = payload.state.params.sensorsdataurl;
                }
                if(payload.state.params.sensorsdataparams){
                   saProperties.sensorsdataparams = JSON.parse(JSON.stringify(payload.state.params.sensorsdataparams));
                }
            }else{
                saProperties.sensorsdataurl = payload.state.routeName;
            }
            if(type == 'didFocus') {
			      if(${ignoreScreen}){
			          if(saProperties.sensorsdataparams){
			            saProperties.sensorsdataparams.SAIgnoreViewScreen = true;
			          }else{
			            saProperties.sensorsdataparams = {SAIgnoreViewScreen : true};
			          }
		          }
                 var ReactNative = require('react-native');
                 var dataModule = ReactNative.NativeModules.RNSensorsDataModule;
                 dataModule && dataModule.trackViewScreen && dataModule.trackViewScreen(saProperties);
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
                var saProperties = {};
                if(route.params) {
                  if(!route.params.sensorsdataurl){
                    saProperties.sensorsdataurl = route.routeName;
                  }else{
                    saProperties.sensorsdataurl = route.params.sensorsdataurl;
                  }
				  if(route.params.sensorsdataparams){
				    saProperties.sensorsdataparams = JSON.parse(JSON.stringify(route.params.sensorsdataparams));
				  }
                } else {
                  saProperties.sensorsdataurl = route.routeName;
                }
                return saProperties;
            }
        }`;

  if (actionName) {
    script = `${script}
	  var type = ${actionName}.type;
	  if(type == 'Navigation/SET_PARAMS' || type == 'Navigation/COMPLETE_TRANSITION') {
	        return;
	  }
	  `;
  }

  script = `${script} var params = $$$getActivePageName$$$(${currentStateVarName});
		      if(${ignoreScreen}){
		          if(params.sensorsdataparams){
		            params.sensorsdataparams.SAIgnoreViewScreen = true;
		          }else{
		            params.sensorsdataparams = {SAIgnoreViewScreen : true};
		          }
	          }
            if (require('react-native').Platform.OS === 'android') {
             var ReactNative = require('react-native');
             var dataModule = ReactNative.NativeModules.RNSensorsDataModule;
             dataModule && dataModule.trackViewScreen && dataModule.trackViewScreen(params);}`;
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
      return;
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
      var content = fs.readFileSync(
        createNavigationContainerJsFilePath,
        'utf8'
      );
      // 已经 hook 过了，不需要再次 hook
      if (content.indexOf('SENSORSDATA HOOK') > -1) {
        return;
      }
      console.log(`found navigation.js: ${getChildEventSubscriberJsFilePath}`);
      // 获取 hook 的代码插入的位置
      var index = content.indexOf(
        "if (typeof this.props.onNavigationStateChange === 'function') {"
      );
      if (index == -1) throw 'index is -1';
      content =
        content.substring(0, index) +
        addTryCatch(navigationString('nav', 'action')) +
        '\n' +
        content.substring(index);
      var didMountIndex = content.indexOf('componentDidMount() {');
      if (didMountIndex == -1) throw 'didMountIndex is -1';
      var forEachIndex = content.indexOf(
        'this._actionEventSubscribers.forEach(subscriber =>',
        didMountIndex
      );
      var clojureEnd = content.indexOf(';', forEachIndex);
      // 插入 hook 代码
      content =
        content.substring(0, forEachIndex) +
        '{' +
        addTryCatch(navigationString('this.state.nav', null)) +
        '\n' +
        content.substring(forEachIndex, clojureEnd + 1) +
        '}' +
        content.substring(clojureEnd + 1);
      // 备份 navigation 源文件
      fs.renameSync(
        createNavigationContainerJsFilePath,
        `${createNavigationContainerJsFilePath}_sensorsdata_backup`
      );
      // 重写文件
      fs.writeFileSync(createNavigationContainerJsFilePath, content, 'utf8');

      // common.modifyFile(getChildEventSubscriberJsFilePath, onEventSubscriberTransformer);
      var content = fs.readFileSync(getChildEventSubscriberJsFilePath, 'utf8');
      // 已经 hook 过了，不需要再次 hook
      if (content.indexOf('SENSORSDATA HOOK') > -1) {
        return;
      }
      // 获取 hook 的代码插入的位置
      var script = 'const emit = (type, payload) => {';
      var index = content.indexOf(script);
      if (index == -1) throw 'index is -1';
      content =
        content.substring(0, index + script.length) +
        addTryCatch(navigationEventString()) +
        '\n' +
        content.substring(index + script.length);
      // 备份 navigation 源文件
      fs.renameSync(
        getChildEventSubscriberJsFilePath,
        `${getChildEventSubscriberJsFilePath}_sensorsdata_backup`
      );
      // 重写文件
      fs.writeFileSync(getChildEventSubscriberJsFilePath, content, 'utf8');
      console.log(`modify navigation.js succeed`);
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
      console.log(`found navigation.js: ${createAppContainerJsFilePath}`);
      var index = content.indexOf(
        "if (typeof this.props.onNavigationStateChange === 'function') {"
      );
      if (index == -1) throw 'index is -1';
      content =
        content.substring(0, index) +
        addTryCatch(navigationString3('prevNav', 'nav', 'action')) +
        '\n' +
        content.substring(index);
      var didMountIndex = content.indexOf('componentDidMount() {');
      if (didMountIndex == -1) throw 'didMountIndex is -1';
      var forEachIndex = content.indexOf(
        'this._actionEventSubscribers.forEach(subscriber =>',
        didMountIndex
      );
      if (forEachIndex == -1) {
        forEachIndex = content.indexOf(
          'this._actionEventSubscribers.forEach((subscriber) =>',
          didMountIndex
        );
      }
      var clojureEnd = content.indexOf(';', forEachIndex);
      content =
        content.substring(0, forEachIndex) +
        '{' +
        addTryCatch(navigationString3(null, 'this.state.nav', null)) +
        '\n' +
        content.substring(forEachIndex, clojureEnd + 1) +
        '}' +
        content.substring(clojureEnd + 1);
      // 备份 navigation 源文件
      fs.renameSync(
        createAppContainerJsFilePath,
        `${createAppContainerJsFilePath}_sensorsdata_backup`
      );
      // 重写文件
      fs.writeFileSync(createAppContainerJsFilePath, content, 'utf8');
      console.log(`modify navigation.js succeed`);
    }
  }
};

// hook pageview 文件
sensorsdataHookNavigationRN = function () {
  injectReactNavigation(reactNavigationPath, 1);
  injectReactNavigation(reactNavigationPath3X, 2);
  injectReactNavigation(reactNavigationPath4X, 2);
};

// 恢复被 hook 的 pageview 文件
sensorsdataResetNavigationRN = function () {
  injectReactNavigation(reactNavigationPath, 1, true);
  injectReactNavigation(reactNavigationPath3X, 2, true);
  injectReactNavigation(reactNavigationPath4X, 2, true);
};

// 全部 hook 文件恢复
resetAllSensorsdataHookRN = function () {
  sensorsdataResetRN(RNClickFilePath);
  sensorsdataResetNavigationRN();
  sensorsdataHookClickableRN(true);
  // 2 期
  sensorsdataHookSliderRN(true);
  sensorsdataHookSwitchRN(true);
  sensorsdataHookSegmentedControlRN(true);
  sensorsdataHookGestureButtonsRN(true)
  // 3 期
  sensorsdataResetRN(RNClickPressabilityFilePath);
  sensorsdataResetRN(reactNavigationPath5X);
  // react-navigation-redux-helper
  sensorsdataHookNavigationReduxCreate(true);
  sensorsdataResetRN(reactNavigationReduxMiddlePath);
};
// 全部 hook 文件
allSensorsdataHookRN = function () {
  if (ignoreScreen) {
    console.log('ignore screen');
  }
  if (userPackageJson && userPackageJson['sensorsData']) {
    var sensorsData = userPackageJson['sensorsData'];
    if (sensorsData['ignoreClick']) {
      console.log('ignore click');
    } else {
      sensorsdataHookClickRN(RNClickFilePath);
      sensorsdataHookClickableRN();
      // 2 期
      sensorsdataHookSliderRN();
      sensorsdataHookSwitchRN();
      sensorsdataHookSegmentedControlRN();
      sensorsdataHookGestureButtonsRN(false)
      // 3 期
      sensorsdataHookPressabilityClickRN(RNClickPressabilityFilePath);
    }
  } else {
    sensorsdataHookClickRN(RNClickFilePath);
    sensorsdataHookClickableRN();
    // 2 期
    sensorsdataHookSliderRN();
    sensorsdataHookSwitchRN();
    sensorsdataHookSegmentedControlRN();
    sensorsdataHookGestureButtonsRN(false)
    // 3 期
    sensorsdataHookPressabilityClickRN(RNClickPressabilityFilePath);
  }
  sensorsdataHookNavigationRN();
  sensorsdataHookNavigation5();
  // react-navigation-redux-helper
  sensorsdataHookNavigationReduxCreate();
  sensorsdataHookNavigationReduxMiddle(reactNavigationReduxMiddlePath);
};
// 命令行
switch (process.argv[2]) {
  case '-run':
    resetAllSensorsdataHookRN();
    allSensorsdataHookRN();
    break;
  case '-reset':
    resetAllSensorsdataHookRN();
    break;
  default:
    console.log('can not find this options: ' + process.argv[2]);
}

