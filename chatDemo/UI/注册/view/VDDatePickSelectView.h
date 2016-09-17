//
//  VDDatePickSelectView.h
//  chatDemo
//
//  Created by vd on 16/9/17.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VDDatePickSelectView;

@protocol VDDatePickSelectViewDelegate <NSObject>
- (void)datePickerSelectTime:(VDDatePickSelectView *)view datePicker:(UIDatePicker *)picker;
@end

@interface VDDatePickSelectView : UIView
@property (nonatomic,assign) id<VDDatePickSelectViewDelegate>delegate;

- (void)showInView;
@end
