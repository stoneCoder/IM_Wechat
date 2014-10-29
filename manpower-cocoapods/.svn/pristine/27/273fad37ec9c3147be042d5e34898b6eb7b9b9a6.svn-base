//
//  AppDelegate.h
//  manpower
//
//  Created by hanjin on 14-5-23.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLTBC.h"
extern BOOL kReachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong,nonatomic) RLTBC * tabVC;
@property (strong,nonatomic) UINavigationController * loginNC;
@property (assign,nonatomic) int pushNum;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



-(void)changeToRoot;
-(void)changeToLogin;
@end
