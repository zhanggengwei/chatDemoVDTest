//
//  VDLogFile.h
//  chatDemo
//
//  Created by vd on 16/9/17.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>
#import <CocoaLumberjack/DDFileLogger.h>
#import <Bugly/Bugly.h>


#define VDLogError(fmt, ...) DDLogError(fmt, ##__VA_ARGS__);BLYLogError(fmt, ##__VA_ARGS__)
#define VDLogWarn(fmt, ...) DDLogWarn(fmt, ##__VA_ARGS__);BLYLogError(fmt, ##__VA_ARGS__)
#define VDLogInfo(fmt, ...) DDLogInfo(fmt, ##__VA_ARGS__);BLYLogInfo(fmt, ##__VA_ARGS__)
#define VDLogDebug(fmt, ...) DDLogDebug(fmt, ##__VA_ARGS__);BLYLogDebug(fmt, ##__VA_ARGS__)
#define VDLogVerbose(fmt, ...) DDLogVerbose(fmt, ##__VA_ARGS__);BLYLogVerbose(fmt, ##__VA_ARGS__)
@interface VDLogFile : NSObject

@end
