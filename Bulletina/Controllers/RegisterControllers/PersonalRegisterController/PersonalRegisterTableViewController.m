//
//  PersonalRegisterTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "PersonalRegisterTableViewController.h"

//static NSInteger const CellsCount = 6;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	AvatarCellIndex = 0,
	UsernameCellIndex = 0,
	EmailCellIndex = 1,
	PasswordCellIndex = 0,
	RetypePasswordCellIndex = 1,
	SaveButtonCellIndex = 2
};

typedef NS_ENUM(NSUInteger, SectionsIndexes) {
	LogoSectionIndex,
	ProfileSectionIndex,	
	PasswordSectionIndex
};

@interface PersonalRegisterTableViewController () <UITextFieldDelegate, ImageActionSheetControllerDelegate>

@property (weak, nonatomic) UITextField *usernameTextfield;
@property (weak, nonatomic) UITextField *emailTextfield;
@property (weak, nonatomic) UITextField *passwordTextfield;
@property (weak, nonatomic) UITextField *retypePasswordTextfield;

@end

@implementation PersonalRegisterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self tableViewSetup];
	[self setupDefaults];
	
	self.title = @"Individual account";
	self.sectionTitles = @[@"",@"USERNAME / EMAIL",@"PASSWORD"];
	self.sectionCellsCount = @[@1, @2, @3];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	self.inputViewsCollection.textInputViews = @[self.usernameTextfield, self.emailTextfield, self.passwordTextfield , self.retypePasswordTextfield];
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
	if (indexPath.item == AvatarCellIndex && indexPath.section == LogoSectionIndex) {
        return [self avatarCellForIndexPath:indexPath];
	} else if (indexPath.item == SaveButtonCellIndex && indexPath.section == PasswordSectionIndex) {
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
		height = AvatarCellHeigth * HeigthCoefficient;
	} else if (indexPath.row == SaveButtonCellIndex && indexPath.section == PasswordSectionIndex) {
		height = ButtonCellHeigth * HeigthCoefficient;
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

- (AvatarTableViewCell *)avatarCellForIndexPath:(NSIndexPath *)indexPath
{
	AvatarTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AvatarTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	cell.avatarImageView.layer.borderColor = [UIColor colorWithRed:205 / 255.0f green:205 / 255.0f blue:205 / 255.0f alpha:1.0f].CGColor;
	cell.avatarImageView.layer.borderWidth = 5.0f;
	cell.avatarImageView.layer.cornerRadius = CGRectGetHeight(cell.avatarImageView.frame) / 2;
	if (self.avatarImage) {
		cell.avatarImageView.image = self.avatarImage;
	}
	[cell.selectImageButton addTarget:self action:@selector(selectImageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	return cell;
}

- (InputTableViewCell *)inputCellForIndexPath:(NSIndexPath *)indexPath
{
	InputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InputTableViewCell.ID forIndexPath:indexPath];
//	cell.backgroundColor = [UIColor mainPageBGColor];
    cell.inputTextField.returnKeyType = UIReturnKeyNext;
	if (indexPath.section == ProfileSectionIndex) {
		if (indexPath.item == UsernameCellIndex) {
			cell.inputTextField.placeholder = TextFieldNicknamePlaceholder;
			cell.placeholderLabel.text = TextFieldNicknameLabel;
			cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
			cell.inputTextField.text = self.tempUser.username;
			self.usernameTextfield = cell.inputTextField;
		} else if (indexPath.item == EmailCellIndex) {
			cell.placeholderLabel.text = TextFieldEmailLabel;
			cell.inputTextField.placeholder = TextFieldEmailPlaceholder;
			cell.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
			cell.inputTextField.text = self.tempUser.email;
			self.emailTextfield = cell.inputTextField;
		}
	} else if (indexPath.section == PasswordSectionIndex) {
		if (indexPath.item == PasswordCellIndex) {
			cell.inputTextField.placeholder = TextFieldPasswordPlaceholder;
			cell.placeholderLabel.text = TextFieldPasswordLabel;
			cell.inputTextField.text = self.tempUser.password;
			cell.inputTextField.secureTextEntry = YES;
			self.passwordTextfield = cell.inputTextField;
		} else if (indexPath.item == RetypePasswordCellIndex) {
			cell.inputTextField.placeholder = TextFieldRePasswordPlaceholder;
			cell.placeholderLabel.text = TextFieldRePasswordLabel;
			cell.inputTextField.text = self.tempUser.rePassword;
			cell.inputTextField.secureTextEntry = YES;
			cell.inputTextField.returnKeyType = UIReturnKeyDone;
			self.retypePasswordTextfield = cell.inputTextField;
		}
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	cell.inputTextField.delegate = self;
	return cell;
}

#pragma mark - Actions

- (void)saveButtonTap:(id)sender
{
	if (!self.usernameTextfield.text.length) {
		[Utils showErrorWithMessage:@"Nickname is required."];
	} else if (![Utils isValidName:self.usernameTextfield.text] ) {
		[Utils showErrorWithMessage:@"Nickname is not valid."];
	} else if (!self.emailTextfield.text.length) {
		[Utils showErrorWithMessage:@"Email is required."];
	} else if (![Utils isValidEmail:self.emailTextfield.text UseHardFilter:NO]) {
		[Utils showErrorWithMessage:@"Email is not valid."];
	} else if (!self.passwordTextfield.text.length || !self.retypePasswordTextfield.text.length) {
		[Utils showErrorWithMessage:@"Password and repassword are required."];
	} else if (![Utils isValidPassword:self.passwordTextfield.text]) {
		[Utils showErrorWithMessage:@"Password is not valid."];
	} else if (![self.retypePasswordTextfield.text isEqualToString:self.passwordTextfield.text]) {
			[Utils showWarningWithMessage:@"Password and repassword doesn't match."];
	} else {
        if (![LocationManager sharedManager].currentLocation) {
            [Utils showLocationErrorOnViewController:self];
        } else {
            [self registerAccount];
        }
    }
}

- (void)registerAccount
{
    [self.tableView endEditing:YES];
    [self.loader show];
    __weak typeof(self) weakSelf = self;
	[[APIClient sharedInstance] createUserWithEmail:self.emailTextfield.text username:self.usernameTextfield.text password:self.passwordTextfield.text languageId:@"" customerTypeId:IndividualAccount companyname:@"" website:@"" phone:@"" avatar:[Utils scaledImage:self.avatarImage] logo:nil withCompletion:^(id response, NSError *error, NSInteger statusCode) {
        if (error) {
            if (response[@"error_message"]) {
                [Utils showErrorWithMessage:response[@"error_message"]];
            } else {
                [Utils showErrorForStatusCode:statusCode];
            }
        } else {
            NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
            UserModel *generatedUser = [UserModel modelWithDictionary:response[@"user"]];
            if (generatedUser.userId) {
                [Utils storeValue:response[@"user"] forKey:CurrentUserKey];
                [[APIClient sharedInstance] updateCurrentUser:generatedUser];
                [[APIClient sharedInstance] updatePasstokenWithDictionary:response];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [((LoginViewController *)weakSelf.navigationController.viewControllers.firstObject) showMainPageAnimated:YES];
                    [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                });
            } else {
                [Utils showErrorWithMessage:@"Can't create user. Try again."];
            }
        }
        [weakSelf.loader hide];
    }];
}

@end
