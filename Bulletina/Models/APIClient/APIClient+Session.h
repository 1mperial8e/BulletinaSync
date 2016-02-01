//
//  APIClient+Session.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient.h"

@interface APIClient (Session)

- (NSURLSessionDataTask *)loginSessionWithEmail:(NSString *)email
									   password:(NSString *)password
								   endpoint_arn:(NSString *)endpoint_arn
								   device_token:(NSString *)device_token
							   operating_system:(NSString *)operating_system
									device_type:(NSString *)device_type
							  current_lattitude:(NSString *)current_lattitude
							  current_longitude:(NSString *)current_longitude
								 withCompletion:(ResponseBlock)completion;

- (NSURLSessionDataTask *)logoutSessionWithUserId:(NSInteger)userId passtoken:(NSString *)passtoken withCompletion:(ResponseBlock)completion;

@end
