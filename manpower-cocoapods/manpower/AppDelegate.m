//
//  AppDelegate.m
//  manpower
//
//  Created by hanjin on 14-5-23.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "AppDelegate.h"
#import "RLLoginVC.h"
#import "XMPPManager.h"
#import "RLBaseNC.h"
#import "RLBaseVC.h"
#import "RLMessageHomeVC.h"
#import "RLContactsHomeVC.h"
#import "RLAppHomeVC.h"
#import "RLMeHomeVC.h"
#import "Reachability.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "XMPPConnnectionManager.h"
#import "RLActivityVC.h"
#import "BaiduMobStat.h"

BOOL kReachability = NO;

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;
    statTracker.enableDebugOn = NO;
    statTracker.channelId = nil;
    statTracker.logStrategy = BaiduMobStatLogStrategyCustom;
    statTracker.logSendInterval = 1;
    statTracker.logSendWifiOnly = NO;
    statTracker.sessionResumeInterval = 10;
    statTracker.shortAppVersion = @"ZMChat-manpower";
    [statTracker startWithAppId:@"b4eda55218"];

    
#ifdef DEBUG
    // Configure logging framework
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
#else
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
#endif
    
    if (!iOS7) {
        [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    //消息
    RLBaseNC * messageHomeNC=[[RLBaseNC alloc] initWithRootViewController:
                              [[RLMessageHomeVC alloc] initWithNibName:nil bundle:nil]];
    //联系人
    RLBaseNC * contactHomeNC=[[RLBaseNC alloc] initWithRootViewController:
                              [[RLContactsHomeVC alloc] initWithNibName:nil bundle:nil]];
    //动态
//    RLBaseNC * activityNC =[[RLBaseNC alloc] initWithRootViewController:
//                              [[RLActivityVC alloc] initWithNibName:nil bundle:nil]];
    //我
    RLBaseNC * meHomeNC=[[RLBaseNC alloc] initWithRootViewController:
                              [[RLMeHomeVC alloc] initWithNibName:nil bundle:nil]];
    
    self.tabVC=[[RLTBC alloc]initWithNibName:nil bundle:nil];
    self.tabVC.viewControllers=@[messageHomeNC,contactHomeNC,meHomeNC];
//    self.tabVC.viewControllers=@[messageHomeNC,contactHomeNC,activityNC,meHomeNC];
    self.tabVC.delegate=self;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.loginNC=[[RLBaseNC alloc]initWithRootViewController:[[RLLoginVC alloc]initWithNibName:nil bundle:nil]];
    self.window.rootViewController= self.loginNC;

    [self setupReachability];
    [XMPPConnnectionManager sharedXMPPConnnectionManager];
    self.pushNum=0;
    
    [self setupUI];
    [self.window makeKeyAndVisible];
    return YES;
}
/**
 *  功能:切换到主视图
 */

-(void)changeToRoot{
    self.window.rootViewController=self.tabVC;
    self.tabVC.selectedIndex = 0;
    [self.tabVC selectItemAtIndex:0];
}

/**
 *  功能:切换到登陆视图
 */

-(void)changeToLogin{
    self.window.rootViewController=self.loginNC;
}

#pragma mark -UINavigationControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    RLTBC *theTBC = (RLTBC *)tabBarController;
    if (theTBC.lastSelectedIndex != theTBC.selectedIndex) {
        theTBC.lastDifferentIndex = theTBC.lastSelectedIndex;
    }
    
    [theTBC selectItemAtIndex:theTBC.selectedIndex];
    [self.tabVC selectItemAtIndex:tabBarController.selectedIndex];
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
   //[[UIApplication sharedApplication] cancelLocalNotification:notification];
    self.pushNum=0;
    //收到本地通知，打开消息和通知界面
    [self.tabVC selectItemAtIndex:0];
    [self.tabVC setSelectedIndex:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
   
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    self.pushNum=0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            DDLogInfo(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"manpower" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"manpower.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        DDLogInfo(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Reachability
-(void)setupReachability{
    kReachability = YES;
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:
                           [NSString stringWithFormat:@"%@:%d",XMPP_HOST_DOMAIN,XMPP_HOST_PORT]];
    
//    struct sockaddr_in address;
//    memset(&address, 0, sizeof(address));
//    address.sin_family = AF_INET;
//    address.sin_len = sizeof(address);
//    address.sin_port = htons(XMPP_HOST_PORT);
//    address.sin_addr.s_addr = htonl(inet_addr("192.168.102.119"));
//    Reachability* reach = [Reachability reachabilityWithAddress:&address];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络连接已断开，请在网络环境好的时候重试。" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        dispatch_async(dispatch_get_main_queue(), ^{
            DDLogVerbose(@"REACHABLE!");
            kReachability = YES;
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            DDLogVerbose(@"UNREACHABLE!");
            kReachability = YES;
//            [alert show];
        });
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}


/**
 *  设置navigationBar, tabBar, barButtonItem, segmentControl, 兼容 iOS6 iOS7
 */
- (void)setupUI{
    /* ************************************
     * navigationBar, barButtonItem设置开始
     * ************************************/
    
//    UIColor *navigationBarColor = UIColorFromRGB(0xEE0000);     // 导航栏背景色
    
    // 设置Title字体大小，颜色
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{ NSForegroundColorAttributeName: [UIColor whiteColor],   // 导航栏文字颜色
        NSFontAttributeName: [UIFont boldSystemFontOfSize:20],  // 导航栏标题字体大小
        UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]}];    //导航栏标题文字阴影
    
    
    UIColor *barButtonItemColorHighlighted = [UIColor grayColor];   // 点击barButtonItem时，文字颜色
    
    
    if (!iOS7) {
        
        // 设置背景色
//        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:navigationBarColor size:CGSizeMake(1, 44)]
//                                           forBarMetrics:UIBarMetricsDefault];
        
        // iOS6 去掉UIBarButtonItem的圆角
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage new]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        
        // 设置返回按钮
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0)
                                                             forBarMetrics:UIBarMetricsDefault];
        
        // iOS6 去掉BackButtonItem的圆角
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:
         [[UIImage imageNamed:@"icon-left-arrow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 0)]
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
        
        barButtonItemColorHighlighted = [UIColor lightGrayColor];
    }
    
//    [[UIBarButtonItem appearance] setbackbutton]
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     @{ UITextAttributeFont: [UIFont systemFontOfSize:17],
//        UITextAttributeTextColor: [UIColor whiteColor],
        UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]} forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     @{ UITextAttributeFont: [UIFont systemFontOfSize:17],
        UITextAttributeTextColor : barButtonItemColorHighlighted,
        UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]} forState:UIControlStateHighlighted];
    
    /* ************************************
     * navigationBar, barButtonItem设置结束
     * ************************************/
    
    /* ************************************
     * tabBar设置开始
     * ************************************/
     
//     UIColor *color = [];
//     //iOS6
//     [[UITabBarItem appearance] setTitleTextAttributes:
//     @{ UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
//     UITextAttributeTextColor: tabBarTintColor }
//     forState:UIControlStateSelected];
     /* ************************************
     * tabBar设置结束
     * ************************************/
}
@end
