//
//  ViewController.m
//  TestChildVC
//
//  Created by 李旭 on 16/8/24.
//  Copyright © 2016年 LX. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.title = @"ScrollerChildVCs";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.800 green:0.600 blue:0.800 alpha:0.5]];

    self.titleCanScroll = YES;
    
    NSMutableArray *titleArr = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [titleArr addObject:[NSString stringWithFormat:@"title_%d", i]];
    }
    self.titleArray = titleArr;
    
    NSMutableArray *vcArr = [NSMutableArray array];
    for (int i = 0; i < self.titleArray.count; i++) {
        if (i%2 == 0) {
            [vcArr addObject:@"OneDetailController"];
        } else {
            [vcArr addObject:@"TwoDetailController"];
        }
    }
    self.controllerArray = vcArr;
}

@end



