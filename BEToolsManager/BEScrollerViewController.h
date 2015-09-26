//
//  BEScrollerViewController.h
//  BERealmDemo
//
//  Created by Rocker_Command on 15/9/26.
//  Copyright (c) 2015年 Rocker_Command. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEScrollAndPageView.h"
#define NUM 10

@interface BEScrollerViewController : UIViewController<BEcrollViewViewDelegate>
{
    BEScrollAndPageView *_whView;
}

@end
