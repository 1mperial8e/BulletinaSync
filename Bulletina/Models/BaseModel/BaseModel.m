//
//  BaseModel.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

#pragma mark - init

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self) {
		[self parseDictionary:dictionary.nonnullDictionary];
	}
	return  self;
}

- (void)parseDictionary:(NSDictionary *)dictionary
{
	DLog(@"parseDictionary is not implemented for class %@", NSStringFromClass(self.class));
}

@end
