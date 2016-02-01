//
//  APIClient+Session.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient+Session.h"

@implementation APIClient (Session)

- (NSURLSessionDataTask *)loginSessionWithEmail:(NSString *)email
								   password:(NSString *)password
								   endpoint_arn:(NSString *)endpoint_arn
								   device_token:(NSString *)device_token
								   operating_system:(NSString *)operating_system
								   device_type:(NSString *)device_type
								   current_lattitude:(NSString *)current_lattitude
								   current_longitude:(NSString *)current_longitude
								  withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{	@"email" : email, @"password":password }];
	
	if (endpoint_arn.length) {
		[parameters setObject:endpoint_arn forKey:@"endpoint_arn"];
	}
	if (device_token.length) {
		[parameters setObject:device_token forKey:@"device_token"];
	}
	if (operating_system.length) {
		[parameters setObject:operating_system forKey:@"operating_system"];
	}
	if (device_type.length) {
		[parameters setObject:device_type forKey:@"device_type"];
	}
	if (current_lattitude.length) {
		[parameters setObject:current_lattitude forKey:@"current_lattitude"];
	}
	if (current_longitude.length) {
		[parameters setObject:current_longitude forKey:@"current_longitude"];
	}
	
	return [self performPOST:@"api/v1/sessions" withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)logoutSessionWithUserId:(NSInteger)userId passtoken:(NSString *)passtoken withCompletion:(ResponseBlock)completion
{
	NSDictionary *parameters = @{@"userId":@(userId), @"passtoken":passtoken};
	NSString *deleteString = [NSString stringWithFormat:@"api/v1/sessions/26.json"];
	return [self performDELETE:deleteString withParameters:parameters response:completion];
//	return [self performPOST:deleteString withParameters:parameters response:completion];
}

@end
