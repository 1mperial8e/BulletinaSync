//
//  IndividualProfileEditTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Controllers
#import "IndividualProfileEditTableViewController.h"
#import "ImageActionSheetController.h"

//Cells
#import "AvatarTableViewCell.h"
#import "InputTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "EditProfileAboutTableViewCell.h"

// Helpers
#import "TextInputNavigationCollection.h"
#import "BulletinaLoaderView.h"

//Models
#import "APIClient+User.h"

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	AvatarCellIndex = 0,
	EmailCellIndex = 0,
	UsernameCellIndex = 1,
	FullNameCellIndex = 2,
	AboutMeCellIndex = 0,
	SaveButtonCellIndex = 1
};

typedef NS_ENUM(NSUInteger, SectionsIndexes) {
	LogoSectionIndex,
	ProfileSectionIndex,
	AboutSectionIndex
};

@interface IndividualProfileEditTableViewController () 

@property (weak, nonatomic) UITextField *emailTextfield;
@property (weak, nonatomic) UITextField *usernameTextfield;
@property (weak, nonatomic) UITextField *fullNameTextfield;

@end

@implementation IndividualProfileEditTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.sectionTitles = @[@"",@"PROFILE",@"ABOUT US"];
	self.sectionCellsCount = @[@1, @3, @2];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.sectionCellsCount[section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self refreshInputViews];
	
	if (indexPath.item == AvatarCellIndex && indexPath.section == LogoSectionIndex) {
		return [self avatarCellForIndexPath:indexPath];
	} else if (indexPath.item == AboutMeCellIndex && indexPath.section == AboutSectionIndex) {
		return [self aboutCellForIndexPath:indexPath];
	} else if (indexPath.item == SaveButtonCellIndex && indexPath.section == AboutSectionIndex) {
		return [self buttonCellForIndexPath:indexPath];
	} else {
		return [self inputCellForIndexPath:indexPath];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	CategoryHeaderView *view = [[CategoryHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 39)];
	view.backgroundColor = [UIColor mainPageBGColor];
	view.sectionTitleLabel.text = self.sectionTitles[section];
	return view;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = InputCellHeigth * HeigthCoefficient;
	if (indexPath.row == AvatarCellIndex && indexPath.section == LogoSectionIndex) {
		return AvatarCellHeigth * HeigthCoefficient;
	} else if (indexPath.row == SaveButtonCellIndex && indexPath.section == AboutSectionIndex) {
		return ButtonCellHeigth * HeigthCoefficient;
	} else if (indexPath.row == AboutMeCellIndex && indexPath.section == AboutSectionIndex) {
		return [self heightForAboutCell];
	}
	return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if(section == LogoSectionIndex)
	{
		return 0;
	}
	return 39.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( [[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[InputTableViewCell class]]) {
		InputTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		[cell.inputTextField becomeFirstResponder];
	}
}

#pragma mark - Cells

- (InputTableViewCell *)inputCellForIndexPath:(NSIndexPath *)indexPath
{
	InputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InputTableViewCell.ID forIndexPath:indexPath];
	cell.inputTextField.returnKeyType = UIReturnKeyNext;
	if (indexPath.section == ProfileSectionIndex) {
		if (indexPath.item == UsernameCellIndex) {
			cell.inputTextField.placeholder = TextFieldNicknamePlaceholder;
			cell.placeholderLabel.text = TextFieldNicknameLabel;
			cell.inputTextField.text = self.tempUser.username;
			cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
			self.usernameTextfield = cell.inputTextField;
		} else if (indexPath.item == EmailCellIndex) {
			cell.inputTextField.placeholder = TextFieldEmailPlaceholder;
			cell.placeholderLabel.text = TextFieldEmailLabel;
			self.emailTextfield = cell.inputTextField;
			cell.inputTextField.text = self.tempUser.email;
			cell.inputTextField.enabled = NO;
		} else if (indexPath.item == FullNameCellIndex) {
			cell.inputTextField.placeholder = TextFieldFullnamePlaceholder;
			cell.placeholderLabel.text = TextFieldFullnameLabel;
			cell.inputTextField.text = self.tempUser.name;
			self.fullNameTextfield = cell.inputTextField;
		}
	}
		cell.inputTextField.delegate = self;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	return cell;
}

#pragma mark - Utils

- (void)refreshInputViews
{
	NSMutableArray *views = [[NSMutableArray alloc] init];
	if (self.usernameTextfield) {
		[views addObject:self.usernameTextfield];
	}
	if (self.fullNameTextfield) {
		[views addObject:self.fullNameTextfield];
	}
	if (self.aboutCell.aboutTextView) {
		[views addObject:self.aboutCell.aboutTextView];
	}
	self.inputViewsCollection.textInputViews =  views;
}

//- (void)updateImage:(UIImage *)image;
//{
//	self.logoImage = image;
//	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:AvatarCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Actions

- (void)saveButtonTap:(id)sender
{
	if (!self.usernameTextfield.text.length) {
		[Utils showErrorWithMessage:@"Nickname is required."];
	} else if (![Utils isValidName:self.usernameTextfield.text] ) {
		[Utils showErrorWithMessage:@"Nickname is not valid."];
	} else {
        [self.tableView endEditing:YES];
		[self.loader show];
		__weak typeof(self) weakSelf = self;
		NSString *aboutText = [self.aboutCell.aboutTextView.text isEqualToString:TextViewPlaceholderText] ? @"" : self.aboutCell.aboutTextView.text;
        [[APIClient sharedInstance] updateUserWithEmail:nil username:self.usernameTextfield.text fullname:self.fullNameTextfield.text companyname:@"" password:@"" website:@"" facebook:@"" linkedin:@"" phone:@"" description:aboutText avatar:[Utils scaledImage:self.avatarImage] logo:nil withCompletion:^(id response, NSError *error, NSInteger statusCode) {
			if (error) {
				if (response[@"error_message"]) {
					[Utils showErrorWithMessage:response[@"error_message"]];
				} else if (((NSArray *)response[@"error"][@"nickname"]).firstObject) {
					NSString *errorMessage = [@"Nickname " stringByAppendingString:((NSArray *)response[@"error"][@"nickname"]).firstObject];
					[Utils showErrorWithMessage:errorMessage];
				} else {
					[Utils showErrorForStatusCode:statusCode];
				}
			} else {
				NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
				UserModel *generatedUser = [UserModel modelWithDictionary:response];
				[Utils storeValue:response forKey:CurrentUserKey];
				[[APIClient sharedInstance] updateCurrentUser:generatedUser];
				[[APIClient sharedInstance] updatePasstokenWithDictionary:response];
				dispatch_async(dispatch_get_main_queue(), ^{
					[weakSelf.navigationController popViewControllerAnimated:YES];
				});
			}
			[weakSelf.loader hide];
		}];
	}
}

@end
