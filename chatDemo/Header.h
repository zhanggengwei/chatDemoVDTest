//
//  Header.h
//  chatDemo
//
//  Created by vd on 16/9/17.
//  Copyright © 2016年 vd. All rights reserved.
//

#ifndef Header_h
#define Header_h
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
#define BuglyAppKey @"900053984"
#define AppLoginAcount @"AppLoginAcount"
#define AppLoginToken @"AppLoginToken"
#define AppLoginIdentify @"AppLoginIdentify"
#endif /* Header_h */
