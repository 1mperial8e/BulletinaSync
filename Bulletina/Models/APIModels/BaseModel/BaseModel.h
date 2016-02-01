//
//  BaseModel.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

@interface BaseModel : NSObject

#pragma mark - init

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

#pragma mark - Parse

- (void)parseDictionary:(NSDictionary *)dictionary;

#pragma mark - Helpers

- (NSString *)stringFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey;
- (double)doubleFromDictionary:(NSDictionary *)newDictionary forKey:(NSString*)newKey;
- (float)floatFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey;
- (NSInteger)integerFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey;
- (long)longFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey;
- (long long)longLongFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey;
//- (NSDate *)dateFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey;
- (BOOL)boolFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey;
- (NSDictionary*)dictionaryFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey ;
- (NSArray*)arrayFromDictionary:(NSDictionary *)newDictionary forKey:(NSString *)newKey;

@end
