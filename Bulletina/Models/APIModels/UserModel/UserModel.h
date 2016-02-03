//
//  UserModel.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, UserAccountType) {
	AnonymousAccount = 1,
	IndividualAccount = 2,
	BusinessAccount = 3
};

@interface UserModel : BaseModel

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *login;

@property (assign, nonatomic) UserAccountType customer_type_id;
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
@property (strong, nonatomic) NSString *company_name;
@property (strong, nonatomic) NSString *home_latitude;
@property (strong, nonatomic) NSString *home_longitude;
@property (strong, nonatomic) NSString *avatar_url;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *facebook;
@property (strong, nonatomic) NSString *linkedin;

//@property (strong, nonatomic) NSString *address;
//@property (strong, nonatomic) NSString *cellphone;
//@property (strong, nonatomic) NSString *country_id;
//@property (strong, nonatomic) NSString *created_at;
//@property (strong, nonatomic) NSString *email_confirmation_sent_at;
//@property (strong, nonatomic) NSString *email_confirmation_token;
//@property (strong, nonatomic) NSString *email_confirmed_at;
//@property (strong, nonatomic) NSString *hours;
//@property (strong, nonatomic) NSString *language_id;
//@property (strong, nonatomic) NSString *password_digest; //not present at generated user
//@property (strong, nonatomic) NSString *reset_password_sent_at;
//@property (strong, nonatomic) NSString *reset_password_token; //not present at generated user
//@property (strong, nonatomic) NSString *twitter;
//@property (strong, nonatomic) NSString *unconfirmed_email;
//@property (strong, nonatomic) NSString *updated_at;

@end
