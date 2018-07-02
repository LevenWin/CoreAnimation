//
//  StringView.m
//  sliderLayer
//
//  Created by leven on 2018/6/12.
//  Copyright © 2018年 leven. All rights reserved.
//

#import "StringView.h"
#import "StringLayer.h"
@interface StringView()
@property (nonatomic, strong) StringLayer *stringLayer;
@end
@implementation StringView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.stringLayer = [StringLayer layer];
    [self.layer addSublayer:self.stringLayer];
    self.backgroundColor = [UIColor darkGrayColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.stringLayer.frame = self.bounds;
    self.stringLayer.controlPoint = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.stringLayer.controlPoint = [touches.anyObject locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.stringLayer.controlPoint = [touches.anyObject locationInView:self];

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.stringLayer.controlPoint = [touches.anyObject locationInView:self];
    [self.stringLayer animateToOriginalPoint];

}

-  (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.stringLayer.controlPoint = [touches.anyObject locationInView:self];
    [self.stringLayer animateToOriginalPoint];
}



@end
