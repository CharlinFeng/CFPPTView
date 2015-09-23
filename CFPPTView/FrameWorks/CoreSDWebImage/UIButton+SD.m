//
//  UIButton+SD.m
//  CoreSDWebImage
//
//  Created by 成林 on 15/5/6.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "UIButton+SD.h"
#import "UIButton+WebCache.h"


@implementation UIButton (SD)

-(void)imageWithUrlStr:(NSString *)urlStr state:(UIControlState)state size:(CGSize)size scale:(CGFloat)scale{
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    UIImage *h = [UIImage placeHolderImageWithSize:size scale:scale];
    
    [self sd_setImageWithURL:url forState:state placeholderImage:h];
}



-(void)imageWithUrlStr:(NSString *)urlStr state:(UIControlState)state size:(CGSize)size scale:(CGFloat)scale progressBlock:(SDWebImageDownloaderProgressBlock)progressBlock completedBlock:(SDWebImageCompletionBlock)completedBlock{
    
    UIImage *h = [UIImage placeHolderImageWithSize:size scale:scale];
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    SDWebImageOptions options = SDWebImageLowPriority | SDWebImageRetryFailed;

    [self sd_setImageWithURL:url forState:state placeholderImage:h options:options completed:completedBlock];
}

@end
