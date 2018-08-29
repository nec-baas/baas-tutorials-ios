//
//  AppDelegate.m
//  NebulaTutorial1
//  Copyright (c) 2014-2018, NEC Corporation. All rights reserved.
//

#import "AppDelegate.h"
#import "Config.h"

#import <NecBaas/Nebula.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Nebula 初期化処理
    [NBCore setUpWithAppId:APP_ID appKey:APP_KEY tenantId:TENANT_ID];
    [NBCore setEndPointUri:ENDPOINT_URI];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
