//
//  VDUserInfoEngine.h
//  chatDemo
//
//  Created by vd on 16/9/10.
//  Copyright © 2016年 123. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDUserInfoEngine : NSObject
@property (nonatomic,strong,readonly) VDUserInfo * info;
@property (nonatomic,strong,readonly) NSString * token;
@property (nonatomic,strong,readonly) NSString * curentPath;
@property (nonatomic,strong,readonly) NSArray * FrindsList;
+(instancetype)shareEngine;

- (void)saveUserInfoResponse:(VDLoginResponse *)info;

- (void)saveFrindsList;

#pragma mark loadWebList

- (void)requsetWebContlistPage:(NSInteger)page pageSize:(NSInteger)size;
- (void)loadData;

@end
