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
#define Device [UIDevice currentDevice]

#define ScreenSize [UIScreen mainScreen].bounds
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define HeigthCoefficient ScreenHeight / 667
#define MaxSearchArea 30 //km

#ifdef DEBUG
#define DLog(format, ...) NSLog(format, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

//MARK: UserDefaults
static NSString *const CurrentUserKey = @"CurrentUserKey";
static NSString *const PassTokenKey = @"PassTokenKey";
static NSString *const SNSEndpointArnKey = @"SNSEndpointArnKey";
static NSString *const CategoriesListKey = @"CategoriesListKey";
static NSString *const ReportReasonsListKey = @"ReportReasonsListKey";

static NSString *const SearchAreaKey = @"SearchAreaKey";
static NSString *const ShowPersonalAdsKey = @"ShowPersonalAdsKey";
static NSString *const ShowBusinessAdsKey = @"ShowBusinessAdsKey";
static NSString *const CategoriesSettingsKey = @"CategoriesSettingsKey";

//MARK: Amazon
static NSString *const AWSCredentialAccessKey = @"AKIAJ4V7INSUGVJNLYJQ";
static NSString *const AWSCredentialAccessSecret = @"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";
static NSString *const AWSArn = @"arn:aws:sns:eu-west-1:794544298113:app/APNS_SANDBOX/bulletina_app_ios";

// Notifications
static NSString *const ItemNotificaionKey = @"ItemNotificaionKey";
static NSString *const ItemIDNotificaionKey = @"ItemIDNotificaionKey";

static NSString *const DeletedItemNotificaionName = @"DeletedItemNotificaionName";
static NSString *const UpdatedItemNotificaionName = @"UpdatedItemNotificaionName";
static NSString *const FavouritedItemNotificaionName = @"FavouritedItemNotificaionName";
static NSString *const UnfavouritedItemNotificaionName = @"UnfavouritedItemNotificaionName";
static NSString *const SettingsChangedNotificaionName = @"SettingsChangedNotificaionName";

#endif /* Constants_h */
