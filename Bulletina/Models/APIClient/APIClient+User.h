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

- (NSURLSessionDataTask *)showCurrentUserWithCompletion:(ResponseBlock)completion;
- (NSURLSessionDataTask *)showUserWithUserId:(NSInteger)userId withCompletion:(ResponseBlock)completion;
- (NSURLSessionDataTask *)generateUserWithCompletion:(ResponseBlock)completion;

#pragma mark - Register profile (Signup)

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
							   withCompletion:(ResponseBlock)completion;

#pragma mark - Edit profile (Update)

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
                               withCompletion:(ResponseBlock)completion;


- (NSURLSessionDataTask *)destroyUserWithCompletion:(ResponseBlock)completion;

#pragma mark - Password

- (NSURLSessionDataTask *)changePassword:(NSString *)oldPassword withNewPassword:(NSString *)newPassword withCompletion:(ResponseBlock)completion;
- (NSURLSessionDataTask *)forgotPasswordWithEmail:(NSString *)email withCompletion:(ResponseBlock)completion;

@end
