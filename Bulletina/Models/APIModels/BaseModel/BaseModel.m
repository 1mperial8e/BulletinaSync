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

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary
{
	return [[self alloc] initWithDictionary:dictionary];
}

+ (NSArray *)arrayWithDictionariesArray:(NSArray *)dictsArray
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSDictionary *dict in dictsArray) {
		[array addObject:[[self alloc] initWithDictionary:dict]];
	}
	return array;
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

@end
