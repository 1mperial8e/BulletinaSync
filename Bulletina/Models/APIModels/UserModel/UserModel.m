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

- (void)parseDictionary:(NSDictionary *)userWithInfo
{
	self.isActive = [userWithInfo[@"active"] boolValue];
	self.isBanned = [userWithInfo[@"banned"] boolValue];
	self.isDeleted = [userWithInfo[@"deleted"] boolValue];
	self.ignoreReports  = [userWithInfo[@"ignore_reports"] boolValue];
	self.isAdmin = [userWithInfo[@"is_admin"] boolValue];
	self.isLocked = [userWithInfo[@"locked"] boolValue];
	
	self.customerTypeId = [userWithInfo[@"customer_type_id"] integerValue];
	self.userId = [userWithInfo[@"id"] integerValue];
	
	self.email = userWithInfo[@"email"];
	self.login = userWithInfo[@"login"];
	
	self.companyName = userWithInfo[@"company_name"];
	self.name = userWithInfo[@"name"];
	self.phone = userWithInfo[@"phone"];
	self.about = userWithInfo[@"description"];
	self.avatarUrl = userWithInfo[@"avatar_url"];
	self.facebook = userWithInfo[@"facebook"];
	self.homeLatitude = userWithInfo[@"home_latitude"];
	self.homeLongitude = userWithInfo[@"home_longitude"];
	self.linkedin = userWithInfo[@"linkedin"];
	self.website = userWithInfo[@"website"];
	
//	self.countryId = userWithInfo[@"country_id"];	
//	self.languageId = userWithInfo[@"language_id"] ;
//	self.address = userWithInfo[@"address"];
//	self.cellphone = userWithInfo[@"cellphone"];
//	self.createdAt = userWithInfo[@"created_at"];
//	self.emailConfirmationSentAt = userWithInfo[@"email_confirmation_sent_at"];
//	self.emailConfirmationToken = userWithInfo[@"email_confirmation_token"];
//	self.emailConfirmedAt = userWithInfo[@"email_confirmed_at"];
//	self.hours = userWithInfo[@"hours"];
//	self.password_digest = userWithInfo[@"password_digest"]; //not present at generated user
//	self.resetPassword_sent_at = userWithInfo[@"reset_password_sent_at"];
//	self.resetPassword_token = userWithInfo[@"reset_password_token"]; //not present at generated user
//	self.twitter = userWithInfo[@"twitter"];
//	self.unconfirmed_email = userWithInfo[@"unconfirmed_email"];
//	self.updated_at = userWithInfo[@"updated_at"];

}

@end
