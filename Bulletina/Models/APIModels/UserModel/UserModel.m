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

- (instancetype)initWithItem:(ItemModel *)item
{
	self = [super init];
	if (self) {
		_userId = item.userId;
		_avatarUrl = item.userUserAvatarUrl;
		_avatarUrlThumb = item.userAvatarThumbUrl;
		_login = item.userNickname;
		_name = item.userFullname;
		_companyName = item.userCompanyName;
		_customerTypeId = item.customerTypeId;
		
//		if (_companyName.length) {
//			_customerTypeId = BusinessAccount;
//		} else {
//			_customerTypeId = IndividualAccount;
//		}
	}
	return self;
}

- (NSString *)title
{
    if (_companyName.length) {
        return _companyName;
    }
    return _login;
}

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

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	UserModel *userCopy = [[UserModel allocWithZone:zone] init];
	
	userCopy.isActive = _isActive;
	userCopy.isBanned = _isBanned;
	userCopy.isDeleted = _isDeleted;
	userCopy.ignoreReports = _ignoreReports;
	userCopy.isAdmin = _isAdmin;
	userCopy.isLocked = _isLocked;
	
	userCopy.customerTypeId = _customerTypeId;
	userCopy.userId = _userId;
	
	userCopy.email = [_email copy];
	userCopy.login = [_login copy];
	
	userCopy.companyName = [_companyName copy];
	userCopy.name = [_name copy];
	userCopy.phone = [_phone copy];
	userCopy.about = [_about copy];
	
	userCopy.avatarUrl = [_avatarUrl copy];
	userCopy.avatarUrlThumb = [_avatarUrlThumb copy];
	
	userCopy.facebook = [_facebook copy];
	userCopy.homeLatitude = [_homeLatitude copy];
	userCopy.homeLongitude = [_homeLongitude copy];
	userCopy.linkedin = [_linkedin copy];
	userCopy.website = [_website copy];
	
	return userCopy;
}

@end
