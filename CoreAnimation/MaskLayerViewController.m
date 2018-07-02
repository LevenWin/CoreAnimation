//
//  MaskLayerViewController.m
//  CoreAnimation
//
//  Created by leven on 2018/1/24.
//  Copyright © 2018年 leven. All rights reserved.
//

#import "MaskLayerViewController.h"
#define KSCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define KSCREENHEIGHT  [UIScreen mainScreen].bounds.size.height

@interface MaskLayerViewController ()<CAAnimationDelegate>
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) CALayer *colorLayer;
@end

@implementation MaskLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT);
    [self.view.layer addSublayer:self.colorLayer];
    
    self.colors = @[[UIColor yellowColor],
                    [UIColor darkGrayColor],
                    [UIColor redColor],
                    [UIColor orangeColor],
                    [UIColor blackColor],
                    [UIColor blueColor],
                    [UIColor grayColor],
                    [UIColor greenColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *wsip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:wsip];
    [tap requireGestureRecognizerToFail:wsip];
}

- (void)tapAction:(UIGestureRecognizer *)gesture {
    UIColor *color = self.colors[(int)(arc4random_uniform(self.colors.count))];
    self.colorLayer.backgroundColor = color.CGColor;
    CGPoint point = [gesture locationInView:self.view];
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x, point.y, 2, 2)];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithArcCenter:point radius:sqrtf(KSCREENHEIGHT * KSCREENHEIGHT + KSCREENWIDTH * KSCREENWIDTH) startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = toPath.CGPath;
    self.colorLayer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.fromValue = (__bridge id)(startPath.CGPath);
    animation.toValue = (__bridge id)((toPath.CGPath));
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:animation forKey:@"mask"];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        self.view.backgroundColor = [UIColor colorWithCGColor:self.colorLayer.backgroundColor];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
