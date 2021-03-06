
//  EXAppDelegate.m
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "EXAppDelegate.h"
#import "RACViewModelServicesImpl.h"
#import "RACNavigationControllerStack.h"

#import "EXRootViewModel.h"
#import "EXRACHTTPClient.h"
#import "EXLauncher.h"
#import "EXDevicePhone.h"

#import "EXTrade.h"

@interface EXAppDelegate ()

@property (nonatomic, strong) EXLauncher *launcher;

@property (nonatomic, strong) id<RACViewModelServices> services;

@property (nonatomic, strong) RACNavigationControllerStack *viewControllerStack;

@end

@implementation EXAppDelegate

- (id<RACViewModelServices>)services{
    if (!_services) {
        _services = [[RACViewModelServicesImpl alloc] initWithUnauthenticatedClient:[EXRACHTTPClient new]];
    }
    return _services;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.launcher = [[EXLauncher alloc] init];
    
    return [[self launcher] launchWithDevice:[EXDevicePhone device]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.viewControllerStack = [[RACNavigationControllerStack alloc] initWithServices:[self services]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[self services] resetRootViewModel:[[EXRootViewModel alloc] initWithServices:[self services] params:nil]];
    [[self window] makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
