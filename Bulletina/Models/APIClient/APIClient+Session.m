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

- (NSURLSessionDataTask *)loginSessionWithUsername:(NSString *)username password:(NSString *)password withCompletion:(ResponseBlock)completion
{
    NSParameterAssert(username.length);
    NSParameterAssert(password.length);
    
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"session" : @{@"email" : username, @"password" : password, @"device_token" : self.pushToken}}];
    [parameters addEntriesFromDictionary:[self deviceParameters]];	
    
	return [self performPOST:@"api/v1/sessions" withParameters:parameters response:completion];
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
