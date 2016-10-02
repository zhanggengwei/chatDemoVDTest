//
//  RJContactViewController.m
//  chatDemo
//
//  Created by vd on 16/7/30.
//  Copyright © 2016年 123. All rights reserved.
//

#import "RJContactViewController.h"
#import "RJAddContactPersonViewController.h"
#import "VDContListTableViewCell.h"
@interface RJContactViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *RJTableView;
@property (strong,nonatomic) UIBarButtonItem * leftItem;
@property (nonatomic,strong) NSArray * friendsList;

@end

@implementation RJContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsList = [[VDUserInfoEngine shareEngine].FrindsList copy];
    self.RJTableView.delegate = self;
    self.RJTableView.dataSource = self;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 60);
 
    [btn setImage:[self imageSize:CGSizeMake(28, 28) andImage: [UIImage imageNamed:@"add"]] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(clickRightAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(UIImage *)imageSize:(CGSize )size andImage:(UIImage *)image{
  
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * lastImage= UIGraphicsGetImageFromCurrentImageContext();
  
    UIGraphicsEndImageContext();
    return lastImage;
    

}

-(void)clickRightAction:(id)sender{
   
    [self.navigationController pushViewController:[RJAddContactPersonViewController  createRJAddContactPersonViewController] animated:YES];
    



}

-(void)showLeftController:(id)sender{


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableviewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    VDContListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VDContListTableViewCell"];
    VDUserBase * base = self.friendsList[indexPath.row];
    [cell layoutData:base];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsList.count;
    
}
@end
