//
//  UIButton+HitArea.m
//  Ippi
//
//  Created by Alexander Polovinka on 1/5/17.
//  Copyright © 2017 Worldline Communication. All rights reserved.
//

#import "UIButton+HitArea.h"
#import <objc/runtime.h>

@implementation UIButton (HitArea)

- (void)setHitAreaEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, @selector(hitAreaEdgeInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitAreaEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, @selector(hitAreaEdgeInsets));
    if(value) {
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitAreaEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }

    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitAreaEdgeInsets);

    return CGRectContainsPoint(hitFrame, point);
}

@end
