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
	} else {
		userWithInfo = dictionary;
	}	
	
	self.isActive = [userWithInfo[@"active"] boolValue];
	self.isBanned = [userWithInfo[@"banned"] boolValue];
	self.isDeleted = [userWithInfo[@"deleted"] boolValue];
	self.ignoreReports  = [userWithInfo[@"ignore_reports"] boolValue];
	self.isAdmin = [userWithInfo[@"is_admin"] boolValue];
	self.isLocked = [userWithInfo[@"locked"] boolValue];
	
	self.customer_type_id = [userWithInfo[@"customer_type_id"] integerValue];
	self.userId = [userWithInfo[@"id"] integerValue];
	
	self.email = userWithInfo[@"email"];
	self.login = userWithInfo[@"login"];
	
	self.company_name = userWithInfo[@"company_name"];
	self.name = userWithInfo[@"name"];
	self.phone = userWithInfo[@"phone"];
	self.about = userWithInfo[@"description"];
	
//	self.address = userWithInfo[@"address"];
//	self.avatar_url = userWithInfo[@"avatar_url"];
//	self.cellphone = userWithInfo[@"cellphone"];
//	self.country_id = userWithInfo[@"country_id"];
//	self.created_at = userWithInfo[@"created_at"];
//	self.email_confirmation_sent_at = userWithInfo[@"email_confirmation_sent_at"];
//	self.email_confirmation_token = userWithInfo[@"email_confirmation_token"];
//	self.email_confirmed_at = userWithInfo[@"email_confirmed_at"];
//	self.facebook = userWithInfo[@"facebook"];
//	self.home_latitude = userWithInfo[@"home_latitude"];
//	self.home_longitude = userWithInfo[@"home_longitude"];
//	self.hours = userWithInfo[@"hours"];
//	self.language_id = userWithInfo[@"language_id"] ;
//	self.linkedin = userWithInfo[@"linkedin"];
//	self.password_digest = userWithInfo[@"password_digest"]; //not present at generated user
//	self.reset_password_sent_at = userWithInfo[@"reset_password_sent_at"];
//	self.reset_password_token = userWithInfo[@"reset_password_token"]; //not present at generated user
//	self.twitter = userWithInfo[@"twitter"];
//	self.unconfirmed_email = userWithInfo[@"unconfirmed_email"];
//	self.updated_at = userWithInfo[@"updated_at"];
//	self.website = userWithInfo[@"website"];
}

@end
