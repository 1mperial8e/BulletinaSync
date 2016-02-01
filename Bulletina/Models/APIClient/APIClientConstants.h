//
//  APIClientConstants.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#ifndef APIClientConstants_h
#define APIClientConstants_h

typedef NS_ENUM (NSUInteger, APIEnvironment) {
    APIEnvironmentSandbox,
    APIEnvironmentProduction
};

typedef NS_ENUM (NSInteger, NetworkStatus) {
    NetworkStatusUnknown          = -1,
    NetworkStatusNotReachable     = 0,
    NetworkStatusReachableViaWWAN = 1,
    NetworkStatusReachableViaWiFi = 2,
};

typedef void(^ResponseBlock)(id response, NSError *error, NSInteger statusCode);

static NSString *const NetworkErrorDomain = @"com.bulletina.network.error";

static NSString *const APIBaseURLProduction = @"https://www.bulletina.com/";
static NSString *const APIBaseURLSandbox = @"http://api.bulletina.net/";

static NSString *const MultipartDataFileName = @"MultipartDataFileName";
static NSString *const MultipartDataFileMimeType = @"MultipartDataFileMimeType";
static NSString *const MultipartDataFileBytes = @"MultipartDataFileBytes";
static NSString *const MultipartDataParameterName = @"MultipartDataParameterName";

#endif /* APIClientConstants_h */
