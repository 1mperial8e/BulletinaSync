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

static CGFloat const AvatarCellHeigth = 218;
static CGFloat const InputCellHeigth = 48;
static CGFloat const ButtonCellHeigth = 52;
static NSString * const TextViewPlaceholderText = @"About:";

static NSInteger const CellsCount = 6;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	AvatarCellIndex,
	EmailCellIndex,
	UsernameCellIndex,
	FullNameCellIndex,
	AboutMeCellIndex,
	SaveButtonCellIndex
};

@interface IndividualProfileEditTableViewController () <UITextFieldDelegate, UITextViewDelegate, ImageActionSheetControllerDelegate>

@property (weak, nonatomic) UITextField *usernameTextfield;
@property (weak, nonatomic) UITextView *aboutMeTextView;
@property (weak, nonatomic) UITextField *fullNameTextfield;
@property (weak, nonatomic) UITextField *passwordTextfield;
@property (weak, nonatomic) UITextField *retypePasswordTextfield;

@property (strong, nonatomic) TextInputNavigationCollection *inputViewsCollection;
@property (strong, nonatomic) EditProfileAboutTableViewCell *aboutCell;
@property (strong,nonatomic) UIImage *logoImage;
@property (strong, nonatomic) BulletinaLoaderView *loader;

@end

@implementation IndividualProfileEditTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self tableViewSetup];
	[self setupDefaults];
	[self setupUI];
	
	if ([APIClient sharedInstance].currentUser.avatarUrl.length) {
		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[APIClient sharedInstance].currentUser.avatarUrl]];
		self.logoImage = [UIImage imageWithData:imageData];
	}
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
		cell.inputTextField.text = [APIClient sharedInstance].currentUser.login;
		cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
		self.usernameTextfield = cell.inputTextField;
	} else if (indexPath.item == EmailCellIndex) {
		cell.inputTextField.placeholder = @"Email:";
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

- (EditProfileAboutTableViewCell *)aboutCellForIndexPath:(NSIndexPath *)indexPath
{
	self.aboutCell = [self.tableView dequeueReusableCellWithIdentifier:EditProfileAboutTableViewCell.ID forIndexPath:indexPath];
	self.aboutCell .backgroundColor = [UIColor mainPageBGColor];
	self.aboutMeTextView = self.aboutCell.aboutTextView;
	self.aboutCell.aboutTextView.returnKeyType = UIReturnKeyNext;
	self.aboutCell.aboutTextView.delegate = self;
	[self.aboutCell.aboutTextView setTextContainerInset:UIEdgeInsetsMake(5, 7, 5, 7)];
	self.aboutCell.aboutTextView.layer.borderColor = [UIColor colorWithRed:225 / 255.0f green:225 / 255.0f  blue:225 / 255.0f  alpha:1].CGColor;
	self.aboutCell.aboutTextView.layer.borderWidth = 1.0f;
	self.aboutCell.aboutTextView.layer.cornerRadius = 5;
	
	if (![APIClient sharedInstance].currentUser.about.length && !self.aboutCell.aboutTextView.text.length) {
		self.aboutCell.aboutTextView.text = TextViewPlaceholderText;
		self.aboutCell.aboutTextView.textColor = [UIColor colorWithRed:186 / 255.0 green:188 / 255.0 blue:193 / 255.0 alpha:1.0];
	} else if ([APIClient sharedInstance].currentUser.about.length && !self.aboutCell.aboutTextView.text.length) {
		self.aboutCell.aboutTextView.text = [APIClient sharedInstance].currentUser.about;
		self.aboutCell.aboutTextView.textColor = [UIColor blackColor];
	}
	
	self.aboutCell.aboutTextView.returnKeyType = UIReturnKeyDone;
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
	self.loader = [[BulletinaLoaderView alloc] initWithView:self.navigationController.view andText:nil];
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

- (void)textViewDidEndEditing:(UITextView *)textView
{
	if ([self.aboutCell.aboutTextView.text isEqualToString:@""])
	{
		self.aboutCell.aboutTextView.text = TextViewPlaceholderText;
		self.aboutCell.aboutTextView.textColor = [UIColor colorWithRed:186 / 255.0 green:188 / 255.0 blue:193 / 255.0 alpha:1.0];
	}
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
{
	if ([string isEqualToString:@"\n"]) {
		[self.inputViewsCollection next];
		return  NO;
	} else if ([textView.text rangeOfString:TextViewPlaceholderText].location != NSNotFound) {
		textView.text = @"";
		textView.textColor = [UIColor blackColor];
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
	if ([self.aboutCell.aboutTextView.text isEqualToString:@""])
	{
		self.aboutCell.aboutTextView.text = TextViewPlaceholderText;
		self.aboutCell.aboutTextView.textColor = [UIColor colorWithRed:186 / 255.0 green:188 / 255.0 blue:193 / 255.0 alpha:1.0];
	} else if ([textView.text rangeOfString:TextViewPlaceholderText].location != NSNotFound) {
		textView.text = @"";
		textView.textColor = [UIColor blackColor];
	}
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
	if (![APIClient sharedInstance].currentUser.about.length && !self.aboutCell.aboutTextView.text.length) {
		self.aboutCell.aboutTextView.text = TextViewPlaceholderText;
		self.aboutCell.aboutTextView.textColor = [UIColor colorWithRed:186 / 255.0 green:188 / 255.0 blue:193 / 255.0 alpha:1.0];
	} else if ([APIClient sharedInstance].currentUser.about.length && !self.aboutCell.aboutTextView.text.length) {
		self.aboutCell.aboutTextView.text = [APIClient sharedInstance].currentUser.about;
		self.aboutCell.aboutTextView.textColor = [UIColor blackColor];
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
	if (self.fullNameTextfield) {
		[views addObject:self.fullNameTextfield];
	}
	if (self.aboutMeTextView) {
		[views addObject:self.aboutMeTextView];
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
	}	else if (![self.retypePasswordTextfield.text isEqualToString:self.passwordTextfield.text]) {
		[Utils showWarningWithMessage:@"Password and repassword doesn't match."];
	} else if (![Utils isValidPassword:self.passwordTextfield.text] && self.passwordTextfield.text.length) {
		[Utils showErrorWithMessage:@"Password is not valid."];
	} else {
		[self.loader show];
		__weak typeof(self) weakSelf = self;
		[[APIClient sharedInstance] updateUserWithUsername:self.usernameTextfield.text fullname:@"" companyname:@"" password:self.passwordTextfield.text website:@"" facebook:@"" linkedin:@"" phone:@"" description:self.aboutMeTextView.text avatar:self.logoImage withCompletion:^(id response, NSError *error, NSInteger statusCode) {
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
					[self.navigationController popViewControllerAnimated:YES];
				});
			}
			[weakSelf.loader hide];
		}];
	}
}

@end
