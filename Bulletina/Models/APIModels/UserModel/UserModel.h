//
//  UserModel.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseModel.h"
#import "ItemModel.h"

typedef NS_ENUM(NSInteger, UserAccountType) {
	AnonymousAccount = 1,
	IndividualAccount = 2,
	BusinessAccount = 3
};

@interface UserModel : BaseModel <NSCopying>

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *login;

@property (assign, nonatomic) UserAccountType customerTypeId;
@property (assign, nonatomic) NSInteger userId;

@property (assign, nonatomic) BOOL isActive;
@property (assign, nonatomic) BOOL isBanned;
@property (assign, nonatomic) BOOL isDeleted;
@property (assign, nonatomic) BOOL ignoreReports;
@property (assign, nonatomic) BOOL isAdmin;
@property (assign, nonatomic) BOOL isLocked;

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *about;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *homeLatitude;
@property (strong, nonatomic) NSString *homeLongitude;
@property (strong, nonatomic) NSURL *avatarUrl;
@property (strong, nonatomic) NSURL *avatarUrlThumb;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *facebook;
@property (strong, nonatomic) NSString *linkedin;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *rePassword;

- (NSString *)title;

- (instancetype)initWithItem:(ItemModel *)item;

@end
