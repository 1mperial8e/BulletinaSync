//
//  AppDelegate.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "AppDelegate.h"
#import "APIClient.h"

// Controllers
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    LoginViewController *loginController = [LoginViewController new];
	UINavigationController *loginNavigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = loginNavigationController;
    [self.window makeKeyAndVisible];
	
	[APIClient sharedInstance];
    
    return YES;
}

@end
