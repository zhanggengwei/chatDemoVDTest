//
//  VDContListTableViewCell.m
//  chatDemo
//
//  Created by vd on 16/10/2.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "VDContListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface VDContListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end


@implementation VDContListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutData:(VDUserBase *)baseInfo
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:baseInfo.avatarUrl] placeholderImage:nil options:SDWebImageProgressiveDownload];
    self.nameLabel.text = baseInfo.nickName;
    
}

@end
