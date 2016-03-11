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
    NSParameterAssert(userId);
	NSDictionary *parameters = @{@"id":@(userId), @"passtoken":self.passtoken};
	
	NSString *query = [NSString stringWithFormat:@"api/v1/users/%li.html",userId];
	return [self performGET:query withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)generateUserWithCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[self deviceParameters]];
    return [self performPOST:@"api/v1/generate.json" withParameters:parameters response:completion];
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
										logo:(UIImage *)logo
                               withCompletion:(ResponseBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[self deviceParameters]];
    NSMutableDictionary *userParameters = [NSMutableDictionary dictionary];
	[userParameters setObject:@([LocationManager sharedManager].currentLocation.coordinate.latitude) forKey:@"home_latitude"];
	[userParameters setObject:@([LocationManager sharedManager].currentLocation.coordinate.longitude) forKey:@"home_longitude"];
	
	[userParameters setObject:@"" forKey:@"login"];
	[userParameters setObject:@"" forKey:@"name"];
	[userParameters setObject:@"" forKey:@"cellphone"];
	[userParameters setObject:@"" forKey:@"language_id"];
	[userParameters setObject:@"" forKey:@"country_id"];
	[userParameters setObject:@"" forKey:@"address"];
	[userParameters setObject:@"" forKey:@"facebook"];
	[userParameters setObject:@"" forKey:@"linkedin"];
	[userParameters setObject:@"" forKey:@"hours"];
	[userParameters setObject:@"" forKey:@"description"];
	
	if (email.length) {
		[userParameters setObject:email forKey:@"email"];
	}
	if (username.length) {
		[userParameters setObject:username forKey:@"nickname"];
	}
	if (password.length) {
		[userParameters setObject:password forKey:@"password"];
		[userParameters setObject:password forKey:@"password_confirmation"];
	}
	if (customerTypeId) {
		[userParameters setObject:@(customerTypeId) forKey:@"customer_type_id"];
	}
	if (companyname) {
		[userParameters setObject:companyname forKey:@"company_name"];
	}
	if (website.length) {
		[userParameters setObject:website forKey:@"website"];
	}
	if (phone.length) {
		[userParameters setObject:phone forKey:@"phone"];
	}
    [parameters setValue:userParameters forKey:@"user"];
    
	NSArray *dataArray;
	if (avatar) {
        dataArray = @[[self multipartFileWithContents:UIImageJPEGRepresentation(avatar, 1.0f) fileName:@"avatar.jpg" mimeType:@"image/jpeg" parameterName:@"user[avatar]"]];
	}
	
	//send logo image
	
	return [self performPOST:@"api/v1/users.json" withParameters:parameters multipartData:dataArray response:completion];
}

- (NSURLSessionDataTask *)updateUserWithEmail:(NSString *)email
                                     username:(NSString *)username
                                     fullname:(NSString *)fullname
                                  companyname:(NSString *)companyname
                                     password:(NSString *)password
                                      website:(NSString *)website
                                     facebook:(NSString *)facebook
                                     linkedin:(NSString *)linkedin
                                        phone:(NSString *)phone
                                  description:(NSString *)description
                                       avatar:(UIImage *)avatar
									   logo:(UIImage *)logo
                               withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *updateParameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
	
    NSMutableDictionary *userParameters = [NSMutableDictionary dictionary];
    UserAccountType customerId = self.currentUser.customerTypeId == AnonymousAccount ? IndividualAccount : self.currentUser.customerTypeId;
    [userParameters setValue:@(customerId) forKey:@"customer_type_id"];
    
    UserModel *me = self.currentUser;
    if (email.length && ![email isEqualToString:me.email]) {
        [userParameters setObject:email forKey:@"email"];
    }
    if (username.length && ![username isEqualToString:me.username]) {
        [userParameters setObject:username forKey:@"nickname"];
    }
    if (fullname) {
        [userParameters setObject:fullname forKey:@"name"];
    }
    if (companyname) {
        [userParameters setObject:companyname forKey:@"company_name"];
    }
    if (password) {
        [userParameters setObject:password forKey:@"password"];
    }
    if (website) {
		[userParameters setObject:website forKey:@"website"];
	}
	if (facebook) {
		[userParameters setObject:facebook forKey:@"facebook"];
	}
	if (linkedin) {
		[userParameters setObject:linkedin forKey:@"linkedin"];
	}
	if (phone) {
		[userParameters setObject:phone forKey:@"phone"];
	}
	if (description) {
		[userParameters setObject:description forKey:@"description"];
	}
	if (password.length) {
		[userParameters setObject:password forKey:@"password"];
	}
    [userParameters setObject:@([LocationManager sharedManager].currentLocation.coordinate.latitude) forKey:@"home_latitude"];
    [userParameters setObject:@([LocationManager sharedManager].currentLocation.coordinate.longitude) forKey:@"home_longitude"];
    
    NSArray *dataArray;
    if (avatar) {
        dataArray = @[[self multipartFileWithContents:UIImageJPEGRepresentation(avatar, 1.0f) fileName:@"avatar.jpg" mimeType:@"image/jpeg" parameterName:@"user[avatar]"]];
    }
    [updateParameters setValue:userParameters forKey:@"user"];
    
    NSString *query = [NSString stringWithFormat:@"api/v1/users/%li.json", self.currentUser.userId];
    return [self performPUT:query withParameters:updateParameters multipartData:dataArray response:completion];
}

- (NSURLSessionDataTask *)destroyUserWithCompletion:(ResponseBlock)completion
{
	NSDictionary *parameters = @{@"passtoken" : self.passtoken};
	
	NSString *query = [NSString stringWithFormat:@"api/v1/users"];
	return [self performDELETE:query withParameters:parameters response:completion];
}

#pragma mark - Password

- (NSURLSessionDataTask *)changePassword:(NSString *)oldPassword withNewPassword:(NSString *)newPassword withCompletion:(ResponseBlock)completion
{
    NSParameterAssert(oldPassword.length);
    NSParameterAssert(newPassword.length);
    NSDictionary *parameters = @{@"old_password" : oldPassword, @"password" : newPassword, @"password_confirmation" : newPassword, @"passtoken" : self.passtoken};
    NSString *query = [NSString stringWithFormat:@"api/v1/password/%li.json", self.currentUser.userId];
    return [self performPUT:query withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)forgotPasswordWithEmail:(NSString *)email withCompletion:(ResponseBlock)completion;
{
    NSParameterAssert(email.length);
    NSDictionary *parameters = @{@"email" : email};

    return [self performPOST:@"api/v1/forgot_password.json" withParameters:parameters response:completion];
}

@end
