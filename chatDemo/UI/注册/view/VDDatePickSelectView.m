//
//  VDDatePickSelectView.m
//  chatDemo
//
//  Created by vd on 16/9/17.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "VDDatePickSelectView.h"

@interface VDDatePickSelectView ()
@property (nonatomic,strong) UIView * backgroundView;
@property (nonatomic,strong) UIDatePicker * datePicker;
@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIView * contentView;

@end

@implementation VDDatePickSelectView

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self initView];
        
    }
    return self;
}

- (void)initView
{
    
    self.frame = [UIScreen mainScreen].bounds;
    
    // 初始化遮罩视图
    self.contentView = [UIView new];
    self.backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.142 alpha:1.000];
    self.backgroundView.alpha = 0.4f;
    [self addSubview:_backgroundView];
    self.datePicker = [UIDatePicker new];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.frame = CGRectMake(0, 50, WIDTH,self.datePicker.frame.size.height);
    self.contentView.frame = CGRectMake(0, HEIGHT, WIDTH, self.datePicker.frame.size.height + 50);
    self.headerView= [UIView new];
    self.headerView.frame = CGRectMake(0, 0, WIDTH, 50);
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.datePicker];
    self.headerView.layer.shadowOffset = CGSizeMake(0, 4);
    self.headerView.layer.shadowRadius = 4;
    self.headerView.layer.shadowOpacity = 0.8;
    self.headerView.layer.shadowColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    [self createBtn];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    UITapGestureRecognizer * tapRecoginzer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideInView)];
    [self.backgroundView addGestureRecognizer:tapRecoginzer];
    self.backgroundView.userInteractionEnabled = YES;
    
}
- (void)createBtn
{
    UIButton * configureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headerView addSubview:configureBtn];
    [self.headerView addSubview:cancelBtn];
    [configureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.headerView addSubview:configureBtn];
    [self.headerView addSubview:cancelBtn];
    [configureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView.mas_left).mas_offset(30);
        make.top.mas_equalTo(self.headerView.mas_top).mas_offset(8);
        make.bottom.mas_equalTo(self.headerView.mas_bottom).mas_offset(-8);
        make.width.mas_equalTo(@80);
    }];
    [configureBtn setTitle:@"确定" forState:UIControlStateNormal];
    configureBtn.layer.cornerRadius = 3;
    configureBtn.layer.shadowOffset = CGSizeMake(0, 5);
    configureBtn.layer.shadowColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.headerView.mas_right).mas_offset(-30);
        make.top.mas_equalTo(self.headerView.mas_top).mas_offset(8);
        make.bottom.mas_equalTo(self.headerView.mas_bottom).mas_offset(-8);
        make.width.mas_equalTo(@80);
    }];
    [configureBtn setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    configureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];

    [configureBtn addTarget:self action:@selector(confiureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)showInView
{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.hidden = NO;
    self.backgroundView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.datePicker.frame;
        CGSize screenSisze = [UIScreen mainScreen].bounds.size;
        frame.origin.y = screenSisze.height - self.datePicker.frame.size.height;
        self.contentView.frame = frame;
        self.backgroundView.alpha = 0.4;
        self.datePicker.hidden = NO;
    } completion:^(BOOL finished) {
    }];
}

- (void)hideInView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.datePicker.frame;
        frame.origin.y = HEIGHT;
        self.contentView.transform = CGAffineTransformMakeTranslation(0, self.datePicker.frame.size.height);
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
#pragma mark buttonAction
- (void)confiureBtn:(id)sender
{
    if([self.delegate respondsToSelector:@selector(datePickerSelectTime:datePicker:)])
    {
        [self.delegate datePickerSelectTime:self datePicker:self.datePicker];
    }
    [self hideInView];
}
- (void)cancelBtn:(id)sender
{
    [self hideInView];
}
@end
