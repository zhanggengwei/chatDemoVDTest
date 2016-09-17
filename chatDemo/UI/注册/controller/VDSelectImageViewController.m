//
//  VDSelectImageViewController.m
//  chatDemo
//
//  Created by vd on 16/9/16.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "VDSelectImageViewController.h"
#import "UIViewController+VDAlertController.h"
#import <LECropPictureViewController/LECropPictureViewController.h>
#import "UIImage+ScaleImage.h"
#import "VDDatePickSelectView.h"

@interface VDSelectImageViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,VDDatePickSelectViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *selectIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation VDSelectImageViewController

+(instancetype)createVDSelectImageViewController
{
    return [[UIStoryboard storyboardWithName:@"VDSelectImageViewController" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectIconImageView.image = [UIImage imageNamed:@"add.png"];
    [self.femaleBtn setBackgroundImage:[UIImage imageNamed:@"sexselect"] forState:UIControlStateSelected];
    [self.femaleBtn setBackgroundImage:[UIImage imageNamed:@"sexunselect"] forState:UIControlStateNormal];
    
    [self.maleBtn setBackgroundImage:[UIImage imageNamed:@"sexunselect"] forState:UIControlStateNormal];
    [self.maleBtn setBackgroundImage:[UIImage imageNamed:@"sexselect"] forState:UIControlStateSelected];
    self.maleBtn.selected = YES;
    
    [self.finishBtn setBackgroundImage:[UIImage imageNamed:@"sexselect"] forState:UIControlStateNormal];
    [self.finishBtn setTitle:@"注册" forState:UIControlStateNormal];
    self.finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tapAction
- (IBAction)tapAction:(id)sender
{
    [self createAlertControllerTitle:@"图片" messageString:@"图片选择方法" ActionTitles:@[@"拍照",@"照片库"] SelectorName:@[@"actionTakePhoto",@"actionSelectPhotoFromPhotoLibrary"]];
}
- (void)actionTakePhoto//:(id)sender
{
    NSLog(@"take photo");

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController * pickerController = [UIImagePickerController new];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.delegate = self;
        pickerController.editing = NO;
        if([[[UIDevice
              currentDevice] systemVersion] floatValue]>=8.0) {
            
            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:pickerController animated:YES completion:nil];
        
    }
    
}
- (void)actionSelectPhotoFromPhotoLibrary//:(id)sender
{
    NSLog(@"take library");
    UIImagePickerController * pickerController = [UIImagePickerController new];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        pickerController.delegate = self;
        pickerController.editing = NO;
        [self presentViewController:pickerController animated:YES completion:nil];
        
    }
    
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"info == %@",info);
    UIImage * image = info[@"UIImagePickerControllerOriginalImage"];
    image = [image imageCompressForSize:image targetSize:CGSizeMake(WIDTH, HEIGHT)];
    
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    LECropPictureViewController * controller = [[LECropPictureViewController alloc]initWithImage:image andCropPictureType:LECropPictureTypeRect];
    
    controller.photoAcceptedBlock = ^(UIImage * image)
    {
        NSLog(@"%@",image);
        self.selectIconImageView.image = image;
        
    };
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
- (IBAction)maleAction:(id)sender
{
    UIButton * maleBtn = (UIButton *)sender;
    maleBtn.selected = !(maleBtn.selected);
    self.femaleBtn.selected = !maleBtn.selected;
    
}
- (IBAction)femaleAction:(id)sender
{
    UIButton * femaleBtn = (UIButton *)sender;
    femaleBtn.selected = !(femaleBtn.selected);
    self.maleBtn.selected = !femaleBtn.selected;
}
- (IBAction)timeAction:(id)sender
{

    VDDatePickSelectView * dateSelect = [VDDatePickSelectView new];
    [dateSelect showInView];
    dateSelect.delegate = self;
    return;

}

- (IBAction)finishAction:(id)sender
{
}
#pragma mark delegate

- (void)datePickerSelectTime:(VDDatePickSelectView *)view datePicker:(UIDatePicker *)picker
{
    NSLog(@"%@",picker.date);
}
@end
