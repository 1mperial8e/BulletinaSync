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

// Helpers
#import "TextInputNavigationCollection.h"
#import "BulletinaLoaderView.h"

// Models
#import "APIClient+User.h"

static NSString *const TextFieldEmailPlaceholder = @"Email:";
static NSString *const TextFieldCompanyNamePlaceholder = @"Company Name:";
static NSString *const TextFieldPhonePlaceholder = @"Phone:";
static NSString *const TextFieldWebsitePlaceholder = @"Website:";
static NSString *const TextFieldPasswordPlaceholder = @"Password:";
static NSString *const TextFieldRePasswordPlaceholder = @"Confirm password:";
static NSString *const TextFieldNicknamePlaceholder = @"Nickname:";
static NSString *const TextFieldFullnamePlaceholder = @"Fullname:";

static CGFloat const AvatarCellHeigth = 218;
static CGFloat const LogoCellHeigth = 178;
static CGFloat const InputCellHeigth = 48;
static CGFloat const ButtonCellHeigth = 52;

static CGFloat const AdditionalBottomInset = 36;

typedef NS_ENUM(NSUInteger, SharedCellsIndexes) {
	LogoCellSharedIndex
};

@interface BaseRegisterProfileTableViewController : UITableViewController <UITextFieldDelegate, ImageActionSheetControllerDelegate>

@property (strong, nonatomic) UIImage *logoImage;
@property (strong, nonatomic) BulletinaLoaderView *loader;
@property (strong, nonatomic) TextInputNavigationCollection *inputViewsCollection;

@property (strong, nonatomic) UserModel *tempUser;

#pragma mark - Utils

- (void)updateImage:(UIImage *)image;

#pragma mark - Setup

- (void)tableViewSetup;
- (void)setupDefaults;

#pragma mark - Actions

- (void)selectImageButtonTap:(id)sender;

#pragma mark - Cells

- (ButtonTableViewCell *)buttonCellForIndexPath:(NSIndexPath *)indexPath;

@end
