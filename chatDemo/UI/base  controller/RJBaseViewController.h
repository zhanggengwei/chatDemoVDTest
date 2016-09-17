//
//  RJBaseViewController.h
//  chatDemo
//
//  Created by vd on 16/7/31.
//  Copyright © 2016年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJBaseViewController : UIViewController

@property (nonatomic,strong,readonly) UIBarButtonItem * leftItem;
@property (nonatomic,strong) UIBarButtonItem * rightItem;
-(void)clickRightAction:(id)sender;
-(UIBarButtonItem *)rightItem;

@end
