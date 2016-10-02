//
//  VDTDBEnginer.h
//  chatDemo
//
//  Created by vd on 16/9/11.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VDUserInfo;
@class VDUserBase;
@interface VDTDBEnginer : NSObject
+(instancetype)shareManager;

- (void)saveUserInfo:(VDUserInfo *)info;
-(BOOL)saveFriendsList:(NSArray <VDUserBase *> *)list;
- (VDUserInfo*)queryUserInfo;
- (NSArray *)queryFriendsList;
@end
