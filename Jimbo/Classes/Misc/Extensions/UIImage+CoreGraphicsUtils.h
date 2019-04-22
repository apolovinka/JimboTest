//
//  UIImage+CoreGraphicsUtils.h
//
//  Created by Alex on 10/24/14.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (CoreGraphicsUtils)

- (UIImage *)imageFilledWithColor:(UIColor *)color;
+ (UIImage *)imageWithFromView:(UIView *)view;

- (BOOL)isLightImage;
- (BOOL)isLightImageInArea:(CGRect)area;
- (BOOL)isLightImageWithHumanCalculation:(BOOL)useHumanCalculation;

- (UIColor *)averageColor;
- (UIImage *)cropImageToRect:(CGRect)cropRect size:(CGSize)size;
+ (UIImage*)cropImage:(UIImage*)originalImage toRect:(CGRect)rect;
- (UIImage *)scaleToSize: (CGSize)size;
- (UIImage *)scaleProportionalToSize: (CGSize)size;
- (UIImage *)circularScaleAndCropWithFrame:(CGRect)frame;


@end
