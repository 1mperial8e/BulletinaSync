//
//  BusinessProfileLogoTableViewCell.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BusinessProfileLogoTableViewCell.h"
#import "UIImageView+AFNetworking.h"

static CGFloat const BusinessLogoCellHeigth = 70;
static CGFloat const BusinessLogoButtonsWidth = 76;
static CGFloat const BusinessLogoHeight = 120;
static CGFloat const BusinessLogoButtonSpace = 10;
static CGFloat const BusinessLogoButtonsContainerHeight = 41;
static CGFloat const BusinessLogoPhoneContainerHeight = 29;
static CGFloat const BusinessAvatarContainerWidth = 125;
static CGFloat const BusinessAvatarContainerHeight = 92;
static CGFloat const BusinessCompanyNameHeight = 34;

@interface BusinessProfileLogoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyPhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *linkedInButton;
@property (weak, nonatomic) IBOutlet UITextView *companyDescriptionTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkedinLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *websiteTrailingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *websiteWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *facebookWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkedinWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeightConstraint;

@end

@implementation BusinessProfileLogoTableViewCell

#pragma mark - Accessors

- (void)setUser:(UserModel *)user
{
    _user = user;
    [self updateCell];
}

#pragma mark - UI

- (void)updateCell
{
    [self addCustomBorderToButton:self.websiteButton];
    [self addCustomBorderToButton:self.facebookButton];
    [self addCustomBorderToButton:self.linkedInButton];
    
    self.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
    self.companyNameLabel.text = self.user.companyName;
    self.companyPhoneLabel.text = self.user.phone.length ? [NSString stringWithFormat:@"Phone:%@", self.user.phone] : @"";
    
    self.companyDescriptionTextView.text = self.user.about;
    self.companyDescriptionTextView.font = [UIFont systemFontOfSize:14];
    self.companyDescriptionTextView.textColor = [UIColor whiteColor];
    self.companyDescriptionTextView.textAlignment = NSTextAlignmentLeft;
    [self.companyDescriptionTextView setTextContainerInset:UIEdgeInsetsZero];
	self.companyDescriptionTextView.textContainer.lineFragmentPadding = 0;
    
    self.websiteWidthConstraint.constant = self.user.website.length ? BusinessLogoButtonsWidth : 0;
    self.facebookWidthConstraint.constant = self.user.facebook.length ? BusinessLogoButtonsWidth : 0;
    self.linkedinWidthConstraint.constant = self.user.linkedin.length ? BusinessLogoButtonsWidth : 0;
	
	self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.frame) / 2;
	self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
	self.avatarImageView.layer.borderWidth = 2.0f;
    
    if (!self.user.website.length && self.user.facebook.length && self.user.linkedin.length) {
        self.websiteTrailingConstraint.constant = 0.0;
        self.linkedinLeadingConstraint.constant = BusinessLogoButtonSpace;
    } else if (self.user.website.length && self.user.facebook.length && !self.user.linkedin.length) {
        self.websiteTrailingConstraint.constant = BusinessLogoButtonSpace;
        self.linkedinLeadingConstraint.constant = 0.0;
    } else if (!self.user.facebook.length && ((self.user.website.length && !self.user.linkedin.length) || (!self.user.website.length && self.user.linkedin.length))) {
        self.websiteTrailingConstraint.constant = 0.0;
        self.linkedinLeadingConstraint.constant = 0.0;
    } else if (self.user.website.length && self.user.facebook.length && self.user.linkedin.length) {
        self.websiteTrailingConstraint.constant = BusinessLogoButtonSpace;
        self.linkedinLeadingConstraint.constant = BusinessLogoButtonSpace;
    }
    
	self.phoneContainerHeightConstraint.constant = self.user.phone.length ? BusinessLogoPhoneContainerHeight : 0.0;
	
	if (self.user.website.length || self.user.facebook.length || self.user.linkedin.length) {
		self.buttonsContainerHeightConstraint.constant = BusinessLogoButtonsContainerHeight;
	} else {
		self.buttonsContainerHeightConstraint.constant = 0.0;
	}
	
    if (self.user.avatarUrl) {
        [self.logoImageView setImageWithURL:self.user.avatarUrl];
		self.logoImageView.layer.cornerRadius = 10;
    }
	
	self.logoHeightConstraint.constant = BusinessLogoHeight * HeigthCoefficient;
    self.logoImageView.layer.cornerRadius = 8.0f;
	
	if (self.user.phone.length) {
		UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneTap:)];
		[self.companyPhoneLabel addGestureRecognizer:phoneTap];
	}
}

#pragma mark - Utils

+ (CGFloat)heightForBusinessLogoCellWithUser:(UserModel *)user
{
    static BusinessProfileLogoTableViewCell *cell;
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:BusinessProfileLogoTableViewCell.ID owner:self options:nil];
        cell = [topLevelObjects firstObject];
    }
	cell.user = user;
	cell.companyDescriptionTextView.text = cell.user.about;
	cell.companyDescriptionTextView.font = [UIFont systemFontOfSize:14];
	cell.companyDescriptionTextView.textColor = [UIColor whiteColor];
	[cell.companyDescriptionTextView setTextContainerInset:UIEdgeInsetsZero];
	
	CGSize size = CGSizeZero;
	if (cell.companyDescriptionTextView.text.length) {
		size = [cell.companyDescriptionTextView sizeThatFits:CGSizeMake(ScreenWidth - 15 - BusinessAvatarContainerWidth, MAXFLOAT)];
	} else {
		size = CGSizeMake(0, 0);
	}
	
	CGFloat extraHeight = size.height + 0.5;
	
	if (cell.user.phone.length) {
		extraHeight += BusinessLogoPhoneContainerHeight;
	}
	
	if (extraHeight + BusinessCompanyNameHeight < BusinessAvatarContainerHeight) {
		extraHeight = BusinessAvatarContainerHeight - BusinessCompanyNameHeight;
	}
	
	if (cell.user.website.length || cell.user.facebook.length || cell.user.linkedin.length) {
		extraHeight += BusinessLogoButtonsContainerHeight;
	}	
	return (BusinessLogoCellHeigth + extraHeight + BusinessLogoHeight * HeigthCoefficient);
}

- (void)addCustomBorderToButton:(UIButton *)button
{
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 4;
}

#pragma mark - Actions

- (IBAction)websiteButtonAction:(id)sender
{
    if (self.user.website.length) {
        if (![self.user.website hasPrefix:@"http"]) {
            self.user.website = [@"http://" stringByAppendingString:self.user.website];
        }
        NSURL *url = [NSURL URLWithString:self.user.website];
        if (url) {
            [self openUrl:url];
        }
    }
}

- (IBAction)facebookButtonAction:(id)sender
{
    if (self.user.facebook.length) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.facebook.com/%@", self.user.facebook]];
        if (url) {
            [self openUrl:url];
        }
    }
}

- (IBAction)linkedinButtonAction:(id)sender
{
    if (self.user.linkedin.length) {
		if (![self.user.linkedin hasPrefix:@"http"]) {
			self.user.linkedin = [@"http://" stringByAppendingString:self.user.linkedin];
		}
        NSURL *url = [NSURL URLWithString:self.user.linkedin];
        if (url) {
            [self openUrl:url];
        }
    }
}

- (void)openUrl:(NSURL *)url
{
    NSParameterAssert(url);
    if ([Application canOpenURL:url]) {
        [Application openURL:url];
    }
}

- (void)phoneTap:(UITapGestureRecognizer *)sender
{
	NSString *phoneNumber = [@"tel://" stringByAppendingString:[((UILabel *)sender.view).text substringFromIndex:6]];
	phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
	[self openUrl:[NSURL URLWithString:phoneNumber]];
}
@end
