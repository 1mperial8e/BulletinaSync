//
//  NSDictionary+Nonnull.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "NSDictionary+Nonnull.h"

@implementation NSDictionary (Nonnull)

- (instancetype)nonnullDictionary
{
	NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
	for (NSString *key in self.allKeys) {
		id obj = [self objectForKey:key];
		if ((obj == [NSNull null]) || ((obj != [NSNull null]) && ([obj isKindOfClass:[NSString class]]) && ([obj isEqualToString:@"null"]))) {
			continue;
		} else {
			if ([obj isKindOfClass:[NSDictionary class]]) {
				obj = [obj nonnullDictionary];
			}
			[newDict setValue:obj forKey:key];
		}
	}
	return newDict;
}

@end
