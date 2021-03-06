//
//  BaseEditProfileTableViewController.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Controllers
#import "ImageActionSheetController.h"

//Cells
#import "AvatarTableViewCell.h"
#import "BusinessLogoTableViewCell.h"
#import "InputTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "EditProfileAboutTableViewCell.h"

// Helpers
#import "TextInputNavigationCollection.h"
#import "BulletinaLoaderView.h"
#import "CategoryHeaderView.h"

//Models
#import "APIClient+User.h"

static NSString *const TextViewPlaceholderText = @"description";

static NSString *const TextFieldEmailPlaceholder = @"post@domain.com";
static NSString *const TextFieldCompanyNamePlaceholder = @"CompanyName Inc";
static NSString *const TextFieldPhonePlaceholder = @"+1 302 999 999";
static NSString *const TextFieldWebsitePlaceholder = @"www.company.com";
static NSString *const TextFieldFacebookPlaceholder = @"facebook_id";
static NSString *const TextFieldLinkedinPlaceholder = @"linked_in";
static NSString *const TextFieldPasswordPlaceholder = @"********************";
static NSString *const TextFieldRePasswordPlaceholder = @"********************";
static NSString *const TextFieldNicknamePlaceholder = @"mynickname";
static NSString *const TextFieldFullnamePlaceholder = @"Full Name:";

static NSString *const TextFieldEmailLabel = @"Email:";
static NSString *const TextFieldCompanyNameLabel = @"Company Name:";
static NSString *const TextFieldPhoneLabel = @"Phone:";
static NSString *const TextFieldWebsiteLabel = @"Website:";
static NSString *const TextFieldFacebookLabel = @"Facebook:";
static NSString *const TextFieldLinkedinLabel = @"Linkedin:";
static NSString *const TextFieldPasswordLabel = @"Set password:";
static NSString *const TextFieldRePasswordLabel = @"Repeat password:";
static NSString *const TextFieldNicknameLabel = @"Nickname:";
static NSString *const TextFieldFullnameLabel = @"Fullname:";

static CGFloat const AvatarCellHeigth = 200;
static CGFloat const BusinessHeaderCellHeigth = 168;
static CGFloat const LogoCellHeigth = 178;
static CGFloat const InputCellHeigth = 44;
static CGFloat const ButtonCellHeigth = 52;

static CGFloat const AdditionalBottomInset = 36;

typedef NS_ENUM(NSUInteger, SharedCellsIndexes) {
	LogoCellSharedIndex
};

typedef NS_ENUM(NSUInteger, imageIndexes) {
	AvatarImageIndex,
	LogoImageIndex
};


@interface BaseEditProfileTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, ImageActionSheetControllerDelegate>

@property (strong, nonatomic) TextInputNavigationCollection *inputViewsCollection;
@property (strong, nonatomic) EditProfileAboutTableViewCell *aboutCell;
@property (strong, nonatomic) UIImage *logoImage;
@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) BulletinaLoaderView *loader;
@property (assign, nonatomic) NSInteger currentImageIndex;

@property (strong, nonatomic) UserModel *tempUser;

@property (strong, nonatomic) NSArray *sectionTitles;
@property (strong, nonatomic) NSArray *sectionCellsCount;

#pragma mark - Setup

- (void)setupUI;
- (void)tableViewSetup;
- (void)setupDefaults;
- (void)refreshInputViews;

#pragma mark - Cells

- (AvatarTableViewCell *)avatarCellForIndexPath:(NSIndexPath *)indexPath;
- (BusinessLogoTableViewCell *)logoCellForIndexPath:(NSIndexPath *)indexPath;
- (EditProfileAboutTableViewCell *)aboutCellForIndexPath:(NSIndexPath *)indexPath;
- (ButtonTableViewCell *)buttonCellForIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Actions

- (void)selectImageButtonTap:(id)sender;
- (void)saveButtonTap:(id)sender;

#pragma mark - Utils

- (CGFloat)heightForAboutCell;
- (void)updateImage:(UIImage *)image forImageIndex:(NSInteger)imageIndex;

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string;
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
- (void)textViewDidChange:(UITextView *)textView;

@end
