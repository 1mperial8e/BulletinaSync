//
//  ConversationTableViewCell.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/21/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ConversationTableViewCell.h"

@implementation ConversationTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self prepareUI];
}

#pragma mark - Layout

- (UIEdgeInsets)layoutMargins
{
	return UIEdgeInsetsZero;
}

#pragma mark - Private Methods

- (void)prepareUI
{
	self.userAvatarImageView.layer.cornerRadius = CGRectGetWidth(self.userAvatarImageView.bounds) / 2;
	self.userAvatarImageView.layer.masksToBounds = YES;
	
	self.badgeView.layer.cornerRadius = CGRectGetWidth(self.badgeView.bounds) / 2;
	self.badgeView.layer.masksToBounds = YES;
}

@end
