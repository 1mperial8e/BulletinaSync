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
		self.password = dictionary[@"passwd"];
	} else {
		userWithInfo = dictionary;
	}	
	
	self.isActive = [userWithInfo[@"active"] boolValue];//active
	self.address = userWithInfo[@"address"];
	self.avatar_url = userWithInfo[@"avatar_url"];
	self.isBanned = [userWithInfo[@"banned"] boolValue]; //banned
	self.cellphone = userWithInfo[@"cellphone"];
	
	self.company_name = userWithInfo[@"company_name"];
	self.country_id = userWithInfo[@"country_id"];
	self.created_at = userWithInfo[@"created_at"];
	self.customer_type_id = [userWithInfo[@"customer_type_id"] integerValue];
	self.isDeleted = userWithInfo[@"deleted"]; //deleted
	
	self.about = userWithInfo[@"description"]; //description
	self.email = userWithInfo[@"email"];
	self.email_confirmation_sent_at = userWithInfo[@"email_confirmation_sent_at"];
	self.email_confirmation_token = userWithInfo[@"email_confirmation_token"];
	self.email_confirmed_at = userWithInfo[@"email_confirmed_at"];
	
	self.facebook = userWithInfo[@"facebook"];
	self.home_latitude = userWithInfo[@"home_latitude"];
	self.home_longitude = userWithInfo[@"home_longitude"];
	self.hours = userWithInfo[@"hours"];
	self.userId = [userWithInfo[@"id"] integerValue]; //id
	
	self.ignoreReports  = userWithInfo[@"ignore_reports"];
	self.isAdmin = userWithInfo[@"is_admin"]; //is_admin
	self.language_id = userWithInfo[@"language_id"] ;
	self.linkedin = userWithInfo[@"linkedin"];
	self.isLocked = userWithInfo[@"locked"]; //locked
	
	self.login = userWithInfo[@"login"];
	self.name = userWithInfo[@"name"];
	self.password_digest = userWithInfo[@"password_digest"]; //not present at generated user
	self.phone = userWithInfo[@"phone"]; //cellphone duplicate?
	self.reset_password_sent_at = userWithInfo[@"reset_password_sent_at"];
	self.reset_password_token = userWithInfo[@"reset_password_token"]; //not present at generated user
	self.twitter = userWithInfo[@"twitter"];
	self.unconfirmed_email = userWithInfo[@"unconfirmed_email"];
	self.updated_at = userWithInfo[@"updated_at"];
	self.website = userWithInfo[@"website"];
}

@end
