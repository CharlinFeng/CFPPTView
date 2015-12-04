//
//  UIImageView+CoreYYWebImage.m
//  CoreYYWebImage
//
//  Created by 冯成林 on 15/12/4.
//  Copyright © 2015年 冯成林. All rights reserved.
//

#import "UIImageView+CoreYYWebImage.h"
#import "UIImageView+YYWebImage.h"


@implementation UIImageView (CoreYYWebImage)

-(void)imageWithUrl:(NSString *)url placeHolderImage:(UIImage *)image{
    
    NSURL *urlObj = [NSURL URLWithString:url];
    
    [self yy_setImageWithURL:urlObj placeholder:image options:YYWebImageOptionProgressiveBlur completion:nil];
}

@end
