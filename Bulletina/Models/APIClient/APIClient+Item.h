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

- (void)addNewItemWithName:(NSString *)name description:(NSString *)description price:(NSString *)price adType:(NSInteger)adType image:(UIImage *)image withCompletion:(ResponseBlock)completion;

@end
