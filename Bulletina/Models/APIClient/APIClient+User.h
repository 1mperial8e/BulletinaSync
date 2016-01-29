//
//  APIClient+User.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient.h"

@interface APIClient (User)

#pragma mark - Login

- (void)loginWithUsername:(NSString *)username password:(NSString *)password withCompletion:(ResponseBlock)completion;

- (NSURLSessionDataTask *)generateUserWithCompletion:(ResponseBlock)completion;

#pragma mark - Password recovery

- (void)forgotPasswordWithEmail:(NSString *)email withCompletion:(ResponseBlock)completion;

#pragma mark - Register profile (Signup)

- (void)registerIndividualProfileWithNickname:(NSString *)nickname email:(NSString *)email password:(NSString *)password logo:(UIImage *)logo withCompletion:(ResponseBlock)completion;

- (void)registerBusinessProfileWithCompanyname:(NSString *)companyname email:(NSString *)email phone:(NSString *)phone website:(NSString *)website password:(NSString *)password logo:(UIImage *)logo withCompletion:(ResponseBlock)completion;

#pragma mark - Edit profile (Update)

- (void)updateIndividualProfileWithNickname:(NSString *)nickname about:(NSString *)about password:(NSString *)password logo:(UIImage *)logo withCompletion:(ResponseBlock)completion;

- (void)updateBusinessProfileWithCompanyname:(NSString *)companyname username:(NSString *)username phone:(NSString *)phone website:(NSString *)website facebook:(NSString *)facebook instagram:(NSString *)instagram linkedin:(NSString *)linkedin about:(NSString *)about password:(NSString *)password logo:(UIImage *)logo withCompletion:(ResponseBlock)completion;

@end
