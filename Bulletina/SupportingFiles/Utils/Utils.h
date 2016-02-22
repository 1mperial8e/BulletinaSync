//
//  Utils.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

@interface Utils : NSObject

#pragma mark - Alert

+ (void)showErrorWithMessage:(NSString *)message;
+ (void)showWarningWithMessage:(NSString *)message;
+ (void)showErrorNoConnection;
+ (void)showErrorUnknown;
+ (void)showErrorForStatusCode:(NSInteger)statusCode;
+ (void)showLocationErrorOnViewController:(UIViewController *)viewController;

#pragma mark - String

+ (BOOL)isValidEmail:(NSString *)email UseHardFilter:(BOOL)filter;
+ (BOOL)isValidName:(NSString *)name;
+ (BOOL)isValidUserName:(NSString *)userName;
+ (BOOL)isValidPassword:(NSString *)password;

#pragma mark - UI

+ (void)setStatusBarColor:(UIColor *)color;

#pragma mark - Defaults

+ (void)storeValue:(id)value forKey:(NSString *)key;

#pragma mark - Controllers

+ (UIViewController *)topViewController;

#pragma mark - Image

+ (UIImage *)scaledImage:(UIImage *)srcImage;

@end
