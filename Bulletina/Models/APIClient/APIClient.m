//
//  APIClient.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient.h"
#import "AFNetworking.h"
#import "UserModel.h"

@interface APIClient ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic, readwrite) NSString *passtoken;

@end

@implementation APIClient

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupManager];
    }
    return self;
}

#pragma mark - Public

+ (instancetype)sharedInstance
{
    static APIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[APIClient alloc] init];
        [sharedClient loadCurrentUser];
    });
    return sharedClient;
}

- (void)cancelAllOperations
{
    [self.manager.operationQueue cancelAllOperations];
}

- (BOOL)hasActiveRequest
{
    return self.manager.operationQueue.operationCount;
}

- (void)updateCurrentUser:(id)newUser
{
    _currentUser = newUser;
}

- (void)updatePasstoken:(NSString *)newPasstoken
{
	_passtoken = newPasstoken;
    [Utils storeValue:_passtoken forKey:PassTokenKey];
}

- (void)updatePasstokenWithDictionary:(NSDictionary *)newDictionary
{
	id newObject = [newDictionary objectForKey:@"passtoken"];
	if (newObject && (NSNull *)newObject != [NSNull null]) {
		[self updatePasstoken:newObject];
	}
}

- (void)updateUserPasswordWithDictionary:(NSDictionary *)newDictionary
{
	id newObject = [newDictionary objectForKey:@"passwd"];
	if (newObject && (NSNull *)newObject != [NSNull null]) {
		_userPassword =  (NSString *)newObject;
	}
}

- (void)loadCurrentUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:CurrentUserKey]) {
        id user = [defaults objectForKey:CurrentUserKey];
        [self updateCurrentUser:[UserModel modelWithDictionary:user]];
    }
}

//temporary
+ (NSArray *)tempCategoriesList
{
	return  @[@"For sale", @"For rent", @"Give away", @"Job request", @"Services", @"Annoucement", @"Lost & found", @"Other"];
}

#pragma mark - Reachability

- (void)startMonitoringNetwork
{
    __weak typeof(self) weakSelf = self;
    [self.manager.reachabilityManager startMonitoring];
    [self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakSelf.networkStatus = (int)status;
    }];
    self.networkStatus = (int)self.manager.reachabilityManager.networkReachabilityStatus;
}

- (void)stopMonitoringNetwork
{
    [self.manager.reachabilityManager stopMonitoring];
}

#pragma mark - Private

void PerformFailureRecognition(NSURLResponse * response, id responseObject, NSError * error, ResponseBlock handler) {
    NSDictionary *responseDict;
    NSInteger statusCode = error.code;
    if (response) {
        statusCode = ((NSHTTPURLResponse *)response).statusCode;
    }
    if (responseObject) {
		if ([responseObject isKindOfClass:[NSData class]]) {
			responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
		} else {
			responseDict = (NSDictionary *)responseObject;
		}
	}
    handler(responseDict, error, statusCode);
};

void PerformSuccessRecognition(NSURLResponse * response, id responseObject, ResponseBlock handler) {
    id value = nil;
    if (responseObject) {
		if ([responseObject isKindOfClass:[NSData class]]) {
			value = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
		} else {
			value = (NSDictionary *)responseObject;
		}		
    }
    handler(value, nil, ((NSHTTPURLResponse *)response).statusCode);
};

void(^PerformCompletionRecognition)(NSURLResponse *, id, NSError *, ResponseBlock) = ^(NSURLResponse * response, id responseObject, NSError * error, ResponseBlock handler) {
    if (error) {
        PerformFailureRecognition(response, responseObject, error, handler);
    } else {
        PerformSuccessRecognition(response, responseObject, handler);
    }
};

- (NSURLSessionDataTask *)performPOST:(NSString *)path contentTypeJson:(BOOL)isJson withParameters:(NSDictionary *)parameters response:(ResponseBlock)completionHandler
{
	return [self performPOST:path contentTypeJson:isJson withParameters:parameters multipartData:nil response:completionHandler];
}

- (NSURLSessionDataTask *)performPOST:(NSString *)path contentTypeJson:(BOOL)isJson withParameters:(NSDictionary *)parameters multipartData:(NSArray *)dataArray response:(ResponseBlock)completionHandler
{
    return [self performRequestWithMethod:@"POST" contentTypeJson:isJson withPath:path withParameters:parameters multipartData:dataArray response:completionHandler];
}

- (NSURLSessionDataTask *)performPUT:(NSString *)path withParameters:(NSDictionary *)parameters response:(ResponseBlock)completionHandler
{
    return [self performPUT:path withParameters:parameters multipartData:nil response:completionHandler];
}

- (NSURLSessionDataTask *)performPUT:(NSString *)path withParameters:(NSDictionary *)parameters multipartData:(NSArray *)dataArray response:(ResponseBlock)completionHandler
{
    return [self performRequestWithMethod:@"PUT" contentTypeJson:YES withPath:path withParameters:parameters multipartData:dataArray response:completionHandler];
}

- (NSURLSessionDataTask *)performGET:(NSString *)path withParameters:(NSDictionary *)parameters response:(ResponseBlock)completionHandler
{
    return [self performRequestWithMethod:@"GET" contentTypeJson:NO withPath:path withParameters:parameters multipartData:nil response:completionHandler];
}

- (NSURLSessionDataTask *)performDELETE:(NSString *)path withParameters:(NSDictionary *)parameters response:(ResponseBlock)completionHandler
{
    return [self performRequestWithMethod:@"DELETE" contentTypeJson:YES  withPath:path withParameters:parameters multipartData:nil response:completionHandler];
}

- (NSURLSessionDataTask *)performRequestWithMethod:(NSString *)method contentTypeJson:(BOOL)isJson withPath:(NSString *)path withParameters:(NSDictionary *)parameters multipartData:(NSArray *)dataArray response:(ResponseBlock)completionHandler
{
    if (self.networkStatus <= NetworkStatusNotReachable && completionHandler) {
        completionHandler(nil, NoConnectionError(), NSURLErrorNotConnectedToInternet);
        return nil;
    }
    
    NSError *requestError;
    NSURLRequest *request;
	AFHTTPRequestSerializer *serializer = (isJson || dataArray) ? [AFJSONRequestSerializer serializer] : [AFHTTPRequestSerializer serializer];
//	[serializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
	
    if (dataArray) {
        request = [serializer multipartFormRequestWithMethod:method URLString:URLWithPath(path) parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (NSDictionary *dict in dataArray) {
                NSAssert([dict isKindOfClass:NSDictionary.class], @"Data must be a dictionary and contains data, mimetype, filename, name. See APIClientConstants.h keys");
                NSParameterAssert(dict[MultipartDataFileBytes]);
                NSParameterAssert(dict[MultipartDataParameterName]);
                NSParameterAssert(dict[MultipartDataFileName]);
                NSParameterAssert(dict[MultipartDataFileMimeType]);
                [formData appendPartWithFileData:dict[MultipartDataFileBytes] name:dict[MultipartDataParameterName] fileName:dict[MultipartDataFileName] mimeType:dict[MultipartDataFileMimeType]];
            }
        } error:&requestError];
    } else {
        if ([method isEqualToString:@"GET"]) {
            serializer = [AFHTTPRequestSerializer serializer];
        }
        request = [serializer requestWithMethod:method URLString:URLWithPath(path) parameters:parameters error:&requestError];
    }
    
    if (requestError) {
        PerformCompletionRecognition(nil, nil, requestError, completionHandler);
        return nil;
    }
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * response, id responseObject, NSError * error) {
        PerformCompletionRecognition(response, responseObject, error, completionHandler);
    }];
    [dataTask resume];
    return dataTask;
}

#pragma mark - Preparation

- (void)setupManager
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    [self startMonitoringNetwork];
    self.passtoken = [Defaults valueForKey:PassTokenKey];
}

NSError *NoConnectionError()
{
    return [NSError errorWithDomain:NetworkErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];
}

NSString *URLWithPath(NSString *path) {
    return [APIBaseURLSandbox stringByAppendingString:path];
}

@end
