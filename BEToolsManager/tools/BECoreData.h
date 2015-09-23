//
//  BECoreData.h
//  BEToolsManager
//
//  Created by ihefe26 on 15/9/22.
//  Copyright (c) 2015年 zhangliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TestTable.h"

@interface BECoreData : NSObject

+(instancetype) getInstance;

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//初始化Core Data使用的数据库
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator;
//managedObjectModel的初始化赋值函数
-(NSManagedObjectModel *)managedObjectModel;
//managedObjectContext的初始化赋值函数
-(NSManagedObjectContext *)managedObjectContext;



@end
