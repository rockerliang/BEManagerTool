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
    for(int i = 0; i < 15;i ++)
    {
        [self.dataArr addObject:[NSString stringWithFormat:@"%d",i]];
    }

    self.tableViewTest.delegate = self;
    
    [self addRefreshView];
  
    [self loadDataByNewPOST];
    [self loadDataByNetGET];
}

-(void)loadDataByNewPOST
{
    //异步的
    // 1.创建请求
    NSURL *url = [NSURL URLWithString:@"http://192.168.10.108:50002/follow_up"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 3.设置请求体
    NSDictionary *json = @{
                            @"patient_id"   : @"123",
                            @"patient_name" : @"小老头",
                            @"relationship" : @"还好"
                          };
    //  NSData --> NSDictionary
    // NSDictionary --> NSData
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%d", data.length);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"respond:%@,dic:%@",response,dic);
    }];
}

-(void)loadDataByNetGET
{
    
    //**********GET*********//
    //    1.设置请求路径
    NSString *urlStr=[NSString stringWithFormat:@"http://192.168.10.108:50002/follow_up"];
    NSURL *url=[NSURL URLWithString:urlStr];
//
//    //    2.创建请求对象
   NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//    NSLog(@"%@",dic);

    //**********异步请求GET
    //异步链接(形式1,较少用)
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       // self.imageView.image = [UIImage imageWithData:data];
            // 解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", dic);
            }];
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentity = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    if(indexPath.row == self.dataArr.count)
    {
        cell.textLabel.text = @"加载更多";
    }else
    {
        cell.textLabel.text = self.dataArr[indexPath.row];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.dataArr.count)
    {
        [self loadMore];
    }
}

#pragma -mark 加载更多
-(void)loadMore
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i = 15; i < 30; i++)
        {
            [self.dataArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableViewTest reloadData];
        });
    });
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
