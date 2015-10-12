//
//  BEAnimationViewController.m
//  BEToolsManager
//
//  Created by ihefe26 on 15/10/8.
//  Copyright (c) 2015年 zhangliang. All rights reserved.
//

#import "BEAnimationViewController.h"

@implementation BEAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    viewAni = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.height / 2 - 100, 200, 200)];
    viewAni.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:viewAni];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animationWithView)];
    [viewAni addGestureRecognizer:tap];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 20, 80, 80);
    btn.layer.cornerRadius = 5.0f;
    btn.layer.borderWidth = 2.0f;
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(coreAnimationBase) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 20, 80, 80);
    btn1.layer.cornerRadius = 5.0f;
    btn1.layer.borderWidth = 2.0f;
    btn1.layer.borderColor = [UIColor yellowColor].CGColor;
    btn1.backgroundColor = [UIColor grayColor];
    [btn1 addTarget:self action:@selector(coreAninmationKey) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    NSOperationQueue *opreationQueue = [[NSOperationQueue alloc] init];
    NSBlockOperation *blockOpre1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1");
    }];
    NSBlockOperation *blockOpre2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2");
    }];
    NSBlockOperation *blockOpre3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3");
    }];
    NSBlockOperation *blockOpre4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"4");
    }];
    [blockOpre3 addDependency:blockOpre4];
    [blockOpre2 addDependency:blockOpre3];
    [blockOpre1 addDependency:blockOpre2];
    [opreationQueue addOperation:blockOpre1];
    [opreationQueue addOperation:blockOpre2];
    [opreationQueue addOperation:blockOpre3];
    [opreationQueue addOperation:blockOpre4];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"updateUI");
    }];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
       // [NSThread sleepForTimeInterval:1];
        NSLog(@"A");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"B");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"C");
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"UI");
    });
    
    //循环执行代码片段5次
    dispatch_apply(5, queue, ^(size_t index) {
        NSLog(@"123");
    });
}

-(void)coreAnimationBase
{
    //创建一个CABasicAnimation对象
    CABasicAnimation *animation=[CABasicAnimation animation];
    //设置颜色
    animation.toValue = (id)[UIColor blueColor].CGColor;
    //动画时间
    animation.duration = 1;
    //是否反转变为原来的属性值
    animation.autoreverses = YES;
    //把animation添加到图层的layer中，便可以播放动画了。forKey指定要应用此动画的属性
    [self.view.layer addAnimation:animation forKey:@"backgroundColor"];
    
}

-(void)coreAninmationKey
{
    //    CAKeyframeAnimation *animation=[CAKeyframeAnimation animation];
    //    //设置属性值
    //    animation.values=[NSArray arrayWithObjects:
    ////                      (id)[UIColor whiteColor].CGColor,
    //                      (id)[UIColor yellowColor].CGColor,
    //                      (id)[UIColor greenColor].CGColor,
    //                      (id)[UIColor blueColor].CGColor,nil];
    //
    //    animation.duration=3;
    //    animation.autoreverses=NO;
    //    //把关键帧添加到layer中
    //    [self.view.layer addAnimation:animation forKey:@"backgroundColor"];
    
    //初始化一个View，用来显示动画   最后移除掉
    redView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    redView.backgroundColor=[UIColor redColor];
    
    [self.view addSubview:redView];
    
    CAKeyframeAnimation *ani=[CAKeyframeAnimation animation];
    //初始化路径
    CGMutablePathRef aPath=CGPathCreateMutable();
    //动画起始点
    CGPathMoveToPoint(aPath, nil, 20, 20);
    CGPathAddCurveToPoint(aPath, nil,
                          160, 30,//控制点
                          220, 220,//控制点
                          240, 380);//控制点
    
    ani.path=aPath;
    ani.removedOnCompletion = NO;
    ani.autoreverses = YES;
    ani.duration=5;
    //设置为渐出
    ani.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //自动旋转方向
    ani.rotationMode=@"auto";
    
    [redView.layer addAnimation:ani forKey:@"position"];
    [self performSelector:@selector(hideredView) withObject:nil afterDelay:10.f];
    
    // [redView removeFromSuperview];
    
}

-(void)hideredView
{
    [redView removeFromSuperview];
}

-(void)animationWithView
{
    [UIView animateWithDuration:0.5f animations:^{
        viewAni.transform = CGAffineTransformScale(viewAni.transform, 0.5, 0.5);
        viewAni.transform = CGAffineTransformRotate(viewAni.transform, M_PI_2 );
        viewAni.transform = CGAffineTransformTranslate(viewAni.transform, 200, 0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
