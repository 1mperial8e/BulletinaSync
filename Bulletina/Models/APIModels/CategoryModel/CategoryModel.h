//
//  CategoryModel.h
//  Bulletina
//
//  Created by Stas Volskyi on 2/10/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseModel.h"

@interface CategoryModel : BaseModel

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger categoryId;

@end
