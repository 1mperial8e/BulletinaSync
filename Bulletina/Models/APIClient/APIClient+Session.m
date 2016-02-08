//
//  APIClient+Session.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient+Session.h"
#import "LocationManager.h"

@implementation APIClient (Session)

- (NSURLSessionDataTask *)loginSessionWithUsername:(NSString *)username
								   password:(NSString *)password
								  withCompletion:(ResponseBlock)completion
{
    NSParameterAssert(username.length);
    NSParameterAssert(password.length);
    
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"session[email]":username, @"session[password]":password }];
	[parameters setObject:[Defaults valueForKey:SNSEndpointArnKey] ? : @"" forKey:@"session[endpoint_arn]"];
	[parameters setObject:self.pushToken ? : @"" forKey:@"session[device_token]"];
	[parameters setObject:[Device.systemName stringByAppendingString:Device.systemVersion] forKey:@"session[operating_system]"];
	[parameters setObject:Device.model forKey:@"session[device_type]"];
	[parameters setObject:@([LocationManager sharedManager].currentLocation.coordinate.latitude) forKey:@"session[current_latitude]"];
	[parameters setObject:@([LocationManager sharedManager].currentLocation.coordinate.longitude) forKey:@"session[current_longitude]"];	
	
	return [self performPOST:@"api/v1/sessions" contentTypeJson:NO withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)logoutSessionWithCompletion:(ResponseBlock)completion
{
    NSParameterAssert(self.currentUser);
    NSParameterAssert(self.passtoken);
    
    NSDictionary *parameters = @{@"passtoken" : self.passtoken, @"user_id" : @(self.currentUser.userId)};
	NSString *query = [NSString stringWithFormat:@"api/v1/sessions/%zd.json", self.currentUser.userId];
    return [self performDELETE:query withParameters:parameters response:completion];
}

@end
