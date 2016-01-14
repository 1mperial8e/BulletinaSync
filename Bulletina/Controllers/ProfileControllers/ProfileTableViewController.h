//
//  ProfileTableViewController.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.

typedef NS_ENUM(NSUInteger, ProfileType) {
	IndividualProfile,
	BusinessProfile
};

@interface ProfileTableViewController : UITableViewController

@property (assign, nonatomic) ProfileType profileType;

@end
