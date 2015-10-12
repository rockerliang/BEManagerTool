//
//  BEAnimationTestViewController.m
//  BEToolsManager
//
//  Created by ihefe26 on 15/10/10.
//  Copyright (c) 2015年 zhangliang. All rights reserved.
//

#import "BEAnimationTestViewController.h"

@interface BEAnimationTestViewController ()

@end

@implementation BEAnimationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     *画虚线圆
     */
    CAShapeLayer *dotteLine =  [CAShapeLayer layer];
    CGMutablePathRef dottePath =  CGPathCreateMutable();
    dotteLine.lineWidth = 2.0f ;
    dotteLine.strokeColor = [UIColor orangeColor].CGColor;
    dotteLine.fillColor = [UIColor clearColor].CGColor;
    CGPathAddEllipseInRect(dottePath, nil, CGRectMake(50.0f,  50.0f, 200.0f, 200.0f));
    dotteLine.path = dottePath;
    NSArray *arr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
    dotteLine.lineDashPhase = 1.0;
    dotteLine.lineDashPattern = arr;
    CGPathRelease(dottePath);
    //[self.view.layer addSublayer:dotteLine];
    
    /*
     *画实线圆
     */
//    solidLine =  [CAShapeLayer layer];
//    CGMutablePathRef solidPath =  CGPathCreateMutable();
//    solidLine.lineWidth = 2.0f ;
//    solidLine.strokeColor = [UIColor orangeColor].CGColor;
//    solidLine.fillColor = [UIColor orangeColor].CGColor;
//    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(50.0f,  300.0f, 20.0f, 20.0f));
//    solidLine.path = solidPath;
//    CGPathRelease(solidPath);
//    
//    [self.view.layer addSublayer:solidLine];
//    
//    
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//    rotationAnimation.duration = 1.0f;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = 1000;
//    [solidLine setValue:[NSNumber numberWithInt:600] forKeyPath:@"transform.rotation.z"];
//
//    [solidLine addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    yuanview = [[YuanView alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
    [self.view addSubview:yuanview];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(roteYuan) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    
}

-(void)roteYuan
{
    yuanview.transform = CGAffineTransformRotate(yuanview.transform, M_2_PI);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
