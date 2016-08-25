//
//  ScrollerChildsController.m
//  TestChildVC
//
//  Created by 李旭 on 16/8/24.
//  Copyright © 2016年 LX. All rights reserved.
//

#import "ScrollerChildsController.h"
#import "UIView+Extension.h"
#import "ChildBaseController.h"
#import "ScrollChildHeader.h"

@interface ScrollerChildsController ()<UIScrollViewDelegate>
{
    CGFloat titleWidth;
}

@property (nonatomic, weak) UIScrollView *titleScroll;      //顶部所有标签的view
@property (nonatomic, weak) UIButton *selectButton;         //记录选中的按钮
@property (nonatomic, weak) UIView *indicatorView;          //标签底部红色指示器
@property (nonatomic, strong) NSMutableArray *buttonArray;  //储存所有标签按钮
@property (nonatomic, weak) UIScrollView *contentView;      //内容视图
@property (nonatomic, copy) NSMutableDictionary *childVCDic;

@end

@implementation ScrollerChildsController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _buttonArray = [NSMutableArray array];
    _childVCDic = [NSMutableDictionary dictionary];
}

#pragma mark - Interface

- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    [self setupTitlesView];
}

- (void)setControllerArray:(NSArray *)controllerArray
{
    _controllerArray = controllerArray;
    [self setupContentView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    if (index != self.selectButton.tag-100) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        [self selectButton:index];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    if (self.controllerArray.count <= index) {
        return;
    }
    
    if (![self.childVCDic objectForKey:IntgerToStr(index)]) {
        [self createChildVCWithIndex:index];
    }
    for (int i = 0; i < self.childVCDic.allKeys.count; i++) {
        NSString *indexKey = self.childVCDic.allKeys[i];
        NSInteger lastIndex = [indexKey integerValue];
        ChildBaseController *vc = [self.childVCDic objectForKey:indexKey];

        if (labs(lastIndex-index) >= 2) {
            [vc.view removeFromSuperview];
//            [vc removeFromParentViewController];
            [self.childVCDic removeObjectForKey:indexKey];
            i--;
        } else if (lastIndex == index) {
            
            [vc downloadData];
        }
    }
}

#pragma mark - Enent response

- (void)titleClick:(UIButton *)button
{
    [UIView animateWithDuration:0 animations:^{
        self.contentView.contentOffset = CGPointMake(SCREEN_WIDTH*(button.tag-100), 0);
    }];
    [self selectButton:button.tag-100];
}

//选择某个标题
- (void)selectButton:(NSInteger)index
{
    [self.selectButton setTitleColor:DEFAULT_TITLE_COLOR forState:UIControlStateNormal];
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:14];

    if (self.buttonArray.count <= index) {
        return;
    }
    self.selectButton = self.buttonArray[index];
    [self.selectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [UIView animateWithDuration:.025 animations:^{
        self.indicatorView.x = titleWidth*index;
    }];
    
    if (self.titleCanScroll) {
        CGRect rect = [self.selectButton.superview convertRect:self.selectButton.frame toView:self.view];
        [UIView animateWithDuration:0 animations:^{
            self.indicatorView.x = titleWidth*index;
            CGPoint contentOffset = self.titleScroll.contentOffset;
            if (contentOffset.x - (SCREEN_WIDTH/2-rect.origin.x-titleWidth/2)<=0) {
                [self.titleScroll setContentOffset:CGPointMake(0, contentOffset.y) animated:YES];
            } else if (contentOffset.x - (SCREEN_WIDTH/2-rect.origin.x-titleWidth/2)+SCREEN_WIDTH>=_titleArray.count*titleWidth) {
                [self.titleScroll setContentOffset:CGPointMake(_titleArray.count*titleWidth-SCREEN_WIDTH, contentOffset.y) animated:YES];
            } else {
                [self.titleScroll setContentOffset:CGPointMake(contentOffset.x - (SCREEN_WIDTH/2-rect.origin.x-titleWidth/2), contentOffset.y) animated:YES];
            }
        }];
    }
}

#pragma mark - Private methods

/**
 *  设置顶部的标签栏
 */
- (void)setupTitlesView
{
    [self setTitleWidth];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*2, 64)];
    titleView.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [self.view addSubview:titleView];
    
    CGFloat scrollY = 0;
    if (self.navigationController.navigationBar) {
        scrollY = 64;
    }
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollY, 375, TITLE_HEIGHT)];
    scroll.contentSize = CGSizeMake(titleWidth*_titleArray.count, TITLE_HEIGHT);
    scroll.bounces = NO;
    scroll.scrollEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scroll];
    _titleScroll = scroll;
    
    for (int i = 0; i < _titleArray.count; i++) {
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(titleWidth*i, 0, titleWidth, TITLE_HEIGHT);
        [titleButton setTitle:_titleArray[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:DEFAULT_TITLE_COLOR forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        titleButton.backgroundColor = RANDOM_COLOR;
        titleButton.tag = 100+i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:titleButton];
        if (i == 0) {
            _selectButton = titleButton;
            [_selectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _selectButton.titleLabel.font = [UIFont systemFontOfSize:18];
        }
        [_buttonArray addObject:titleButton];
    }
    
    //    滑块
    UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(0, TITLE_HEIGHT-1, titleWidth, 1)];
    sliderV.backgroundColor = [UIColor redColor];
    [scroll addSubview:sliderV];
    self.indicatorView=sliderV;
}

- (void)setTitleWidth
{
    titleWidth = SCREEN_WIDTH/self.titleArray.count;
    if (self.titleCanScroll) {
        if (100*self.titleArray.count > SCREEN_WIDTH) {
            titleWidth = 100;
        } else {
            self.titleCanScroll = NO;
        }
    }
}

/**
 *  底部scrollerView
 */
- (void)setupContentView
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    CGFloat contentViewY = self.titleScroll.y + self.titleScroll.height;
    contentView.frame = CGRectMake(0, contentViewY, SCREEN_WIDTH, self.view.height - contentViewY);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.controllerArray.count, 0);
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

- (void)createChildVCWithIndex:(NSInteger)index
{
    ChildBaseController *vc = [[NSClassFromString(self.controllerArray[index]) alloc] init];
    vc.view.x = index * SCREEN_WIDTH;
    vc.view.y = 0;
    vc.view.height = self.contentView.height;
    vc.index = index;
    [self.contentView addSubview:vc.view];
//    [self addChildViewController:vc];
    [self.childVCDic setObject:vc forKey:IntgerToStr(index)];
}

@end


