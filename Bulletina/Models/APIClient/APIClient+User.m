//
//  APIClient+User.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient+User.h"

@implementation APIClient (User)

#pragma mark - Login

- (NSURLSessionDataTask *)showUserWithUserId:(NSInteger)userId passtoken:(NSString *)passtoken withCompletion:(ResponseBlock)completion
{
	NSDictionary *parameters = @{@"id":@(userId), @"passtoken":passtoken};
	
	NSString *getString = [NSString stringWithFormat:@"api/v1/users/%li.html", userId];
	return [self performGET:getString withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)generateUserWithCompletion:(ResponseBlock)completion
{
	NSDictionary *parameters = @{@"generate":@"1"};
	
	return [self performPOST:@"api/v1/users" withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)createUserWithFullName:(NSString *)fullName
                                           email:(NSString *)email
                                        username:(NSString *)username
                                        password:(NSString *)password
                                password_confirm:(NSString *)password_confirm
                                     language_id:(NSString *)language_id
                                   home_latitude:(NSString *)home_latitude
                                  home_longitude:(NSString *)home_longitude
                                customer_type_id:(UserAccountType)customer_type_id
                                    company_name:(NSString *)company_name
                                         address:(NSString *)address
                                         website:(NSString *)website
                                        facebook:(NSString *)facebook
                                        linkedin:(NSString *)linkedin
                                           phone:(NSString *)phone
                                     description:(NSString *)description
                                          avatar:(UIImage *)avatar
                                  withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *createParameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"email" : email,
																						 @"login" : username,
																						 @"password":password,
																						 @"password_confirm":password_confirm,
																						 @"company_name":company_name,
																						 @"customer_type_id":@(customer_type_id)}];
	
	if (fullName.length) {
		[createParameters setObject:fullName forKey:@"name"];
	}
	if (language_id.length) {
		[createParameters setObject:language_id forKey:@"language_id"];
	}
	if (address.length) {
		[createParameters setObject:address forKey:@"address"];
	}
	if (website.length) {
		[createParameters setObject:website forKey:@"website"];
	}
	if (facebook.length) {
		[createParameters setObject:facebook forKey:@"facebook"];
	}
	if (linkedin.length) {
		[createParameters setObject:linkedin forKey:@"linkedin"];
	}
	if (phone.length) {
		[createParameters setObject:phone forKey:@"phone"];
	}
	if (description.length) {
		[createParameters setObject:description forKey:@"description"];
	}
	if (home_latitude.length && home_longitude.length) {
		[createParameters setObject:home_latitude forKey:@"home_latitude"];
		[createParameters setObject:home_longitude forKey:@"home_longitude"];
	}
	NSData *imageData;
	if (avatar) {
		imageData = UIImageJPEGRepresentation(avatar, 1.0f);
	}
	return [self performPOST:@"api/v1/users" withParameters:createParameters multipartData:nil response:completion];
}

- (NSURLSessionDataTask *)updateUserWithUserId:(NSInteger)userId
										passtoken:(NSString *)passtoken
										   active:(NSString *)active
											  fullName:(NSString *)fullName
										   email:(NSString *)email
										username:(NSString *)username
										password:(NSString *)password
								password_confirm:(NSString *)password_confirm
									 language_id:(NSString *)language_id
								   home_latitude:(NSString *)home_latitude
								  home_longitude:(NSString *)home_longitude
								customer_type_id:(UserAccountType)customer_type_id
									company_name:(NSString *)company_name
								   address:(NSString *)address
								   website:(NSString *)website
										facebook:(NSString *)facebook
										linkedin:(NSString *)linkedin
										   phone:(NSString *)phone
									 description:(NSString *)description
										  avatar:(UIImage *)avatar
								  withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *updateParameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken":passtoken,
																							   @"active":active,
																							   @"email" : email,
																							   @"login" : username,
																							   @"password":password,
																							   @"password_confirm":password_confirm,
																							   @"company_name":company_name,
																							   @"customer_type_id":@(customer_type_id)}];
	
	if (fullName.length) {
		[updateParameters setObject:fullName forKey:@"name"];
	}
	if (language_id.length) {
		[updateParameters setObject:language_id forKey:@"language_id"];
	}
	if (address.length) {
		[updateParameters setObject:address forKey:@"address"];
	}
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
	if (home_latitude.length && home_longitude.length) {
		[updateParameters setObject:home_latitude forKey:@"home_latitude"];
		[updateParameters setObject:home_longitude forKey:@"home_longitude"];
	}
	NSData *imageData;
	if (avatar) {
		imageData = UIImageJPEGRepresentation(avatar, 1.0f);
	}
		NSString *putString = [NSString stringWithFormat:@"api/v1/users/%li.html", userId];
		return [self performPUT:putString withParameters:updateParameters multipartData:nil response:completion];
}

- (NSURLSessionDataTask *)destroyUserWithUserId:(NSInteger)userId passtoken:(NSString *)passtoken withCompletion:(ResponseBlock)completion
{
	NSDictionary *parameters = @{@"passtoken":passtoken};
	
	NSString *deleteString = [NSString stringWithFormat:@"api/v1/users/%li.html", userId];
	return [self performDELETE:deleteString withParameters:parameters response:completion];
}

#pragma mark - Password recovery

- (void)forgotPasswordWithEmail:(NSString *)email withCompletion:(ResponseBlock)completion
{
	if (completion) {
		completion(nil, nil, 404);
	}
}

#pragma mark - Register profile (Signup)

- (void)registerIndividualProfileWithNickname:(NSString *)nickname email:(NSString *)email password:(NSString *)password logo:(UIImage *)logo withCompletion:(ResponseBlock)completion
{
	if (completion) {
		completion(nil, nil, 404);
	}
}

- (void)registerBusinessProfileWithCompanyname:(NSString *)companyname email:(NSString *)email phone:(NSString *)phone website:(NSString *)website password:(NSString *)password logo:(UIImage *)logo withCompletion:(ResponseBlock)completion
{
	if (completion) {
		completion(nil, nil, 404);
	}
}

#pragma mark - Edit profile (Update)

- (void)updateIndividualProfileWithNickname:(NSString *)nickname about:(NSString *)about password:(NSString *)password logo:(UIImage *)logo withCompletion:(ResponseBlock)completion
{
	if (completion) {
		completion(nil, nil, 404);
	}
}

- (void)updateBusinessProfileWithCompanyname:(NSString *)companyname username:(NSString *)username phone:(NSString *)phone website:(NSString *)website facebook:(NSString *)facebook instagram:(NSString *)instagram linkedin:(NSString *)linkedin about:(NSString *)about password:(NSString *)password logo:(UIImage *)logo withCompletion:(ResponseBlock)completion
{
	if (completion) {
		completion(nil, nil, 404);
	}
}



@end
