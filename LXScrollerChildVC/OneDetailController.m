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
    
    //在这里创建自己所需UI；
}

- (void)downloadData
{
    //可以不用父类的label，在ChildBaseController里删除
    self.label.text = [NSString stringWithFormat:@"这是OneDetailController\n第 %ld 页", (long)self.index];
}

@end
