//
//  TMCertificateConfig.h
//  SetI001
//
//  Created by rxk on 2018/12/19.
//  Copyright © 2018年 Tianma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
//#import "AFNetworking.h"
NS_ASSUME_NONNULL_BEGIN


@interface TMCertificateConfig : NSObject

/**
 是否是https请求
 */
@property (nonatomic, assign, readonly) BOOL isHttpsRequest;

/**
 https证书类型
 */
@property (nonatomic, assign, readonly) AFSSLPinningMode pinningMode;

/**
 https证书数据
 */
@property (nonatomic, strong, readonly) NSData *certificateData;

/**
 https证书key
 */
@property (nonatomic, strong, readonly) NSString *certificateKey;

/**
 是否允许无效证书
 */
@property (nonatomic, assign, readonly) BOOL allowInvalidCertificates;

/**
 是否需要验证域名
 */
@property (nonatomic, assign, readonly) BOOL validatesDomainName;

+ (TMCertificateConfig *)instance;
@end

NS_ASSUME_NONNULL_END
