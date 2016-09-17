//
//  VDLogFile.m
//  chatDemo
//
//  Created by vd on 16/9/17.
//  Copyright © 2016年 vd. All rights reserved.
//
// 进行日志的打印
#import "VDLogFile.h"
#import "OTFileManager.h"
#import <Bugly/Bugly.h>
#ifdef __OBJC__

#import <CocoaLumberjack/CocoaLumberjack.h>

#endif
#ifdef DEBUG
static const DDLogLevel ddLogLevel =DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelOff;
#endif

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]



@implementation VDLogFile
+ (instancetype)shareManager
{
    static dispatch_once_t token;
    static VDLogFile * manager;
    dispatch_once(&token, ^{
        manager = [VDLogFile new];
    });
    return manager;
}

+ (void)initLogUtil
{
    if (self == [VDLogFile class])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        docDir = PATH_OF_DOCUMENT;
        NSString *logPath = [docDir stringByAppendingString:@"/DDlog"];
        
        DDLogFileManagerDefault *lfm = [[DDLogFileManagerDefault alloc]initWithLogsDirectory:logPath];
        lfm.maximumNumberOfLogFiles = 7;    //log keep for a week
        
        DDFileLogger *fileLogger = [[DDFileLogger alloc]initWithLogFileManager:lfm];
        fileLogger.rollingFrequency = 60 * 60 * 24; //one day per log file
        
        [DDLog addLogger:fileLogger];
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
//        BuglyConfig *cfg = [[BuglyConfig alloc]init];
//        cfg.reportLogLevel = BuglyLogLevelDebug;
//        [Bugly startWithAppId:kPPAppKeyBugly config:cfg];
    }
}

@end
