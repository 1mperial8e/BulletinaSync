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


@property (strong, nonatomic) NSString *password;
@property (assign, nonatomic) BOOL isActive; //active
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *avatar_url;
@property (assign, nonatomic) BOOL isBanned; //banned
@property (strong, nonatomic) NSString *cellphone;

@property (strong, nonatomic) NSString *company_name;
@property (assign, nonatomic) NSInteger country_id;
@property (strong, nonatomic) NSString *created_at;
@property (assign, nonatomic) UserAccountType customer_type_id;
@property (assign, nonatomic) BOOL isDeleted; //deleted

@property (strong, nonatomic) NSString *about; //description
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *email_confirmation_sent_at;
@property (strong, nonatomic) NSString *email_confirmation_token;
@property (strong, nonatomic) NSString *email_confirmed_at;

@property (strong, nonatomic) NSString *facebook;
@property (strong, nonatomic) NSString *home_latitude;
@property (strong, nonatomic) NSString *home_longitude;
@property (strong, nonatomic) NSString *hours;
@property (assign, nonatomic) NSInteger userId; //id

@property (assign, nonatomic) BOOL ignoreReports; //ignore_reports
@property (assign, nonatomic) BOOL isAdmin; //is_admin
@property (assign, nonatomic) NSInteger language_id;
@property (strong, nonatomic) NSString *linkedin;
@property (assign, nonatomic) BOOL isLocked; //locked

@property (strong, nonatomic) NSString *login;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *password_digest; //not present at generated user
@property (strong, nonatomic) NSString *phone; //cellphone duplicate?
@property (strong, nonatomic) NSString *reset_password_sent_at;
@property (strong, nonatomic) NSString *reset_password_token; //not present at generated user
@property (strong, nonatomic) NSString *twitter;
@property (strong, nonatomic) NSString *unconfirmed_email;
@property (strong, nonatomic) NSString *updated_at;
@property (strong, nonatomic) NSString *website;

@end
