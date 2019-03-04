//
//  TMPayUtils.h
//  TMPayDemo
//
//  Created by rxk on 2018/11/12.
//  Copyright © 2018年 Tianma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMPayDefine.h"

/**
 支付完成回调

 @param payStatus 支付状态
 @param rawData 原始数据
 @param message msg
 */
typedef void(^TMPayFinish)(TMPayStatus payStatus, id rawData, NSString *message);

/**
 获取支持的支付平台

 @param payPlatforms 支付平台数组
 @param errorInfo 错误信息，如果不为nil，表示获取支持的支付平台错误或者暂无支持支付的平台
 */
typedef void(^TMPayPlatform)(NSArray *payPlatforms, NSString *errorInfo);
NS_ASSUME_NONNULL_BEGIN

@interface TMPayUtils : NSObject
+ (instancetype)sharedInstance;

/**
 获取支持的支付平台

 @param payplatforms 平台回调
 */
- (void)tm_getPayPlatform:(TMPayPlatform)payplatforms;

/**
 发起支付

 @param orderData 订单数据
 @param type 支付类型
 @param payFinishBlock 支付结果
 */
- (void)tm_payWithOrderData:(id)orderData type:(TMPayType )type payFinishBlock:(TMPayFinish)payFinishBlock;

/**
 处理支付回调

 @param url 回调地址
 @param options 回调参数
 */
- (void)tm_handlePayResultWithOpenURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;



@end

NS_ASSUME_NONNULL_END
