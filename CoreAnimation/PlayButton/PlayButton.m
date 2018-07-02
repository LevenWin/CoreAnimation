//
//  PlayButton.m
//  CoreAnimation
//
//  Created by leven on 2018/6/29.
//  Copyright © 2018年 leven. All rights reserved.
//

#import "PlayButton.h"
@interface CircleLayer :CALayer
@end

@implementation CircleLayer

-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    UIGraphicsPushContext(ctx);

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.position radius:75 startAngle:0 endAngle:2* M_PI clockwise:NO];
    path.lineWidth = 4;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [[UIColor colorWithRed:3.0/255.0 green:216.0/255.0 blue:255.0/255.0 alpha:0.2] setStroke];
    [path stroke];
    UIGraphicsPopContext();
}
@end

@interface PlayButton()
@property (nonatomic, strong) CircleLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *rightLayer;
@property (nonatomic, strong) CAShapeLayer *leftLayer;

@end
@implementation PlayButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
         [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _circleLayer = [CircleLayer layer];
    [self.layer addSublayer:_circleLayer];
    
    [self setTitle:@"" forState:UIControlStateNormal];
    
    _rightLayer  = [CAShapeLayer layer];
    _rightLayer.lineWidth = 6;
    _rightLayer.lineCap = kCALineCapRound;
    _rightLayer.strokeColor = [UIColor colorWithRed:3.0/255.0 green:216.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    _rightLayer.fillColor = [UIColor colorWithRed:3.0/255.0 green:216.0/255.0 blue:255.0/255.0 alpha:0].CGColor;
    [self.layer addSublayer:_rightLayer];
    
    _leftLayer  = [CAShapeLayer layer];
    _leftLayer.lineWidth = 6;
    _leftLayer.lineCap = kCALineCapRound;
    _leftLayer.strokeColor = [UIColor colorWithRed:3.0/255.0 green:216.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    _leftLayer.fillColor = [UIColor colorWithRed:3.0/255.0 green:216.0/255.0 blue:255.0/255.0 alpha:0].CGColor;
    [self.layer addSublayer:_leftLayer];
}

- (CGPathRef)leftPath {
    CGFloat centerX = self.frame.size.width / 2;
    CGFloat centerY = self.frame.size.height / 2;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(centerX - 20, centerY - 40)];
    [path addLineToPoint:CGPointMake(centerX - 20, centerY + 30)];
    [path addLineToPoint:CGPointMake(centerX + 32, centerY)];
    [path addLineToPoint:CGPointMake(centerX - 20, centerY - 30)];
    [path addLineToPoint:CGPointMake(centerX - 20, centerY + 30)];
    [path addLineToPoint:CGPointMake(centerX + 32, centerY)];
    return path.CGPath;
}


- (CGPathRef)rightPath {
    CGFloat centerX = self.frame.size.width / 2;
    CGFloat centerY = self.frame.size.height / 2;

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(centerX+ 20, centerY+ 40)];
    [path addLineToPoint:CGPointMake(centerX+ 20, centerY-60)];
    [path addQuadCurveToPoint:CGPointMake(50, 11.5) controlPoint:CGPointMake(93, -5)];
    [path addArcWithCenter:CGPointMake(centerX, centerY) radius:150/2 startAngle:M_PI + M_PI *0.35 endAngle:0 clockwise:NO];
    [path addArcWithCenter:CGPointMake(centerX, centerY) radius:150/2 startAngle:0  endAngle:M_PI + M_PI * 0.25 clockwise:NO];
    return path.CGPath;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _circleLayer.frame = self.bounds;
    _rightLayer.frame = self.bounds;
    _leftLayer.frame = self.bounds;
    _rightLayer.path = [self rightPath];
    _leftLayer.path = [self leftPath];
    _leftLayer.strokeEnd = 0.224;
    _leftLayer.strokeStart = 0.028;
    
    _rightLayer.strokeEnd = 0.107;
    _rightLayer.strokeStart = 0.016;


    [_circleLayer setNeedsDisplay];
}

- (void)updatePercent:(CGFloat)percent {
    CGFloat rightEndPercent =  percent;
    CGFloat rightStartPercent =  0;
    CGFloat rightEndOld = _rightLayer.strokeEnd;
    CGFloat rightStartOld = _rightLayer.strokeStart;
    CGFloat rightHeight = 0.107 - 0.016;
    rightEndPercent = rightHeight + (1-rightHeight) * percent;
    
    if (rightEndPercent > 0.237 + rightHeight ) {
        rightStartPercent = 0.237;
    }else {
        rightStartPercent = rightEndPercent - rightHeight;
    }

    _rightLayer.strokeStart = rightStartPercent;
    _rightLayer.strokeEnd = rightEndPercent;


    CABasicAnimation*rightEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    rightEndAnimation.duration = 0.1;
    rightEndAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rightEndAnimation.fromValue =  @(rightEndOld);
    rightEndAnimation.removedOnCompletion = NO;
    rightEndAnimation.autoreverses=NO;

    CABasicAnimation*rightStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    rightStartAnimation.duration = 0.1;
    rightStartAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rightStartAnimation.fromValue =  @(rightStartOld);
    rightStartAnimation.removedOnCompletion = NO;
    rightStartAnimation.autoreverses=NO;

    CAAnimationGroup *rightGroupAnimation = [CAAnimationGroup animation];
    rightGroupAnimation.animations = [NSArray arrayWithObjects:rightEndAnimation,rightStartAnimation, nil];
    rightGroupAnimation.duration = 0.1f;
    rightGroupAnimation.fillMode=kCAFillModeForwards;
    [_rightLayer addAnimation:rightGroupAnimation forKey:@"rightayer"];

    
    

    CGFloat strokeEnd = _leftLayer.strokeEnd;
    CGFloat strokeStart = _leftLayer.strokeStart;
    CGFloat leftEndPercent =  percent;
    CGFloat leftStartPercnt = 0;
    CGFloat height = 0.224 - 0.028;

    leftEndPercent = height + (1- height) * percent;
    
    if (leftEndPercent <= 0.419) {
        leftStartPercnt = (1- height) * percent;
    }else {
        leftStartPercnt = (leftEndPercent - 0.419)/(1-0.419) * 0.191 + 0.228;
    }
    _leftLayer.strokeEnd = leftEndPercent;
    _leftLayer.strokeStart = leftStartPercnt;
    
    CABasicAnimation*leftStartPathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    leftStartPathAnimation.duration = 0.1;
    leftStartPathAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    leftStartPathAnimation.fromValue =  @(strokeStart);
    leftStartPathAnimation.removedOnCompletion = NO;
    leftStartPathAnimation.autoreverses=NO;
    CABasicAnimation*leftEndPathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    leftEndPathAnimation.duration = 0.1;
    leftEndPathAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    leftEndPathAnimation.fromValue =  @(strokeEnd);
    leftEndPathAnimation.removedOnCompletion = NO;
    leftEndPathAnimation.autoreverses=NO;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:leftEndPathAnimation,leftStartPathAnimation, nil];
    groupAnimation.duration = 0.1f;
    groupAnimation.fillMode=kCAFillModeForwards;

    
    [_leftLayer addAnimation:groupAnimation forKey:@"leftLayer"];
    NSLog(@"end %@",@(percent));
}

@end
