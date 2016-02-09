//
//  APIClient+Session.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient.h"

@interface APIClient (Session)

- (NSURLSessionDataTask *)loginSessionWithUsername:(NSString *)username password:(NSString *)password withCompletion:(ResponseBlock)completion;
- (NSURLSessionDataTask *)logoutSessionWithCompletion:(ResponseBlock)completion;

@end
