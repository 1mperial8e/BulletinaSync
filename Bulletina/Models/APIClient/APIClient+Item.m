//
//  APIClient+Item.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient+Item.h"

// Models
#import "LocationManager.h"

NSInteger const ItemsPerPage = 10;

@implementation APIClient (Item)

#pragma mark - Categories

- (void)categoriesListWithCompletion:(ResponseBlock)completion
{
    [self performGET:@"/api/v1/ad_types.json" withParameters:nil response:completion];
}

#pragma mark - ReportResons

- (void)reportReasonsListWithCompletion:(ResponseBlock)completion
{
	[self performGET:@"/api/v1/report_reasons.json" withParameters:nil response:completion];
}

#pragma mark - Items

- (void)addNewItemWithDescription:(NSString *)description price:(NSString *)price adType:(NSInteger)adType image:(UIImage *)image withCompletion:(ResponseBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
    NSMutableDictionary *itemParameters = [NSMutableDictionary dictionary];
    [itemParameters setValue:@(adType) forKey:@"ad_type_id"];
    [itemParameters setValue:price ? price : @"" forKey:@"price"];
    [itemParameters setValue:description ? description : @"" forKey:@"description"];
    [itemParameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.latitude) forKey:@"latitude"];
    [itemParameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.longitude) forKey:@"longitude"];
    [itemParameters setValue:@YES forKey:@"active"];
    [itemParameters setValue:@(self.currentUser.userId) forKey:@"user_id"];

    NSArray *dataArray;
    if (image) {
        dataArray = @[[self multipartFileWithContents:UIImageJPEGRepresentation(image, 1.0f) fileName:@"image.jpg" mimeType:@"image/jpeg" parameterName:@"item[image]"]];
    }
    
    [parameters setValue:itemParameters forKey:@"item"];

    [self performPOST:@"api/v1/items.json" withParameters:parameters multipartData:dataArray response:completion];
}

- (void)updateItemId:(NSInteger)itemId withDescription:(NSString *)description price:(NSString *)price adType:(NSInteger)adType image:(UIImage *)image withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
	NSMutableDictionary *itemParameters = [NSMutableDictionary dictionary];
//	[itemParameters setValue:@(adType) forKey:@"ad_type_id"];
	[itemParameters setValue:price ? price : @"" forKey:@"price"];
	[itemParameters setValue:description ? description : @"" forKey:@"description"];
//	[itemParameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.latitude) forKey:@"latitude"];
//	[itemParameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.longitude) forKey:@"longitude"];
//	[itemParameters setValue:@YES forKey:@"active"];
	[itemParameters setValue:@(self.currentUser.userId) forKey:@"user_id"];  
//	[itemParameters setValue:@(itemId) forKey:@"id"];
//	[itemParameters setValue:@"" forKey:@"name"];
//	[itemParameters setValue:@"" forKey:@"hashtags"];
//	[itemParameters setValue:@"" forKey:@"city"];
//	[itemParameters setValue:@"" forKey:@"country_id"];

	NSArray *dataArray;
	if (image) {
		dataArray = @[[self multipartFileWithContents:UIImageJPEGRepresentation(image, 1.0f) fileName:@"image.jpg" mimeType:@"image/jpeg" parameterName:@"item[image]"]];
	}

	[parameters setValue:itemParameters forKey:@"item"];
	NSString *query = [NSString stringWithFormat:@"api/v1/items/%zd.json", itemId];
	
	[self performPUT:query withParameters:parameters multipartData:dataArray response:completion];
}

- (NSURLSessionTask *)fetchItemsForUserId:(NSInteger)userId page:(NSInteger)page withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
	[parameters setValue:@(userId) forKey:@"id"];
	
//	NSString *query = [NSString stringWithFormat:@"api/v1/items/%zd.json", userId];
	
	return [self performGET:@"api/v1/items.json" withParameters:parameters response:completion];
}

- (NSURLSessionTask *)fetchAllItemsForUserId:(NSInteger)userId page:(NSInteger)page withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
	[parameters setValue:@(page * ItemsPerPage) forKey:@"offset"];
//	[parameters setValue:@(page) forKey:@"page"];
	[parameters setValue:@(ItemsPerPage) forKey:@"limit"];
	[parameters setValue:@(userId) forKey:@"user_id"];
	[parameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.latitude) forKey:@"latitude"];
	[parameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.longitude) forKey:@"longitude"];
	
	NSString *query = [NSString stringWithFormat:@"api/v1/items.json"];
	
	return [self performGET:query withParameters:parameters response:completion];
}

- (NSURLSessionTask *)fetchItemsWithSearchText:(NSString *)searchString page:(NSInteger)page withCompletion:(ResponseBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
    NSMutableDictionary *searchParameters = [NSMutableDictionary dictionary];
    [searchParameters setValue:@(page) forKey:@"page"];
	[searchParameters setValue:@(ItemsPerPage) forKey:@"limit"];
    
    [searchParameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.latitude) forKey:@"latitude"];
    [searchParameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.longitude) forKey:@"longitude"];
    
	CGFloat searchAreaPercentage = [Defaults floatForKey:SearchAreaKey]?:0.5f;
    [searchParameters setValue:@(MaxSearchArea * searchAreaPercentage) forKey:@"distance"];
    [searchParameters setValue:searchString ? searchString : @"" forKey:@"searchstring"];

	NSString *adTypesIds = @"";
	NSMutableDictionary *categoriesId = [NSMutableDictionary new];
	
	if ([Defaults objectForKey:CategoriesSettingsKey]) {
		categoriesId = [[Defaults dictionaryForKey:CategoriesSettingsKey] mutableCopy];
	} else if ([Defaults objectForKey:CategoriesListKey]) {
		NSMutableArray *categoriesArray = [CategoryModel arrayWithDictionariesArray:[Defaults objectForKey:CategoriesListKey]];
		for (NSInteger i = 0; i < categoriesArray.count; i++){
			CategoryModel *currentCategory = categoriesArray[i];
			[categoriesId setValue:@YES forKey:@(currentCategory.categoryId).stringValue];
		}
		[Utils storeValue:categoriesId forKey:CategoriesSettingsKey];
		
	} else {
		
		[[APIClient sharedInstance] categoriesListWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
			if (!error) {
				NSParameterAssert([response isKindOfClass:[NSArray class]]);
				[Utils storeValue:response forKey:CategoriesListKey];
				
				for (NSInteger i = 0; i < ((NSArray *)response).count; i++) {
					CategoryModel *currentCategory = [[CategoryModel alloc] initWithDictionary:response[i]];
					[categoriesId setValue:@YES forKey:@(currentCategory.categoryId).stringValue];
				}
				[Utils storeValue:categoriesId forKey:CategoriesSettingsKey];
				[[NSNotificationCenter defaultCenter] postNotificationName:SettingsChangedNotificaionName object:nil];
			}
		}];
	}
	
	NSString *key;
	for (key in categoriesId){
		if ([categoriesId[key] boolValue]) {
			if (adTypesIds.length) {
				adTypesIds = [adTypesIds stringByAppendingString:@","];
			}
			adTypesIds = [adTypesIds stringByAppendingString:key];
		}
	}
	
	[searchParameters setValue:adTypesIds forKey:@"ad_type_ids"];
	
    [parameters setValue:searchParameters forKey:@"search"];
	
    return [self performGET:@"api/v1/search.json" withParameters:parameters response:completion];
}


- (void)reportItemWithId:(NSInteger)itemId andUserId:(NSInteger)userId description:(NSString *)text reasonId:(NSInteger)reasonId withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
	NSMutableDictionary *reportParameters = [NSMutableDictionary dictionary];
	[reportParameters setValue:@(userId) forKey:@"user_id"];
	[reportParameters setValue:@(itemId) forKey:@"item_id"];
	[reportParameters setValue:@(reasonId) forKey:@"report_reason_id"];
	[reportParameters setValue:text forKey:@"user_comment"];
	
	[parameters setValue:reportParameters forKey:@"report"];
	
	[self performPOST:@"api/v1/reports" withParameters:parameters multipartData:nil response:completion];
}

- (NSURLSessionDataTask *)deleteItemWithId:(NSInteger)itemId withCompletion:(ResponseBlock)completion
{
	NSParameterAssert(self.passtoken);
    NSParameterAssert(itemId);

	NSDictionary *parameters = @{@"passtoken" : self.passtoken};
	NSString *query = [NSString stringWithFormat:@"api/v1/items/%zd.html", itemId];
	return [self performDELETE:query withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)addFavoriteItemId:(NSInteger)itemId withCompletion:(ResponseBlock)completion
{
	NSParameterAssert(self.passtoken);
	NSParameterAssert(itemId);
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
	NSMutableDictionary *favoriteParameters = [NSMutableDictionary dictionary];
	[favoriteParameters setValue:@(itemId) forKey:@"item_id"];
	[parameters setValue:favoriteParameters forKey:@"favorite"];
	
	return [self performPOST:@"api/v1/favorites.json" withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)removeFavoriteItemId:(NSInteger)itemId withCompletion:(ResponseBlock)completion
{
	NSParameterAssert(self.passtoken);
	NSParameterAssert(itemId);
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
	NSMutableDictionary *favoriteParameters = [NSMutableDictionary dictionary];
	[favoriteParameters setValue:@(itemId) forKey:@"item_id"];
	[parameters setValue:favoriteParameters forKey:@"favorite"];
	
	NSString *query = [NSString stringWithFormat:@"api/v1/favorites/%zd.json", itemId];
	return [self performDELETE:query withParameters:parameters response:completion];
}

- (NSURLSessionDataTask *)loadMyFavoriteItemsForPage:(NSInteger)page withCompletion:(ResponseBlock)completion
{
	NSParameterAssert(self.passtoken);
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
	[parameters setValue:@(page * ItemsPerPage) forKey:@"offset"];
	//	[parameters setValue:@(page) forKey:@"page"];
	[parameters setValue:@(ItemsPerPage) forKey:@"limit"];
	[parameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.latitude) forKey:@"latitude"];
	[parameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.longitude) forKey:@"longitude"];
	return [self performGET:@"api/v1/favorites.json" withParameters:parameters response:completion];
}

@end
