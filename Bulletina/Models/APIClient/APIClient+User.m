//
//  APIClient+User.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient+User.h"
#import "LocationManager.h"

@implementation APIClient (User)

- (NSURLSessionDataTask *)showCurrentUserWithCompletion:(ResponseBlock)completion
{
	return [self showUserWithUserId:self.currentUser.userId withCompletion:completion];
}

- (NSURLSessionDataTask *)showUserWithUserId:(NSInteger)userId withCompletion:(ResponseBlock)completion
{
	NSDictionary *parameters = @{@"id":@(userId), @"passtoken":self.passtoken};
	
	NSString *query = [NSString stringWithFormat:@"api/v1/users/%li.html",userId];
	return [self performGET:query withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)generateUserWithCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[self deviceParameters]];
    [parameters setObject:@1 forKey:@"generate"];

    return [self performPOST:@"api/v1/generate.json" contentTypeJson:NO withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)createUserWithEmail:(NSString *)email
                                     username:(NSString *)username
                                     password:(NSString *)password
                                   languageId:(NSString *)languageId
                               customerTypeId:(UserAccountType)customerTypeId
                                  companyname:(NSString *)companyname
                                      website:(NSString *)website
                                        phone:(NSString *)phone
                                       avatar:(UIImage *)avatar
                               withCompletion:(ResponseBlock)completion
{
    NSMutableDictionary *createParameters = [[NSMutableDictionary alloc] initWithDictionary:[self deviceParameters]];
	
	[createParameters setObject:@([LocationManager sharedManager].currentLocation.coordinate.latitude) forKey:@"user[home_latitude]"];
	[createParameters setObject:@([LocationManager sharedManager].currentLocation.coordinate.longitude) forKey:@"user[home_longitude]"];
	
	[createParameters setObject:@"" forKey:@"user[login]"];
	[createParameters setObject:@"" forKey:@"user[name]"];
	[createParameters setObject:@"" forKey:@"user[cellphone]"];
	[createParameters setObject:@"" forKey:@"user[language_id]"];
	[createParameters setObject:@"" forKey:@"user[country_id]"];
	[createParameters setObject:@"" forKey:@"user[address]"];
	[createParameters setObject:@"" forKey:@"user[facebook]"];
	[createParameters setObject:@"" forKey:@"user[linkedin]"];
	[createParameters setObject:@"" forKey:@"user[hours]"];
	[createParameters setObject:@"" forKey:@"user[description]"];
	
	if (email.length) {
		[createParameters setObject:email forKey:@"user[email]"];
	}
	if (username.length) {
		[createParameters setObject:username forKey:@"user[login]"];
	}
	if (password.length) {
		[createParameters setObject:password forKey:@"user[password]"];
		[createParameters setObject:password forKey:@"user[password_confirmation]"];
	}
	if (customerTypeId) {
		[createParameters setObject:@(customerTypeId) forKey:@"user[customer_type_id]"];
	}
	if (companyname) {
		[createParameters setObject:companyname forKey:@"user[company_name]"];
	}
	if (website.length) {
		[createParameters setObject:website forKey:@"user[website]"];
	}
	if (phone.length) {
		[createParameters setObject:phone forKey:@"user[phone]"];
	}
	
	NSData *imageData;
	if (avatar) {
		imageData = UIImageJPEGRepresentation(avatar, 1.0f);
	}
	//implement sending image
	return [self performPOST:@"api/v1/users.json" contentTypeJson:NO withParameters:createParameters multipartData:nil response:completion];
}

- (NSURLSessionDataTask *)updateUserWithUsername:(NSString *)username
										fullname:(NSString *)fullname
                                     companyname:(NSString *)companyname
										password:(NSString *)password
										 website:(NSString *)website
										facebook:(NSString *)facebook
										linkedin:(NSString *)linkedin
										   phone:(NSString *)phone
									 description:(NSString *)description
										  avatar:(UIImage *)avatar
								  withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *updateParameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken":self.passtoken,
																							   @"user[email]" : self.currentUser.email,
																							   @"user[login]" : username,
																							   @"user[password]":password,
																							   @"user[name]":fullname,
																							   @"user[company_name]":companyname,
																							   @"user[customer_type_id]":@(self.currentUser.customer_type_id),
																							   @"user[home_latitude]":self.currentUser.home_latitude ? self.currentUser.home_latitude : @0,
																							   @"user[home_longitude]":self.currentUser.home_longitude ? self.currentUser.home_longitude : @0}];
	
	if (website.length) {
		[updateParameters setObject:website forKey:@"user[website]"];
	}
	if (facebook.length) {
		[updateParameters setObject:facebook forKey:@"user[facebook]"];
	}
	if (linkedin.length) {
		[updateParameters setObject:linkedin forKey:@"user[linkedin]"];
	}
	if (phone.length) {
		[updateParameters setObject:phone forKey:@"user[phone]"];
	}
	if (description.length) {
		[updateParameters setObject:description forKey:@"user[description]"];
	}
	if (password.length) {
		[updateParameters setObject:password forKey:@"user[password]"];
	} 
	NSData *imageData;
	if (avatar) {
		imageData = UIImageJPEGRepresentation(avatar, 1.0f);
	}
	//implement sending image
		NSString *query = [NSString stringWithFormat:@"api/v1/users/%li.json", self.currentUser.userId];
		return [self performPUT:query withParameters:updateParameters multipartData:nil response:completion];
}

- (NSURLSessionDataTask *)destroyUserWithCompletion:(ResponseBlock)completion
{
	NSDictionary *parameters = @{@"passtoken":self.passtoken};
	
	NSString *query = [NSString stringWithFormat:@"api/v1/users"];
	return [self performDELETE:query withParameters:parameters response:completion];
}

#pragma mark - Password recovery

- (void)forgotPasswordWithEmail:(NSString *)email withCompletion:(ResponseBlock)completion
{
	if (completion) {
		completion(nil, nil, 404);
	}
}

@end
