//
//  APIClient+Item.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient.h"

@interface APIClient (Item)

#pragma mark - Categories

- (void)categoriesListWithCompletion:(ResponseBlock)completion;

#pragma mark - AddNew

- (void)addNewItemWithDescription:(NSString *)description price:(NSString *)price adType:(NSInteger)adType image:(UIImage *)image withCompletion:(ResponseBlock)completion;

#pragma mark - Update

- (void)updateItemId:(NSInteger)itemId withDescription:(NSString *)description price:(NSString *)price adType:(NSInteger)adType image:(UIImage *)image withCompletion:(ResponseBlock)completion;

#pragma mark - Items List

- (void)fetchItemsWithOffset:(NSNumber *)offset limit:(NSNumber *)limit withCompletion:(ResponseBlock)completion;

#pragma mark - Search Items

- (void)fetchItemsForSearchSettingsAndPage:(NSInteger)page withCompletion:(ResponseBlock)completion;

#pragma mark - Report

- (void)reportItemWithId:(NSInteger)itemId andUserId:(NSInteger)userId description:(NSString *)text reasonId:(NSInteger)reasonId withCompletion:(ResponseBlock)completion;

#pragma mark - Delete

- (NSURLSessionDataTask *)deleteItemWithId:(NSInteger)itemId withCompletion:(ResponseBlock)completion;

@end
