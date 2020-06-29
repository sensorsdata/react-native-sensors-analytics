//
//  SAReactNativeSwizzler.h
//  RNSensorsAnalyticsModule
//
//  Created by 彭远洋 on 2020/5/14.
//  Copyright © 2020 ziven.mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SAReactNativeSwizzler)

+ (BOOL)sa_reactnative_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_;
+ (BOOL)sa_reactnative_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError **)error_;

@end

NS_ASSUME_NONNULL_END
