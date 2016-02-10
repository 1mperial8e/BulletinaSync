//
//  NSDictionary+Nonnull.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

@interface NSDictionary (Nonnull)

- (instancetype)nonnullDictionary;
+ (NSArray *)arrayByRemovingNulls:(NSArray *)array;

@end
