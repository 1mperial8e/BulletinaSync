//
//  CategoryModel.m
//  Bulletina
//
//  Created by Stas Volskyi on 2/10/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

- (void)parseDictionary:(NSDictionary *)dictionary
{
    _name = dictionary[@"name"];
    _categoryId = [dictionary[@"id"] longValue];
	_hasPrice = [dictionary[@"has_price"]boolValue];
}

- (id) copyWithZone:(NSZone *)zone
{
	CategoryModel *categoryCopy = [[CategoryModel allocWithZone:zone] init];
	
	categoryCopy.name = [_name copy];
	categoryCopy.categoryId = _categoryId;
	categoryCopy.hasPrice = _hasPrice;
	
	return categoryCopy;
}

@end
