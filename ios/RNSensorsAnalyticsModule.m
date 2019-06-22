//
//  RNSensorsAnalyticsModule.m
//  RNSensorsAnalyticsModule
//
//  Created by 肖彦敏 on 2017/4/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RNSensorsAnalyticsModule.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "SensorsAnalyticsSDK.h"

@implementation RNSensorsAnalyticsModule

RCT_EXPORT_MODULE(RNSensorsAnalyticsModule)

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
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:propertyDict];
        [propertyDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSArray.class]) {
                [mutDict setObject:[NSSet setWithArray:obj] forKey:key];
            }
        }];
        [[SensorsAnalyticsSDK sharedInstance] track:event withProperties:mutDict];
    } @catch (NSException *exception) {
        NSLog(@"[RNSensorsAnalytics] error:%@",exception);
    }
}
/**
 * 导出 trackTimerBegin 方法给 RN 使用.
 *
 * 初始化事件的计时器，默认计时单位为毫秒(计时开始).
 * @param eventName 事件的名称.
 *
 *  RN 中使用示例：（计时器事件名称 viewTimer ）
 *     <Button
 *            title="Button"
 *            onPress={()=>
 *            RNSensorsAnalyticsModule.trackTimerBegin("viewTimer")}>
 *     </Button>
 */
RCT_EXPORT_METHOD(trackTimerBegin:(NSString *)event){
    @try {
        [[SensorsAnalyticsSDK sharedInstance] trackTimerBegin:event];
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
        [[SensorsAnalyticsSDK sharedInstance] trackTimerEnd:event withProperties:propertyDict];
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
        [[SensorsAnalyticsSDK sharedInstance] login:loginId];
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
        [[SensorsAnalyticsSDK sharedInstance] trackViewScreen:url withProperties:properties];
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
        [[[SensorsAnalyticsSDK sharedInstance] people] set:profileDict];
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
        [[[SensorsAnalyticsSDK sharedInstance] people] set:profileDict];
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
        [[[SensorsAnalyticsSDK sharedInstance] people] setOnce:profileDict];
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
        [[[SensorsAnalyticsSDK sharedInstance] people] setOnce:profileDict];
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
        [[[SensorsAnalyticsSDK sharedInstance] people] unset:profile];
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
        [[[SensorsAnalyticsSDK sharedInstance] people] unset:profile];
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
RCT_EXPORT_METHOD(increment:(NSString *)profile by:(NSNumber *)amount){
    @try {
        [[[SensorsAnalyticsSDK sharedInstance] people] increment:profile by:amount];
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
RCT_EXPORT_METHOD(profileIncrement:(NSString *)profile by:(NSNumber *)amount){
    @try {
        [[[SensorsAnalyticsSDK sharedInstance] people] increment:profile by:amount];
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
        [[[SensorsAnalyticsSDK sharedInstance] people] append:profile by:setCntent];
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
        [[[SensorsAnalyticsSDK sharedInstance] people] append:profile by:setCntent];
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
        [[[SensorsAnalyticsSDK sharedInstance] people] deleteUser];
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
        [[[SensorsAnalyticsSDK sharedInstance] people] deleteUser];
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

@end

