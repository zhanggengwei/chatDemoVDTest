//
//  VDSelectImageViewController.h
//  chatDemo
//
//  Created by vd on 16/9/16.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSelectImageViewController : UIViewController
+(instancetype)createVDSelectImageViewController;
@property (nonatomic,strong) NSString * code;
@property (nonatomic,strong) NSString * account;
@property (nonatomic,strong) NSString * passWord;
@property (nonatomic,strong) NSString * countryCode;
@end
