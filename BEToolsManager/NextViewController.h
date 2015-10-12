//
//  NextViewController.h
//  BEToolsManager
//
//  Created by Rocker_Command on 15/9/24.
//  Copyright (c) 2015年 zhangliang. All rights reserved.
//

#import "ViewController.h"

typedef void (^blockTest)(NSString *text);

@interface NextViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *textf;


- (IBAction)backAct:(id)sender;

@property (strong, nonatomic) blockTest testT;

@end
