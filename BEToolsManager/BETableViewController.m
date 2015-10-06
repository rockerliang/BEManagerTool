//
//  BETableViewController.m
//  BEToolsManager
//
//  Created by ihefe26 on 15/9/23.
//  Copyright (c) 2015年 zhangliang. All rights reserved.
//

#import "BETableViewController.h"

@interface BETableViewController ()

@end

@implementation BETableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     //self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
    self.dataArr = [NSMutableArray array];
    for(int i = 0; i < 100;i ++)
    {
        [self.dataArr addObject:[NSString stringWithFormat:@"%d",i]];
    }

    self.tableViewTest.delegate = self;
    
    [self addRefreshView];
    
    
}

-(void)addRefreshView
{
    if (refreshHeaderView == nil) {
        refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0.0f - self.view.bounds.size.height, self.view.frame.size.width,self.view.bounds.size.height)];
        NSLog(@"%@",NSStringFromCGRect(refreshHeaderView.frame));
        refreshHeaderView.backgroundColor = [UIColor colorWithRed:253.0/255 green:253.0/255 blue:254.0/255 alpha:1];
        refreshHeaderView.delegate = self;
        [_tableViewTest addSubview:refreshHeaderView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDataArray
{
    for (int i = -1; i < 10; i ++) {
        [self.dataArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.tableViewTest reloadData];
    
        [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableViewTest];
        reloading = NO;
 

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArr.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentity = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
   // cell.imageView.image = nil;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *url=[NSURL URLWithString:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_1.jpg"];
//        NSData *data=[NSData dataWithContentsOfURL:url];
//        UIImage *image=[UIImage imageWithData:data];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            cell.imageView.image = image;
//        });
//
//    });
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 0, 100, 100)];
    [imgView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%d.jpg",indexPath.row]]];
    [cell addSubview:imgView1];
    
   // [cell addSubview:imgView];
    if(indexPath.row == self.dataArr.count)
    {
        cell.textLabel.text = @"加载更多";
    }else
    {
        cell.textLabel.text = self.dataArr[indexPath.row];
    }

    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.backgroundColor = [UIColor yellowColor];
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != self.dataArr.count)
    {
        [self performSegueWithIdentifier:@"gcdpush" sender:nil];
    }
}

#pragma mark - EGORefreshTableHeaderDelegate Methods
//下拉控件刷新触发事件
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark Data Source Loading / Reloading Methods
//下拉动作触发事件调用的函数。在这里发送数据请求
- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    NSLog(@"dragging!!!");
//    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doneLoadingTableViewData) userInfo:nil repeats:NO];
    [self loadData];
    reloading = YES;
    
}


-(void) loadData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.dataArr = [NSMutableArray array];
        for (int i = -1; i < 10; i ++) {
            [self.dataArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableViewTest reloadData];
            reloading = NO;
            [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableViewTest];
        });
       

    });
}
//请求结束函数。在这里要关闭下拉的视图.并更新表视图
- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    NSLog(@"stop loading");
    timer = nil;
    
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
