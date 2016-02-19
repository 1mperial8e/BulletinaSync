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
	//temp
    [Defaults removeObjectForKey:CurrentUserKey];
    [Defaults removeObjectForKey:PassTokenKey];
	
    [BuddyBuildSDK setup];
    [self setupSNS];
    
    // Register for Push Notifications
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
    [application registerUserNotificationSettings:notificationSettings];
    [application registerForRemoteNotifications];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    LoginViewController *loginController = [LoginViewController new];
	UINavigationController *loginNavigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = loginNavigationController;
    [self.window makeKeyAndVisible];
	
	[APIClient sharedInstance];
	[LocationManager sharedManager];
    
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

@end
