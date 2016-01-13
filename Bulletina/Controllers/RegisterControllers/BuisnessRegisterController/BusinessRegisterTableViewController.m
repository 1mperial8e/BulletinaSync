//
//  BusinessRegisterTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Controllers
#import "BusinessRegisterTableViewController.h"

//Cells
#import "BusinessLogoTableViewCell.h"
#import "InputTableViewCell.h"
#import "ButtonTableViewCell.h"

// Helpers
#import "TextInputNavigationCollection.h"

static CGFloat const LogoCellHeigth = 178;
static CGFloat const InputCellHeigth = 48;
static CGFloat const ButtonCellHeigth = 52;


typedef NS_ENUM(NSUInteger, CellsIndexes) {
	LogoCellIndex,
	UsernameCellIndex,
	CompanyNameCellIndex,
	WebsiteCellIndex,
	FacebookCellIndex,
	LinkedInCellIndex,
	TwitterCellIndex,
	NewPasswordCellIndex,
	RetypeNewPasswordCellIndex,
	SaveButtonCellIndex
};

@interface BusinessRegisterTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) UITextField *usernameTextfield;
@property (weak, nonatomic) UITextField *companyNameTextfield;
@property (weak, nonatomic) UITextField *websiteTextfield;
@property (weak, nonatomic) UITextField *facebookTextfield;
@property (weak, nonatomic) UITextField *linkedInTextfield;
@property (weak, nonatomic) UITextField *twitterTextfield;
@property (weak, nonatomic) UITextField *passwordTextfield;
@property (weak, nonatomic) UITextField *retypePasswordTextfield;

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
	self.inputViewsCollection.textInputViews = @[self.usernameTextfield, self.companyNameTextfield, self.websiteTextfield, self.facebookTextfield, self.linkedInTextfield, self.twitterTextfield, self.passwordTextfield , self.retypePasswordTextfield];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
	CGFloat height = InputCellHeigth * [self heightCoefficient];
	if (indexPath.row == LogoCellIndex) {
		return LogoCellHeigth * [self heightCoefficient];
	} else if (indexPath.row == TwitterCellIndex) {
		return (InputCellHeigth + 36) * [self heightCoefficient];
	} else if (indexPath.row == SaveButtonCellIndex) {
		return ButtonCellHeigth * [self heightCoefficient];
	}
	return height;
}

#pragma mark - Cells

- (BusinessLogoTableViewCell *)logoCellForIndexPath:(NSIndexPath *)indexPath
{
	BusinessLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BusinessLogoTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	return cell;
}

- (InputTableViewCell *)inputCellForIndexPath:(NSIndexPath *)indexPath
{
	InputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InputTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	if (indexPath.item == UsernameCellIndex) {
		cell.inputTextField.placeholder = @"Username:";
		cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
		cell.inputTextField.returnKeyType = UIReturnKeyNext;
		self.usernameTextfield = cell.inputTextField;
	} else if (indexPath.item == CompanyNameCellIndex) {
		cell.inputTextField.placeholder = @"Company Name:";
		cell.inputTextField.returnKeyType = UIReturnKeyNext;
		self.companyNameTextfield = cell.inputTextField;
	} else if (indexPath.item == WebsiteCellIndex) {
		cell.inputTextField.placeholder = @"Website:";
		cell.inputTextField.returnKeyType = UIReturnKeyNext;
		self.websiteTextfield = cell.inputTextField;
	} else if (indexPath.item == FacebookCellIndex) {
		cell.inputTextField.placeholder = @"Facebook:";
		cell.inputTextField.returnKeyType = UIReturnKeyNext;
		self.facebookTextfield = cell.inputTextField;
	} else if (indexPath.item == LinkedInCellIndex) {
		cell.inputTextField.placeholder = @"LinkedIn:";
		cell.inputTextField.returnKeyType = UIReturnKeyNext;
		self.linkedInTextfield = cell.inputTextField;
	} else if (indexPath.item == TwitterCellIndex) {
		cell.inputTextField.placeholder = @"Twitter:";
		cell.inputTextField.returnKeyType = UIReturnKeyNext;
		self.twitterTextfield = cell.inputTextField;
		cell.bottomInsetConstraint.constant = 36 * [self heightCoefficient];
	} else if (indexPath.item == NewPasswordCellIndex) {
		cell.inputTextField.placeholder = @"Password:";
		cell.inputTextField.secureTextEntry = YES;
		cell.inputTextField.returnKeyType = UIReturnKeyNext;
		self.passwordTextfield = cell.inputTextField;
	} else if (indexPath.item == RetypeNewPasswordCellIndex) {
		cell.inputTextField.placeholder = @"Retype password:";
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
	
}

- (void)setupDefaults
{
	self.inputViewsCollection = [TextInputNavigationCollection new];
}

#pragma mark - Utils

- (CGFloat)heightCoefficient
{
	return ScreenHeight / 667;
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

@end
