//
//  RNSensorsDataModule.h
//  RNSensorsAnalyticsModule
//
//  Created by 彭远洋 on 2020/4/3.
//  Copyright © 2020 ziven.mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface RNSensorsDataModule : NSObject <RCTBridgeModule>

@end

NS_ASSUME_NONNULL_END
