//
//  BusinessProfileEditTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Controllers
#import "BusinessProfileEditTableViewController.h"

//Cells
#import "BusinessLogoTableViewCell.h"
#import "InputTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "EditProfileAboutTableViewCell.h"

// Helpers
#import "TextInputNavigationCollection.h"

static CGFloat const LogoCellHeigth = 178;
static CGFloat const InputCellHeigth = 48;
static CGFloat const ButtonCellHeigth = 52;

static NSInteger const CellsCount = 11;
static CGFloat const AdditionalBottomInset = 36;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	LogoCellIndex,
	UsernameCellIndex,
	CompanyNameCellIndex,
	WebsiteCellIndex,
	FacebookCellIndex,
	LinkedInCellIndex,
	TwitterCellIndex,
	AboutCellIndex,
	PasswordCellIndex,
	RetypePasswordCellIndex,
	SaveButtonCellIndex
};

@interface BusinessProfileEditTableViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) UITextField *usernameTextfield;
@property (weak, nonatomic) UITextField *companyNameTextfield;
@property (weak, nonatomic) UITextField *websiteTextfield;
@property (weak, nonatomic) UITextField *facebookTextfield;
@property (weak, nonatomic) UITextField *linkedInTextfield;
@property (weak, nonatomic) UITextField *twitterTextfield;
@property (weak, nonatomic) UITextView *aboutTextView;
@property (weak, nonatomic) UITextField *passwordTextfield;
@property (weak, nonatomic) UITextField *retypePasswordTextfield;

@property (strong, nonatomic) TextInputNavigationCollection *inputViewsCollection;

@property (strong, nonatomic) EditProfileAboutTableViewCell *aboutCell;

@end

@implementation BusinessProfileEditTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self tableViewSetup];
	[self setupDefaults];
	[self setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self refreshInputViews];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return CellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self refreshInputViews];
	
	if (indexPath.item == LogoCellIndex) {
		return [self logoCellForIndexPath:indexPath];
	} else if (indexPath.item == AboutCellIndex) {
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
	if (indexPath.row == LogoCellIndex) {
		return LogoCellHeigth * HeigthCoefficient;
	} else if (indexPath.row == SaveButtonCellIndex) {
		return ButtonCellHeigth * HeigthCoefficient;
	} else if (indexPath.row == AboutCellIndex) {
		return [self heightForAboutCell];
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
	cell.inputTextField.returnKeyType = UIReturnKeyNext;
	if (indexPath.item == UsernameCellIndex) {
		cell.inputTextField.placeholder = @"Username:";
		cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
		self.usernameTextfield = cell.inputTextField;
	} else if (indexPath.item == CompanyNameCellIndex) {
		cell.inputTextField.placeholder = @"Company Name:";
		self.companyNameTextfield = cell.inputTextField;
	} else if (indexPath.item == WebsiteCellIndex) {
		cell.inputTextField.placeholder = @"Website:";
		self.websiteTextfield = cell.inputTextField;
	} else if (indexPath.item == FacebookCellIndex) {
		cell.inputTextField.placeholder = @"Facebook:";
		self.facebookTextfield = cell.inputTextField;
	} else if (indexPath.item == LinkedInCellIndex) {
		cell.inputTextField.placeholder = @"LinkedIn:";
		self.linkedInTextfield = cell.inputTextField;
	} else if (indexPath.item == TwitterCellIndex) {
		cell.inputTextField.placeholder = @"Twitter:";
		self.twitterTextfield = cell.inputTextField;
	} else if (indexPath.item == PasswordCellIndex) {
		cell.inputTextField.placeholder = @"New password:";
		cell.inputTextField.secureTextEntry = YES;
		self.passwordTextfield = cell.inputTextField;
	} else if (indexPath.item == RetypePasswordCellIndex) {
		cell.inputTextField.placeholder = @"Retype New password:";
		cell.inputTextField.secureTextEntry = YES;
		cell.inputTextField.returnKeyType = UIReturnKeyDone;
		self.retypePasswordTextfield = cell.inputTextField;
	}
	cell.inputTextField.delegate = self;
	return cell;
}


- (EditProfileAboutTableViewCell *)aboutCellForIndexPath:(NSIndexPath *)indexPath
{
	self.aboutCell = [self.tableView dequeueReusableCellWithIdentifier:EditProfileAboutTableViewCell.ID forIndexPath:indexPath];
	self.aboutCell.backgroundColor = [UIColor mainPageBGColor];
	self.aboutTextView = self.aboutCell .aboutTextView;
	self.aboutCell.aboutTextView.returnKeyType = UIReturnKeyNext;
	self.aboutCell.aboutTextView.delegate = self;
	[self.aboutCell.aboutTextView setTextContainerInset:UIEdgeInsetsMake(5, 7, 5, 7)];
	self.aboutCell.bottomInsetConstraint.constant = AdditionalBottomInset * HeigthCoefficient;
	self.aboutCell.aboutTextView.layer.borderColor = [UIColor colorWithRed:225 / 255.0f green:225 / 255.0f  blue:225 / 255.0f  alpha:1].CGColor;
	self.aboutCell.aboutTextView.layer.borderWidth = 1.0f;
	self.aboutCell.aboutTextView.layer.cornerRadius = 5;
	return self.aboutCell ;
}

- (ButtonTableViewCell *)buttonCellForIndexPath:(NSIndexPath *)indexPath
{
	ButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ButtonTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	cell.saveButton.layer.cornerRadius = 5;
	return cell;
}

#pragma mark - Setup

- (void)setupUI
{
	self.title = @"Edit company profile";
	self.navigationController.navigationBar.topItem.title = @"Cancel";
	self.view.backgroundColor = [UIColor mainPageBGColor];
}

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	self.tableView.separatorColor = [UIColor clearColor];
	[self.tableView registerNib:BusinessLogoTableViewCell.nib forCellReuseIdentifier:BusinessLogoTableViewCell.ID];
	[self.tableView registerNib:InputTableViewCell.nib forCellReuseIdentifier:InputTableViewCell.ID];
	[self.tableView registerNib:ButtonTableViewCell.nib forCellReuseIdentifier:ButtonTableViewCell.ID];
	[self.tableView registerNib:EditProfileAboutTableViewCell.nib forCellReuseIdentifier:EditProfileAboutTableViewCell.ID];
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 30, 0)];
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

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
{
	if ([string isEqualToString:@"\n"]) {
		[self.inputViewsCollection next];
		return  NO;
	}
	return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	[self.inputViewsCollection inputViewWillBecomeFirstResponder:textView];
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	CGFloat height = ceil([textView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
	if (textView.contentSize.height > height + 1 || textView.contentSize.height < height - 1) {
		[self.tableView beginUpdates];
		[self.tableView endUpdates];
		
		CGRect textViewRect = [self.tableView convertRect:textView.frame fromView:textView.superview];
		textViewRect.origin.y += 5;
		[self.tableView scrollRectToVisible:textViewRect animated:YES];
	}
}

#pragma mark - Utils

- (CGFloat)heightForAboutCell
{
	if (!self.aboutCell) {
		self.aboutCell = [[NSBundle mainBundle] loadNibNamed:EditProfileAboutTableViewCell.ID owner:nil options:nil].firstObject;
	}
	CGFloat height = ceil([self.aboutCell.aboutTextView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
	return height + 5.f + AdditionalBottomInset*HeigthCoefficient;
}

- (void)refreshInputViews
{
	NSMutableArray *views = [[NSMutableArray alloc] init];
	
	if (self.usernameTextfield) {
		[views addObject:self.usernameTextfield];
	}
	if (self.companyNameTextfield) {
		[views addObject:self.companyNameTextfield];
	}
	if (self.websiteTextfield) {
		[views addObject:self.websiteTextfield];
	}
	if (self.facebookTextfield) {
		[views addObject:self.facebookTextfield];
	}
	if (self.linkedInTextfield) {
		[views addObject:self.linkedInTextfield];
	}
	if (self.twitterTextfield) {
		[views addObject:self.twitterTextfield];
	}
	if (self.aboutTextView) {
		[views addObject:self.aboutTextView];
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
