//
//  TMEncryptionTool.h
//  SetI001
//
//  Created by rxk on 2018/12/20.
//  Copyright © 2018年 Tianma. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMEncryptionTool : NSObject

/**
 是否加密头文件，默认为YES，如无特殊需求，不建议修改
 */
@property (nonatomic, assign) BOOL isEncryptionHead;

/**
 加密头文件
 */
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSString *> * encryptHeader;



/**
 生成加密请求头
 该加密请求头会用在请求头里和加解密,如无特殊需求，不必调用该方法
 
 @param isEncryption 请求头是否加解密，如果没有特殊需求，请传入YES
 */
- (void)tm_generateGloadHeaderWithIsEncryption:(BOOL)isEncryption;

/**
 利用加密头文件进行加密
 
 @param content 需要加密的内容
 @return 返回加密后的内容,如果返回nil表示加密失败
 */
- (NSString *)tm_encryptionWithContent:(NSString *)content;

/**
 利用加密头文件进行解密
 
 @param content 需要解密的内容
 @return 返回解密后的内容，如果返回nil表示解密失败
 */
- (NSString *)tm_decryptionWithContent:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
