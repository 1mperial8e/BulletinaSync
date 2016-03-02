//
//  APIClient+Item.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient.h"

extern NSInteger const ItemsPerPage;

@interface APIClient (Item)

#pragma mark - Categories

- (void)categoriesListWithCompletion:(ResponseBlock)completion;

#pragma mark - ReportResons

- (void)reportReasonsListWithCompletion:(ResponseBlock)completion;

#pragma mark - Items

- (void)addNewItemWithDescription:(NSString *)description price:(NSString *)price adType:(NSInteger)adType image:(UIImage *)image withCompletion:(ResponseBlock)completion;
- (void)updateItemId:(NSInteger)itemId withDescription:(NSString *)description price:(NSString *)price adType:(NSInteger)adType image:(UIImage *)image withCompletion:(ResponseBlock)completion;

- (NSURLSessionTask *)fetchItemsForUserId:(NSInteger)userId page:(NSInteger)page withCompletion:(ResponseBlock)completion;
- (NSURLSessionTask *)fetchAllItemsForPage:(NSInteger)page withCompletion:(ResponseBlock)completion;
- (NSURLSessionTask *)fetchItemsWithSearchText:(NSString *)searchString page:(NSInteger)page withCompletion:(ResponseBlock)completion;

- (void)reportItemWithId:(NSInteger)itemId andUserId:(NSInteger)userId description:(NSString *)text reasonId:(NSInteger)reasonId withCompletion:(ResponseBlock)completion;
- (NSURLSessionDataTask *)deleteItemWithId:(NSInteger)itemId withCompletion:(ResponseBlock)completion;

- (NSURLSessionDataTask *)loadMyFavoriteItemsWithCompletion:(ResponseBlock)completion;
- (NSURLSessionDataTask *)addFavoriteItemId:(NSInteger)itemId withCompletion:(ResponseBlock)completion;
- (NSURLSessionDataTask *)removeFavoriteItemId:(NSInteger)itemId withCompletion:(ResponseBlock)completion;

@end
