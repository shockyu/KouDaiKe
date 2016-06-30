//
//  AppDelegate.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/11.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
#define UMENG_APPKEY @"55f3e6f6e0f55ae70d002214"

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) AFNetworkReachabilityStatus networkStatus;

//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;

@end

