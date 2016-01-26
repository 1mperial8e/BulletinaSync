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

//Models
#import "APIClient+User.h"

static CGFloat const AvatarCellHeigth = 218;
static CGFloat const InputCellHeigth = 48;
static CGFloat const ButtonCellHeigth = 52;

static NSInteger const CellsCount = 6;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	AvatarCellIndex,
	UsernameCellIndex,
	AboutMeCellIndex,
	PasswordCellIndex,
	RetypePasswordCellIndex,
	SaveButtonCellIndex
};

@interface IndividualProfileEditTableViewController () <UITextFieldDelegate, UITextViewDelegate, ImageActionSheetControllerDelegate>

@property (weak, nonatomic) UITextField *usernameTextfield;
@property (weak, nonatomic) UITextView *aboutMeTextView;
@property (weak, nonatomic) UITextField *passwordTextfield;
@property (weak, nonatomic) UITextField *retypePasswordTextfield;

@property (strong, nonatomic) TextInputNavigationCollection *inputViewsCollection;
@property (strong, nonatomic) EditProfileAboutTableViewCell *aboutCell;
@property (strong,nonatomic) UIImage *logoImage;

@end

@implementation IndividualProfileEditTableViewController

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

- (AvatarTableViewCell *)avatarCellForIndexPath:(NSIndexPath *)indexPath
{
	AvatarTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AvatarTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	cell.avatarImageView.layer.borderColor = [UIColor grayColor].CGColor;
	cell.avatarImageView.layer.borderWidth = 5.0f;
	cell.avatarImageView.layer.cornerRadius = CGRectGetHeight(cell.avatarImageView.frame) / 2;
	if (self.logoImage) {
		cell.avatarImageView.image = self.logoImage;
	}	
	[cell.selectImageButton addTarget:self action:@selector(selectImageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
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
	} else if (indexPath.item == PasswordCellIndex) {
		cell.inputTextField.placeholder = @"New password:";
		cell.inputTextField.secureTextEntry = YES;
		self.passwordTextfield = cell.inputTextField;
	} else if (indexPath.item == RetypePasswordCellIndex) {
		cell.inputTextField.placeholder = @"Retype new password:";
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
	self.aboutCell .backgroundColor = [UIColor mainPageBGColor];
	self.aboutMeTextView = self.aboutCell .aboutTextView;
	self.aboutCell.aboutTextView.returnKeyType = UIReturnKeyNext;
	self.aboutCell.aboutTextView.delegate = self;
	[self.aboutCell.aboutTextView setTextContainerInset:UIEdgeInsetsMake(5, 7, 5, 7)];
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
	[cell.saveButton addTarget:self action:@selector(saveButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
}

#pragma mark - Setup

- (void)setupUI
{
	self.title = @"Edit profile";
	self.navigationController.navigationBar.topItem.title = @"Cancel";
	self.view.backgroundColor = [UIColor mainPageBGColor];
}

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	self.tableView.separatorColor = [UIColor clearColor];
	[self.tableView registerNib:AvatarTableViewCell.nib forCellReuseIdentifier:AvatarTableViewCell.ID];
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
	return height + 5.f;
}

- (void)refreshInputViews
{
	NSMutableArray *views = [[NSMutableArray alloc] init];
	if (self.usernameTextfield) {
		[views addObject:self.usernameTextfield];
	}
	if (self.aboutMeTextView) {
		[views addObject:self.aboutMeTextView];
	}
	if (self.passwordTextfield) {
		[views addObject:self.passwordTextfield];
	}
	if (self.retypePasswordTextfield) {
		[views addObject:self.retypePasswordTextfield];
	}
	self.inputViewsCollection.textInputViews =  views;
}

- (void)updateImage:(UIImage *)image;
{
	self.logoImage = image;
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:AvatarCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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
	if (!self.usernameTextfield.text.length) {
		[Utils showErrorWithMessage:@"Username is required."];
	} else if (![Utils isValidName:self.usernameTextfield.text] ) {
		[Utils showErrorWithMessage:@"Username is not valid."];
	}	else if (self.passwordTextfield.text.length || self.retypePasswordTextfield.text.length) {
		if (![self.retypePasswordTextfield.text isEqualToString:self.passwordTextfield.text]) {
			[Utils showWarningWithMessage:@"Password and repassword doesn't match."];
		} else if (![Utils isValidPassword:self.passwordTextfield.text]) {
			[Utils showErrorWithMessage:@"Password is not valid."];
		} else {
			[[APIClient sharedInstance] updateIndividualProfileWithNickname:self.usernameTextfield.text  about:self.aboutMeTextView.text password:self.passwordTextfield.text logo:self.logoImage withCompletion:^(id response, NSError *error, NSInteger statusCode){ DLog(@"Not implemented"); }];
		}
	}
}

@end
