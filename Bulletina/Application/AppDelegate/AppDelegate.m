//
//  AppDelegate.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "AppDelegate.h"
#import "APIClient.h"
#import "LocationManager.h"

// Controllers
#import "LoginViewController.h"
#import <BuddyBuildSDK/BuddyBuildSDK.h>

// Frameworks
#import <AWSSNS/AWSSNS.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [BuddyBuildSDK setup];
    [self setupSNS];
    [self setupDefaults];
	
	[APIClient sharedInstance];
	[LocationManager sharedManager];
    
    // Register for Push Notifications
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
    [application registerUserNotificationSettings:notificationSettings];
    [application registerForRemoteNotifications];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    LoginViewController *loginController = [LoginViewController new];
	UINavigationController *loginNavigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = loginNavigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [deviceToken description];
    token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [APIClient sharedInstance].pushToken = token;
    
    AWSSNSCreatePlatformEndpointInput *endPointInput = [[AWSSNSCreatePlatformEndpointInput alloc] init];
    endPointInput.platformApplicationArn = AWSArn;
    endPointInput.token = token;
    
    AWSSNS *sns = [AWSSNS defaultSNS];
    [[sns createPlatformEndpoint:endPointInput] continueWithBlock:^id _Nullable(AWSTask<AWSSNSCreateEndpointResponse *> * _Nonnull task) {
        if (task.error != nil) {
            NSLog(@"Error: %@",task.error);
        } else {
            AWSSNSCreateEndpointResponse *createEndPointResponse = task.result;
            AWSSNSGetEndpointAttributesInput *getEndpoints = [[AWSSNSGetEndpointAttributesInput alloc] init];
            getEndpoints.endpointArn = createEndPointResponse.endpointArn;
            
            if (getEndpoints.endpointArn.length) {
                [Utils storeValue:getEndpoints.endpointArn forKey:SNSEndpointArnKey];
            }
            [[sns getEndpointAttributes:getEndpoints] continueWithBlock:^id _Nullable(AWSTask<AWSSNSGetEndpointAttributesResponse *> * _Nonnull task2) {
                AWSSNSGetEndpointAttributesResponse *getEpAttribs = task2.result;
                if (![[getEpAttribs.attributes objectForKey:@"Enabled"] isEqualToString:@"true"]) {
                    AWSSNSSetEndpointAttributesInput *setEndpointAttributes = [[AWSSNSSetEndpointAttributesInput alloc] init];
                    setEndpointAttributes.attributes = @{@"Enabled" : @"true"};
                    setEndpointAttributes.endpointArn = createEndPointResponse.endpointArn;
                    
                    [[sns setEndpointAttributes:setEndpointAttributes] continueWithBlock:^id _Nullable(AWSTask * _Nonnull task3) {
                        return task3;
                    }];
                }
                return task2;
            }];
        }
        return task;
    }];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for remote notifications with error: %@",error);
}

#pragma mark - AmazonSNS

- (void)setupSNS
{
    AWSStaticCredentialsProvider *credentialsProvider = [[AWSStaticCredentialsProvider alloc] initWithAccessKey:AWSCredentialAccessKey secretKey:AWSCredentialAccessSecret];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUWest1 credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[[LocationManager sharedManager] startUpdatingLocation];
}

#pragma mark - Defaults

- (void)setupDefaults
{
    if (![Defaults valueForKey:SearchAreaKey]) {
        [Defaults setValue:@(0.5) forKey:SearchAreaKey];
        [Defaults setValue:@YES forKey:ShowBusinessAdsKey];
		[Defaults setValue:@YES forKey:ShowPersonaAdsKey];
    }
}

@end
