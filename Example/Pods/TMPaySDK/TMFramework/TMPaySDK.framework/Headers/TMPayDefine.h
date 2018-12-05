//
//  TMPayDefine.h
//  TMPayDemo
//
//  Created by rxk on 2018/11/13.
//  Copyright © 2018年 Tianma. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 天马支付类型

 - TMPayTypeWeChat: 微信支付
 - TMPayTypeAliPay: 支付宝支付
 */
typedef NS_ENUM(NSUInteger, TMPayType) {
    TMPayTypeAliPay = 1,
    TMPayTypeWeChat

};

/**
 天马支付状态

 - TMPayStatusSuccess: 支付成功
 - TMPayStatusFail: 支付失败
 - TMPayStatusNoKnow: 未知，需要和服务端再次确认
 */
typedef NS_ENUM(NSUInteger, TMPayStatus) {
    TMPayStatusSuccess = 1,
    TMPayStatusFail,
    TMPayStatusNoKnow
};

