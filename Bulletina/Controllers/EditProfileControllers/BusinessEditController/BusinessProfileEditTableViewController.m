//
//  BusinessProfileEditTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Controllers
#import "BusinessProfileEditTableViewController.h"
#import "ImageActionSheetController.h"

//Cells
#import "BusinessLogoTableViewCell.h"
#import "InputTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "EditProfileAboutTableViewCell.h"

// Helpers
#import "TextInputNavigationCollection.h"
#import "BulletinaLoaderView.h"

//Models
#import "APIClient+User.h"

static CGFloat const LogoCellHeigth = 178;
static CGFloat const InputCellHeigth = 48;
static CGFloat const ButtonCellHeigth = 52;
static NSString * const TextViewPlaceholderText = @"About:";

static NSInteger const CellsCount = 9;
//static CGFloat const AdditionalBottomInset = 36;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	LogoCellIndex,
	UsernameCellIndex,
	CompanyNameCellIndex,
	PhoneCellIndex,
	WebsiteCellIndex,
	FacebookCellIndex,
	LinkedInCellIndex,
	AboutCellIndex,
	SaveButtonCellIndex
};

@interface BusinessProfileEditTableViewController () <UITextFieldDelegate, UITextViewDelegate, ImageActionSheetControllerDelegate>

@property (weak, nonatomic) UITextField *usernameTextfield;
@property (weak, nonatomic) UITextField *companyNameTextfield;
@property (weak, nonatomic) UITextField *phoneTextfield;
@property (weak, nonatomic) UITextField *websiteTextfield;
@property (weak, nonatomic) UITextField *facebookTextfield;
@property (weak, nonatomic) UITextField *linkedInTextfield;
@property (weak, nonatomic) UITextView *aboutTextView;

@property (strong, nonatomic) TextInputNavigationCollection *inputViewsCollection;
@property (strong, nonatomic) EditProfileAboutTableViewCell *aboutCell;
@property (strong,nonatomic) UIImage *logoImage;
@property (strong, nonatomic) BulletinaLoaderView *loader;

@end

@implementation BusinessProfileEditTableViewController

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
	if (indexPath.item == UsernameCellIndex) {
		cell.inputTextField.placeholder = @"Username:";
		cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
		self.usernameTextfield = cell.inputTextField;
		cell.inputTextField.text = [APIClient sharedInstance].currentUser.login;
	} else if (indexPath.item == CompanyNameCellIndex) {
		cell.inputTextField.placeholder = @"Company Name:";
		cell.inputTextField.text = [APIClient sharedInstance].currentUser.companyName;
		self.companyNameTextfield = cell.inputTextField;
	} else if (indexPath.item == PhoneCellIndex) {
		cell.inputTextField.placeholder = @"Phone:";
		cell.inputTextField.text = [APIClient sharedInstance].currentUser.phone ?:@"";
		self.phoneTextfield = cell.inputTextField;
		cell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
	} else if (indexPath.item == WebsiteCellIndex) {
		cell.inputTextField.placeholder = @"Website:";
		cell.inputTextField.text = [APIClient sharedInstance].currentUser.website;
		self.websiteTextfield = cell.inputTextField;
	} else if (indexPath.item == FacebookCellIndex) {
		cell.inputTextField.placeholder = @"Facebook:";
		cell.inputTextField.text = [APIClient sharedInstance].currentUser.facebook;
		self.facebookTextfield = cell.inputTextField;
	} else if (indexPath.item == LinkedInCellIndex) {
		cell.inputTextField.placeholder = @"LinkedIn:";
		cell.inputTextField.text = [APIClient sharedInstance].currentUser.linkedin;
		self.linkedInTextfield = cell.inputTextField;
	}
	cell.inputTextField.delegate = self;
	return cell;
}


- (EditProfileAboutTableViewCell *)aboutCellForIndexPath:(NSIndexPath *)indexPath
{
	self.aboutCell = [self.tableView dequeueReusableCellWithIdentifier:EditProfileAboutTableViewCell.ID forIndexPath:indexPath];
	self.aboutCell.backgroundColor = [UIColor mainPageBGColor];
	self.aboutTextView = self.aboutCell.aboutTextView;
	self.aboutCell.aboutTextView.returnKeyType = UIReturnKeyNext;
	self.aboutCell.aboutTextView.delegate = self;
	[self.aboutCell.aboutTextView setTextContainerInset:UIEdgeInsetsMake(10, 5, 10, 5)];
	self.aboutCell.aboutTextView.layer.borderColor = [UIColor colorWithRed:225 / 255.0f green:225 / 255.0f  blue:225 / 255.0f  alpha:1].CGColor;
	if (![APIClient sharedInstance].currentUser.about.length && !self.aboutCell.aboutTextView.text.length) {
		self.aboutCell.aboutTextView.text = TextViewPlaceholderText;
		self.aboutCell.aboutTextView.textColor = [UIColor colorWithRed:204 / 255.0 green:206 / 255.0 blue:209 / 255.0 alpha:1.0];
	} else if ([APIClient sharedInstance].currentUser.about.length && !self.aboutCell.aboutTextView.text.length) {
		self.aboutCell.aboutTextView.text = [APIClient sharedInstance].currentUser.about;
		self.aboutCell.aboutTextView.textColor = [UIColor blackColor];
	}
	self.aboutCell.aboutTextView.layer.borderWidth = 1.0f;
	self.aboutCell.aboutTextView.layer.cornerRadius = 5;
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
	self.title = @"Edit company profile";
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
		self.aboutCell.aboutTextView.textColor = [UIColor colorWithRed:204 / 255.0 green:206 / 255.0 blue:209 / 255.0 alpha:1.0];
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
		self.aboutCell.aboutTextView.textColor = [UIColor colorWithRed:204 / 255.0 green:206 / 255.0 blue:209 / 255.0 alpha:1.0];
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
		self.aboutCell.aboutTextView.textColor = [UIColor colorWithRed:204 / 255.0 green:206 / 255.0 blue:209 / 255.0 alpha:1.0];
	} else if ([APIClient sharedInstance].currentUser.about.length && !self.aboutCell.aboutTextView.text.length) {
		self.aboutCell.aboutTextView.text = [APIClient sharedInstance].currentUser.about;
		self.aboutCell.aboutTextView.textColor = [UIColor blackColor];
	}
	[self.aboutCell.aboutTextView setTextContainerInset:UIEdgeInsetsMake(10, 5, 10, 5)];
	CGFloat height = ceil([self.aboutCell.aboutTextView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
	return height + 5.f;
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
	if (self.phoneTextfield) {
		[views addObject:self.phoneTextfield];
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
	if (self.aboutTextView) {
		[views addObject:self.aboutTextView];
	}
	self.inputViewsCollection.textInputViews =  views;
}

- (void)updateImage:(UIImage *)image;
{
	self.logoImage = image;
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:LogoCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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
	} else {
		[self.loader show];
		__weak typeof(self) weakSelf = self;
		[[APIClient sharedInstance] updateUserWithUsername:self.usernameTextfield.text fullname:@"" companyname:self.companyNameTextfield.text password:@"" website:self.websiteTextfield.text facebook:self.facebookTextfield.text linkedin:self.linkedInTextfield.text phone:self.phoneTextfield.text	description:self.aboutTextView.text avatar:self.logoImage withCompletion:^(id response, NSError *error, NSInteger statusCode) {
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
