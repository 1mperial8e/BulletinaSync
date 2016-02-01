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

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self) {
		[self parseDictionary:dictionary.nonnullDictionary];
	}
	return  self;
}

#pragma mark - Parse

- (void)parseDictionary:(NSDictionary *)dictionary
{
	DLog(@"parseDictionary is not implemented for class %@", NSStringFromClass(self.class));
}

#pragma mark - Helpers

- (NSString *)stringFromDictionary:(NSDictionary*)newDictionary forKey:(NSString *)newKey {
	
	if ((NSNull *)newDictionary != [NSNull null] && [newDictionary isKindOfClass:[NSDictionary class]] && newKey &&
		[newKey isKindOfClass:[NSString class]] && [newKey length] > 0) {
		
		id newObject = [newDictionary objectForKey:newKey];
		if (newObject && (NSNull *)newObject != [NSNull null]) {
			if ([newObject respondsToSelector:@selector(stringValue)]) {
				newObject = [newObject stringValue];
			}
			return newObject;
		}
	}
	
	return @"";
}

- (double)doubleFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey {
	
	if ((NSNull *)newDictionary != [NSNull null] && [newDictionary isKindOfClass:[NSDictionary class]] && newKey &&
		[newKey isKindOfClass:[NSString class]] && [newKey length] > 0) {
		
		id newObject = [newDictionary objectForKey:newKey];
		if (newObject && (NSNull *)newObject != [NSNull null]) {
			if ([newObject respondsToSelector:@selector(doubleValue)]) {
				return [newObject doubleValue];
			}
		}
	}
	
	return 0.0;
}

- (float)floatFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey {
	
	if ((NSNull *)newDictionary != [NSNull null] && [newDictionary isKindOfClass:[NSDictionary class]] && newKey &&
		[newKey isKindOfClass:[NSString class]] && [newKey length] > 0) {
		
		id newObject = [newDictionary objectForKey:newKey];
		if (newObject && (NSNull *)newObject != [NSNull null]) {
			if ([newObject respondsToSelector:@selector(floatValue)]) {
				return [newObject floatValue];
			}
		}
	}
	
	return 0.0f;
}

//- (NSDate *)dateFromDictionary:(NSDictionary*)newDictionary forKey:(NSString *)newKey {
//	if ((NSNull *)newDictionary != [NSNull null] && [newDictionary isKindOfClass:[NSDictionary class]] && newKey &&
//		[newKey isKindOfClass:[NSString class]] && [newKey length] > 0) {
//		
//		id newObject = [newDictionary objectForKey:newKey];
//		if (newObject && (NSNull *)newObject != [NSNull null]) {
//			
//			return [myDateFormatter dateFromString:newObject];
//		}
//	}
//	
//	return nil;
//}

- (NSInteger)integerFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey {
	
	if ((NSNull *)newDictionary != [NSNull null] && [newDictionary isKindOfClass:[NSDictionary class]] && newKey &&
		[newKey isKindOfClass:[NSString class]] && [newKey length] > 0) {
		
		id newObject = [newDictionary objectForKey:newKey];
		if (newObject && (NSNull *)newObject != [NSNull null]) {
			if ([newObject respondsToSelector:@selector(integerValue)]) {
				return [newObject integerValue];
			}
		}
	}
	
	return 0;
}

- (BOOL)boolFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey {
	
	if ((NSNull *)newDictionary != [NSNull null] && [newDictionary isKindOfClass:[NSDictionary class]] && newKey &&
		[newKey isKindOfClass:[NSString class]] && [newKey length] > 0) {
		
		id newObject = [newDictionary objectForKey:newKey];
		if (newObject && (NSNull *)newObject != [NSNull null]) {
			if ([newObject respondsToSelector:@selector(boolValue)]) {
				return [newObject boolValue];
			}
		}
	}
	
	return NO;
}

- (long)longFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey {
	
	if ((NSNull *)newDictionary != [NSNull null] && [newDictionary isKindOfClass:[NSDictionary class]] && newKey &&
		[newKey isKindOfClass:[NSString class]] && [newKey length] > 0) {
		
		id newObject = [newDictionary objectForKey:newKey];
		
		if (newObject && (NSNull *)newObject != [NSNull null]) {
			if ([newObject respondsToSelector:@selector(longValue)]) {
				return [newObject longValue];
			}
			else{
				if ([newObject respondsToSelector:@selector(integerValue)]) {
					return [newObject integerValue];
				}
			}
		}
	}
	
	return 0;
}

- (long long)longLongFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey {
	
	if ((NSNull *)newDictionary != [NSNull null] && [newDictionary isKindOfClass:[NSDictionary class]] && newKey &&
		[newKey isKindOfClass:[NSString class]] && [newKey length] > 0) {
		
		id newObject = [newDictionary objectForKey:newKey];
		if (newObject && (NSNull *)newObject != [NSNull null]) {
			if ([newObject respondsToSelector:@selector(longLongValue)]) {
				return [newObject longLongValue];
			}
		}
	}
	
	return 0;
}

- (NSDictionary *)dictionaryFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey {
	
	if ((NSNull *)newDictionary != [NSNull null] && [newDictionary isKindOfClass:[NSDictionary class]] && newKey &&
		[newKey isKindOfClass:[NSString class]] && [newKey length] > 0) {
		
		id newObject = [newDictionary objectForKey:newKey];
		if (newObject && (NSNull *)newObject != [NSNull null]) {
			if ([newObject isKindOfClass:[NSDictionary class]]) {
				return newObject;
			}
		}
	}
	return [NSDictionary dictionary];
}

- (NSArray *)arrayFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey {
	
	if ((NSNull *)newDictionary != [NSNull null] && [newDictionary isKindOfClass:[NSDictionary class]] && newKey &&
		[newKey isKindOfClass:[NSString class]] && [newKey length] > 0) {
		
		id newObject = [newDictionary objectForKey:newKey];
		if (newObject && (NSNull *)newObject != [NSNull null]) {
			if ([newObject isKindOfClass:[NSArray class]]) {
				return newObject;
			}
		}
	}
	return [NSArray array];
}


@end
