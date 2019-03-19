//
//  SetI001ChannelTool.h
//  SetI001
//
//  Created by rxk on 2019/1/17.
//  Copyright © 2019 Tianma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenInstallSDK.h"

/**
 获取渠道商ID
 
 @param channelCode 渠道商ID
 */
typedef void(^TMGetChannelCodeComplate)(NSString *channelCode);

NS_ASSUME_NONNULL_BEGIN

@interface SetI001ChannelTool : NSObject

@property (nonatomic, assign) BOOL isDidLoadComplate;
@property (nonatomic, copy) NSString *channelCode;
@property (nonatomic, copy) NSDictionary *customData;

+ (instancetype)sharedManager;

+ (void)tm_getChannelCodeWithComplate:(nullable TMGetChannelCodeComplate)complate;
@end

NS_ASSUME_NONNULL_END
