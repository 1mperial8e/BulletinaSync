//
//  ItemModel.m
//  Bulletina
//
//  Created by Stas Volskyi on 2/10/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

- (instancetype)init
{
	self = [super init];
	if (self) {
//		_category = [CategoryModel new];
	}
	return self;
}

- (void)parseDictionary:(NSDictionary *)dictionary
{
	self.active = [dictionary[@"active"] boolValue];
	self.adTypeId = [dictionary[@"ad_type_id"] integerValue];
	self.banned =  [dictionary[@"banned"] boolValue];
	self.city = dictionary[@"city"];
	self.countryId = [dictionary[@"country_id"] integerValue];
	self.createdAt = dictionary[@"created_at"];
	self.deleted = [dictionary[@"deleted"] boolValue];
	self.text = dictionary[@"description"];
	self.hashtags = dictionary[@"hashtags"];
	self.itemId = [dictionary[@"id"] integerValue];
	self.ignoreReports = [dictionary[@"ignore_reports"] boolValue];
	self.imageThumbUrl = dictionary[@"image_thumb_url"];
	self.imagesUrl = dictionary[@"images_url"];
	self.latitude = dictionary[@"latitude"];
	self.longitude = dictionary[@"longitude"];
	self.name = dictionary[@"name"];
	self.price = dictionary[@"price"];
	self.updatedAt = dictionary[@"updated_at"];
	self.userId = [dictionary[@"user_id"] integerValue];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:CategoriesListKey]) {
		NSArray *categoriesArray = [CategoryModel arrayWithDictionariesArray:[defaults objectForKey:CategoriesListKey]];
		for (CategoryModel *category in categoriesArray) {
			if (category.categoryId == self.adTypeId) {
				self.category = category;
			}
		}
	}
}

@end
