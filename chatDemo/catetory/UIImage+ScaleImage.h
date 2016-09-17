//
//  UIImage+ScaleImage.h
//  chatDemo
//
//  Created by vd on 16/9/17.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScaleImage)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
;

-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
@end
