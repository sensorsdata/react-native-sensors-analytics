//
// SAReactNativeManager
// SAReactNativeUtils
//
// Created by chuqiangsheng on 2025/02/18.
// Copyright © 2015-2025 Sensors Data Co., Ltd. All rights reserved.
//
// import { SAAutoTrackType } from "@sensorsdata/analytics";

export class SAReactNativeUtils extends Object {
  /**
   * 将 RN 传入的全埋点配置，拆分成鸿蒙接口的枚举集合
   * @param num RN 全埋点配置
   * @returns harmonyOS 全埋点配置
   */
  // static convertToAutoTrackSet(num: number): Set<SAAutoTrackType> {
  //   const set = new Set<SAAutoTrackType>();
  //   const enumValues = Object.values(SAAutoTrackType)
  //     .filter(v => typeof v === 'number') as number[];
  //
  //   for (const value of enumValues) {
  //     if (num & value) {
  //       set.add(value as SAAutoTrackType);
  //     }
  //   }
  //   return set;
  // }


  /**
   * 追加 object 中所有 key-value
   *
   * @param obj1 原始 object，如果包含需要追加的 key，则会被覆盖
   * @param obj2 需要追加内容的 object
   */
  static addEntriesFromObject(obj1: object, obj2: object) {
    if (Object.keys(obj2).length === 0) {
      return;
    }

    // 获取 JavaScript 对象的所有属性，并遍历添加到原始对象中
    Object.keys(obj2).forEach((key) => {
      obj1[key] = obj2[key];
    });
  }

  /**
   * 判断对象是否为空
   * @param obj 需要判断的 jsonObject 对象
   * @returns 是否为空
   */
  static isEmpty(obj: object): boolean {
    if (obj === null || obj === undefined || Object.keys(obj).length === 0) {
      return true;
    }
    return false;
  }
}