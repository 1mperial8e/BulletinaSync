//
//  IndividualProfileLogoTableViewCell.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "IndividualProfileLogoTableViewCell.h"
#import "UIImageView+AFNetworking.h"

static CGFloat const PersonalLogoCellHeigth = 215;

@interface IndividualProfileLogoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNicknameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTextViewConstraint;
@property (weak, nonatomic) IBOutlet UITextView *aboutMeTextView;

@end

@implementation IndividualProfileLogoTableViewCell

#pragma mark - Accessors

- (void)setUser:(UserModel *)user
{
	_user = user;
	[self updateCell];
}

#pragma mark - UI

- (void)updateCell
{
	self.aboutMeTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	self.logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
	self.logoImageView.layer.borderWidth = 2.0f;
	self.logoImageView.layer.cornerRadius = CGRectGetHeight(self.logoImageView.frame) / 2;
	self.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
	if (self.user.customerTypeId == AnonymousAccount) {
		self.userFullNameLabel.text = @"Anonymus";
	} else {
		self.userFullNameLabel.text = self.user.name;
		self.userNicknameLabel.text = self.user.login;
		
		self.aboutMeTextView.text = self.user.about;
		self.aboutMeTextView.font = [UIFont systemFontOfSize:13];
		self.aboutMeTextView.textColor = [UIColor whiteColor];
		self.aboutMeTextView.textAlignment = NSTextAlignmentCenter;
		[self.aboutMeTextView setTextContainerInset:UIEdgeInsetsZero];
		
		if (self.user.avatarUrl) {
			[self.logoImageView setImageWithURL:self.user.avatarUrl];;
		}
	}
}

#pragma mark - Utils

+ (CGFloat)heightForIndividualAvatarCellWithUser:(UserModel *)user
{
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:IndividualProfileLogoTableViewCell.ID owner:self options:nil];
	IndividualProfileLogoTableViewCell *cell = [topLevelObjects firstObject];	
	cell.user = user;
	
	cell.aboutMeTextView.text = cell.user.about;
	cell.aboutMeTextView.font = [UIFont systemFontOfSize:13];
	cell.aboutMeTextView.textColor = [UIColor whiteColor];
	cell.aboutMeTextView.textAlignment = NSTextAlignmentCenter;
	[cell.aboutMeTextView setTextContainerInset:UIEdgeInsetsZero];
	
	CGSize size = CGSizeZero;
	if (cell.aboutMeTextView.text.length) {
		size = [cell.aboutMeTextView sizeThatFits:CGSizeMake(ScreenWidth - 60, MAXFLOAT)];
	} else {
		size = CGSizeMake(0, 0);
	}
	return (size.height + PersonalLogoCellHeigth);
}

@end
