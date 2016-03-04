//
//  BusinessRegisterTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BusinessRegisterTableViewController.h"

static NSInteger const CellsCount = 8;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	LogoCellIndex,
	EmailCellIndex,
	CompanyNameCellIndex,
	PhoneCellIndex,
	WebsiteCellIndex,
	PasswordCellIndex,
	RetypePasswordCellIndex,
	SaveButtonCellIndex
};

@interface BusinessRegisterTableViewController () <UITextFieldDelegate, ImageActionSheetControllerDelegate>

@property (weak, nonatomic) UITextField *emailTextfield;
@property (weak, nonatomic) UITextField *companyNameTextfield;
@property (weak, nonatomic) UITextField *websiteTextfield;
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
	
	self.title = @"Business account";
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	self.inputViewsCollection.textInputViews = @[self.emailTextfield, self.companyNameTextfield, self.phoneTextfield, self.websiteTextfield, self.passwordTextfield , self.retypePasswordTextfield];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item == LogoCellIndex) {
		return [self logoCellForIndexPath:indexPath];
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
	if (indexPath.row == LogoCellIndex) {
		height = LogoCellHeigth * HeigthCoefficient;
	} else  if (indexPath.row == WebsiteCellIndex) {
		height = (InputCellHeigth + AdditionalBottomInset)  * HeigthCoefficient;
	} else if (indexPath.row == SaveButtonCellIndex) {
		height = ButtonCellHeigth * HeigthCoefficient;
	}
	return height;
}

#pragma mark - Cells

- (BusinessLogoTableViewCell *)logoCellForIndexPath:(NSIndexPath *)indexPath
{
	BusinessLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BusinessLogoTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	
	if (self.logoImage) {
		cell.logoImageView.image = self.logoImage;
	}
	cell.logoImageView.layer.borderColor = [UIColor grayColor].CGColor;
	cell.logoImageView.layer.borderWidth = 2.0f;
	cell.logoImageView.layer.cornerRadius = 10;

	[cell.selectImageButton addTarget:self action:@selector(selectImageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
}

- (InputTableViewCell *)inputCellForIndexPath:(NSIndexPath *)indexPath
{
	InputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InputTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
    cell.inputTextField.returnKeyType = UIReturnKeyNext;
	if (indexPath.item == EmailCellIndex) {
		cell.inputTextField.placeholder = TextFieldEmailPlaceholder;
		cell.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
		cell.inputTextField.text = self.tempUser.email;
		self.emailTextfield = cell.inputTextField;
	} else if (indexPath.item == CompanyNameCellIndex) {
		cell.inputTextField.placeholder = TextFieldCompanyNamePlaceholder;
		cell.inputTextField.text = self.tempUser.companyName;
		self.companyNameTextfield = cell.inputTextField;
	} else if (indexPath.item == PhoneCellIndex) {
		cell.inputTextField.placeholder = TextFieldPhonePlaceholder;
		cell.inputTextField.text = self.tempUser.phone;
		self.phoneTextfield = cell.inputTextField;
		cell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
	} else if (indexPath.item == WebsiteCellIndex) {
		cell.inputTextField.placeholder = TextFieldWebsitePlaceholder;
		cell.inputTextField.text = self.tempUser.website;
		self.websiteTextfield = cell.inputTextField;
		cell.bottomInsetConstraint.constant = AdditionalBottomInset;
	} else if (indexPath.item == PasswordCellIndex) {
		cell.inputTextField.placeholder = TextFieldPasswordPlaceholder;
		cell.inputTextField.text = self.tempUser.password;
		cell.inputTextField.secureTextEntry = YES;
		self.passwordTextfield = cell.inputTextField;
	} else if (indexPath.item == RetypePasswordCellIndex) {
		cell.inputTextField.placeholder = TextFieldRePasswordPlaceholder;
		cell.inputTextField.text = self.tempUser.rePassword;
		cell.inputTextField.secureTextEntry = YES;
		cell.inputTextField.returnKeyType = UIReturnKeyDone;
		self.retypePasswordTextfield = cell.inputTextField;
	}
	cell.inputTextField.delegate = self;
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
    [[APIClient sharedInstance] createUserWithEmail:self.emailTextfield.text username:@"" password:self.passwordTextfield.text languageId:@"" customerTypeId:BusinessAccount companyname:self.companyNameTextfield.text website:self.websiteTextfield.text phone:self.phoneTextfield.text avatar:[Utils scaledImage:self.logoImage] withCompletion:^(id response, NSError *error, NSInteger statusCode) {
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
