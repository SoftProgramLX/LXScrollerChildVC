//
//  TwoDetailController.m
//  TestChildVC
//
//  Created by 李旭 on 16/8/24.
//  Copyright © 2016年 LX. All rights reserved.
//

#import "TwoDetailController.h"
#import "ScrollChildHeader.h"

@implementation TwoDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RANDOM_COLOR;
}

- (void)downloadData
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2.0, 200, 200, 44)];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:[NSString stringWithFormat:@"第 %ld 页", (long)self.index] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

@end
