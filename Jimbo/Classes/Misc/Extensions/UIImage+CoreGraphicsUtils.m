//
//  UIImage+CoreGraphicsUtils.m
//
//  Created by Alex on 10/24/14.
//
//

#import "UIImage+CoreGraphicsUtils.h"

@implementation UIImage (CoreGraphicsUtils)

- (UIImage *)imageFilledWithColor:(UIColor *)color{
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;
}

- (BOOL)isLightImageInArea:(CGRect)area {
    CGImageRef image = CGImageCreateWithImageInRect(self.CGImage, area);
    BOOL result = [[UIImage imageWithCGImage:image] isLightImage];
    CGImageRelease(image);
    return result;
}

- (BOOL)isLightImageWithHumanCalculation:(BOOL)useHumanCalculation {
    BOOL isDark = FALSE;

    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage));
    const UInt8 *pixels = CFDataGetBytePtr(imageData);

    int darkPixels = 0;

    CFIndex length = CFDataGetLength(imageData);
    int const darkPixelThreshold = (self.size.width*self.size.height)*.45;

    for(int i=0; i<length; i+=4)
    {
        int r = pixels[i];
        int g = pixels[i+1];
        int b = pixels[i+2];

        //luminance calculation gives more weight to r and b for human eyes
        float luminance;
        if (useHumanCalculation) {
            luminance = (0.299*r + 0.587*g + 0.114*b);
        }else {
            luminance = (r + g + b);
        }
        if (luminance<150) darkPixels ++;
    }

    if (darkPixels >= darkPixelThreshold)
        isDark = YES;

    CFRelease(imageData);

    return !isDark;
}

- (BOOL) isLightImage {
    return [self isLightImageWithHumanCalculation:YES];
}

- (UIColor *)averageColor {
    CGSize size = {1, 1};
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
    [self drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];
    uint8_t *data = CGBitmapContextGetData(ctx);
    UIColor *color = [UIColor colorWithRed:data[2] / 255.0f
                                     green:data[1] / 255.0f
                                      blue:data[0] / 255.0f
                                     alpha:1];
    UIGraphicsEndImageContext();
    return color;
}

static inline double radians (double degrees) {return degrees * M_PI/180;}

+ (UIImage*)cropImage:(UIImage*)originalImage toRect:(CGRect)rect{

    CGAffineTransform rectTransform;
    BOOL shouldTransform = YES;
    switch (originalImage.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(radians(90)), 0, -originalImage.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(radians(-90)), -originalImage.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(radians(-180)), -originalImage.size.width, -originalImage.size.height);
            break;
        default:
            shouldTransform = NO;
            rectTransform = CGAffineTransformIdentity;
    };
    if (shouldTransform) {
        rectTransform = CGAffineTransformScale(rectTransform, originalImage.scale, originalImage.scale);
        rect = CGRectApplyAffineTransform(rect, rectTransform);
    }


    CGImageRef imageRef = CGImageCreateWithImageInRect([originalImage CGImage], rect);
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef scale:originalImage.scale orientation:originalImage.imageOrientation];
    CGImageRelease(imageRef);

    return resultImage;
}

- (UIImage *)cropImageToRect:(CGRect)cropRect size:(CGSize)size {

    // viewWidth, viewHeight are dimensions of imageView
    const CGFloat imageViewScale = MAX(self.size.width/size.width, self.size.height/size.height);

//    CGRect rect = CGRectMake(cropRect.origin.x * self.scale, cropRect.origin.y * self.scale, cropRect.size.width * self.scale, cropRect.size.height  * self.scale);
    CGRect rect = CGRectMake(cropRect.origin.x, cropRect.origin.y, cropRect.size.width, cropRect.size.height);


    // Perform cropping in Core Graphics
    CGImageRef cutImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);

    UIImage *image = [UIImage imageWithCGImage:cutImageRef scale:self.scale orientation:self.imageOrientation];

    UIImage* croppedImage;
    if (imageViewScale != 0.0) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        croppedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else {
        croppedImage = [UIImage imageWithCGImage:cutImageRef scale:self.scale orientation:self.imageOrientation];
    }

    // Clean up reference pointers
    CGImageRelease(cutImageRef);

    return croppedImage;
}

//- (UIImage *)scaleImageToSize:(CGSize)size {
//
//    CGRect scaledImageRect = CGRectZero;
//
//    CGFloat aspectWidth = size.width / self.size.width;
//    CGFloat aspectHeight = size.height / self.size.height;
//    CGFloat aspectRatio = MAX ( aspectWidth, aspectHeight );
//
//    scaledImageRect.size.width = self.size.width * aspectRatio;
//    scaledImageRect.size.height = self.size.height * aspectRatio;
//    scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0f;
//    scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0f;
//
//    UIGraphicsBeginImageContextWithOptions( size, NO, 0 );
//    [self drawInRect:scaledImageRect];
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return scaledImage;
//}

- (UIImage *) scaleToSize: (CGSize)size
{
    CGFloat scale = UIScreen.mainScreen.scale;
    size = CGSizeMake(size.width * scale, size.height * scale);
    // Scalling selected image to targeted size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));

    if(self.imageOrientation == UIImageOrientationRight)
    {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), self.CGImage);
    }
    else {
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
    }

    CGImageRef scaledImage=CGBitmapContextCreateImage(context);

    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);

    UIImage *image = [UIImage imageWithCGImage:scaledImage scale:scale orientation:self.imageOrientation];

    CGImageRelease(scaledImage);

    return image;
}

- (UIImage *) scaleProportionalToSize: (CGSize)size
{
    if (self.size.width <= size.width && self.size.height <= size.height) {
        return self;
    }

    CGSize newSize;
    if(self.size.width < self.size.height){
        newSize = CGSizeMake(
                             (self.size.width / self.size.height) * size.height,
                             size.height);
    } else {
        newSize = CGSizeMake(
                             size.width,
                             (self.size.height / self.size.width) * size.width);
    }

    return [self scaleToSize:newSize];
}

- (UIImage *)circularScaleAndCropWithFrame:(CGRect)frame {
    // This function returns a newImage, based on image, that has been:
    // - scaled to fit in (CGRect) rect
    // - and cropped within a circle of radius: rectWidth/2

    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    //Get the width and heights
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGFloat rectWidth = frame.size.width;
    CGFloat rectHeight = frame.size.height;

    //Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;

    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;

    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);

    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);

    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [self drawInRect:myRect];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

@end
