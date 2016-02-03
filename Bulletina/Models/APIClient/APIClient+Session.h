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
									endpointArn:(NSString *)endpointArn
									deviceToken:(NSString *)deviceToken
								operatingSystem:(NSString *)operatingSystem
									 deviceType:(NSString *)deviceType
							   currentLattitude:(CGFloat)currentLattitude
							   currentLongitude:(CGFloat)currentLongitude
								 withCompletion:(ResponseBlock)completion;

- (NSURLSessionDataTask *)logoutSessionWithCompletion:(ResponseBlock)completion;

@end
