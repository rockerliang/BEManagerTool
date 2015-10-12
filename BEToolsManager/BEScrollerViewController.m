//
//  BEScrollerViewController.m
//  BERealmDemo
//
//  Created by Rocker_Command on 15/9/26.
//  Copyright (c) 2015年 Rocker_Command. All rights reserved.
//

#import "BEScrollerViewController.h"

@interface BEScrollerViewController ()

@end

@implementation BEScrollerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建view （view中包含UIScrollView、UIPageControl，设置frame）
    _whView = [[BEScrollAndPageView alloc] initWithFrame:CGRectMake(0, 44, 320, 400)];

    //把N张图片放到imageview上
    NSMutableArray *tempAry = [NSMutableArray array];
    for (int i=1; i<6; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d",i]];
        [tempAry addObject:imageView];
    }
    //把imageView数组存到whView里
    [_whView setImageViewAry:tempAry];
    
    //把图片展示的view加到当前页面
    [self.view addSubview:_whView];
    
    //开启自动翻页
    [_whView shouldAutoShow:YES];
    
    //遵守协议
    _whView.delegate = self;
}

#pragma mark 协议里面方法，点击某一页
-(void)didClickPage:(BEScrollAndPageView *)view atIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld页",(long)index);
}
#pragma mark 界面消失的时候，停止自动滚动
-(void)viewDidDisappear:(BOOL)animated
{
    [_whView shouldAutoShow:NO];
}
@end