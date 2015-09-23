//
//  UIImageView+SD.h
//  CoreSDWebImage
//
//  Created by 成林 on 15/5/6.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"
#import "UIImage+ReMake.h"


@interface UIImageView (SD)


-(void)imageWithUrlStr:(NSString *)urlStr size:(CGSize)size scale:(CGFloat)scale;



-(void)imageWithUrlStr:(NSString *)urlStr size:(CGSize)size scale:(CGFloat)scale progressBlock:(SDWebImageDownloaderProgressBlock)progressBlock completedBlock:(SDWebImageCompletionBlock)completedBlock;


@end
