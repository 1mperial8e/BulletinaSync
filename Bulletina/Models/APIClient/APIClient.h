//
//  APIClient.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClientConstants.h"
#import "UserModel.h"

@interface APIClient : NSObject

@property (assign, nonatomic) NetworkStatus networkStatus;
@property (assign, nonatomic) APIEnvironment apiEnviroment;

@property (strong, nonatomic) NSString *pushToken;
@property (strong, nonatomic, readonly) NSString *passtoken;
@property (assign, nonatomic, readonly) CGFloat requestStartDelay;

@property (strong, nonatomic, readonly) UserModel *currentUser;

+ (instancetype)sharedInstance;

- (void)cancelAllOperations;
- (BOOL)hasActiveRequest;

- (void)updateCurrentUser:(id)newUser;
- (void)updatePasstoken:(NSString *)newPasstoken;
- (void)updatePasstokenWithDictionary:(NSDictionary *)newDictionary;

#pragma mark - Parameters

- (NSDictionary *)deviceParameters;
- (id)multipartFileWithContents:(NSData *)contents fileName:(NSString *)fileName mimeType:(NSString *)mimeType parameterName:(NSString *)parameterName;

#pragma mark - Reachability

- (void)startMonitoringNetwork;
- (void)stopMonitoringNetwork;

#pragma mark - API

- (NSURLSessionDataTask *)performPOST:(NSString *)path withParameters:(NSDictionary *)parameters response:(ResponseBlock)completionHandler;
- (NSURLSessionDataTask *)performPOST:(NSString *)path withParameters:(NSDictionary *)parameters multipartData:(NSArray *)dataArray response:(ResponseBlock)completionHandler;
- (NSURLSessionDataTask *)performPUT:(NSString *)path withParameters:(NSDictionary *)parameters response:(ResponseBlock)completionHandler;
- (NSURLSessionDataTask *)performPUT:(NSString *)path withParameters:(NSDictionary *)parameters multipartData:(NSArray *)dataArray response:(ResponseBlock)completionHandler;
- (NSURLSessionDataTask *)performGET:(NSString *)path withParameters:(NSDictionary *)parameters response:(ResponseBlock)completionHandler;
- (NSURLSessionDataTask *)performDELETE:(NSString *)path withParameters:(NSDictionary *)parameters response:(ResponseBlock)completionHandler;

@end

