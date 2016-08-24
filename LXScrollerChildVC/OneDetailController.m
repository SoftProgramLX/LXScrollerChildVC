//
//  DetailController.m
//  TestChildVC
//
//  Created by 李旭 on 16/8/24.
//  Copyright © 2016年 LX. All rights reserved.
//

#import "OneDetailController.h"
#import "ScrollChildHeader.h"

@implementation OneDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RANDOM_COLOR;
}

- (void)downloadData
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-74)/2.0, 200, 74, 44)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:[NSString stringWithFormat:@"第 %ld 页", (long)self.index] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

@end
