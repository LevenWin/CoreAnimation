//
//  ColorsLoadingViewController.m
//  CoreAnimation
//
//  Created by leven on 2018/1/24.
//  Copyright © 2018年 leven. All rights reserved.
//

#import "ColorsLoadingViewController.h"

#define KSCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define KSCREENHEIGHT  [UIScreen mainScreen].bounds.size.height


@interface ColorsLoadingViewController ()<CAAnimationDelegate>{
    NSTimer *_timer;
    BOOL _check;
}
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) CAShapeLayer *shaperMaskLayer;
@property (nonatomic, strong) CAShapeLayer *checkMaskLayer;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation ColorsLoadingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = CGRectMake(0, 0, 300, 300);
    _gradientLayer.position = self.view.center;
    
    [self.view.layer addSublayer:_gradientLayer];
    
    NSMutableArray *colorArray = [NSMutableArray new];
    for (NSInteger hue = 0; hue <= 360; hue += 5) {
        UIColor *color = [UIColor colorWithHue:1.0*hue/360.0
                                    saturation:0.7
                                    brightness:0.5
                                         alpha:1.0];
        [colorArray addObject:(id)color.CGColor];
    }
    //
    _gradientLayer.colors = colorArray;
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(1, 1);
    
    // shapeLayer
    
    _shaperMaskLayer = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150) radius:70 startAngle:M_PI*0.5 endAngle:M_PI clockwise:NO];
    _shaperMaskLayer.path = bezierPath.CGPath;
    _shaperMaskLayer.lineWidth = 10;
    _shaperMaskLayer.lineCap = kCALineCapRound;
    _shaperMaskLayer.fillColor = [UIColor clearColor].CGColor;
    _shaperMaskLayer.strokeColor = [UIColor blueColor].CGColor;
    _gradientLayer.mask = _shaperMaskLayer;

    _checkMaskLayer =  [CAShapeLayer layer];
    UIBezierPath *checkPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150) radius:70 startAngle:M_PI*0.5 endAngle:M_PI clockwise:NO];
    [checkPath addLineToPoint:CGPointMake(120, 190)];
    [checkPath addLineToPoint:CGPointMake(220, 50)];
    _checkMaskLayer.path = checkPath.CGPath;
    _checkMaskLayer.lineWidth = 10;
    _checkMaskLayer.lineCap = kCALineCapRound;
    _checkMaskLayer.fillColor = [UIColor clearColor].CGColor;
    _checkMaskLayer.strokeColor = [UIColor blueColor].CGColor;
    _checkMaskLayer.strokeStart = 0;
    _checkMaskLayer.strokeEnd = 0.59;

    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"success" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(begin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *loadbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loadbutton setTitle:@"load" forState:UIControlStateNormal];
    [loadbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [loadbutton addTarget:self action:@selector(begin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadbutton];
    
    button.frame = CGRectMake(20, 200, 80, 40);
    loadbutton.frame = CGRectMake(150, 200, 80, 40);
    
}

- (void)begin {
    if (!_timer) {
        __block CGFloat percent = 0.0;
        __block NSInteger count = 0;
        _timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            _gradientLayer.transform = CATransform3DRotate(CATransform3DIdentity, -M_PI * (percent += 0.2), 0, 0, 1);
            count++;
            NSLog(@"%@,%@",@(percent),@(count));
            if (_check && (count%5 == 0 && count/5%2 == 0)) {
                [_timer setFireDate:[NSDate distantFuture]];
                [self checkAnimation];
            }
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer setFireDate:[NSDate distantPast]];
        
    }else{
        _check = !_check;
        if (!_check) {
            [_timer setFireDate:[NSDate distantPast]];
        }
    }
}


- (void)circleEnd {
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    rotate.toValue = @(1);
    rotate.removedOnCompletion=NO;
    rotate.fillMode=kCAFillModeForwards;
    rotate.delegate = self;
    rotate.duration = 0.75;
    rotate.autoreverses=NO;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [rotate setValue:@"loadingAnimation" forKey:@"animationName"];
    [_shaperMaskLayer addAnimation:rotate forKey:@"circleEnd"];
}

- (void)checkAnimation {
    _gradientLayer.mask = _checkMaskLayer;
    _checkMaskLayer.strokeEnd = 1;
    _checkMaskLayer.strokeStart = 0.59;

    CABasicAnimation *checkEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkEnd.fromValue = @(0.59);
    checkEnd.removedOnCompletion=NO;
    checkEnd.fillMode=kCAFillModeForwards;
    checkEnd.delegate = self;
    checkEnd.autoreverses=NO;
    checkEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CABasicAnimation *checkStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    checkStart.fromValue = @(0);
    checkStart.fillMode=kCAFillModeForwards;
    checkStart.delegate = self;
    checkStart.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:checkEnd,checkStart, nil];
    groupAnimation.delegate = self;
    groupAnimation.duration = 0.5f;
    groupAnimation.fillMode=kCAFillModeForwards;
    [_checkMaskLayer addAnimation:groupAnimation forKey:@"check"];
}


- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
