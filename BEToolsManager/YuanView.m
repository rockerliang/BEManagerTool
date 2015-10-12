//
//  YuanView.m
//  BEToolsManager
//
//  Created by ihefe26 on 15/10/10.
//  Copyright (c) 2015年 zhangliang. All rights reserved.
//

#import "YuanView.h"
#define PI 3.14159265358979323846

@implementation YuanView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色

    // Drawing code
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
//    CGContextAddArc(context, 100, 20, 15, 0, 2*PI, 0); //添加一个圆
//    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    //填充圆，无边框
    CGContextAddArc(context, 10, 10, 10, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);//绘制填充
//    
//    //画大圆并填充颜
//    UIColor*aColor = [UIColor redColor];
//    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
//    CGContextSetLineWidth(context, 3.0);//线的宽度
//    CGContextAddArc(context, 250, 40, 40, 0, 2*PI, 0); //添加一个圆
//    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
//    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}


@end
