//
//  APIClient+Message.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient.h"
#import "APIClient+Item.h"

@interface APIClient (Message)

- (NSURLSessionTask *)fetchMyMessagesWithPage:(NSInteger)page withCompletion:(ResponseBlock)completion;
- (NSURLSessionTask *)fetchMyUnreadMessagesCountWithCompletion:(ResponseBlock)completion;
- (NSURLSessionTask *)fetchConversationsListWithCompletion:(ResponseBlock)completion;

@end
