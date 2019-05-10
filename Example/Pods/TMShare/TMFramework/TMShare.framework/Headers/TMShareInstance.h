//
//  TMShareInstance.h
//  UMSocialDemo
//
//  Created by ZhouYou on 2018/2/8.
//  Copyright © 2018年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMUser.h"


/**
 *  平台类型
 */
typedef NS_ENUM(NSUInteger, TMPlatformType)
{
    /**
     * QQ
     */
    TMPlatformTypeQQ      = 1,
    /**
     *  微信
     */
    TMPlatformTypeWechat    = 2,
    /**
     *  微博
     */
    TMPlatformTypeSina   = 3,
    /**
     *  未知
     */
    TMPlatformTypeNoKnow = 4,
    
};

/**
 *  分享结果
 */
typedef NS_ENUM(NSUInteger, TMResultState){
    
    /**
     *  未知
     */
    TMResultStateNoKnow     = 0,
    
    /**
     *  成功
     */
    TMResultStateSuccess    = 1,
    
    /**
     *  失败
     */
    TMResultStateFail       = 2,
    
    /**
     *  取消
     */
    TMResultStateCancel     = 3,
};

typedef void(^TMShareComplete)(id data, NSError *error);
typedef void(^TMloginComplate)(TMUser *user, BOOL isCancel, NSError *error);

typedef void(^TM_ShareComplete)(TMResultState resultState, TMPlatformType platformType, NSError *error);


@class UIViewController;
@interface TMShareInstance : NSObject

+ (TMShareInstance *)instance;
+ (instancetype)sharedManager;//建议舍弃


//已舍弃
- (void)configWith:(id)config;
/*
 webLink   分享的web地址（可为空）
 thumb     缩略图（可为空）
 title     标题（因各三方平台限制，最多分享30个字符，超出部分将被截断）（可为空）
 des       描述（因各三方平台限制，最多分享40个字符，超出部分将被截断）（可为空）
 currentController  当前页面Controller（仅在ipad平台使用，iPhone可为空）
 complete   回调
 
 当以上参数都为空时，默认分享APP Icon
 */
- (void)showShare:(NSString *)webLink
         thumbUrl:(id)thumb
            title:(NSString *)title
            descr:(NSString *)des
currentController:(UIViewController *)currentController
           finish:(TMShareComplete)complete;
    
- (void)tm_showShare:(NSString *)webLink
         thumbUrl:(id)thumb
            title:(NSString *)title
            descr:(NSString *)des
currentController:(UIViewController *)currentController
           finish:(TM_ShareComplete)complete;
    

/**
 分享图片

 @param image 图片对象：包含url或者UIImage对象两种形式，如果为空，则默认分享APP Icon
 @param complate 分享结果回调
 */
- (void)tm_showShareWithImage:(id)image
                       finish:(TM_ShareComplete)complate;


/*
第三方登录
platformType  1 QQ  2 微信 3 新浪微博
resultBlock  回调
*/
- (void)thirdLoginWithPlatform:(TMPlatformType)platformType  resultBlock:(TMloginComplate)resultBlock;

- (void)cancelThirdLogin;

/**
 *  是否安装客户端（支持平台：微博、微信、QQ）
 *
 *  @param platformType 平台类型
 *
 *  @return YES 已安装，NO 尚未安装
 */
- (BOOL)tm_isClientInstalled:(TMPlatformType)platformType;

/**
 是否有对应平台key

 @param platformType 平台类型
 @return YES 有对应key  NO 无对应key
 */
- (BOOL)tm_isHasAppKey:(TMPlatformType)platformType;
/**
 *  取消分享平台授权
 *
 *  @param platformType  平台类型
 */
- (void)tm_cancelAuthorize:(TMPlatformType)platformType;


@end
