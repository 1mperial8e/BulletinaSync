//
//  BusinessRegisterTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BusinessRegisterTableViewController.h"

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	LogoCellIndex = 0,
	NicknameCellIndex = 0,
	CompanyNameCellIndex = 1,
	PhoneCellIndex = 2,
	EmailCellIndex = 3,
	WebsiteCellIndex = 0,
	FacebookCellIndex = 1,
	LinkedinCellIndex = 2,
	PasswordCellIndex = 0,
	RetypePasswordCellIndex = 1,
	SaveButtonCellIndex = 2
};

typedef NS_ENUM(NSUInteger, SectionsIndexes) {
	LogoSectionIndex,
	ProfileSectionIndex,
	SocialSectionIndex,
	PasswordSectionIndex
};

@interface BusinessRegisterTableViewController () <UITextFieldDelegate, ImageActionSheetControllerDelegate>

@property (weak, nonatomic) UITextField *emailTextfield;
@property (weak, nonatomic) UITextField *nicknameTextfield;
@property (weak, nonatomic) UITextField *companyNameTextfield;
@property (weak, nonatomic) UITextField *websiteTextfield;
@property (weak, nonatomic) UITextField *facebookTextfield;
@property (weak, nonatomic) UITextField *linkedinTextfield;
@property (weak, nonatomic) UITextField *phoneTextfield;
@property (weak, nonatomic) UITextField *passwordTextfield;
@property (weak, nonatomic) UITextField *retypePasswordTextfield;

@end

@implementation BusinessRegisterTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self tableViewSetup];
	[self setupDefaults];
	
	self.sectionTitles = @[@"",@"PROFILE",@"SOCIAL LINKS (OPTIONAL)",@"PASSWORD"];
	self.sectionCellsCount = @[@1, @4, @3, @3];
	self.title = @"Business account";
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self refreshInputViews];
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

	if (indexPath.item == LogoCellIndex && indexPath.section == LogoSectionIndex) {
		return [self logoCellForIndexPath:indexPath];
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
	if (indexPath.row == LogoCellIndex &&  indexPath.section == LogoSectionIndex) {
		height = BusinessHeaderCellHeigth;
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

- (BusinessLogoTableViewCell *)logoCellForIndexPath:(NSIndexPath *)indexPath
{
	BusinessLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BusinessLogoTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	
	if (self.logoImage) {
		cell.logoImageView.image = self.logoImage;
	}
	
	if (self.avatarImage) {
		cell.avatarImageView.image = self.avatarImage;
	}
	
	cell.avatarImageView.layer.borderColor = [UIColor colorWithRed:205 / 255.0f green:205 / 255.0f blue:205 / 255.0f alpha:1.0f].CGColor;
	cell.avatarImageView.layer.borderWidth = 5.0f;
	cell.avatarImageView.layer.cornerRadius = CGRectGetHeight(cell.avatarImageView.frame) / 2;
	cell.selectAvatarButton.tag = AvatarImageIndex;
	
	cell.logoImageView.layer.borderColor = [UIColor colorWithRed:205 / 255.0f green:205 / 255.0f blue:205 / 255.0f alpha:1.0f].CGColor;
	cell.logoImageView.layer.borderWidth = 1.0f;
	cell.logoImageView.layer.cornerRadius = 13;
	cell.selectLogoButton.tag = LogoImageIndex;

	[cell.selectLogoButton addTarget:self action:@selector(selectImageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	[cell.selectAvatarButton addTarget:self action:@selector(selectImageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	cell.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (InputTableViewCell *)inputCellForIndexPath:(NSIndexPath *)indexPath
{
	InputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InputTableViewCell.ID forIndexPath:indexPath];
    cell.inputTextField.returnKeyType = UIReturnKeyNext;
	if (indexPath.section == ProfileSectionIndex) {
		if (indexPath.item == EmailCellIndex) {
			cell.placeholderLabel.text = TextFieldEmailLabel;
			cell.inputTextField.placeholder = TextFieldEmailPlaceholder;
			cell.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
			cell.inputTextField.text = self.tempUser.email;
			self.emailTextfield = cell.inputTextField;
		} else if (indexPath.item == CompanyNameCellIndex) {
			cell.placeholderLabel.text = TextFieldCompanyNameLabel;
			cell.inputTextField.placeholder = TextFieldCompanyNamePlaceholder;
			cell.inputTextField.text = self.tempUser.companyName;
			self.companyNameTextfield = cell.inputTextField;
		} else if (indexPath.item == PhoneCellIndex) {
			cell.placeholderLabel.text = TextFieldPhoneLabel;
			cell.inputTextField.placeholder = TextFieldPhonePlaceholder;
			cell.inputTextField.text = self.tempUser.phone;
			self.phoneTextfield = cell.inputTextField;
			cell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
		} else if (indexPath.item == NicknameCellIndex) {
			cell.placeholderLabel.text = TextFieldNicknameLabel;
			cell.inputTextField.placeholder = TextFieldNicknamePlaceholder;
			cell.inputTextField.text = self.tempUser.username;
			self.nicknameTextfield = cell.inputTextField;
		}
	} else if (indexPath.section == SocialSectionIndex) {
		if (indexPath.item == WebsiteCellIndex) {
			cell.placeholderLabel.text = TextFieldWebsiteLabel;
			cell.inputTextField.placeholder = TextFieldWebsitePlaceholder;
			cell.inputTextField.text = self.tempUser.website;
			self.websiteTextfield = cell.inputTextField;
		} else if (indexPath.item == FacebookCellIndex) {
			cell.placeholderLabel.text = TextFieldFacebookLabel;
			cell.inputTextField.placeholder = TextFieldFacebookPlaceholder;
			cell.inputTextField.text = self.tempUser.facebook;
			self.facebookTextfield = cell.inputTextField;
		} else if (indexPath.item == LinkedinCellIndex) {
			cell.placeholderLabel.text = TextFieldLinkedinLabel;
			cell.inputTextField.placeholder = TextFieldLinkedinPlaceholder;
			cell.inputTextField.text = self.tempUser.linkedin;
			self.linkedinTextfield = cell.inputTextField;
		}
	} else if (indexPath.section == PasswordSectionIndex) {
		if (indexPath.item == PasswordCellIndex) {
			cell.inputTextField.secureTextEntry = YES;
			cell.placeholderLabel.text = TextFieldPasswordLabel;
			cell.inputTextField.placeholder = TextFieldPasswordPlaceholder;
			cell.inputTextField.text = self.tempUser.password;			
			self.passwordTextfield = cell.inputTextField;
		} else if (indexPath.item == RetypePasswordCellIndex) {
			cell.placeholderLabel.text = TextFieldRePasswordLabel;
			cell.inputTextField.placeholder = TextFieldRePasswordPlaceholder;
			cell.inputTextField.secureTextEntry = YES;
			cell.inputTextField.returnKeyType = UIReturnKeyDone;
			cell.inputTextField.text = self.tempUser.rePassword;
			self.retypePasswordTextfield = cell.inputTextField;
		}
	}
	cell.backgroundColor =[UIColor whiteColor];
	cell.inputTextField.delegate = self;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

#pragma mark - Actions

- (void)saveButtonTap:(id)sender
{
	if (!self.companyNameTextfield.text.length) {
		[Utils showErrorWithMessage:@"Company name is required."];
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
    [[APIClient sharedInstance] createUserWithEmail:self.emailTextfield.text username:@"" password:self.passwordTextfield.text languageId:@"" customerTypeId:BusinessAccount companyname:self.companyNameTextfield.text website:self.websiteTextfield.text phone:self.phoneTextfield.text avatar:[Utils scaledImage:self.avatarImage] logo:[Utils scaledImage:self.logoImage] withCompletion:^(id response, NSError *error, NSInteger statusCode) {
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

#pragma mark - Utils

- (void)refreshInputViews
{
	NSMutableArray *views = [[NSMutableArray alloc] init];
	
	if (self.nicknameTextfield) {
		[views addObject:self.nicknameTextfield];
	}
	if (self.companyNameTextfield) {
		[views addObject:self.companyNameTextfield];
	}
	if (self.phoneTextfield) {
		[views addObject:self.phoneTextfield];
	}
	if (self.emailTextfield) {
		[views addObject:self.emailTextfield];
	}
	if (self.websiteTextfield) {
		[views addObject:self.websiteTextfield];
	}
	if (self.facebookTextfield) {
		[views addObject:self.facebookTextfield];
	}
	if (self.linkedinTextfield) {
		[views addObject:self.linkedinTextfield];
	}
	if (self.passwordTextfield) {
		[views addObject:self.passwordTextfield];
	}
	if (self.retypePasswordTextfield) {
		[views addObject:self.retypePasswordTextfield];
	}
	self.inputViewsCollection.textInputViews =  views;
}

@end
