//
//  ItemModel.h
//  Bulletina
//
//  Created by Stas Volskyi on 2/10/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseModel.h"
#import "CategoryModel.h"

@interface ItemModel : BaseModel

@property (strong, nonatomic) CategoryModel *category;

@property (assign, nonatomic) BOOL active;
@property (assign, nonatomic) NSInteger adTypeId;
@property (assign, nonatomic) BOOL banned;
@property (strong, nonatomic) NSString *city;
@property (assign, nonatomic) NSInteger countryId;
@property (strong, nonatomic) NSString *createdAt;
@property (assign, nonatomic) BOOL deleted;
@property (strong, nonatomic) NSString *text; //description
@property (strong, nonatomic) NSArray *hashtags;
@property (assign, nonatomic) NSInteger itemId;
@property (assign, nonatomic) BOOL ignoreReports;
@property (strong, nonatomic) NSString *imageThumbUrl;
@property (strong, nonatomic) NSString *imagesUrl;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *updatedAt;
@property (assign, nonatomic) NSInteger userId;

@end
