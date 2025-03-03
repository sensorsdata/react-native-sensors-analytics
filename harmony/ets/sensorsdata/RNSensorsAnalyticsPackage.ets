//
// RNSensorsAnalyticsPackage
// RNSensorsAnalyticsModule
//
// Created by chuqiangsheng on 2025/02/18.
// Copyright © 2015-2025 Sensors Data Co., Ltd. All rights reserved.
//


import { RNPackage, TurboModulesFactory } from '@rnoh/react-native-openharmony/ts';
import type {
  TurboModule,
  TurboModuleContext
} from '@rnoh/react-native-openharmony/ts';
import { SA } from './NativeSensorsAnalyticsModule';

import { RNSensorsAnalyticsModule } from './RNSensorsAnalyticsModule';

class GeneratedTurboModulesFactory extends TurboModulesFactory {
  createTurboModule(name: string): TurboModule | null {
    if (name === SA.NativeSensorsAnalyticsModule.NAME) {
      return new RNSensorsAnalyticsModule(this.ctx);
    }
    return null;
  }
  hasTurboModule(name: string): boolean {
    return name === SA.NativeSensorsAnalyticsModule.NAME;
  }
}
export class RNSensorsAnalyticsPackage extends RNPackage {
  createTurboModulesFactory(ctx: TurboModuleContext): TurboModulesFactory {
    return new GeneratedTurboModulesFactory(ctx);
  }
}