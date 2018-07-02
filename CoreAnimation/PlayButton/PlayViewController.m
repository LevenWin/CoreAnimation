//
//  PlayViewController.m
//  CoreAnimation
//
//  Created by leven on 2018/6/29.
//  Copyright © 2018年 leven. All rights reserved.
//

#import "PlayViewController.h"
#import "PlayButton.h"

@interface PlayViewController ()
@property (strong, nonatomic) IBOutlet PlayButton *animationLayer;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sliderChange:(UISlider *)sender {
    [_animationLayer updatePercent:sender.value];
}
- (IBAction)stopClick:(id)sender {
    
}
- (IBAction)beginClick:(id)sender {
    
}
- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
