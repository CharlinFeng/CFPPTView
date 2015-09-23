//
//  UIImage+ReMake.m
//  CoreSDWebImage
//
//  Created by 成林 on 15/5/6.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "UIImage+ReMake.h"

@implementation UIImage (ReMake)

-(UIImage *)remakeImageWithFullSize:(CGSize)fullSize scale:(CGFloat)scale{
    
    //新建上下文
    UIGraphicsBeginImageContextWithOptions(fullSize, NO, 0.0);
    
    //图片原本size
    CGSize size_orignal = self.size;
    CGFloat sizeW = size_orignal.width * scale;
    CGFloat sizeH = size_orignal.height * scale;
    CGFloat x = (fullSize.width - sizeW) *.5f;
    CGFloat y = (fullSize.height - sizeH) * .5f;
    CGRect rect = CGRectMake(x, y, sizeW, sizeH);
    
    [self drawInRect:rect];
    
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


/*
 *  生成一个默认的占位图片：bundle默认图片
 */
+(UIImage *)placeHolderImageWithSize:(CGSize)fullSize scale:(CGFloat)scale{
    
    return [[UIImage imageNamed:@"CoreSDWebImage.bundle/empty_picture"] remakeImageWithFullSize:fullSize scale:scale];
}

@end
