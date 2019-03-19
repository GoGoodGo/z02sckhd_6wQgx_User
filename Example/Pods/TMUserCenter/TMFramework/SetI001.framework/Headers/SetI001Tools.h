//
//  SetI001Tools.h
//  SetI001
//
//  Created by rxk on 2018/10/24.
//  Copyright © 2018年 Tianma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN
/**
 跳转页面完成回调

 @param isSuccess 是否成功跳转
 @param message 提示信息
 */
typedef void(^TMJumpPageComplate)(BOOL isSuccess, NSString *message);

@interface SetI001Tools : NSObject
+ (void)changePointWithKey:(NSString *)key value:(NSString *)value;

/**
 检查是否登录

 @return 返回是否登录，如果登录返回YES，如果未登录返回NO。
 */
+ (BOOL)tm_checkIsLogin;

/**
 跳转到登录页面

 @param controller 当前页面的控制器
 */
+ (void)tm_jumpLoginPageWithCurrentPageController:(UIViewController *)controller;
/**
 跳转到登录页面
 
 @param title 跳转到登录页面时弹框显示的title
 @param message 跳转到登录页面时弹框显示的描述
 @param controller 当前页面的控制器
 @param jumpComplate 页面跳转回调
 */
+ (void)tm_jumpLoginPageWithShowTitle:(NSString *)title message:(NSString *)message currentPageController:(UIViewController *)controller jumpComplate:(TMJumpPageComplate)jumpComplate;
/**
 跳转到绑定手机号页面
 
 @param controller 当前页面的控制器
 */
+ (void)tm_jumpBindPhonePageWithCurrentPageController:(UIViewController *)controller;

/**
 跳转到绑定手机号页面

 @param title 跳转到绑定手机号页面时弹框显示的title
 @param message 跳转到绑定手机号页面时弹框显示的描述
 @param controller 当前页面的控制器
 @param jumpComplate 页面跳转回调
 */
+ (void)tm_jumpBindPhonePageWithShowTitle:(NSString *)title message:(NSString *)message currentPageController:(UIViewController *)controller jumpComplate:(TMJumpPageComplate)jumpComplate;

/**
 将颜色转换为16进制色值

 @param color 颜色
 @return 16进制色值
 */
+ (NSString*)tm_toStrByUIColor:(UIColor*)color;

/**
 退出
 */
+ (void)tm_logOut;

+ (BOOL)tm_userCenter_isPhoneX;
+ (CGFloat)tm_userCenter_bottomSafeArea;


@end

NS_ASSUME_NONNULL_END
