//
//  CategoryModel.m
//  Bulletina
//
//  Created by Stas Volskyi on 2/10/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

- (void)parseDictionary:(NSDictionary *)dictionary
{
    _name = dictionary[@"name"];
    _categoryId = [dictionary[@"id"] integerValue];
}

@end
