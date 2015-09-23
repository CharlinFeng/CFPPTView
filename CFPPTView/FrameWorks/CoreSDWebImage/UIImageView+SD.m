//
//  UIImageView+SD.m
//  CoreSDWebImage
//
//  Created by 成林 on 15/5/6.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "UIImageView+SD.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ReMake.h"

@implementation UIImageView (SD)


-(void)imageWithUrlStr:(NSString *)urlStr size:(CGSize)size scale:(CGFloat)scale{
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    UIImage *h = [UIImage placeHolderImageWithSize:size scale:scale];
    
    [self sd_setImageWithURL:url placeholderImage:h];
}


-(void)imageWithUrlStr:(NSString *)urlStr size:(CGSize)size scale:(CGFloat)scale progressBlock:(SDWebImageDownloaderProgressBlock)progressBlock completedBlock:(SDWebImageCompletionBlock)completedBlock{
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    SDWebImageOptions options = SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageDownloaderProgressiveDownload;

    UIImage *h = [UIImage placeHolderImageWithSize:size scale:scale];
    
    [self sd_setImageWithURL:url placeholderImage:h options:options progress:progressBlock completed:completedBlock];
}


@end
