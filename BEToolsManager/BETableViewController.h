//
//  BETableViewController.h
//  BEToolsManager
//
//  Created by ihefe26 on 15/9/23.
//  Copyright (c) 2015年 zhangliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "UIImageView+WebCache.h"

@interface BETableViewController : UITableViewController<EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL reloading;
    NSTimer *timer;
    UIImageView *imgView;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewTest;


@property (strong, nonatomic) NSMutableArray *dataArr;



@end
