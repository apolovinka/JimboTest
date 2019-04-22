//
//  UIButton+HitArea.h
//  Ippi
//
//  Created by Alexander Polovinka on 1/5/17.
//  Copyright © 2017 Worldline Communication. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HitArea)

// To expand a hit area the values should be negative
@property (nonatomic, assign) UIEdgeInsets hitAreaEdgeInsets;

@end
