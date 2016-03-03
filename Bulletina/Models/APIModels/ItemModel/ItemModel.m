//
//  ItemModel.m
//  Bulletina
//
//  Created by Stas Volskyi on 2/10/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

+ (NSMutableArray *)arrayWithFavoritreDictionariesArray:(NSArray *)dictsArray
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSDictionary *dict in dictsArray) {
		[array addObject:[[self alloc] initWithDictionary:dict[@"item"]]];
	}
	return array;
}

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
	self.customerTypeId = [dictionary[@"customer_type_id"] integerValue];
	
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
	self.timeAgo = dictionary[@"time_ago"];
	self.imageHeight = [dictionary[@"image_height"] floatValue];
	self.imageWidth = [dictionary[@"image_width"] floatValue];
	self.isFavorite = [dictionary[@"is_favorite"] integerValue];
	
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

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	ItemModel *itemCopy = [[ItemModel allocWithZone:zone] init];
	
	itemCopy.active = _active;
	itemCopy.adTypeId = _adTypeId;
	itemCopy.banned =  _banned;
	itemCopy.city = [_city copy];
	itemCopy.countryId = _countryId;
	itemCopy.createdAt = [_createdAt copy];
	itemCopy.deleted = _deleted;
	itemCopy.text = [_text copy];
	itemCopy.hashtags = [_hashtags copy];
	itemCopy.itemId = _itemId;
	itemCopy.ignoreReports = _ignoreReports;
	itemCopy.imageThumbUrl = [_imageThumbUrl copy];
	itemCopy.imagesUrl = [_imagesUrl copy];
	itemCopy.latitude = [_latitude copy];
	itemCopy.longitude = [_longitude copy];
	itemCopy.name = [_name copy];
	itemCopy.price = [_price copy];
	itemCopy.updatedAt = [_updatedAt copy];
	itemCopy.userId = _userId;
	itemCopy.adTypeName = [_adTypeName copy];
	itemCopy.countryName = [_countryName copy];
	itemCopy.userAvatarThumbUrl = [_userUserAvatarUrl copy];
	itemCopy.userCompanyName = [_userCompanyName copy];
	itemCopy.userFullname = [_userFullname copy];
	itemCopy.userNickname = [_userNickname copy];
	itemCopy.distance = [_distance copy];
	itemCopy.timeAgo = [_timeAgo copy];
	itemCopy.imageHeight = _imageHeight;
	itemCopy.imageWidth = _imageWidth;
	itemCopy.userUserAvatarUrl = [_userUserAvatarUrl copy];
	itemCopy.category =[_category copy];
	return itemCopy;
}

@end
