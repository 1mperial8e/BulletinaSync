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
								   endpointArn:(NSString *)endpointArn
								   deviceToken:(NSString *)deviceToken
								   operatingSystem:(NSString *)operatingSystem
								   deviceType:(NSString *)deviceType
								   currentLattitude:(CGFloat)currentLattitude
								   currentLongitude:(CGFloat)currentLongitude
								  withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{	@"email" : email, @"password":password }];
	
	if (endpointArn.length) {
		[parameters setObject:endpointArn forKey:@"endpoint_arn"];
	}
	if (deviceToken.length) {
		[parameters setObject:deviceToken forKey:@"device_token"];
	}
	if (operatingSystem.length) {
		[parameters setObject:operatingSystem forKey:@"operating_system"];
	}
	if (deviceType.length) {
		[parameters setObject:deviceType forKey:@"device_type"];
	}
	if (currentLattitude) {
		[parameters setObject:@(currentLattitude) forKey:@"current_lattitude"];
	}
	if (currentLongitude) {
		[parameters setObject:@(currentLongitude) forKey:@"current_longitude"];
	}	
	return [self performPOST:@"api/v1/sessions" withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)logoutSessionWithUserId:(NSInteger)userId passtoken:(NSString *)passtoken withCompletion:(ResponseBlock)completion
{
	NSDictionary *parameters = @{@"userId":@(userId), @"passtoken":passtoken};
	NSString *query = [NSString stringWithFormat:@"api/v1/sessions/26.json"];
	return [self performDELETE:query withParameters:parameters response:completion];
//	return [self performPOST:query withParameters:parameters response:completion];
}

@end
