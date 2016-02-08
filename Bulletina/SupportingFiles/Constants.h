//
//  Constants.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define Application [UIApplication sharedApplication]
#define Defaults [NSUserDefaults standardUserDefaults]
#define Bundle [NSBundle mainBundle]
#define FileManager [NSFileManager defaultManager]

#define ScreenSize [UIScreen mainScreen].bounds
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define HeigthCoefficient ScreenHeight / 667

#ifdef DEBUG
#define DLog(format, ...) NSLog(format, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

//MARK: UserDefaults
static NSString *const CurrentUserKey = @"CurrentUserKey";
static NSString *const SNSEndpointArnKey = @"SNSEndpointArnKey";

//MARK: Amazon
static NSString *const AWSCredentialAccessKey = @"AKIAJ4V7INSUGVJNLYJQ";
static NSString *const AWSCredentialAccessSecret = @"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";
static NSString *const AWSArn = @"arn:aws:sns:eu-west-1:794544298113:app/APNS_SANDBOX/bulletina_app_ios";

#endif /* Constants_h */
