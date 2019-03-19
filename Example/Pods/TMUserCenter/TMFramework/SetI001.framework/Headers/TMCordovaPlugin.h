//
//  TMCordovaPlugin.h
//  SetI001
//
//  Created by rxk on 2018/12/6.
//  Copyright © 2018年 Tianma. All rights reserved.
//

#import <TMSDK/TMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMCordovaPlugin : CDVPlugin

/**
 获取会员信息

 @param command command
 */
- (void)tm_getMemberInfo:(CDVInvokedUrlCommand *)command;

/**
 获取工程配置

 @param command command
 */
- (void)tm_getProjectConfig:(CDVInvokedUrlCommand *)command;

- (void)tm_checkLogin:(CDVInvokedUrlCommand *)command;

- (void)tm_jumpLoginPage:(CDVInvokedUrlCommand *)command;
- (void)tm_logOut:(CDVInvokedUrlCommand *)command;
- (void)tm_jumpBindPhonePage:(CDVInvokedUrlCommand *)command;
- (void)tm_jumpUserCenter:(CDVInvokedUrlCommand *)command;

- (void)tm_shareImage:(CDVInvokedUrlCommand *)command;
- (void)tm_shareImageText:(CDVInvokedUrlCommand *)command;

- (void)tm_getLocationInfo:(CDVInvokedUrlCommand *)command;

@end

NS_ASSUME_NONNULL_END
