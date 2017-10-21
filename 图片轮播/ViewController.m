//
//  ViewController.m
//  图片轮播
//
//  Created by LongCh on 2017/10/8.
//  Copyright © 2017年 LongCh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat imageW = self.scrollView.frame.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    CGFloat imageY = 30;
    //循环加载图片
    for (int i=0; i<8; ++i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *imgName = [NSString stringWithFormat:@"%02d",i+1];
        imageView.image = [UIImage imageNamed:imgName];
        CGFloat imageX = i * 375;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [self.scrollView addSubview:imageView];
    }
    CGFloat maxW = self.scrollView.frame.size.width * 8;
    //设置scrollView.contentSize
    self.scrollView.contentSize =CGSizeMake(maxW, imageH);
    //实现分页
    self.scrollView.pagingEnabled = YES;
    //去除横向的滑块
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //设置pageControl的numberOfPages、currentPage属性，前者是有多少个page，后者是显示当前的哪个page
    self.pageControl.numberOfPages = 8;
    self.pageControl.currentPage = 0;
    //设置“计时器”Timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    //设置Timer的CPU处理的优先级与UI控件的一样
    //同时处理UI控件和改变Timer
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:self.timer forMode: NSRunLoopCommonModes];
    
    
}
- (void)scrollImage{
    NSInteger page = self.pageControl.currentPage;
    if(page == self.pageControl.numberOfPages - 1){
        page = 0;
    }else{
        page++;
    }
    CGFloat offsetx = page * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(offsetx, 0) animated:YES];
    //设置Timer的CPU处理的优先级与UI控件的一样
    //同时处理UI控件和改变Timer
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:self.timer forMode: NSRunLoopCommonModes];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    offsetX = offsetX + (scrollView.frame.size.width * 0.5);
    int temp = offsetX / scrollView.frame.size.width;
    self.pageControl.currentPage = temp;
}
//将要拖拽时移除计时器，
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;
}
//拖拽结束时 新建一个计时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
