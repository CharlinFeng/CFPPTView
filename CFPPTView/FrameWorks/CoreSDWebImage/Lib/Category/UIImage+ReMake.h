//
//  UIImage+ReMake.h
//  CoreSDWebImage
//
//  Created by 成林 on 15/5/6.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ReMake)


-(UIImage *)remakeImageWithFullSize:(CGSize)fullSize scale:(CGFloat)scale;



+(UIImage *)placeHolderImageWithSize:(CGSize)fullSize scale:(CGFloat)scale;





@end
