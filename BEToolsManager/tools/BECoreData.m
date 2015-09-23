//
//  BECoreData.m
//  BEToolsManager
//
//  Created by ihefe26 on 15/9/22.
//  Copyright (c) 2015年 zhangliang. All rights reserved.
//

#import "BECoreData.h"

@implementation BECoreData
static BECoreData *coreData = nil;

+(instancetype)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreData = [[BECoreData alloc] init];
    });
    return coreData;
}


-(id)init {
    
    if (self = [super init]) {
        // init code
    }
    return self;
}


+ (instancetype)alloc
{
    if (coreData) {
        return coreData;
    }
    return [super alloc];
}

- (id)copy
{
    if (coreData) {
        return coreData;
    }
    return [super copy];
}

-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return  _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
        
    if (_persistentStoreCoordinator != nil) {
        
        return _persistentStoreCoordinator;
        
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *folderPath = [NSString stringWithFormat:@"%@/Calendar",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    
    if(![fileManager fileExistsAtPath:folderPath]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    NSLog(@"本地数据库路径:%@",folderPath);
    
    NSURL *storeURL = [NSURL fileURLWithPath:[folderPath stringByAppendingPathComponent:@"BECoreData.sqlite"]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSNumber numberWithBool:YES],
                             
                             NSMigratePersistentStoresAutomaticallyOption,
                             
                             [NSNumber numberWithBool:YES],
                             
                             NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        abort();
        
    }
    
    return _persistentStoreCoordinator;
}
-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator =[self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc]init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

-(void) insertBasicInfo:(NSMutableDictionary *)dic
{
    NSManagedObjectContext *context = [self managedObjectContext];
    //让CoreData在上下文中创建一个新对象(托管对象)
    TestTable *basicInfo = (TestTable *)[NSEntityDescription insertNewObjectForEntityForName:@"TestTable" inManagedObjectContext:context];
    [basicInfo setTest1:@"13"];
    [basicInfo setTest2:@"24"];
    NSError *error;
    //托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    BOOL isSaveSuccess = [context save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else {
        NSLog(@"SaveBasicInfo successful!");
    }
}

-(NSMutableArray *) queryBasicInfo:(NSMutableDictionary *)dic
{
    NSManagedObjectContext *context = [self managedObjectContext];
    //创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TestTable"inManagedObjectContext:context];
    //设置请求实体
    [request setEntity:entity];
    
    //查询条件
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"test1==%@",@"13"];
    [request setPredicate:predicate];
    
    //指定对结果的排序方式
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createDate"ascending:NO];
//    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
//    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    NSMutableArray *entries = mutableFetchResult;
    NSLog(@"The count of tableBasicInfo:%lu",(unsigned long)[entries count]);
    NSMutableArray *arr = [NSMutableArray array];
    TestTable *tabke = entries[0];
    [arr addObject:tabke];
    return arr;
}

-(BOOL)deletetest:(NSString *)test
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"TestTable" inManagedObjectContext:context];
    [request setEntity:user];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"test1==%@",test];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of tableBasicInfo: %lu",(unsigned long)[mutableFetchResult count]);
    for (TestTable* test in mutableFetchResult) {
        [context deleteObject:test];
    }
    if ([context save:&error]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
        return YES;
    }
    return NO;
}

@end
