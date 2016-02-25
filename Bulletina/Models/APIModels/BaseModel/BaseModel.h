//
//  BaseModel.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

@interface BaseModel : NSObject

#pragma mark - init

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)arrayWithDictionariesArray:(NSArray *)dictsArray;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

#pragma mark - Parse

- (void)parseDictionary:(NSDictionary *)dictionary;

@end
