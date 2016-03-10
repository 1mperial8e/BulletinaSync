//
//  AnonymusProfileEditTableViewController
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Controllers
#import "AnonymusProfileEditTableViewController.h"

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

@interface AnonymusProfileEditTableViewController () 

@property (weak, nonatomic) UITextField *emailTextfield;
@property (weak, nonatomic) UITextField *usernameTextfield;
@property (weak, nonatomic) UITextField *fullNameTextfield;
@property (weak, nonatomic) UITextField *passwordTextfield;
@property (weak, nonatomic) UITextField *retypePasswordTextfield;

@end

@implementation AnonymusProfileEditTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.sectionTitles = @[@"",@"USERNAME / EMAIL",@"PASSWORD"];
	self.sectionCellsCount = @[@1, @2, @3];
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
	
	if (indexPath.item == AvatarCellIndex) {
		return [self avatarCellForIndexPath:indexPath];
	}
//	else if (indexPath.item == AboutCellIndex) {
//		return [self aboutCellForIndexPath:indexPath];
//	}
	else if (indexPath.item == SaveButtonCellIndex) {
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
	}
//	else if (indexPath.row == AboutMeCellIndex) {
//		return [self heightForAboutCell];
//	}
	return height;
}

#pragma mark - Cells

- (InputTableViewCell *)inputCellForIndexPath:(NSIndexPath *)indexPath
{
	InputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InputTableViewCell.ID forIndexPath:indexPath];
	cell.inputTextField.returnKeyType = UIReturnKeyNext;
	if (indexPath.item == EmailCellIndex) {
		cell.inputTextField.placeholder = @"Email:";
		cell.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
		self.emailTextfield = cell.inputTextField;
	} else if (indexPath.item == UsernameCellIndex) {
		cell.inputTextField.placeholder = @"Nickname:";
		cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
		self.usernameTextfield = cell.inputTextField;
	}
//	else if (indexPath.item == FullNameCellIndex) {
//		cell.inputTextField.placeholder = @"Fullname:";
//		cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
//		self.fullNameTextfield = cell.inputTextField;
//	}
	else if (indexPath.item == PasswordCellIndex) {
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
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

#pragma mark - Utils

- (void)refreshInputViews
{
	NSMutableArray *views = [[NSMutableArray alloc] init];
	if (self.emailTextfield) {
		[views addObject:self.emailTextfield];
	}
	if (self.usernameTextfield) {
		[views addObject:self.usernameTextfield];
	}
	if (self.fullNameTextfield) {
		[views addObject:self.fullNameTextfield];
	}
	if (self.aboutCell.aboutTextView) {
		[views addObject:self.aboutCell.aboutTextView];
	}
	if (self.passwordTextfield) {
		[views addObject:self.passwordTextfield];
	}
	if (self.retypePasswordTextfield) {
		[views addObject:self.retypePasswordTextfield];
	}
	self.inputViewsCollection.textInputViews =  views;
}

//- (void)updateImage:(UIImage *)image;
//{
//	self.logoImage = image;
//	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:AvatarCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

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
        [self.tableView endEditing:YES];
		[self.loader show];
		__weak typeof(self) weakSelf = self;
		NSString *aboutText = [self.aboutCell.aboutTextView.text isEqualToString:TextViewPlaceholderText] ? @"" : self.aboutCell.aboutTextView.text;
		[[APIClient sharedInstance] updateUserWithEmail:self.emailTextfield.text username:self.usernameTextfield.text fullname:self.fullNameTextfield.text companyname:@"" password:self.passwordTextfield.text website:@"" facebook:@"" linkedin:@"" phone:@"" description:aboutText avatar:[Utils scaledImage:self.avatarImage] logo:nil withCompletion:^(id response, NSError *error, NSInteger statusCode) {
			if (error) {
				if (response[@"error_message"]) {
					[Utils showErrorWithMessage:response[@"error_message"]];
				} else if (((NSArray *)response[@"error"][@"nickname"]).firstObject) {
					NSString *errorMessage = [@"Nickname " stringByAppendingString:((NSArray *)response[@"error"][@"nickname"]).firstObject];
					[Utils showErrorWithMessage:errorMessage];
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
