//
//  VDRequestEngine.m
//  chatDemo
//
//  Created by Donald on 16/9/10.
//  Copyright © 2016年 123. All rights reserved.
//

#import "VDRequestEngine.h"
#import "VDHTTPRequestOperationManager.h"
#import "VDHttpResponse.h"

@implementation VDRequestEngine
+ (instancetype)shareEngine
{
    static VDRequestEngine * engine;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        engine = [VDRequestEngine new];
    });
    return engine;
}
- (void)saveUserInfoPrivateInfoAccount:(NSString *)account token:(NSString *)tokenString
{
    [SFHFKeychainUtils storeUsername:account andPassword:tokenString forServiceName:VDServiceName updateExisting:YES error:nil];
    
    
}
- (void)_completeWithResponse:(VDHttpResponse *)aResponse block:(PPResponseBlock())aResponseBlock
{
    if (aResponseBlock) {
        aResponseBlock(aResponse);
    }
}
- (void)requsetLoginResonse:(PPResponseBlock())responseBlock Account:(NSString *)account passWord:(NSString *)pasWord
{
    VDHTTPRequestOperationManager * manager = [VDHTTPRequestOperationManager manager];
    NSDictionary * dict = @{@"account":[@"+86" stringByAppendingString: account],@"password":pasWord,@"type":@"1",@"device":@"1"};
    [manager GET:KPPUrlLogin parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError * error;
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        VDLoginResponse * info = [[VDLoginResponse alloc]initWithData:responseObject error:&error];
       
        info = [[VDLoginResponse alloc]initWithDictionary:dict error:&error];
        if(info.code.integerValue == kppRequestSucessCode)
        {
             [[VDUserInfoEngine shareEngine]saveUserInfo:info.object];
            [VDUserInfoEngine shareEngine].token = info.authorization.token;
            
            [self saveUserInfoPrivateInfoAccount:info.authorization.account token:info.authorization.token];
            [self requestGetFriendsList:^(VDHttpResponse * response) {
                NSLog(@"response == %@",response);
                
            } methodType:2 orderByFirstLetter:YES page:1 size:20 identfify:nil];
            
           
            VDImUser * user = info.object.imUser;
            
            [[RJChatTools shareManager] login:user.userName andPassword:user.password];
        }
        [self _completeWithResponse:info block:responseBlock];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        VDHttpResponse * response = [VDHttpResponse responseWithError:error];
      [self _completeWithResponse:response block:responseBlock];
    }];
}

- (void)requestResetPassWordResponse:(PPResponseBlock())responseBlock Account:(NSString *)account passWord:(NSString *)pasWord Code:(NSString *)code
{
    VDHTTPRequestOperationManager * manager = [VDHTTPRequestOperationManager manager];
    NSDictionary * dict = @{@"account":[@"+86" stringByAppendingString: account],@"password":pasWord,@"code":code};
    
    [manager POST:KPPUrlResetPassWord parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError * error;
        VDLoginResponse * info1 = [[VDLoginResponse alloc]initWithData:responseObject error:&error];
        [self _completeWithResponse:info1 block:responseBlock];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        VDHttpResponse * response = [VDHttpResponse responseWithError:error];
        [self _completeWithResponse:response block:responseBlock];
        
    }];
}
- (void)requestRegisterResponse:(PPResponseBlock())responseBlock Account:(NSString *)account passWord:(NSString *)passWord userNickName:(NSString *)nickName  Code:(NSString *)code Birthday:(NSString *)birthday weChatID:(NSString *)weChatID Sex:(NSString *)sex iconImageFiles:(UIImage *)image
{
     VDHTTPRequestOperationManager * manager = [VDHTTPRequestOperationManager manager];
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    if([account isValid])
    {
        [dict setObject:[@"" stringByAppendingString:account] forKey:@"account"];
    }
    if([passWord isValid])
    {
        [dict setObject:passWord forKey:@"password"];
    }
    if([code isValid])
    {
        [dict setObject:code forKey:@"code"];
    }
    if([birthday isValid])
    {
        [dict setObject:birthday forKey:@"birthday"];
        
    }
    if([weChatID isValid])
    {
        [dict setObject:weChatID forKey:@"wechatId"];
        
    }
    if([sex isValid])
    {
        [dict setObject:sex forKey:@"sex"];
    }
    if([nickName isValid])
    {
        [dict setObject:nickName forKey:@"nickName"];
        
    }
    [manager POST:kPPUrlRegister parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.9) name:@"uploadfile" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError * error;
        VDLoginResponse * info1 = [[VDLoginResponse alloc]initWithData:responseObject error:&error];
        [self _completeWithResponse:info1 block:responseBlock];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        VDHttpResponse * response = [VDHttpResponse responseWithError:error];
        [self _completeWithResponse:response block:responseBlock];
    }];
}


- (void)requestUpdatePassWord:(PPResponseBlock())responseBlock oldPassWord:(NSString *)oldPassword newPassWord:(NSString *)passWord
{
    VDHTTPRequestOperationManager * manager = [VDHTTPRequestOperationManager manager];
      [manager.requestSerializer setValue:[VDUserInfoEngine shareEngine].token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary * parm = @{@"oldPassword":oldPassword,@"password":passWord};
    [manager POST:kPPUrlUpdatePassWord parameters:parm success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)requestGetUserInfo:(PPResponseBlock())responseBlock
{
    VDHTTPRequestOperationManager * manager = [VDHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:[VDUserInfoEngine shareEngine].token forHTTPHeaderField:@"Authorization"];
    
    [manager GET:kPPUrlGetInfo parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
- (void)requsetSearchUser:(PPResponseBlock())responseBlock identify:(NSString *)aidentify
{
    VDHTTPRequestOperationManager * manager = [VDHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:[VDUserInfoEngine shareEngine].token forHTTPHeaderField:@"Authorization"];
    [manager GET:kPPUrlSearchUsers parameters:@{@"identify":aidentify} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    }];
    
}

- (void)requsetBindPhone:(PPResponseBlock())responseBlock phone:(NSString *)aphoneNumber Code:(NSString *)acode PassWord:(NSString *)apassWord
{
    VDHTTPRequestOperationManager * manager = [VDHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[VDUserInfoEngine shareEngine].token forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary * parm = [NSMutableDictionary new];
    [parm setObject:acode forKey:@"code"];
    [parm setObject:apassWord forKey:@"password"];
    [parm setObject:aphoneNumber forKey:@"phone"];
    [manager POST:kPPUrlBindPhone parameters:parm success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}

- (void)requsetBindWeChat:(PPResponseBlock())responseBlock weChatId:(NSString *)aweChatId
{
    VDHTTPRequestOperationManager * manager = [VDHTTPRequestOperationManager manager];
     [manager.requestSerializer setValue:[VDUserInfoEngine shareEngine].token forHTTPHeaderField:@"Authorization"];
    [manager POST:kPPUrlBindWeChat parameters:@{@"weChatId":aweChatId} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

-(void)requestRegisterResponse:(void (^)(id))responseBlock Account:(NSString *)account sendType:(NSInteger)type
{
    VDHTTPRequestOperationManager * manager = [VDHTTPRequestOperationManager manager];
    NSMutableDictionary * param = [NSMutableDictionary new];
    if(![account checkPhoneNumberValid])
    {
        VDLogError(@"手机号码错误");
        
        return;
        
    }
    [param setObject:account forKey:@"account"];
    [param setObject:@(type) forKey:@"type"];
    
    [manager POST:kPPUrlSendSms parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError * error;
        VDHttpResponse * response = [[VDHttpResponse alloc]initWithData:responseObject error:&error];
        [self _completeWithResponse:response block:responseBlock];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        VDHttpResponse * response = [VDHttpResponse responseWithError:error];
        [self _completeWithResponse:response block:responseBlock];
        
    }];
}
// * Integer methodType        //方法参数
//-- 1，不分页查询所有数据；
//-- 2，分页查询
//* Booleand orderByFirstLetter ;    //true表示根据首字母排序，false表示按照添加时间排序
//Integer page;    //methodType = 2时必填，分页的页数
//Integer size;    //methodType = 2时必填，每一页的数量
//String identify;     //不填则查询自己的好友，如果填则查询好友的好友
- (void)requestGetFriendsList:(void (^)(id))responseBlock methodType:(NSInteger)methodType orderByFirstLetter:(BOOL)oreder page:(NSInteger)page size:(NSInteger)size identfify:(NSString *)identify
{
    VDHTTPRequestOperationManager * manager = [VDHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[VDUserInfoEngine shareEngine].token forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary * param = [NSMutableDictionary new];
    [param setObject:@(methodType) forKey:@"methodType"];
    [param setObject:@(oreder) forKey:@"orderByFirstLetter"];
    if(methodType==2)
    {
        [param setObject:@(page) forKey:@"page"];
        [param setObject:@(size) forKey:@"size"];
    }
    if(identify)
    {
        [param setObject:identify forKey:@"identify"];
    }
    [manager GET:kPPUrlSearchMyListFriends parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError * error;
        VDFriendsListResponse * response = [[VDFriendsListResponse alloc]initWithData:responseObject error:&error];
        if(response.code.integerValue != kppRequestSucessCode)
        {
            
            return ;
        }
        if(response.totalPage.integerValue==page)
        {
            return ;
        }
        else
        {
            return [self requestGetFriendsList:^(id obj) {
                
            } methodType:methodType orderByFirstLetter:YES page:page + 1 size:size identfify:identify];
        }
        
        NSLog(@"response == %@",response);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error == %@",error);
        
    }];
}


@end
