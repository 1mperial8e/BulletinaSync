//
//  Utils.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "Utils.h"

@implementation Utils

#pragma mark - Alert

+ (void)showErrorWithMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

+ (void)showWarningWithMessage:(NSString *)message
{
    NSString *appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    [[[UIAlertView alloc] initWithTitle:appName message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

+ (void)showErrorNoConnection
{
    [self showErrorWithMessage:@"Please check your Internet connection and try again"];
}

+ (void)showErrorUnknown
{
    [self showErrorWithMessage:@"Something went wrong, please try again"];
}

+ (void)showErrorForStatusCode:(NSInteger)statusCode
{
    if (statusCode == NSURLErrorNotConnectedToInternet) {
        [self showErrorNoConnection];
    } else if (statusCode == NSURLErrorTimedOut) {
        [self showErrorWithMessage:@"Server is not responding"];
    } else if (statusCode == NSURLErrorCannotConnectToHost) {
        [self showErrorWithMessage:@"Could not connect to server"];
    } else if (statusCode == NSURLErrorCancelled) {
        // do nothing
    } else {
        [self showErrorUnknown];
    }
}

#pragma mark - String

+ (BOOL)isValidEmail:(NSString *)email UseHardFilter:(BOOL)filter
{
    BOOL stricterFilter = filter;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@{1}([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidName:(NSString *)name
{
    NSString *allowedSymbols = @"[a-zA-z]+([ '-][a-zA-Z]+)*$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allowedSymbols];
    return [test evaluateWithObject:name];
}

+ (BOOL)isValidUserName:(NSString *)userName
{
    NSString *allowedSymbols = @"[A-Za-z0-9-]+";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allowedSymbols];
    return [test evaluateWithObject:userName];
}

+ (BOOL)isValidPassword:(NSString *)password
{
    NSString *allowedSymbols = @"[A-Za-z0-9]+";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allowedSymbols];
    return [test evaluateWithObject:password];
}

#pragma mark - UI

+ (void)setStatusBarColor:(UIColor *)color
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    id statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"_statusBarWindow"];
    NSString *statusBarWindowClassString = NSStringFromClass([statusBarWindow class]);
    if ([statusBarWindowClassString isEqualToString:@"UIStatusBarWindow"]) {
        NSArray *statusBarWindowSubviews = [statusBarWindow subviews];
        for (UIView *statusBarWindowSubview in statusBarWindowSubviews) {
            NSString *statusBarWindowSubviewClassString = NSStringFromClass([statusBarWindowSubview class]);
            if ([statusBarWindowSubviewClassString isEqualToString:@"UIStatusBar"]) {
                [statusBarWindowSubview setBackgroundColor:color];
            }
        }
    }
}

#pragma mark - Defaults

+ (void)storeValue:(id)value forKey:(NSString *)key
{
    NSParameterAssert(value);
    NSParameterAssert(key);
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Controllers

+ (UIViewController *)topViewController
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIViewController *controller = window.rootViewController;
    return controller;
}

@end