//
//  TMHttpUser.h
//  CordovaLib
//
//  Created by ZhouYou on 2018/1/9.
//

#import <Foundation/Foundation.h>
#import "TMHttpDefine.h"
#import "TMHttpUserInstance.h"

@interface TMHttpUser : NSObject

/*
 获取saveToken保存的token
 */
+ (NSString *)token;

@end
