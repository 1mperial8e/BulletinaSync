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

static NSInteger const CellsCount = 6;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	AvatarCellIndex,
	EmailCellIndex,
	UsernameCellIndex,
	FullNameCellIndex,
	AboutMeCellIndex,
	SaveButtonCellIndex
};

@interface IndividualProfileEditTableViewController () 

@property (weak, nonatomic) UITextField *emailTextfield;
@property (weak, nonatomic) UITextField *usernameTextfield;
@property (weak, nonatomic) UITextField *fullNameTextfield;

@end

@implementation IndividualProfileEditTableViewController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self refreshInputViews];
	
	if (indexPath.item == AvatarCellIndex) {
		return [self avatarCellForIndexPath:indexPath];
	} else if (indexPath.item == AboutMeCellIndex) {
		return [self aboutCellForIndexPath:indexPath];
	} else if (indexPath.item == SaveButtonCellIndex) {
		return [self buttonCellForIndexPath:indexPath];
	} else {
		return [self inputCellForIndexPath:indexPath];
	}
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = InputCellHeigth * HeigthCoefficient;
	if (indexPath.row == AvatarCellIndex) {
		return AvatarCellHeigth * HeigthCoefficient;
	} else if (indexPath.row == SaveButtonCellIndex) {
		return ButtonCellHeigth * HeigthCoefficient;
	} else if (indexPath.row == AboutMeCellIndex) {
		return [self heightForAboutCell];
	}
	return height;
}

#pragma mark - Cells

- (InputTableViewCell *)inputCellForIndexPath:(NSIndexPath *)indexPath
{
	InputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InputTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	cell.inputTextField.returnKeyType = UIReturnKeyNext;
	if (indexPath.item == UsernameCellIndex) {
		cell.inputTextField.placeholder = @"Nickname:";
		cell.inputTextField.text = [APIClient sharedInstance].currentUser.login;
		cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
		self.usernameTextfield = cell.inputTextField;
	} else if (indexPath.item == EmailCellIndex) {
		cell.inputTextField.placeholder = @"Email:";
		self.emailTextfield = cell.inputTextField;
		cell.inputTextField.text = [APIClient sharedInstance].currentUser.email;
		cell.inputTextField.enabled = NO;
	} else if (indexPath.item == FullNameCellIndex) {
		cell.inputTextField.placeholder = @"Fullname:";
		cell.inputTextField.text = [APIClient sharedInstance].currentUser.name;
		self.fullNameTextfield = cell.inputTextField;
	}
	cell.inputTextField.delegate = self;
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

- (void)updateImage:(UIImage *)image;
{
	self.logoImage = image;
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:AvatarCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Actions

- (void)saveButtonTap:(id)sender
{
	if (!self.usernameTextfield.text.length) {
		[Utils showErrorWithMessage:@"Nickname is required."];
	} else if (![Utils isValidName:self.usernameTextfield.text] ) {
		[Utils showErrorWithMessage:@"Nickname is not valid."];
	} else {
        [self.tableView resignFirstResponder];
		[self.loader show];
		__weak typeof(self) weakSelf = self;
		NSString *aboutText = [self.aboutCell.aboutTextView.text isEqualToString:TextViewPlaceholderText] ? @"" : self.aboutCell.aboutTextView.text;
        [[APIClient sharedInstance] updateUserWithEmail:nil username:self.usernameTextfield.text fullname:self.fullNameTextfield.text companyname:@"" password:@"" website:@"" facebook:@"" linkedin:@"" phone:@"" description:aboutText avatar:[Utils scaledImage:self.logoImage] withCompletion:^(id response, NSError *error, NSInteger statusCode) {
			if (error) {
				if (response[@"error_message"]) {
					[Utils showErrorWithMessage:response[@"error_message"]];
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
