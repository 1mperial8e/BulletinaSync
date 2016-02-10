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
	self.login = userWithInfo[@"nickname"];
	
	self.companyName = userWithInfo[@"company_name"];
	self.name = userWithInfo[@"name"];
	self.phone = userWithInfo[@"phone"];
	self.about = userWithInfo[@"description"];
    NSString *avatarUrl = userWithInfo[@"avatar_url"];
    if (avatarUrl.length) {
        self.avatarUrl = [NSURL URLWithString:avatarUrl];
    }
    NSString *avatarUrlThumb = userWithInfo[@"avatar_thumb_url"];
    if (avatarUrlThumb.length) {
        self.avatarUrlThumb = [NSURL URLWithString:avatarUrlThumb];
    }
	self.facebook = userWithInfo[@"facebook"];
	self.homeLatitude = userWithInfo[@"home_latitude"];
	self.homeLongitude = userWithInfo[@"home_longitude"];
	self.linkedin = userWithInfo[@"linkedin"];
    self.website = userWithInfo[@"website"];
}

@end
