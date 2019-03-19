//
//  TMBaseNetworking.h
//  SetI001
//
//  Created by rxk on 2018/11/30.
//  Copyright © 2018年 Tianma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMEncryptionTool.h"


NS_ASSUME_NONNULL_BEGIN
@protocol AFMultipartFormData;

/**
 http请求类型

 - TMRequestMethodGET: GET请求
 - TMRequestMethodPOST: POST请求
 */
typedef NS_ENUM(NSInteger, TMRequestMethod) {
    TMRequestMethodGET = 0,
    TMRequestMethodPOST
};


/**
 请求序列化

 - TMRequestSerializerTypeHTTP: 二进制
 - TMRequestSerializerTypeJSON: json
 */
typedef NS_ENUM(NSInteger, TMRequestSerializerType) {
    TMRequestSerializerTypeHTTP = 0,
    TMRequestSerializerTypeJSON
};



/**
  响应序列化

 - TMResponseSerializerTypeHTTP: 二进制
 - TMResponseSerializerTypeJSON: json
 - TMResponseSerializerTypeXMLParser: xml
 */
typedef NS_ENUM(NSInteger, TMResponseSerializerType) {
    TMResponseSerializerTypeHTTP = 0,
    TMResponseSerializerTypeJSON,
    TMResponseSerializerTypeXMLParser
};

/*!
 *  请求封装的Block回调
 */
typedef void(^TMRequestSuccessBlock)(id data, TMEncryptionTool *encryptionTool);
typedef void(^TMRequestFailureBlock)(NSString *error, id data);

typedef void(^AFURLSessionTaskProgressBlock)(NSProgress *progress);
typedef void(^AFConstructingBodyBlock)(id<AFMultipartFormData> data);

@interface TMBaseNetworking : NSObject
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSURLSessionTask *requestTask;
@property (nonatomic, assign) BOOL showHUD;

@property (nonatomic, copy, nullable) AFConstructingBodyBlock constructingBodyBlock;

@property (nonatomic, copy, nullable) AFURLSessionTaskProgressBlock uploadProgress;

@property (nonatomic, copy, nullable) TMRequestSuccessBlock successBlock;
@property (nonatomic, copy, nullable) TMRequestFailureBlock failureBlock;


/**
 请求参数
 */
@property (nonatomic, strong) NSDictionary *requestArguments;

/**
 请求方法,(默认为GET)
 */
@property (nonatomic, assign) TMRequestMethod requestMethod;

/**
 超时时间，默认为10s
 */
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;




/**
 请求序列，默认为：TMRequestSerializerTypeJSON
 */
@property (nonatomic, assign) TMRequestSerializerType requestSerializerType;

/**
 响应序列， 默认为：TMResponseSerializerTypeJSON
 */
@property (nonatomic, assign) TMResponseSerializerType responseSerializerType;

/**
 请求URL路径
 */
@property (nonatomic, strong) NSString *requestURLPath;

/**
 请求头
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * requestHeaderFieldValueDictionary;

/**
 加密请求工具
 */
@property (nonatomic, strong) TMEncryptionTool *encryptionTool;


- (instancetype)initWithSuccessBlock:(TMRequestSuccessBlock)successBlock
                        failureBlock:(TMRequestFailureBlock)failureBlock;

+ (instancetype)requestWithSuccessBlock:(TMRequestSuccessBlock)successBlock
                           failureBlock:(TMRequestFailureBlock)failureBlock;

- (void)startCompletionBlockWithSuccess:(TMRequestSuccessBlock)success
                                failure:(TMRequestFailureBlock)failure;


/**
 * @brief 开始请求
 */
- (void)startRequest;





/**
 post请求

 @param urlString 请求地址
 @param paraments 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 @return 请求工具类
 */
+(TMBaseNetworking *)tm_postWithUrlString:(NSString *)urlString
                            withParaments:(nullable id)paraments
                         withSuccessBlock:( TMRequestSuccessBlock)successBlock
                         withFailureBlock:( TMRequestFailureBlock)failureBlock;
/**
 get请求
 
 @param urlString 请求地址
 @param paraments 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 @return 请求工具类
 */
+(TMBaseNetworking *)tm_getWithUrlString:(NSString *)urlString
                           withParaments:(nullable id)paraments
                        withSuccessBlock:( TMRequestSuccessBlock)successBlock
                        withFailureBlock:( TMRequestFailureBlock)failureBlock;


/**
 post请求

 @param urlString 请求地址
 @param paraments 请求参数
 @param encryptionTool 加密工具，其中涉及加密参数及加密请求头。如果没有特殊需求请传入空，工具类会按照默认处理。
 @param successBlock 成功回调
 @param failureBlock 失败回调
 @return 请求工具类
 */
+(TMBaseNetworking *)tm_postWithUrlString:(NSString *)urlString
                            withParaments:(nullable id)paraments
                           encryptionTool:(nullable TMEncryptionTool *)encryptionTool
                         withSuccessBlock:( TMRequestSuccessBlock)successBlock
                         withFailureBlock:( TMRequestFailureBlock)failureBlock;
/**
 get请求
 
 @param urlString 请求地址
 @param paraments 请求参数
 @param encryptionTool 加密工具，其中涉及加密参数及加密请求头。如果没有特殊需求请传入空，工具类会按照默认处理。
 @param successBlock 成功回调
 @param failureBlock 失败回调
 @return 请求工具类
 */
+(TMBaseNetworking *)tm_getWithUrlString:(NSString *)urlString
                           withParaments:(nullable id)paraments
                          encryptionTool:(nullable TMEncryptionTool *)encryptionTool
                        withSuccessBlock:( TMRequestSuccessBlock)successBlock
                        withFailureBlock:( TMRequestFailureBlock)failureBlock;

@end


NS_ASSUME_NONNULL_END
