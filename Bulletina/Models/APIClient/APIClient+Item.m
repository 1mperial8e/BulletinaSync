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

@implementation APIClient (Item)

#pragma mark - Categories

- (void)categoriesListWithCompletion:(ResponseBlock)completion
{
    [self performGET:@"/api/v1/ad_types.json" withParameters:nil response:completion];
}

#pragma mark - AddNew

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

#pragma mark - Update

- (void)updateItemId:(NSInteger)itemId withDescription:(NSString *)description price:(NSString *)price adType:(NSInteger)adType image:(UIImage *)image withCompletion:(ResponseBlock)completion
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
	[itemParameters setValue:@(itemId) forKey:@"id"];
	[itemParameters setValue:@"" forKey:@"name"];
	[itemParameters setValue:@"" forKey:@"hashtags"];
	[itemParameters setValue:@"" forKey:@"city"];
	[itemParameters setValue:@"" forKey:@"active"];

	NSArray *dataArray;
	if (image) {
		dataArray = @[[self multipartFileWithContents:UIImageJPEGRepresentation(image, 1.0f) fileName:@"image.jpg" mimeType:@"image/jpeg" parameterName:@"item[image]"]];
	}

	[parameters setValue:itemParameters forKey:@"item"];
	NSString *query = [NSString stringWithFormat:@"api/v1/items/%zd.html", itemId];
	
	[self performPUT:query withParameters:parameters multipartData:dataArray response:completion];
}

#pragma mark - Items List

- (void)fetchItemsWithOffset:(NSNumber *)offset limit:(NSNumber *)limit withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
	[parameters setValue:offset forKey:@"offset"];
	[parameters setValue:limit forKey:@"limit"];
	
	[self performGET:@"api/v1/items.json" withParameters:parameters response:completion];
}

- (void)fetchItemsForUserId:(NSInteger)userId withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
	[parameters setValue:@(userId) forKey:@"id"];
	
//	NSString *query = [NSString stringWithFormat:@"api/v1/items/%zd.html", userId];
	
	[self performGET:@"api/v1/items.json" withParameters:parameters response:completion];
}

#pragma mark - Search Items

- (void)fetchItemsWithSettingsForSearchString:(NSString *)searchString withCompletion:(ResponseBlock)completion
{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
	NSMutableDictionary *searchParameters = [NSMutableDictionary dictionary];
//	[searchParameters setValue:@(page) forKey:@"page"];
	[searchParameters setValue:@25 forKey:@"limit"];
	[searchParameters setValue:@0 forKey:@"offset"];

	[searchParameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.latitude) forKey:@"latitude"];
	[searchParameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.longitude) forKey:@"longitude"];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	CGFloat searchAreaPercentage;
	if ([defaults objectForKey:SearchAreaKey]) {
		searchAreaPercentage = [defaults floatForKey:SearchAreaKey];
	} else {
		searchAreaPercentage = 1.0;
	}
	[searchParameters setValue:@(MaxSearchArea * searchAreaPercentage) forKey:@"distance"];
	[searchParameters setValue:searchString forKey:@"searchstring"];
	[parameters setValue:searchParameters forKey:@"search"];
	
	[self performGET:@"api/v1/search.json" withParameters:parameters response:completion];
}

#pragma mark - Report

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

#pragma mark - Delete

- (NSURLSessionDataTask *)deleteItemWithId:(NSInteger)itemId withCompletion:(ResponseBlock)completion
{
	NSParameterAssert(self.passtoken);
	
	NSDictionary *parameters = @{@"passtoken" : self.passtoken};
	NSString *query = [NSString stringWithFormat:@"api/v1/items/%zd.html", itemId];
	return [self performDELETE:query withParameters:parameters response:completion];
}

@end
