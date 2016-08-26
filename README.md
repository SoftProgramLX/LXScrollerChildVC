# LXScrollerChildVC
实现横向类似tableView功能，仿新闻首页标签栏和内容均可滚动，此demo适用于每个界面不用复用的情形。

假如标签栏有很多标签，但是所有标签展示的页面的布局几乎都不一样，那么采用缓存机制也达不到优化的作用，因为缓存池里几乎装下了所有页面。这种情况采用类似懒加载的原理，scrollerView里最多只有三个view，滑动时创建新的view，及时将远离的view移除掉。这里的view采用的是子控制器的view。在初始化自定义控件时不能创建好子控制器传入，这样就会一直占用内存，我采用了传入类名的字符串方式，动态的去创建子类。

先看一下如下效果图：
![1499A456-6270-44FD-B4AD-1D8EA1FB8EF6.png](http://upload-images.jianshu.io/upload_images/301102-1d7b9e66ff98837a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


关键代码如下：
```objective-c
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
```

在滑动内容view或点击标签按钮时都会掉用上面的方法，通过掉用下面的方法创建新的viewCell.
```objective-c
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
```

通过代码if (labs(lastIndex-index) >= 2)判断不是当前界面位置左或右的控制器视图都将其引用全部删除。

集成这个控件相对简单，主控制器须继承ScrollerChildsController类，代码如下：
```objective-c
//RootViewController.h
@interface RootViewController : ScrollerChildsController
@end

//RootViewController.m
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
```
所有子控制器也需要继承ChildBaseController，然后重载父类方法，如下：
```objective-c
- (void)downloadData
{
    self.label.text = [NSString stringWithFormat:@"这是OneDetailController\n第 %ld 页", (long)self.index];
}
```
demo的标签栏可以由属性titleCanScroll设置能否滚动。

