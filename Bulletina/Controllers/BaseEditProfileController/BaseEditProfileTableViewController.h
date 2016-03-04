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

//Models
#import "APIClient+User.h"

static CGFloat const AvatarCellHeigth = 218;
static CGFloat const LogoCellHeigth = 178;
static CGFloat const InputCellHeigth = 48;
static CGFloat const ButtonCellHeigth = 52;
static NSString *const TextViewPlaceholderText = @"About:";

static NSString *const TextFieldEmailPlaceholder = @"Email:";
static NSString *const TextFieldCompanyNamePlaceholder = @"Company Name:";
static NSString *const TextFieldPhonePlaceholder = @"Phone:";
static NSString *const TextFieldWebsitePlaceholder = @"Website:";
static NSString *const TextFieldFacebookPlaceholder = @"Facebook:";
static NSString *const TextFieldLinkedinPlaceholder = @"LinkedIn:";
static NSString *const TextFieldNicknamePlaceholder = @"Nickname:";
static NSString *const TextFieldFullnamePlaceholder = @"Fullname:";


@interface BaseEditProfileTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, ImageActionSheetControllerDelegate>

@property (strong, nonatomic) TextInputNavigationCollection *inputViewsCollection;
@property (strong, nonatomic) EditProfileAboutTableViewCell *aboutCell;
@property (strong, nonatomic) UIImage *logoImage;
@property (strong, nonatomic) BulletinaLoaderView *loader;

@property (strong, nonatomic) UserModel *tempUser;

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
- (void)updateImage:(UIImage *)image;

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string;
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
- (void)textViewDidChange:(UITextView *)textView;

@end
