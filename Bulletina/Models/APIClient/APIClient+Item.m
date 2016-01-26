//
//  APIClient+Item.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient+Item.h"

@implementation APIClient (Item)

#pragma mark - AddNew

- (void)addNewItemWithCategory:(NSString *)category description:(NSString *)description price:(NSString *)price image:(UIImage *)image withCompletion:(ResponseBlock)completion
{
	if (completion) {
		completion(nil, nil, 404);
	}
}

@end
