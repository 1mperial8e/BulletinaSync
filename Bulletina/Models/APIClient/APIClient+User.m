//
//  APIClient+User.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient+User.h"

@implementation APIClient (User)

- (NSURLSessionDataTask *)showUserWithUserId:(NSInteger)userId withCompletion:(ResponseBlock)completion
{
	NSDictionary *parameters = @{@"id":@(userId), @"passtoken":self.passtoken};
	
	NSString *query = [NSString stringWithFormat:@"api/v1/users"];
	return [self performGET:query withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)generateUserWithCompletion:(ResponseBlock)completion
{
	NSDictionary *parameters = @{@"generate":@"1"};
	
	return [self performPOST:@"api/v1/users" withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)createUserWithEmail:(NSString *)email
                                        username:(NSString *)username
                                        password:(NSString *)password
                                     languageId:(NSString *)languageId
                                   homeLatitude:(NSString *)homeLatitude
                                  homeLongitude:(NSString *)homeLongitude
                                customerTypeId:(UserAccountType)customerTypeId
                                    companyname:(NSString *)companyname
                                         website:(NSString *)website
										phone:(NSString *)phone
                                          avatar:(UIImage *)avatar
                                  withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *createParameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"email" : email,
																						 @"login" : username,
																						 @"company_name": companyname,
																						 @"password": password,
																						 @"customer_type_id": @(customerTypeId)}];
	
	if (languageId.length) {
		[createParameters setObject:languageId forKey:@"language_id"];
	}
	if (website.length) {
		[createParameters setObject:website forKey:@"website"];
	}
	if (phone.length) {
		[createParameters setObject:phone forKey:@"phone"];
	}
	if (homeLatitude.length && homeLongitude.length) {
		[createParameters setObject:homeLatitude forKey:@"home_latitude"];
		[createParameters setObject:homeLongitude forKey:@"home_longitude"];
	}
	NSData *imageData;
	if (avatar) {
		imageData = UIImageJPEGRepresentation(avatar, 1.0f);
	}
	//implement sending image
	return [self performPOST:@"api/v1/users" withParameters:createParameters multipartData:nil response:completion];
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
																							   @"email" : self.currentUser.email,
																							   @"login" : username,
																							   @"password":password,
																							   @"name":fullname,
																							   @"company_name":companyname,
																							   @"customer_type_id":@(self.currentUser.customer_type_id),
																							   @"home_latitude":self.currentUser.home_latitude ? self.currentUser.home_latitude : @0,
																							   @"home_longitude":self.currentUser.home_longitude ? self.currentUser.home_longitude : @0}];	
	
	if (website.length) {
		[updateParameters setObject:website forKey:@"website"];
	}
	if (facebook.length) {
		[updateParameters setObject:facebook forKey:@"facebook"];
	}
	if (linkedin.length) {
		[updateParameters setObject:linkedin forKey:@"linkedin"];
	}
	if (phone.length) {
		[updateParameters setObject:phone forKey:@"phone"];
	}
	if (description.length) {
		[updateParameters setObject:description forKey:@"description"];
	}
	if (password.length) {
		[updateParameters setObject:password forKey:@"password"];
	} 
	NSData *imageData;
	if (avatar) {
		imageData = UIImageJPEGRepresentation(avatar, 1.0f);
	}
	//implement sending image
		NSString *query = [NSString stringWithFormat:@"api/v1/users/%li.html", self.currentUser.userId];
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
