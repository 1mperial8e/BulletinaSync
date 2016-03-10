//
//  BaseRegisterProfileTableViewController.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

// Controllers
#import "ImageActionSheetController.h"
#import "MainPageController.h"
#import "LoginViewController.h"

// Cells
#import "BusinessLogoTableViewCell.h"
#import "AvatarTableViewCell.h"
#import "InputTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "CategoryHeaderView.h"

// Helpers
#import "TextInputNavigationCollection.h"
#import "BulletinaLoaderView.h"

// Models
#import "APIClient+User.h"

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

static CGFloat const AvatarCellHeigth = 218;
static CGFloat const BusinessHeaderCellHeigth = 168;
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

@interface BaseRegisterProfileTableViewController : UITableViewController <UITextFieldDelegate, ImageActionSheetControllerDelegate>

@property (strong, nonatomic) UIImage *logoImage;
@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) BulletinaLoaderView *loader;
@property (strong, nonatomic) TextInputNavigationCollection *inputViewsCollection;
@property (assign, nonatomic) NSInteger currentImageIndex;

@property (strong, nonatomic) UserModel *tempUser;

@property (strong, nonatomic) NSArray *sectionTitles;
@property (strong, nonatomic) NSArray *sectionCellsCount;

#pragma mark - Utils

- (void)updateImage:(UIImage *)image forImageIndex:(NSInteger)imageIndex;
#pragma mark - Setup

- (void)tableViewSetup;
- (void)setupDefaults;

#pragma mark - Actions

- (void)selectImageButtonTap:(id)sender;

#pragma mark - Cells

- (ButtonTableViewCell *)buttonCellForIndexPath:(NSIndexPath *)indexPath;

@end
