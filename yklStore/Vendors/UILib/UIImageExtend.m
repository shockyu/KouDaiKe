//
//  UIImage+APAddition.m
//  Etion
//
//  Created by  user on 11-9-5.
//  Copyright 2011 GuangZhouXuanWu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIImageExtend.h"

@implementation UIImage (UIImageExtend)

+ (UIImage *)imageWithMainBundle:(NSString *)szImagename
{
    UIImage *image = nil;
    NSString *szPath = @"";
    NSString *szFilename = [szImagename stringByDeletingPathExtension];
    NSString *szFileext = [szImagename pathExtension];
    if(szFileext.length<=0)
        szFileext=@"png";
    if (szFilename.length > 0 && szFileext.length > 0)
    {
        if ([[UIScreen mainScreen] scale] >= 2.0)
        {
            szPath = [[NSBundle mainBundle] pathForResource:[szFilename stringByAppendingString:@"@2x"] ofType:szFileext];
            if (![[NSFileManager defaultManager] fileExistsAtPath:szPath])
                szPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:szImagename];
        }
        else
        {
            szPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:szImagename];
            if (![[NSFileManager defaultManager] fileExistsAtPath:szPath])
                szPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[[szFilename stringByAppendingString:@"@2x"] stringByAppendingPathExtension:szFileext]];
        }
        image = [UIImage imageWithContentsOfFile:szPath];
    }
    return image;
}

- (id)initWithContentsOfResolutionIndependentFile:(NSString *)path
{
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0)
    {
        return [self initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:path]] CGImage] scale:2.0 orientation:UIImageOrientationUp];
    }
    return [self initWithData:[NSData dataWithContentsOfFile:path]];
}

+ (UIImage *)imageWithContentsOfResolutionIndependentFile:(NSString *)path
{
    return [[UIImage alloc] initWithContentsOfResolutionIndependentFile:path];
}

//get a thumnail
+ (UIImage *)imageFromImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageFromImage:(UIImage *)image scaledToFitSize:(CGSize)newSize
{
    CGFloat w = 0, h = 0;
    [UIImage caleFitImageSize:image.size targetSize:newSize width:&w height:&h];
    return [UIImage imageFromImage:image size:CGSizeMake(w, h) fillStyle:EImageFillStyleStretch];
}

+ (UIImage *)imageFromImage:(UIImage *)image size:(CGSize)newSize fillStyle:(EImageFillStyle)fillStyle
{
    if (image.size.width == newSize.width && image.size.height == newSize.height)
    {
        return image;
    }

    CGSize newImageSize;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);

    switch (fillStyle)
    {
        case EImageFillStyleStretch:
        {
            [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            break;
        }
        case EImageFillStyleScale:
        {
            [UIImage caleFitImageSize:image.size targetSize:newSize width:&newImageSize.width height:&newImageSize.height];
            [image drawInRect:CGRectMake((newSize.width - newImageSize.width) / 2, (newSize.height - newImageSize.height) / 2, newImageSize.width, newImageSize.height)];
            break;
        }
        case EImageFillStyleStretchByScale:
        case EImageFillStyleStretchByXCenterScale:
        case EImageFillStyleStretchByCenterScale:
        {
            float rateW = image.size.width / newSize.width;
            float rateH = image.size.height / newSize.height;
            float rateScale = rateW < rateH ? 1.0 / rateW : 1.0 / rateH;
            newImageSize.width = rateScale * image.size.width;
            newImageSize.height = rateScale * image.size.height;

            switch (fillStyle)
            {
                case EImageFillStyleStretchByScale:
                    [image drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)];
                    break;
                case EImageFillStyleStretchByXCenterScale:
                    [image drawInRect:CGRectMake(newImageSize.width > newSize.width ? (newSize.width - newImageSize.width) / 2 : 0, 0, newImageSize.width, newImageSize.height)];
                    break;
                case EImageFillStyleStretchByCenterScale:
                    [image drawInRect:CGRectMake(newImageSize.width > newSize.width ? (newSize.width - newImageSize.width) / 2 : 0, newImageSize.height > newSize.height ? (newSize.height - newImageSize.height) / 2 : 0, newImageSize.width, newImageSize.height)];
                    break;
                default:
                    break;
            }

            break;
        }
        default:
            [image drawAtPoint:CGPointMake(0, 0)];
            break;
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//get a screenshot
+ (UIImage *)imageFromView:(UIView *)targetView
{
    UIGraphicsBeginImageContextWithOptions(targetView.frame.size, NO, 0.0);
    if([[UIDevice currentDevice].systemVersion floatValue]>=7.0)
        [targetView drawViewHierarchyInRect:targetView.bounds afterScreenUpdates:YES];
    else
        [targetView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (float)caleFitImageSize:(CGSize)oriimgsize targetSize:(CGSize)targetimgsize width:(CGFloat *)nInitwidth height:(CGFloat *)nInitheight
{
    float width = 0.0;
    float height = 0.0;
    float wmul = 0.0;
    float hmul = 0.0;
    float mul = 1.0;
    float w = targetimgsize.width;
    float h = targetimgsize.height;
    CGSize imgsize = oriimgsize;
    if (imgsize.width > w)
        mul = wmul = w / imgsize.width;
    if (imgsize.height > h)
        mul = hmul = h / imgsize.height;
    if (wmul != 0.0 && 0.0 == hmul)
    {
        width = w;
        height = imgsize.height * wmul;
    }
    else if (0.0 == wmul && hmul != 0.0)
    {
        width = imgsize.width * hmul;
        height = h;
    }
    else if (0.0 != wmul && 0.0 != hmul)
    {
        mul = MIN(wmul, hmul);
        width = imgsize.width * mul;
        height = imgsize.height * mul;
    }
    else
    {
        width = imgsize.width;
        height = imgsize.height;
    }
    *nInitwidth = width;
    *nInitheight = height;

    return mul;
}

+ (CGSize)caleFitImageSize:(CGSize)orgSize targetSize:(CGSize)targetSize
{
    CGSize fitSize;
    [self caleFitImageSize:orgSize targetSize:targetSize width:&fitSize.width height:&fitSize.height];
    return fitSize;
}

- (UIImage *)resizeableCenterImage
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(self.size.height/2, self.size.width/2, self.size.height/2, self.size.width/2);
    return [self resizableImageWithCapInsets:edgeInsets];
}

- (UIImage *)drawResizeableImageWithSize:(CGSize)size capInsets:(UIEdgeInsets)capinsets
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height),NO, 0);
    
    UIImage* image = [self resizableImageWithCapInsets:capinsets];
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageFromImage:(UIImage *)image renderWithColor:(UIColor *)renderColor
{
    CGRect imageRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, image.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [image drawInRect:imageRect];
    
    CGContextSetFillColorWithColor(ctx, [renderColor CGColor]);
    CGContextSetBlendMode(ctx, kCGBlendModeSourceIn);
    CGContextFillRect(ctx, imageRect);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *renderImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    UIGraphicsEndImageContext();
    
    return renderImage;
}

@end
