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

//MARK: Amazon
static NSString *const AWSCredentialAccessKey = @"AKIAJGGUYAFAJC7XOTDQ";
static NSString *const AWSCredentialAccessSecret = @"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";
static NSString *const AWSArn = @"arn:aws:sns:eu-west-1:340493393210:app/APNS/bulletina_general";

#endif /* Constants_h */
