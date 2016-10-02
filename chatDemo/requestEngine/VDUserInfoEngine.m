//
//  VDUserInfoEngine.m
//  chatDemo
//
//  Created by vd on 16/9/10.
//  Copyright © 2016年 123. All rights reserved.
//

#import "VDUserInfoEngine.h"
#import "VDFileManager.h"
#import "VDHTTPRequestOperationManager.h"

#import <iAppInfos/UIDevice+iAppInfos.h>
@interface VDUserInfoEngine ()
@property (nonatomic,strong) VDUserInfo * info;
@property (nonatomic,strong) NSString * token;
@property (nonatomic,strong) NSString * curentPath;
@property (nonatomic,strong) NSArray * FrindsList;
@end

@implementation VDUserInfoEngine
@synthesize info = _info;
+(instancetype)shareEngine
{
    static VDUserInfoEngine * engine;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        engine = [VDUserInfoEngine new];
    });
    return engine;
}
- (NSArray *)FrindsList
{
    if(_FrindsList== nil)
    {
        _FrindsList = [NSArray new];
    }
    return _FrindsList;
    
}
- (void)_completeWithResponse:(VDHttpResponse *)aResponse block:(PPResponseBlock())aResponseBlock
{
    if (aResponseBlock) {
        aResponseBlock(aResponse);
    }
}

-(void)loadUserInfo
{
    if([UIDevice jmo_deviceModelType] == UIDeviceModelTypeSimulator)
    {

        self.token =[[NSUserDefaults standardUserDefaults]objectForKey:AppLoginToken];
        
        self.info = [[VDTDBEnginer shareManager]queryUserInfo];
        
    }else
    {

    self.token = [SFHFKeychainUtils getPasswordForUsername:AppLoginToken andServiceName:VDServiceName error:nil];
    self.info = [[VDTDBEnginer shareManager]queryUserInfo];
    }
}

- (void)saveUserInfoPrivateInfoAccount:(NSString *)account token:(NSString *)tokenString
{

    if([UIDevice jmo_deviceModelType] == UIDeviceModelTypeSimulator)
    {
        NSUserDefaults * standardDefaults=[NSUserDefaults standardUserDefaults];
        [standardDefaults setObject:account forKey:AppLoginAcount];
        [standardDefaults setObject:tokenString forKey:AppLoginToken];
        [standardDefaults setObject:self.info.identify forKey:AppLoginIdentify];
        [standardDefaults synchronize];
    }
    else
    {
        
        [SFHFKeychainUtils storeUsername:AppLoginToken andPassword:tokenString forServiceName:VDServiceName updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:AppLoginIdentify andPassword:self.info.identify forServiceName:VDServiceName updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:AppLoginAcount andPassword:account forServiceName:VDServiceName updateExisting:YES error:nil];
    }
    
}
- (void)saveUserInfoResponse:(VDLoginResponse  *)info
{
    self.info = info.object;
    self.token = info.authorization.token;
    [[VDTDBEnginer shareManager]saveUserInfo:self.info];
    [self saveUserInfoPrivateInfoAccount:info.authorization.account token:info.authorization.token];
    
    
}
- (NSString *)curentPath
{
    NSString * identify = @"";
    if([UIDevice jmo_deviceModelType] == UIDeviceModelTypeSimulator)
    {
        identify = [[NSUserDefaults standardUserDefaults]objectForKey:AppLoginIdentify];
        
    }else
    {
        identify = [SFHFKeychainUtils getPasswordForUsername:AppLoginIdentify andServiceName:VDServiceName error:nil];
    }
    VDFileManager * manager = [VDFileManager sharedManager];
    NSString * curPath = [manager pathForDomain:PPFileDirDomain_User appendPathName:[identify md5]];
    [manager createPath:curPath];
    _curentPath = curPath;
    return _curentPath;
}
- (void)saveFrindsList:(NSArray <VDUserBase *> *)listArr
{
    [[VDTDBEnginer shareManager]saveFriendsList:listArr];
    
}
#pragma mark loadFrindsList
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
        [self _completeWithResponse:response block:responseBlock];

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error == %@",error);
        
    }];
}

- (void)requsetWebContlistPage:(NSInteger)page pageSize:(NSInteger)size
{

    [self requestGetFriendsList:^(VDFriendsListResponse * response) {
        if(response.code.integerValue == kppRequestSucessCode)
        {
          
             self.FrindsList = [self.FrindsList arrayByAddingObjectsFromArray:response.list];
             if(response.totalPage.integerValue == page)
            {
               
                [self saveFrindsList:self.FrindsList];
            }
            else
            {
                [self requsetWebContlistPage:page + 1 pageSize:size];
            }
        }
        else
        {
            return ;
        }
    } methodType:2 orderByFirstLetter:YES page:page size:size identfify:nil];
}
- (void)loadData
{
    [self loadUserInfo];
    self.FrindsList = [[VDTDBEnginer shareManager]queryFriendsList];
    NSLog(@"fdfdfd");
    
}

@end
