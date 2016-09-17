//
//  RJBaseViewController+buttonItemsAction.m
//  chatDemo
//
//  Created by vd on 16/9/17.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RJBaseViewController+buttonItemsAction.h"

@implementation RJBaseViewController (buttonItemsAction)
- (void)leftItemAction:(id)sender
{
    
#pragma mark  进行判断 推进的方式
    
    if(self.navigationController.viewControllers.count>1){
        
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}
- (void)rightItemAction:(id)sender
{
    
}
@end
