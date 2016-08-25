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
    self.label.text = [NSString stringWithFormat:@"这是OneDetailController\n第 %ld 页", (long)self.index];
}

@end
