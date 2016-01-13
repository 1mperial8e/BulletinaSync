//
//  APIClient.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClientConstants.h"

@interface APIClient : NSObject

@property (assign, nonatomic) NetworkStatus networkStatus;
@property (assign, nonatomic) APIEnvironment apiEnviroment;

@property (strong, nonatomic) NSString *pushToken;

@property (strong, nonatomic, readonly) id currentUser;

+ (instancetype)sharedInstance;

- (void)cancelAllOperations;
- (BOOL)hasActiveRequest;

- (void)updateCurrentUser:(id)newUser;

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

