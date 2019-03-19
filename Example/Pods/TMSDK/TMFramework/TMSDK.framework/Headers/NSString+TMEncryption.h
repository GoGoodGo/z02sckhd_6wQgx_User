//
//  NSString+TMEncryption.h
//  SetI001
//
//  Created by rxk on 2018/11/30.
//  Copyright © 2018年 Tianma. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TMEncryption)

/**
 md5加密

 @return 加密后的字符串
 */
- (NSString *)tm_md5;

/**
 *  转换为Base64编码
 */
- (NSString *)tm_base64EncodedString;
/**
 *  将Base64编码还原
 */
- (NSString *)tm_base64DecodedString;



/**
 生成指定长度随机字符串

 @param length 字符串长度
 @return 返回生成的随机字符串
 */
+ (NSString *)tm_returnLetterAndNumberWithLength:(NSInteger)length;

/**
 字典转json字符串

 @param dict 待转换字典
 @return json字符串
 */
+ (NSString *)tm_convertToJsonData:(NSDictionary *)dict;

/**
 json字符串转换字典

 @param jsonString 待转换字符串
 @return 字典
 */
+ (NSDictionary *)tm_dictionaryWithJsonString:(NSString *)jsonString;



@end

NS_ASSUME_NONNULL_END
