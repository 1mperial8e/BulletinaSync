//
//  MessageTableViewCell.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/21/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell () 

@end

@implementation MessageTableViewCell

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
	[self.userButton addTarget:self action:@selector(userTap:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)userTap:(UITapGestureRecognizer *)sender
{
	if ([self.delegate respondsToSelector:@selector(showUser:)]) {
		[self.delegate showUser:self.message.relatedUser];
	}
}

@end
