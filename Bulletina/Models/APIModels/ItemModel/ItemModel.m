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
		_category = [CategoryModel new];
	}
	return self;
}

- (void)parseDictionary:(NSDictionary *)dictionary
{
	self.active = [dictionary[@"active"] boolValue];
	self.adTypeId = [dictionary[@"ad_type_id"] longValue];
	self.banned =  [dictionary[@"banned"] boolValue];
	self.city = dictionary[@"city"];
	self.countryId = [dictionary[@"country_id"] integerValue];
	self.createdAt = dictionary[@"created_at"];
	self.deleted = [dictionary[@"deleted"] boolValue];
	self.text = dictionary[@"description"];
	self.hashtags = dictionary[@"hashtags"];
	self.itemId = [dictionary[@"id"] integerValue];
	self.ignoreReports = [dictionary[@"ignore_reports"] boolValue];
	
	NSString *imageThumbUrl = dictionary[@"image_thumb_url"];
	if (imageThumbUrl.length) {
		self.imageThumbUrl = [NSURL URLWithString:imageThumbUrl];
	}
	
	NSString *imagesUrl = dictionary[@"images_url"];
	if (imagesUrl.length) {
		self.imagesUrl = [NSURL URLWithString:imagesUrl];
	}
	
	self.latitude = dictionary[@"latitude"];
	self.longitude = dictionary[@"longitude"];
	self.name = dictionary[@"name"];
	self.price = dictionary[@"price"];
	self.updatedAt = dictionary[@"updated_at"];
	self.userId = [dictionary[@"user_id"] integerValue];
	
	self.adTypeName = dictionary[@"ad_type_name"];
	self.countryName = dictionary[@"country_name"];
	
	NSString *userAvatarThumbUrl = dictionary[@"user_avatar_thumb_url"];
	if (userAvatarThumbUrl.length) {
		self.userAvatarThumbUrl = [NSURL URLWithString:userAvatarThumbUrl];
	}
	
	self.userCompanyName = dictionary[@"user_company_name"];
	self.userFullname = dictionary[@"user_fullname"];
	self.userNickname = dictionary[@"user_nickname"];
	
	self.distance = dictionary[@"distance"];
	
	NSString *userUserAvatarUrl = dictionary[@"user_user_avatar_url"];
	if (userUserAvatarUrl.length) {
		self.userUserAvatarUrl = [NSURL URLWithString:userUserAvatarUrl];
	}	
	
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
