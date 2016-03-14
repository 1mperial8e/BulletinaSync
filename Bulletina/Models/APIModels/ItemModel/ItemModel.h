//
//  ItemModel.h
//  Bulletina
//
//  Created by Stas Volskyi on 2/10/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseModel.h"
#import "CategoryModel.h"

@interface ItemModel : BaseModel <NSCopying>

@property (strong, nonatomic) CategoryModel *category;

@property (assign, nonatomic) BOOL active;
@property (assign, nonatomic) NSInteger adTypeId;
@property (strong, nonatomic) NSString *adTypeName;
@property (assign, nonatomic) BOOL banned;
@property (strong, nonatomic) NSString *city;
@property (assign, nonatomic) NSInteger countryId;
@property (strong, nonatomic) NSString *countryName;
@property (strong, nonatomic) NSString *createdAt;
@property (assign, nonatomic) BOOL deleted;
@property (strong, nonatomic) NSString *text; //description
@property (strong, nonatomic) NSArray *hashtags;
@property (assign, nonatomic) NSInteger itemId;
@property (assign, nonatomic) BOOL ignoreReports;

@property (strong, nonatomic) NSURL *imageThumbUrl;
@property (strong, nonatomic) NSURL *imagesUrl;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *updatedAt;

@property (assign, nonatomic) NSInteger userId;
@property (assign, nonatomic) NSInteger customerTypeId;

@property (strong, nonatomic) NSURL *userAvatarThumbUrl;
@property (strong, nonatomic) NSString *userCompanyName;
@property (strong, nonatomic) NSString *userFullname;
@property (strong, nonatomic) NSString *userNickname;
@property (strong, nonatomic) NSURL *userUserAvatarUrl;

@property (assign, nonatomic) CGFloat imageHeight;
@property (assign, nonatomic) CGFloat imageWidth;
@property (strong, nonatomic) NSString *timeAgo;
@property (strong, nonatomic) NSString *distance;
@property (assign, nonatomic) BOOL isFavorite;
@property (assign, nonatomic) BOOL isChatActive;

+ (NSMutableArray *)arrayWithFavoritreDictionariesArray:(NSArray *)dictsArray;

#pragma mark - Private

- (ItemModel *)fakeItem;

@end
