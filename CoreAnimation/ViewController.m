//
//  ViewController.m
//  CoreAnimation
//
//  Created by leven on 2018/1/24.
//  Copyright © 2018年 leven. All rights reserved.
//

#import "ViewController.h"
#import "MaskLayerViewController.h"
#import "ColorsLoadingViewController.h"
#import "PlayViewController.h"
#import "StringViewController.h"

static NSString *const kMaskLayerCellKey = @"kMaskLayerCellKey";
static NSString *const kColorLoadingLayerCellKey = @"kColorLoadingLayerCellKey";
static NSString *const kPlayLayerCellKey = @"kPlayLayerCellKey";
static NSString *const kStringLayerCellKey = @"kStringLayerCellKey";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation ViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_initUI];
}
#pragma mark - Private
- (void)p_initUI {
    self.titles = @[kMaskLayerCellKey,
                    kColorLoadingLayerCellKey,
                    kPlayLayerCellKey,
                    kStringLayerCellKey];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - Actions

#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellKey = _titles[indexPath.row];
    if ([cellKey isEqualToString:kMaskLayerCellKey]) {
        MaskLayerViewController *vc = [[MaskLayerViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([cellKey isEqualToString:kColorLoadingLayerCellKey]){
        ColorsLoadingViewController *vc = [[ColorsLoadingViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([cellKey isEqualToString:kPlayLayerCellKey]) {
        PlayViewController *vc = [[PlayViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([cellKey isEqualToString:kStringLayerCellKey]) {
        StringViewController *vc = [[StringViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}


#pragma mark - delegate

#pragma mark - Public

#pragma mark - Custom Accessors

#pragma mark - Lazy Load

#pragma mark - Other


@end
