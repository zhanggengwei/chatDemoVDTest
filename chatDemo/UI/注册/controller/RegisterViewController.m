//
//  RegisterViewController.m
//  chatDemoWDdemo
//
//  Created by 123 on 16/6/9.
//  Copyright © 2016年 123. All rights reserved.
//

#import "RegisterViewController.h"
#import "RJBackView.h"
#import "UIButton+ButtonThread.h"
#import "VDSelectImageViewController.h"
@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet RJBackView *backView;
@property (weak, nonatomic) IBOutlet UITextField *PassWord;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITextField *codePassWord;
@property (weak, nonatomic) IBOutlet UITextField *againPassWord;
@property (weak, nonatomic) IBOutlet UIButton *VDBottomBtn;
@end

@implementation RegisterViewController
#pragma mark life_cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
#pragma mark textField Action
    [_PassWord addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.masksToBounds = YES;
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    if(self.style == VDReginsterController)
    {
        [self.VDBottomBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    else
    {
        [self.VDBottomBtn setTitle:@"完成" forState:UIControlStateNormal];
        
    }
    self.VDBottomBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action
- (IBAction)backController:(id)sender {

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//进行验证码获取的方法
- (IBAction)BtnCodeAction:(id)sender {
    
//    if([self.RJNumberTextField.text checkPhoneNumInput]){
//        //进行 手机的注册
    [self.getCodeBtn startTime];

}
- (void)textFiledChange:(id)sender
{
    UITextField * textField = (UITextField *)sender;
    
    if(textField==self.numberText&&self.numberText.text.length>=12)
    {
        self.numberText.text = [self.numberText.text substringToIndex:12];
        
    }
    if(textField == self.codePassWord && self.codePassWord.text.length>5)
    {
        self.codePassWord.text = [self.codePassWord.text substringToIndex:5];
    }
    if(self.numberText.text.length>=11&&self.codePassWord.text.length>=4&&self.PassWord.text.length>=6&&self.againPassWord.text.length>=6)
    {
        self.VDBottomBtn.enabled = YES;
    }else
    {
        self.VDBottomBtn.enabled = NO;
    }
}

- (IBAction)registerBtn:(id)sender
{
    if(self.style == VDReginsterController)
    {
        
        if(![self.againPassWord.text isEqualToString:self.PassWord.text])
        {
            return;
        }
        
        VDSelectImageViewController * controller = [VDSelectImageViewController createVDSelectImageViewController];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else if(self.style == VDResetPassWordController)
    {
       [[VDRequestEngine shareEngine]requestResetPassWordResponse:^(VDHttpResponse * aTaskResponse) {
           
       } Account:self.numberText.text passWord:[self.PassWord.text md5] Code:self.codePassWord.text];
    }
}
@end
