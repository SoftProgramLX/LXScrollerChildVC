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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"这是TwoDetailController\n第 %ld 页", (long)self.index];
    [self.view addSubview:label];
}

@end
