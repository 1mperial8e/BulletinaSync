//
//  UserModel.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "UserModel.h"

@interface UserModel ()

@end

@implementation UserModel

#pragma mark - Parse

- (void)parseDictionary:(NSDictionary *)dictionary
{
	NSDictionary *userWithInfo;
	id newObject = [dictionary objectForKey:@"user"];
	if (newObject) {
		userWithInfo = dictionary[@"user"];
		self.password = [self stringFromDictionary:dictionary forKey:@"passwd"];
	} else {
		userWithInfo = dictionary;
	}	
	
	self.isActive = [self boolFromDictionary:userWithInfo forKey:@"active"];//active
	self.address = [self stringFromDictionary:userWithInfo forKey:@"address"];
	self.avatar_url = [self stringFromDictionary:userWithInfo forKey:@"avatar_url"];
	self.isBanned = [self boolFromDictionary:userWithInfo forKey:@"banned"]; //banned
	self.cellphone = [self stringFromDictionary:userWithInfo forKey:@"cellphone"];
	
	self.company_name = [self stringFromDictionary:userWithInfo forKey:@"company_name"];
	self.country_id = [self integerFromDictionary:userWithInfo forKey:@"country_id"];
	self.created_at = [self stringFromDictionary:userWithInfo forKey:@"created_at"];
	self.customer_type_id = [self integerFromDictionary:userWithInfo forKey:@"customer_type_id"];
	self.isDeleted = [self boolFromDictionary:userWithInfo forKey:@"deleted"]; //deleted
	
	self.about = [self stringFromDictionary:userWithInfo forKey:@"description"]; //description
	self.email = [self stringFromDictionary:userWithInfo forKey:@"email"];
	self.email_confirmation_sent_at = [self stringFromDictionary:userWithInfo forKey:@"email_confirmation_sent_at"];
	self.email_confirmation_token = [self stringFromDictionary:userWithInfo forKey:@"email_confirmation_token"];
	self.email_confirmed_at = [self stringFromDictionary:userWithInfo forKey:@"email_confirmed_at"];
	
	self.facebook = [self stringFromDictionary:userWithInfo forKey:@"facebook"];
	self.home_latitude = [self stringFromDictionary:userWithInfo forKey:@"home_latitude"];
	self.home_longitude = [self stringFromDictionary:userWithInfo forKey:@"home_longitude"];
	self.hours = [self stringFromDictionary:userWithInfo forKey:@"hours"];
	self.userId = [self integerFromDictionary:userWithInfo forKey:@"id"]; //id
	
	self.ignoreReports  = [self boolFromDictionary:userWithInfo forKey:@"ignore_reports"];
	self.isAdmin = [self boolFromDictionary:userWithInfo forKey:@"is_admin"]; //is_admin
	self.language_id = [self integerFromDictionary:userWithInfo forKey:@"language_id"];
	self.linkedin = [self stringFromDictionary:userWithInfo forKey:@"linkedin"];
	self.isLocked = [self boolFromDictionary:userWithInfo forKey:@"locked"]; //locked
	
	self.login = [self stringFromDictionary:userWithInfo forKey:@"login"];
	self.name = [self stringFromDictionary:userWithInfo forKey:@"name"];
	self.password_digest = [self stringFromDictionary:userWithInfo forKey:@"password_digest"]; //not present at generated user
	self.phone = [self stringFromDictionary:userWithInfo forKey:@"phone"]; //cellphone duplicate?
	self.reset_password_sent_at = [self stringFromDictionary:userWithInfo forKey:@"reset_password_sent_at"];
	self.reset_password_token = [self stringFromDictionary:userWithInfo forKey:@"reset_password_token"]; //not present at generated user
	self.twitter = [self stringFromDictionary:userWithInfo forKey:@"twitter"];
	self.unconfirmed_email = [self stringFromDictionary:userWithInfo forKey:@"unconfirmed_email"];
	self.updated_at = [self stringFromDictionary:userWithInfo forKey:@"updated_at"];
	self.website = [self stringFromDictionary:userWithInfo forKey:@"website"];
}

#pragma mark - NSCoding methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:@(self.userId) forKey:@"userID"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if (self) {
		self.userId = [[decoder decodeObjectForKey:@"userID"] integerValue];
	}
	return self;
}


@end
