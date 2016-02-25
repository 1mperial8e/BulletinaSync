//
//  APIClient+Message.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient+Message.h"

@implementation APIClient (Message)

- (NSURLSessionTask *)fetchMyMessagesWithPage:(NSInteger)page withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
	[parameters setValue:@(page * ItemsPerPage) forKey:@"offset"];
	[parameters setValue:@(ItemsPerPage) forKey:@"limit"];
	
	return [self performGET:@"api/v1/messages.json" withParameters:parameters response:completion];
}

@end
