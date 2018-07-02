//
//  StringLayer.h
//  sliderLayer
//
//  Created by leven on 2018/6/12.
//  Copyright © 2018年 leven. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface StringLayer : CALayer<CAAnimationDelegate>
@property (nonatomic) CGPoint controlPoint;
- (void)animateToOriginalPoint;
@end
