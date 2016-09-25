//
//  VDUrlObject.h
//  chatDemo
//
//  Created by Donald on 16/9/10.
//  Copyright © 2016年 123. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPPUrlHttp @"http://www.popoteam.com:8080/"
//#define kPPUrlHttp @"http://192.168.3.170:8080/"
#pragma mark - user module
//登录
#define KPPUrlLogin [NSString stringWithFormat:@"%@app/user/login",kPPUrlHttp]
// 密码重置
#define KPPUrlResetPassWord [NSString stringWithFormat:@"%@app/user/resetPassword",kPPUrlHttp]
//注册
#define kPPUrlRegister [NSString stringWithFormat:@"%@app/user/register",kPPUrlHttp]
//密码更新
#define kPPUrlUpdatePassWord [NSString stringWithFormat:@"%@app/user/updatePassword",kPPUrlHttp]
//getInfo
// 获取个人信息
#define kPPUrlGetInfo  [NSString stringWithFormat:@"%@app/user/getInfo",kPPUrlHttp]

//bindPhone
/**绑定手机号*/
#define kPPUrlBindPhone [NSString stringWithFormat:@"%@app/user/bindPhone",kPPUrlHttp]
//bindWeChat
#define kPPUrlBindWeChat [NSString stringWithFormat:@"%@app/user/bindWeChat",kPPUrlHttp]

#define kPPUrlSearchUsers [NSString stringWithFormat:@"%@app/user/search",kPPUrlHttp]

#define kPPUrlSendSms [NSString stringWithFormat:@"%@app/sms/send",kPPUrlHttp]

#define kPPUrlSearchMyListFriends [NSString stringWithFormat:@"%@app/friend/search",kPPUrlHttp]

@interface VDUrlObject : NSObject

@end
