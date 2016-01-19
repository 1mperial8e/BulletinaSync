//
//  BusinessRegisterTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Controllers
#import "BusinessRegisterTableViewController.h"
#import "ImageActionSheetController.h"

//Cells
#import "BusinessLogoTableViewCell.h"
#import "InputTableViewCell.h"
#import "ButtonTableViewCell.h"

// Helpers
#import "TextInputNavigationCollection.h"

static CGFloat const LogoCellHeigth = 178;
static CGFloat const InputCellHeigth = 48;
static CGFloat const ButtonCellHeigth = 52;

static NSInteger const CellsCount = 8;
static CGFloat const AdditionalBottomInset = 36;

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

@property (strong,nonatomic) UIImage *logoImage;

@property (strong, nonatomic) TextInputNavigationCollection *inputViewsCollection;

@end

@implementation BusinessRegisterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self tableViewSetup];
	[self setupDefaults];
	
	self.title = @"Business account";
	self.navigationController.navigationBar.topItem.title = @"Cancel";
	self.view.backgroundColor = [UIColor mainPageBGColor];	
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
		return LogoCellHeigth * HeigthCoefficient;
	} else  if (indexPath.row == WebsiteCellIndex) {
		return (InputCellHeigth + AdditionalBottomInset)  * HeigthCoefficient;
	} else if (indexPath.row == SaveButtonCellIndex) {
		return ButtonCellHeigth * HeigthCoefficient;
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
		cell.inputTextField.placeholder = @"Email:";
		cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
		self.emailTextfield = cell.inputTextField;
	} else if (indexPath.item == CompanyNameCellIndex) {
		cell.inputTextField.placeholder = @"Company Name:";
		self.companyNameTextfield = cell.inputTextField;
	} else if (indexPath.item == PhoneCellIndex) {
		cell.inputTextField.placeholder = @"Phone:";
		self.phoneTextfield = cell.inputTextField;
		cell.inputTextField.keyboardType = UIKeyboardTypeNamePhonePad;
	} else if (indexPath.item == WebsiteCellIndex) {
		cell.inputTextField.placeholder = @"Website:";
		self.websiteTextfield = cell.inputTextField;
		cell.bottomInsetConstraint.constant = AdditionalBottomInset;
	} else if (indexPath.item == PasswordCellIndex) {
		cell.inputTextField.placeholder = @"Password:";
		cell.inputTextField.secureTextEntry = YES;
		self.passwordTextfield = cell.inputTextField;
	} else if (indexPath.item == RetypePasswordCellIndex) {
		cell.inputTextField.placeholder = @"Confirm password:";
		cell.inputTextField.secureTextEntry = YES;
		cell.inputTextField.returnKeyType = UIReturnKeyDone;
		self.retypePasswordTextfield = cell.inputTextField;
	}
	cell.inputTextField.delegate = self;
	return cell;
}

- (ButtonTableViewCell *)buttonCellForIndexPath:(NSIndexPath *)indexPath
{
	ButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ButtonTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	[cell.saveButton.layer setCornerRadius:5];
	[cell.saveButton addTarget:self action:@selector(saveButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
}

#pragma mark - Setup

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	self.tableView.separatorColor = [UIColor clearColor];
	
	[self.tableView registerNib:BusinessLogoTableViewCell.nib forCellReuseIdentifier:BusinessLogoTableViewCell.ID];
	[self.tableView registerNib:InputTableViewCell.nib forCellReuseIdentifier:InputTableViewCell.ID];
	[self.tableView registerNib:ButtonTableViewCell.nib forCellReuseIdentifier:ButtonTableViewCell.ID];
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
}

- (void)setupDefaults
{
	self.inputViewsCollection = [TextInputNavigationCollection new];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[self.inputViewsCollection inputViewWillBecomeFirstResponder:textField];
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.inputViewsCollection next];
	return YES;
}

#pragma mark - Actions

- (void)selectImageButtonTap:(id)sender
{
	ImageActionSheetController *imageController = [ImageActionSheetController new];
	imageController.delegate = self;
	imageController.cancelButtonTintColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
	imageController.tintColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
	__weak typeof(self) weakSelf = self;
	imageController.photoDidSelectImageInPreview = ^(UIImage *image) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		[strongSelf updateImage:image];
	};
	[self presentViewController:imageController animated:YES completion:nil];
}

- (void)saveButtonTap:(id)sender
{
	if (!self.companyNameTextfield.text.length) {
		[Utils showErrorWithMessage:@"Company name is required."];
	} else if (![Utils isValidName:self.companyNameTextfield.text] ) {
		[Utils showErrorWithMessage:@"Company name is not valid."];
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
	}
}

#pragma mark - Utils

- (void)updateImage:(UIImage *)image;
{
	self.logoImage = image;
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:LogoCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
