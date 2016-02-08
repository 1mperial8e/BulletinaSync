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
								   deviceToken:(NSString *)deviceToken
								   operatingSystem:(NSString *)operatingSystem
								   deviceType:(NSString *)deviceType
								   currentLattitude:(CGFloat)currentLattitude
								   currentLongitude:(CGFloat)currentLongitude
								  withCompletion:(ResponseBlock)completion
{
    NSParameterAssert(email.length);
    NSParameterAssert(password.length);
    
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"email":email, @"password":password }];
//	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//	[parameters setObject:session forKey:@"session"];
	
	NSString *endpointArn = [[NSUserDefaults standardUserDefaults] objectForKey:SNSEndpointArnKey];
	if (endpointArn.length) {
		[parameters setObject:endpointArn forKey:@"session[endpoint_arn]"];
	}
	
//	if (deviceToken.length) {
//		[parameters setObject:deviceToken forKey:@"session[device_token]"];
//	}
//	if (operatingSystem.length) {
//		[parameters setObject:operatingSystem forKey:@"session[operating_system]"];
//	}
//	if (deviceType.length) {
//		[parameters setObject:deviceType forKey:@"session[device_type]"];
//	}
//	if (currentLattitude) {
//		[parameters setObject:@(currentLattitude) forKey:@"session[current_lattitude]"];
//	}
//	if (currentLongitude) {
//		[parameters setObject:@(currentLongitude) forKey:@"session[current_longitude]"];
//	}	
	return [self performPOST:@"api/v1/sessions" contentTypeJson:YES withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)logoutSessionWithCompletion:(ResponseBlock)completion
{
    NSParameterAssert(self.currentUser);
    NSParameterAssert(self.passtoken);
    
	NSDictionary *parameters = @{/*@"userId":@(self.currentUser.userId),*/ @"passtoken":self.passtoken};
	NSString *query = [NSString stringWithFormat:@"api/v1/sessions/%zd", self.currentUser.userId];
	return [self performDELETE:query withParameters:parameters response:completion];
}

@end
