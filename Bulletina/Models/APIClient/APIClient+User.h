//
//  APIClient+User.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient.h"
#import "UserModel.h"

@interface APIClient (User)

#pragma mark - Login

- (NSURLSessionDataTask *)generateUserWithCompletion:(ResponseBlock)completion;
- (NSURLSessionDataTask *)showUserWithUserId:(NSInteger)userId passtoken:(NSString *)passtoken withCompletion:(ResponseBlock)completion;

#pragma mark - Register profile (Signup)

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
							   withCompletion:(ResponseBlock)completion;

#pragma mark - Edit profile (Update)

- (NSURLSessionDataTask *)updateUserWithUsername:(NSString *)username
										password:(NSString *)password
									 companyname:(NSString *)companyname
										 website:(NSString *)website
										facebook:(NSString *)facebook
										linkedin:(NSString *)linkedin
										   phone:(NSString *)phone
									 description:(NSString *)description
										  avatar:(UIImage *)avatar
								  withCompletion:(ResponseBlock)completion;


- (NSURLSessionDataTask *)destroyUserWithUserId:(NSInteger)userId passtoken:(NSString *)passtoken withCompletion:(ResponseBlock)completion;

#pragma mark - Password recovery

- (void)forgotPasswordWithEmail:(NSString *)email withCompletion:(ResponseBlock)completion;

@end
