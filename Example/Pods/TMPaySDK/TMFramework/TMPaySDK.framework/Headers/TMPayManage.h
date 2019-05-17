//
//  TMPayManage.h
//  TMPayDemo
//
//  Created by rxk on 2018/11/13.
//  Copyright © 2018年 Tianma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMPayDefine.h"

/**
 返回订单数据

 @param orderInfo 订单数据
 @param error 错误信息
 */
typedef void(^TMReturnOrderInfo)(id orderInfo, NSError *error);

/**
 选择支付回调

 @param payType 支付方式
 @param orderInfoComplate 根据支付方式，从后台回去订单签名数据后回传订单数据
 */
typedef void(^SelectPayMethod)(TMPayType payType, TMReturnOrderInfo orderInfoComplate);


/**
 支付结果回调

 @param rawData 支付原始数据
 @param message 支付结果描述
 @param payStatus 支付结果状态
 */
typedef void(^PayComplate)(NSDictionary *rawData, NSString *message, TMPayStatus payStatus);
NS_ASSUME_NONNULL_BEGIN


@interface TMPayManage : NSObject

/**
 发起支付

 @param paymethod 选择支付方式
 @param paycomplate 支付结果回调
 */
+ (void)tm_startPayWithSelectPayMethod:(SelectPayMethod)paymethod
                         onPayComplate:(PayComplate)paycomplate;


@end

NS_ASSUME_NONNULL_END
