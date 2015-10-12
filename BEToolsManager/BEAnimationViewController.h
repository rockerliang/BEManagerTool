//
//  BEAnimationViewController.h
//  BEToolsManager
//
//  Created by ihefe26 on 15/10/8.
//  Copyright (c) 2015年 zhangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^hideView)(UIView *viewBlock);

@interface BEAnimationViewController : UIViewController
{
    UIView *viewAni;
    UIView *redView;
}

@property (strong, nonatomic) hideView hideBlock;

@end
