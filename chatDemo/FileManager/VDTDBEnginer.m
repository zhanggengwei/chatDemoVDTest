//
//  VDTDBEnginer.m
//  chatDemo
//
//  Created by vd on 16/9/11.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "VDTDBEnginer.h"
#import <FMDB/FMDB.h>
#import "VDFileManager.h"
#import "VDUserInfoEngine.h"
#import <objc/runtime.h>
#import "VDHttpResponse.h"
#import <iAppInfos/UIDevice+iAppInfos.h>

@implementation VDTDBEnginer
{
    FMDatabase * _db;
}


+(instancetype)shareManager
{
    static VDTDBEnginer * engine;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        engine = [[self alloc]init];
        [engine loadData];
    });
    return engine;
    
}

// 数据库文件

- (void)loadData
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * path =  [[VDUserInfoEngine shareEngine].curentPath stringByAppendingPathComponent:@"user.db"];
    
    BOOL newUser = ![fileManager fileExistsAtPath:path];
    _db = [FMDatabase databaseWithPath:path];
    
    if(![_db open])
    {
        [fileManager removeItemAtPath:path error:nil];
        _db = [FMDatabase databaseWithPath:path];
        [self createTable];
    }
    else  if(newUser)
    {
        [self createTable];
    }
     [_db close];
    
    
}
// 创建表的方法
- (void)createTable
{
    NSString * createUserInfoSql =@"create Table if not exists User_info (userId  integer  NOT NULL,avatarId integer not null,identify varchar(30) primary KEY NOT NULL,avatarUrl varchar(30) not  null,nickName varchar(30) not null,nickNameChar varchar(30) not null,sex varchar(30) not null,sign text(100),provinceid integer(20),province varchar(16),cityid integer(20),city varchar(16),areaid integer(20),area varchar(16),userName varchar(128) NOT NULL,password varchar(128) NOT NULL,birthday varchar(30) not null,constellation varchar (30) not null,friendUpdateTime varchar(128) not null)";
    
    [_db executeUpdate:createUserInfoSql];
    NSString * createFriendsListSql = @"create table if not exists Friends_List (userId  integer  NOT NULL,avatarId integer not null,identify varchar(30) primary KEY NOT NULL,avatarUrl varchar(30) NOT NULL,nickName varchar(30) not null,nickNameChar varchar(30) not null,sex varchar(30) not null,userName varchar(30) not NULL)";
    [_db executeUpdate:createFriendsListSql];
    
    
}
- (void)saveUserInfo:(VDUserInfo *)info
{
    
     VDFileManager * manager  = [VDFileManager sharedManager];
    NSString * path = [manager pathForDomain:PPFileDirDomain_User appendPathName:[[VDUserInfoEngine shareEngine].info.identify md5]];
    path = [path stringByAppendingPathComponent:@"user.db"];
    [_db open];
    
    NSString * searchUsersUrl = @"select * from User_info";
    FMResultSet * set =[_db executeQuery:searchUsersUrl];
    BOOL containsRecord;
    if(set.next)
    {
        NSString * searchSql =[NSString stringWithFormat:@"select * from User_info where identify = %@",info.identify];
        set =[_db executeQuery:searchSql];
        containsRecord = set.next;
    }else
    {
        containsRecord = NO;
    }
    if(!containsRecord)
    {
        // 修改
        NSString * inserSql = @"INSERT INTO User_info (userId, identify, avatarId, avatarUrl, nickName, nickNameChar, sex, sign, birthday, constellation, provinceid, province, cityid, city, areaid, area, userName, password, friendUpdateTime) VALUES (?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?);";
        BOOL  insqlSucess=  [_db executeUpdate:inserSql,info.userId,info.identify,info.avatarId,info.avatarUrl,info.nickName,info.nickNameChar,info.sex,info.sign,info.birthday,info.constellation,info.comeFrom.provinceid,info.comeFrom.province,info.comeFrom.cityid,info.comeFrom.city,info.comeFrom.areaid,info.comeFrom.area,info.imUser.userName,info.imUser.password,info.friendUpdateTime];
        
        if(insqlSucess)
        {
            NSLog(@"insert sql sucess");
        }else
        {
            NSLog(@"insert sql error");
        }
    }
    else
    {
        NSString* updateSql1 = @"update User_info set avatarId = ?,avatarUrl = ?,nickName =?,nickNameChar =?,sign = ?,sex = ?,provinceid =?,province = ?,cityid = ? ,city = ?,areaid= ?,area = ?,birthday =?,constellation = ?,friendUpdateTime =? where identify = ?";
        BOOL updateError=   [_db executeUpdate:updateSql1,info.avatarId,info.avatarUrl,info.nickName,info.nickNameChar,info.sign,info.sex,info.comeFrom.provinceid,info.comeFrom.province,info.comeFrom.cityid,info.comeFrom.city,info.comeFrom.areaid,info.comeFrom.area,info.birthday,info.constellation,info.friendUpdateTime,info.identify];
        
        if(updateError)
        {
            NSLog(@"更新sucess");
        }
        else
        {
            NSLog(@"更新失败");
        }
    }
}

- (VDUserInfo*)queryUserInfo
{
    
    NSString * identify= @"";
    if([UIDevice jmo_deviceModelType] == UIDeviceModelTypeSimulator)
    {
        identify = [[NSUserDefaults standardUserDefaults]objectForKey:AppLoginIdentify];
    }else
    {
        identify = [SFHFKeychainUtils getPasswordForUsername:AppLoginIdentify andServiceName:VDServiceName error:nil];
    }
     VDFileManager * manager  = [VDFileManager sharedManager];
     NSString * path = [manager pathForDomain:PPFileDirDomain_User appendPathName:[identify md5]];
    path = [path stringByAppendingPathComponent:@"user.db"];
    _db = [FMDatabase databaseWithPath:path];
    if ([_db open]){
    NSString * querySql = [NSString stringWithFormat:@"select * from User_info where identify = \'%@\'",identify];
    FMResultSet * set= [_db executeQuery:querySql];
    VDUserInfo * info;
    if(set.next)
    {
        info = [VDUserInfo new];
        for (int i =0; i < set.columnCount; i++) {
            NSString * name = [set columnNameForIndex:i];
           id obj = [set objectForColumnName:name];
            if([self isAddressClass:name])
            {
                if(info.comeFrom==nil)
                {
                    info.comeFrom = [VDAddress new];
                }
                [info.comeFrom setValue:obj forKey:name];
            }else if ([self isVDImUserClassProperty:name])
            {
                if(info.imUser ==nil)
                {
                    info.imUser = [VDImUser new];
                }
                [info.imUser setValue:obj forKey:name];
            }
            else
            {
                
                [info setValue:obj forKey:name];
            }
            
            
        }
    }
    
        return info;
        
    }
    return nil;
    
}

- (BOOL)isAddressClass:(NSString *)name
{
    
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([VDAddress class], &count);
    
    for (int i = 0; i < count; i++)
    {
     const char *propertyName = property_getName(propertyList[i]);
      
        if([[NSString stringWithFormat:@"%s",propertyName] isEqualToString:name])
        {
            free(propertyList);
            return YES;
        }
    }
    
    free(propertyList);
    return NO;
    
}

-(BOOL)isVDImUserClassProperty:(NSString *)name
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([VDImUser class], &count);
    for (int i = 0; i < count; i++) {
        // const char * ivar_getName ( Iv
        const char *propertyName = property_getName(propertyList[i]);
        if([[NSString stringWithFormat:@"%s",propertyName] isEqualToString:name])
        {
            free(propertyList);
            return YES;
        }
    }
    free(propertyList);
    return NO;
}
//保存list friends
-(BOOL)saveFriendsList:(NSArray <VDUserBase *> *)list
{
    if(list == nil||list.count ==0)
        return YES;
    
    if([_db open])
    {
        [_db beginTransaction];
       
        @try {
            BOOL ret;
            if([self haveTable:@"Friends_List"])
            {
                NSString * dropSql = @"DELETE FROM  Friends_List";
                 ret = [_db executeUpdate:dropSql];
                if(!ret)
                {
                    if([_db inTransaction])
                    {
                        [_db rollback];
                    }
                    [_db close];
                    return NO;
                }
            }
            NSString * insertSql = @"insert into Friends_List(userId,avatarId,identify,avatarUrl,nickName,nickNameChar,sex,userName) values(?,?,?,?,?,?,?,?)";
            for (int i = 0; i < list.count; i++)
            {
                VDUserBase * base = list[i];
                ret = [_db executeUpdate:insertSql,base.userId,base.avatarId,base.identify,base.avatarUrl,base.nickName,base.nickNameChar,base.sex,base.imUser.userName];
                if(!ret)
                {
                    if ([_db inTransaction])
                    {
                        [_db rollback];
                    }
                    [_db close];
                    return NO;
                }
            }
            if ([_db inTransaction])
            {
                [_db commit];
            }
        } @catch (NSException *exception) {
            if([_db inTransaction])
            {
                [_db rollback];
            }
            return NO;
            
        } @finally {
            [_db close];
            return YES;
        }
    }
        return YES;
}
- (NSArray *)queryFriendsList
{
    NSMutableArray * listArr = [NSMutableArray new];
    //NSString * identify = [VDUserInfoEngine shareEngine].info.identify;
    NSString * searchSql = @"select * from Friends_list";
    //searchSql = [NSString stringWithFormat:searchSql,identify];
    if([_db open])
    {
        FMResultSet * set = [_db executeQuery:searchSql];
        while (set.next)
        {
            VDUserBase * base = [VDUserBase new];
            for (int i = 0; i < set.columnCount; i++)
            {
                NSString * propertyName = [set columnNameForIndex:i];
               NSString * propertyValues = [set objectForColumnName:propertyName];
                if([propertyName isEqualToString:@"userName"])
                {
                    VDImUser * imUser = [VDImUser new];
                    [imUser setValue:propertyValues forKey:propertyName];
                    base.imUser = imUser;
                }
                else
                {
                    [base setValue:propertyValues forKey:propertyName];
                }
                
            }
            [listArr addObject:base];
        }
    }
    return listArr;
}
-(BOOL)haveTable:(NSString *)tableName
{
    if([_db open])
    {
        NSString * searchSql =  [NSString stringWithFormat:@"select * from \'%@\'",tableName];
        
        if([_db open])
        {
            FMResultSet * set = [_db executeQuery:searchSql];
            return set.next;
        }
    }
    return NO;
}


@end
