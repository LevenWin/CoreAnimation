//
//  StringLayer.m
//  sliderLayer
//
//  Created by leven on 2018/6/12.
//  Copyright © 2018年 leven. All rights reserved.
//

#import "StringLayer.h"

@implementation StringLayer

- (instancetype)initWithLayer:(StringLayer *)layer {
    self = [super initWithLayer:layer];
    if (self) {
        self.controlPoint = layer.controlPoint;
    }
    return self;
}

- (void)setControlPoint:(CGPoint)controlPoint {
    _controlPoint = controlPoint;
    [self setNeedsDisplay];
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"controlPoint"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)animateToOriginalPoint {
    CGFloat dampingFactor  = 10.0;
    CGFloat velocityFactor = 10.0;
    NSMutableArray *values = [self springAnimationValues:_controlPoint toValue:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) usingSpringWithDamping:0.5 * dampingFactor initialSpringVelocity:2.5 * velocityFactor duration:1.0];
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"controlPoint"];
    anim.values = values;
    anim.delegate = self;
    anim.duration = 0.5;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    [self addAnimation:anim forKey:@"animation"];
}


-(NSMutableArray *) springAnimationValues:(CGPoint)fromValue toValue:(CGPoint)toValue usingSpringWithDamping:(CGFloat)damping initialSpringVelocity:(CGFloat)velocity duration:(CGFloat)duration{
    //60个关键帧
    NSInteger numOfFrames  = duration * 60;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numOfFrames];
    for (NSInteger i = 0; i < numOfFrames; i++) {
        [values addObject:@(0.0)];
    }
    
    //差值
    CGFloat Xdiff = toValue.x - fromValue.x;
    CGFloat Ydiff = toValue.y - fromValue.y;

    // y = 1-e^{-5x} * cos(30x)
    for (NSInteger frame = 0; frame<numOfFrames; frame++) {
        CGFloat x = (CGFloat)frame / (CGFloat)numOfFrames;
        CGFloat Xvalue = toValue.x- Xdiff * (pow(M_E, -damping * x) * cos(velocity * x));
        CGFloat Yvalue = toValue.y- Ydiff * (pow(M_E, -damping * x) * cos(velocity * x));
        values[frame] = @(CGPointMake(Xvalue, Yvalue));
    }
    
    return values;
    
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        if ([anim isEqual:[self animationForKey:@"animation"]]) {
            self.controlPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            [self removeAllAnimations];
        }
    }
}


- (void)drawInContext:(CGContextRef)ctx {
    CGRect rect = self.bounds;
    CGPoint leftControlPoint = CGPointMake(0, rect.size.height/2.0);
    CGPoint rightControlPoint = CGPointMake(rect.size.width, rect.size.height/2.0);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:leftControlPoint];
    [path addQuadCurveToPoint:rightControlPoint controlPoint:_controlPoint];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, 3);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextStrokePath(ctx);
    CGContextFillPath(ctx);
}

@end
