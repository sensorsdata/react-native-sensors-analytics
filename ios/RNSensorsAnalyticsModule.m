//
//  RNSensorsAnalyticsModule.m
//  RNSensorsAnalyticsModule
//
//  Created by 肖彦敏 on 2017/4/14.
//  Copyright © 2017-2021 Sensors Data Co., Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#if __has_include(<SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>)
#import <SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>
#else
#import "SensorsAnalyticsSDK.h"
#endif

#import "RNSensorsAnalyticsModule.h"
#import "SAReactNativeManager.h"
#import "SAReactNativeEventProperty.h"

NSString *const kSAReactNativePluginVersion = @"react_native:2.3.4";

@implementation RNSensorsAnalyticsModule

RCT_EXPORT_MODULE(RNSensorsAnalyticsModule)

RCT_EXPORT_METHOD(init:(NSDictionary *)settings){
    @try {
        [SAReactNativeManager configureSDKWithSettings:settings];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 track 方法给 RN 使用.
 *
 * @param event  事件名称
 * @param propertyDict 事件的具体属性
 *
 * RN 中使用示例：
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.track("RN_AddToFav",{"ProductID":123456,"UserLevel":"VIP"})}>
 *     </Button>
 */

RCT_EXPORT_METHOD(track:(NSString *)event withProperties:(NSDictionary *)propertyDict){
    @try {
        NSDictionary *properties = [SAReactNativeEventProperty eventProperties:propertyDict];
        [[SensorsAnalyticsSDK sharedInstance] track:event withProperties:properties];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 trackTimerStart 方法给 RN 使用.
 *
 * 初始化事件的计时器，默认计时单位为秒(计时开始).
 * @param eventName 事件的名称.
 *
 *  RN 中使用示例：（计时器事件名称 viewTimer ）
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.trackTimerStart("viewTimer")}>
 *     </Button>
 */
RCT_EXPORT_METHOD(trackTimerStart:(NSString *)event){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] trackTimerStart:event];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 trackTimerEnd 方法给 RN 使用.
 *
 * 初始化事件的计时器，默认计时单位为秒(计时结束并触发事件).
 * @param eventName 事件的名称.
 *
 *  RN 中使用示例：（计时器事件名称 viewTimer ）
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.trackTimerEnd("viewTimer",{"ProductID":123456,"UserLevel":"VIP"})}>
 *     </Button>
 */
RCT_EXPORT_METHOD(trackTimerEnd:(NSString *)event withProperties:(NSDictionary *)propertyDict){
    @try {
        NSDictionary *properties = [SAReactNativeEventProperty eventProperties:propertyDict];
        [[SensorsAnalyticsSDK sharedInstance] trackTimerEnd:event withProperties:properties];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 clearTrackTimer 方法给 RN 使用.
 * <p>
 * 清除所有事件计时器
 * <p>
 * RN 中使用示例：
 *      <Button
 *                 title="Button"
 *                 onPress={()=>
 *                 RNSensorsAnalyticsModule.clearTrackTimer()}>
 *      </Button>
 */
RCT_EXPORT_METHOD(clearTrackTimer){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] clearTrackTimer];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 trackInstallation 方法给 RN 使用.
 *
 * 用于记录首次安装激活、渠道追踪的事件.
 * @param event  事件名.
 * @param propertyDict 事件属性.
 *
 *  RN 中使用示例：
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            const date = new Date();
 *            this.year = date.getFullYear();
 *            this.month = date.getMonth() + 1;
 *            this.date = date.getDate();
 *            this.hour = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
 *            this.minute = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
 *            this.second = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
 *            var currentTime =  this.year + "-" + this.month + "-" + this.date + " " + this.hour
 *                               + ":" + this.minute + ":" + this.second;
 *            RNSensorsAnalyticsModule.trackInstallation("AppInstall",{"FirstUseTime":currentTime})}>
 *     </Button>
 */
RCT_EXPORT_METHOD(trackInstallation:(NSString *)event withProperties:(NSDictionary *)propertyDict){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] trackInstallation:event withProperties:propertyDict];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 login 方法给 RN 使用.
 *
 * @param loginId 用户唯一下登录ID
 *
 * RN 中使用示例：
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.login("developer@sensorsdata.cn")}>
 *     </Button>
 */
RCT_EXPORT_METHOD(login:(NSString *)loginId){
    @try {
        NSDictionary *properties = [SAReactNativeEventProperty eventProperties:nil];
        [[SensorsAnalyticsSDK sharedInstance] login:loginId withProperties:properties];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 logout 方法给 RN 使用.
 *
 * RN 中使用示例：
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.logout()}>
 *     </Button>
 */
RCT_EXPORT_METHOD(logout){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] logout];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 trackViewScreen 方法给 RN 使用.
 *
 * 此方法用于 RN 中 Tab 切换页面的时候调用，用于记录 $AppViewScreen 事件.
 *
 * @param url        页面的 url  记录到 $url 字段中(如果不需要此属性，可以传 null ).
 * @param properties 页面的属性.
 *
 * 注：为保证记录到的 $AppViewScreen 事件和 Auto Track 采集的一致，
 *    需要传入 $title（页面的title） 、$screen_name （页面的名称，即 包名.类名）字段.
 *
 * RN 中使用示例：
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.trackViewScreen(null,{"$title":"RN主页","$screen_name":"cn.sensorsdata.demo.RNHome"})}>
 *     </Button>
 *
 *
 */
RCT_EXPORT_METHOD(trackViewScreen:(NSString *)url withProperties:(NSDictionary *)properties){
    @try {
        [[SAReactNativeManager sharedInstance] trackViewScreen:url properties:properties autoTrack:NO];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 set 方法给 RN 使用.
 *
 * @param profileDict 用户属性
 *
 * RN 中使用示例：（保存用户的属性 "sex":"男"）
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.set({"sex":"男"})}>
 *     </Button>
 */
RCT_EXPORT_METHOD(set:(NSDictionary *)profileDict){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] set:profileDict];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 profileSet 方法给 RN 使用.
 *
 * @param profileDict 用户属性
 *
 * RN 中使用示例：（保存用户的属性 "sex":"男"）
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.profileSet({"sex":"男"})}>
 *     </Button>
 */
RCT_EXPORT_METHOD(profileSet:(NSDictionary *)profileDict){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] set:profileDict];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 setOnce 方法给 RN 使用.
 *
 * 首次设置用户的一个或多个 Profile.
 * 与set接口不同的是，如果之前存在，则忽略，否则，新创建.
 *
 * @param profileDict 属性列表
 *
 *  RN 中使用示例：（保存用户的属性 "sex":"男"）
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.setOnce({"sex":"男"})}>
 *     </Button>
 */
RCT_EXPORT_METHOD(setOnce:(NSDictionary *)profileDict){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] setOnce:profileDict];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 profileSetOnce 方法给 RN 使用.
 *
 * 首次设置用户的一个或多个 Profile.
 * 与set接口不同的是，如果之前存在，则忽略，否则，新创建.
 *
 * @param profileDict 属性列表
 *
 *  RN 中使用示例：（保存用户的属性 "sex":"男"）
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.profileSetOnce({"sex":"男"})}>
 *     </Button>
 */
RCT_EXPORT_METHOD(profileSetOnce:(NSDictionary *)profileDict){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] setOnce:profileDict];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 unset 方法给 RN 使用.
 * <p>
 * 删除用户的一个 Profile.
 *
 * @param property 属性名称.
 *                 <p>
 *                 RN 中使用示例：
 *                 <Button
 *                 title="Button"
 *                 onPress={()=>
 *                 RNSensorsAnalyticsModule.unset("sex")}>
 *                 </Button>
 */
RCT_EXPORT_METHOD(unset:(NSString *) profile){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] unset:profile];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 profileUnset 方法给 RN 使用.
 * <p>
 * 删除用户的一个 Profile.
 *
 * @param property 属性名称.
 *                 <p>
 *                 RN 中使用示例：
 *                 <Button
 *                 title="Button"
 *                 onPress={()=>
 *                 RNSensorsAnalyticsModule.profileUnset("sex")}>
 *                 </Button>
 */
RCT_EXPORT_METHOD(profileUnset:(NSString *) profile){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] unset:profile];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 increment 方法给 RN 使用.
 *
 * 给一个数值类型的Profile增加一个数值. 只能对数值型属性进行操作，若该属性
 * 未设置，则添加属性并设置默认值为0.
 *
 * @param property 属性名称
 * @param value    属性的值，值的类型只允许为 Number .
 *
 * RN 中使用示例：
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.increment("money",10)}>
 *     </Button>
 */
RCT_EXPORT_METHOD(increment:(NSString *)profile by:(nonnull NSNumber *)amount){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] increment:profile by:amount];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 profileIncrement 方法给 RN 使用.
 *
 * 给一个数值类型的Profile增加一个数值. 只能对数值型属性进行操作，若该属性
 * 未设置，则添加属性并设置默认值为0.
 *
 * @param property 属性名称
 * @param value    属性的值，值的类型只允许为 Number .
 *
 * RN 中使用示例：
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.profileIncrement("money",10)}>
 *     </Button>
 */
RCT_EXPORT_METHOD(profileIncrement:(NSString *)profile by:(nonnull NSNumber *)amount){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] increment:profile by:amount];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 append 方法给 RN 使用.
 * <p>
 * 向一个<code>NSSet</code>类型的value添加一些值
 *
 * @param property 属性名称.
 * @param value    新增的元素.
 *                 <p>
 * RN 中使用示例：
 *      <Button
 *                 title="Button"
 *                 onPress={()=>{
 *                   var list = ["Sicario","Love Letter"];
 *                   RNSensorsAnalyticsModule.append("Move",list);}>
 *     </Button>
 */
RCT_EXPORT_METHOD(append:(NSString *)profile by:(NSArray *)content){
    @try {
        NSSet *setCntent = [NSSet setWithArray:content];
        [[SensorsAnalyticsSDK sharedInstance] append:profile by:setCntent];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 profileAppend 方法给 RN 使用.
 * <p>
 * 向一个<code>NSSet</code>类型的value添加一些值
 *
 * @param property 属性名称.
 * @param value    新增的元素.
 *                 <p>
 * RN 中使用示例：
 *      <Button
 *                 title="Button"
 *                 onPress={()=>{
 *                   var list = ["Sicario","Love Letter"];
 *                   RNSensorsAnalyticsModule.profileAppend("Move",list);}>
 *     </Button>
 */
RCT_EXPORT_METHOD(profileAppend:(NSString *)profile by:(NSArray *)content){
    @try {
        NSSet *setCntent = [NSSet setWithArray:content];
        [[SensorsAnalyticsSDK sharedInstance] append:profile by:setCntent];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 deleteUser 方法给 RN 使用.
 * <p>
 * 删除当前这个用户的所有记录.
 * <p>
 * RN 中使用示例：
 *      <Button
 *                title="Button"
 *                onPress={()=>
 *                RNSensorsAnalyticsModule.deleteUser()}>
 *      </Button>
 */
RCT_EXPORT_METHOD(deleteUser){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] deleteUser];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 profileDelete 方法给 RN 使用.
 * <p>
 * 删除当前这个用户的所有记录.
 * <p>
 * RN 中使用示例：
 *      <Button
 *                title="Button"
 *                onPress={()=>
 *                RNSensorsAnalyticsModule.profileDelete()}>
 *      </Button>
 */
RCT_EXPORT_METHOD(profileDelete){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] deleteUser];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}



/**
 * 导出 clearKeychainData 方法给 RN 使用.
 * <p>
 * 删除当前 keychain记录 .
 * <p>
 * RN 中使用示例：
 *      <Button
 *                title="Button"
 *                onPress={()=>
 *                RNSensorsAnalyticsModule.clearKeychainData()}>
 *      </Button>
 */
RCT_EXPORT_METHOD(clearKeychainData){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] clearKeychainData];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 getDistinctId 方法给 RN 使用.
 * <p>
 * 获取distinctId .
 * <p>
 * RN 中使用示例：
 * var distinctId = RNSensorsAnalyticsModule.getDistinctId();
 */
RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getDistinctId){
    @try {
        NSString *bestId = [SensorsAnalyticsSDK sharedInstance].loginId;
        if (bestId == nil) {
            bestId = [SensorsAnalyticsSDK sharedInstance].distinctId;
        }
        if (bestId == nil) {
            [[SensorsAnalyticsSDK sharedInstance] resetAnonymousId];
            bestId = [SensorsAnalyticsSDK sharedInstance].anonymousId;
        }
        return bestId;
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
        return nil;
    }
    return nil;
}

/**
 * 导出 getDistinctIdPromise 方法给 RN 使用.
 * <p>
 * Promise 方式，获取 distinctId.
 * <p>
 * RN 中使用示例：
 *    async  getDistinctIdPromise() {
 *       var distinctId = await RNSensorsAnalyticsModule.getDistinctIdPromise()
 *    };
 */
RCT_EXPORT_METHOD(getDistinctIdPromise:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
    @try {
        NSString *bestId = [SensorsAnalyticsSDK sharedInstance].loginId;
        if (bestId == nil) {
            bestId = [SensorsAnalyticsSDK sharedInstance].distinctId;
        }
        if (bestId == nil) {
            [[SensorsAnalyticsSDK sharedInstance] resetAnonymousId];
            bestId = [SensorsAnalyticsSDK sharedInstance].anonymousId;
        }
        resolve(bestId);
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 getAnonymousIdPromise 方法给 RN 使用.
 * <p>
 * Promise 方式 getAnonymousId 获取匿名 ID.
 * <p>
 * RN 中使用示例：
 *    async  getAnonymousIdPromise() {
 *       var anonymousId = await RNSensorsAnalyticsModule.getAnonymousIdPromise()
 *    };
 */
RCT_EXPORT_METHOD(getAnonymousIdPromise:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
    @try {
        resolve([SensorsAnalyticsSDK sharedInstance].anonymousId);
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 registerSuperProperties 方法给 RN 使用.
 *
 * @param properties 要设置的公共属性
 *
 * RN 中使用示例：设置公共属性 "Platform":"iOS"）
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.registerSuperProperties({"Platform":"iOS"})}>
 *     </Button>
 */
RCT_EXPORT_METHOD(registerSuperProperties:(NSDictionary *)properties){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:properties];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 unregisterSuperProperty 方法给 RN 使用.
 *
 * @param property 要设置的公共属性
 *
 * RN 中使用示例：（删除公共属性 "Platform"）
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.unregisterSuperProperty("Platform")}>
 *     </Button>
 */
RCT_EXPORT_METHOD(unregisterSuperProperty:(NSString *)property){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] unregisterSuperProperty:property];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 clearSuperProperties 方法给 RN 使用.
 *
 *
 * RN 中使用示例：（删除所有已设置的公共属性）
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.clearSuperProperties()}>
 *     </Button>
 */
RCT_EXPORT_METHOD(clearSuperProperties){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] clearSuperProperties];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 flush 方法给 RN 使用.
 *
 *                   <p>
 *                   RN 中使用示例：（强制发送数据到服务端）
 *                   <Button
 *                   title="Button"
 *                   onPress={()=>
 *                   RNSensorsAnalyticsModule.flush()}>
 *                   </Button>
 */
RCT_EXPORT_METHOD(flush){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] flush];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 deleteAll 方法给 RN 使用.
 *
 *                   <p>
 *                   RN 中使用示例：（删除本地数据库的所有数据！！！请谨慎使用）
 *                   <Button
 *                   title="Button"
 *                   onPress={()=>
 *                   RNSensorsAnalyticsModule.deleteAll()}>
 *                   </Button>
 */
RCT_EXPORT_METHOD(deleteAll){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] deleteAll];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 导出 identify 方法给 RN 使用.
 *
 * @param anonymousId 当前用户的 anonymousId
 *
 *  RN 中使用示例：（在初始化 SDK 之后立即调用，替换神策分析默认分配的 *匿名 ID*）
 *                   <Button
 *                   title="Button"
 *                   onPress={()=>
 *                   RNSensorsAnalyticsModule.identify("AAA")}>
 *                   </Button>
*/
RCT_EXPORT_METHOD(identify:(NSString *)anonymousId) {
    @try {
        [[SensorsAnalyticsSDK sharedInstance] identify:anonymousId];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
暂停事件计时
 * @discussion
 * 多次调用 trackTimerPause: 时，以首次调用为准。
 * @param event 事件名称或事件的 eventId
 *
 * RN 中使用示例：
 *
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.trackTimerPause("event")}>
 *  </Button>
*/
RCT_EXPORT_METHOD(trackTimerPause:(NSString *)event){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] trackTimerPause:event];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
恢复事件计时

@discussion
 * 多次调用 trackTimerResume: 时，以首次调用为准。
 * @param event 事件名称或事件的 eventId
 *
 * RN 中使用示例：
 *
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.trackTimerResume("event")}>
 *  </Button>
*/
RCT_EXPORT_METHOD(trackTimerResume:(NSString *)event){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] trackTimerResume:event];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * @abstract
 * 直接设置用户的pushId
 *
 * @discussion
 * 设置用户的 pushId 比如 @{@"jgId":pushId}，并触发 profileSet 设置对应的用户属性。
 * 当 disctinct_id 或者 pushId 没有发生改变的时,不会触发 profileSet。
 * @param pushTypeKey  pushId 的 key
 * @param pushId  pushId 的值
 *
 *  RN 中使用示例：
 *
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.profilePushId("pushTypeKey", "pushId")}>
 *  </Button>
*/
RCT_EXPORT_METHOD(profilePushId:(NSString *)pushTypeKey pushId:(NSString *)pushId){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] profilePushKey:pushTypeKey pushId:pushId];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * @abstract
 * 删除用户设置的 pushId
 *
 * @discussion
 * 删除用户设置的 pushId 比如 @{@"jgId":pushId}，并触发 profileUnset 删除对应的用户属性。
 * 当 disctinct_id 未找到本地缓存记录时, 不会触发 profileUnset。
 * @param pushTypeKey  pushId 的 key
 *
 *  RN 中使用示例：
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.profileUnsetPushId("pushTypeKey")}>
 *  </Button>
*/
RCT_EXPORT_METHOD(profileUnsetPushId:(NSString *)pushTypeKey) {
    @try {
        [[SensorsAnalyticsSDK sharedInstance] profileUnsetPushKey:pushTypeKey];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * @abstract
 * 重置默认匿名 id
 *
 *  RN 中使用示例：
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.resetAnonymousId()}>
 *  </Button>
*/
RCT_EXPORT_METHOD(resetAnonymousId) {
    @try {
        [[SensorsAnalyticsSDK sharedInstance] resetAnonymousId];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * @abstract
 * 拿到当前的 superProperty 的副本
 *
 * @return 当前的 superProperty 的副本
 *
 *  RN 中使用示例：
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.getSuperPropertiesPromise().then((value) => { // value 为获取到的公共属性  })}>
 *  </Button>
*/
RCT_EXPORT_METHOD(getSuperPropertiesPromise:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    @try {
        NSDictionary *superProperties = [[SensorsAnalyticsSDK sharedInstance] currentSuperProperties];
        resolve(superProperties);
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * @abstract
 * 设置当前 serverUrl
 *
 *  RN 中使用示例：
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.setServerUrl("https://www.sensorsdata.cn") }>
 *  </Button>
*/
RCT_EXPORT_METHOD(setServerUrl:(NSString *)serverUrl) {
    @try {
        [[SensorsAnalyticsSDK sharedInstance] setServerUrl:serverUrl];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
设置 item
 * @param itemType item 类型
 * @param itemId item Id
 * @param propertyDict item 相关属性
 *
 *  RN 中使用示例：
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.itemSet('itemType', 'itemId', { 'key' : 'value' }) }>
 *  </Button>
*/
RCT_EXPORT_METHOD(itemSet:(NSString *)itemType itemId:(NSString *)itemId properties:(nullable NSDictionary <NSString *, id> *)propertyDict) {
    @try {
        [[SensorsAnalyticsSDK sharedInstance] itemSetWithType:itemType itemId:itemId properties:propertyDict];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
删除 item
 *
 * @param itemType item 类型
 * @param itemId item Id
 *
 *  RN 中使用示例：
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.itemDelete('itemType', 'itemId') }>
 *  </Button>
*/
RCT_EXPORT_METHOD(itemDelete:(NSString *)itemType itemId:(NSString *)itemId) {
    @try {
        [[SensorsAnalyticsSDK sharedInstance] itemDeleteWithType:itemType itemId:itemId];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * @abstract
 * 返回预置的属性
 *
 * @return NSDictionary 返回预置的属性
 *
 *  RN 中使用示例：
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.getPresetPropertiesPromise().then((value) => { // value 为获取到的预置属性  }) }>
 *  </Button>
*/
RCT_EXPORT_METHOD(getPresetPropertiesPromise:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    @try {
        NSDictionary *presetProperties = [[SensorsAnalyticsSDK sharedInstance] getPresetProperties];
        resolve(presetProperties);
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 设置 flush 时网络发送策略，默认 3G、4G、WI-FI 环境下都会尝试 flush
 * TYPE_NONE = 0;         //NULL    0
 * TYPE_2G = 1;              // 2G        1
 * TYPE_3G = 1 << 1;     // 3G        2
 * TYPE_4G = 1 << 2;     // 4G        4
 * TYPE_WIFI = 1 << 3;  // WIFI     8
 * TYPE_ALL = 0xFF;     // ALL       255
 * 例：若需要开启 4G WIFI 发送数据，则需要设置 4 + 8 = 12
 *
 *  RN 中使用示例：
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.setFlushNetworkPolicy( 20 ) }>
 *  </Button>
*/
RCT_EXPORT_METHOD(setFlushNetworkPolicy:(NSInteger)networkType) {
    @try {
        [[SensorsAnalyticsSDK sharedInstance] setFlushNetworkPolicy:networkType];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * @abstract
 * 用户登录唯一标识符
 *
 *  RN 中使用示例：
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.getLoginIdPromise().then((value) => { // value 为获取到的登录 ID  }) }>
 *  </Button>
*/
RCT_EXPORT_METHOD(getLoginIdPromise:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    @try {
        resolve([[SensorsAnalyticsSDK sharedInstance] loginId]);
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * @abstract
 * 是否开启 AutoTrack
 *
 * @return YES: 开启 AutoTrack; NO: 关闭 AutoTrack
 *
 *  RN 中使用示例：
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.isAutoTrackEnabledPromise().then((value) => { // value 为获取到的全埋点开启状态  }) }>
 *  </Button>
*/
RCT_EXPORT_METHOD(isAutoTrackEnabledPromise:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    @try {
        resolve(@([[SensorsAnalyticsSDK sharedInstance] isAutoTrackEnabled]));
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 是否开启 可视化全埋点 分析，默认不
 *
 * @return YES/NO
 *
 *  RN 中使用示例：
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.isVisualizedAutoTrackEnabledPromise().then((value) => { // value 为获取到的可视化埋点开启状态  }) }>
 *  </Button>
*/
RCT_EXPORT_METHOD(isVisualizedAutoTrackEnabledPromise:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    @try {
        resolve(@([[SensorsAnalyticsSDK sharedInstance] isVisualizedAutoTrackEnabled]));
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 是否开启点击图
 *
 * @return YES/NO 是否开启了点击图
 *
 *  RN 中使用示例：
 *  <Button
 *  title="Button"
 *  onPress={()=>
 *  RNSensorsAnalyticsModule.isHeatMapEnabledPromise().then((value) => { // value 为获取到的热力图开启状态  }) }>
 *  </Button>
*/
RCT_EXPORT_METHOD(isHeatMapEnabledPromise:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    @try {
        resolve(@([[SensorsAnalyticsSDK sharedInstance] isHeatMapEnabled]));
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * 记录 $AppInstall 事件，用于在 App 首次启动时追踪渠道来源，并设置追踪渠道事件的属性。
 * 这是 Sensors Analytics 进阶功能，请参考文档 https://sensorsdata.cn/manual/track_installation.html
 *
 * @param properties 渠道追踪事件的属性
*/
RCT_EXPORT_METHOD(trackAppInstall:(NSDictionary *)property) {
    @try {
        [[SensorsAnalyticsSDK sharedInstance] trackInstallation:@"$AppInstall" withProperties:property];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * ID-Mapping 3.0 功能下绑定业务 ID 功能
 *
 * @param key 绑定业务 ID 的键名
 * @param value 绑定业务 ID 的键值
 */
RCT_EXPORT_METHOD(bind:(NSString *)key value:(NSString *)value) {
    @try {
        [[SensorsAnalyticsSDK sharedInstance] bind:key value:value];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * ID-Mapping 3.0 功能下解绑业务 ID 功能
 *
 * @param key 解绑业务 ID 的键名
 * @param value 解绑业务 ID 的键值
 */
RCT_EXPORT_METHOD(unbind:(NSString *)key value:(NSString *)value) {
    @try {
        [[SensorsAnalyticsSDK sharedInstance] unbind:key value:value];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}

/**
 * Android Only
 *
 * Android 独有的方法，iOS 添加对应的空实现，避免客户使用 API 时 iOS 报错
 *
*/
RCT_EXPORT_METHOD(setSessionIntervalTime:(NSInteger)interval) {

}

RCT_EXPORT_METHOD(getSessionIntervalTimePromise:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {

}

RCT_EXPORT_METHOD(enableNetworkRequest:(BOOL)enable) {

}

RCT_EXPORT_METHOD(enableDataCollect) {

}

RCT_EXPORT_METHOD(isNetworkRequestEnablePromise:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {

}

@end
