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

- (void)loginWithUsername:(NSString *)username password:(NSString *)password withCompletion:(ResponseBlock)completion
{
	if (completion) {
		completion(nil, nil, 404);
	}
}

- (NSURLSessionDataTask *)generateUserWithCompletion:(ResponseBlock)completion
{
	NSDictionary *parameters = @{}; //@{@"commit":@"Generate user"}; //@{@"utf8":@"✓",APIKey: APIValue, @"generate":@"{:value=>\"1\"}",@"commit":@"Generate user"};
	
	NSDictionary *createParameters = @{@"name":@"userNAME", @"cellphone":@"123",@"email":@"123",@"login":@"123",@"password":@"123", @"password_confirm":@"123", @"language_id":@"1",@"home_latitude":@"123" ,@"home_longitude":@"123", @"country_id":@"1",@"customer_type_id":@"1",@"company_name":@"123",@"address":@"123", @"website":@"123",@"facebook":@"123",@"twitter":@"123",@"linkedin":@"123",@"phone":@"123",@"hours":@"123",@"description":@"123"};
	
	return [self performPOST:@"api/v1/users.json" withParameters:parameters response:completion];
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
