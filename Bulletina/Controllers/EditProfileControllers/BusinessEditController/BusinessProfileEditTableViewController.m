//
//  BusinessProfileEditTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Controllers
#import "BusinessProfileEditTableViewController.h"

static NSInteger const CellsCount = 9;

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

@interface BusinessProfileEditTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) UITextField *emailTextfield;
@property (weak, nonatomic) UITextField *companyNameTextfield;
@property (weak, nonatomic) UITextField *phoneTextfield;
@property (weak, nonatomic) UITextField *websiteTextfield;
@property (weak, nonatomic) UITextField *facebookTextfield;
@property (weak, nonatomic) UITextField *linkedInTextfield;

@end

@implementation BusinessProfileEditTableViewController

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

- (InputTableViewCell *)inputCellForIndexPath:(NSIndexPath *)indexPath
{
	InputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InputTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	cell.inputTextField.returnKeyType = UIReturnKeyNext;
	if (indexPath.item == UsernameCellIndex) {
		cell.inputTextField.placeholder = @"Email:";
		cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
		self.emailTextfield = cell.inputTextField;
		cell.inputTextField.text = [APIClient sharedInstance].currentUser.email;
        cell.inputTextField.enabled = NO;
	} else if (indexPath.item == CompanyNameCellIndex) {
		cell.inputTextField.placeholder = @"Company Name:";
		cell.inputTextField.text = [APIClient sharedInstance].currentUser.companyName;
		self.companyNameTextfield = cell.inputTextField;
		cell.inputTextField.delegate = self;
	} else if (indexPath.item == PhoneCellIndex) {
		cell.inputTextField.placeholder = @"Phone:";
		cell.inputTextField.text = [APIClient sharedInstance].currentUser.phone ?:@"";
		self.phoneTextfield = cell.inputTextField;
		cell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
		cell.inputTextField.delegate = self;
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

#pragma mark - Setup

- (void)setupUI
{
	[super setupUI];
	self.title = @"Edit company profile";
}

#pragma mark - Utils

- (void)refreshInputViews
{
	NSMutableArray *views = [[NSMutableArray alloc] init];
	
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
	if (self.aboutCell.aboutTextView) {
		[views addObject:self.aboutCell.aboutTextView];
	}
	self.inputViewsCollection.textInputViews =  views;
}

- (void)updateImage:(UIImage *)image;
{
	self.logoImage = image;
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:LogoCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Actions

- (void)saveButtonTap:(id)sender
{
	if (!self.companyNameTextfield.text.length) {
		[Utils showErrorWithMessage:@"Company name is required."];
	} else {
        [self.tableView endEditing:YES];
		[self.loader show];
		__weak typeof(self) weakSelf = self;
		NSString *aboutText = [self.aboutCell.aboutTextView.text isEqualToString:TextViewPlaceholderText] ? @"" : self.aboutCell.aboutTextView.text;
		[[APIClient sharedInstance] updateUserWithEmail:nil
                                               username:nil
                                               fullname:nil
                                            companyname:self.companyNameTextfield.text password:@""
                                                website:self.websiteTextfield.text
                                               facebook:self.facebookTextfield.text
                                               linkedin:self.linkedInTextfield.text
                                                  phone:self.phoneTextfield.text
                                            description:aboutText
                                                 avatar:[Utils scaledImage:self.logoImage]
                                         withCompletion:^(id response, NSError *error, NSInteger statusCode) {
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
				dispatch_async(dispatch_get_main_queue(), ^{
					[weakSelf.navigationController popViewControllerAnimated:YES];
				});
			}
			[weakSelf.loader hide];
		}];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
	return newText.length < 30;
}

@end
