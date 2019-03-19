//
//  SetI001AddPhoneController.h
//  SetI001
//
//  Created by rxk on 2018/8/22.
//  Copyright © 2018年 Tianma. All rights reserved.
//

#import <TMSDK/TMSDK.h>

@interface SetI001AddPhoneController : TMViewController
@property (nonatomic, copy) void(^completeHander)(NSString *);
@end
