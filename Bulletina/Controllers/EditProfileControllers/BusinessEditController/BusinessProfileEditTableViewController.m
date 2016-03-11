//
//  BusinessProfileEditTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Controllers
#import "BusinessProfileEditTableViewController.h"

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	LogoCellIndex = 0,
	EmailCellIndex = 0,
	NicknameCellIndex = 1,
	CompanyNameCellIndex = 2,
	PhoneCellIndex = 3,
	WebsiteCellIndex = 0,
	FacebookCellIndex = 1,
	LinkedinCellIndex = 2,
	AboutCellIndex = 0,
	SaveButtonCellIndex = 1
};

typedef NS_ENUM(NSUInteger, SectionsIndexes) {
	LogoSectionIndex,
	ProfileSectionIndex,
	SocialSectionIndex,
	AboutSectionIndex
};

@interface BusinessProfileEditTableViewController ()

@property (weak, nonatomic) UITextField *emailTextfield;
@property (weak, nonatomic) UITextField *nicknameTextfield;
@property (weak, nonatomic) UITextField *companyNameTextfield;
@property (weak, nonatomic) UITextField *websiteTextfield;
@property (weak, nonatomic) UITextField *facebookTextfield;
@property (weak, nonatomic) UITextField *linkedinTextfield;
@property (weak, nonatomic) UITextField *phoneTextfield;

@end

@implementation BusinessProfileEditTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.sectionTitles = @[@"",@"PROFILE",@"SOCIAL LINKS (OPTIONAL)",@"ABOUT US"];
	self.sectionCellsCount = @[@1, @4, @3, @2];
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
	} else if (indexPath.item == AboutCellIndex && indexPath.section == AboutSectionIndex) {
		return [self aboutCellForIndexPath:indexPath];
	} else if (indexPath.item == SaveButtonCellIndex && indexPath.section == AboutSectionIndex) {
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
	if (indexPath.row == LogoCellIndex && indexPath.section == LogoSectionIndex) {
		return BusinessHeaderCellHeigth;
	} else if (indexPath.row == SaveButtonCellIndex && indexPath.section == AboutSectionIndex) {
		return ButtonCellHeigth * HeigthCoefficient;
	} else if (indexPath.row == AboutCellIndex && indexPath.section == AboutSectionIndex) {
		return [self heightForAboutCell];
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

- (InputTableViewCell *)inputCellForIndexPath:(NSIndexPath *)indexPath
{
	InputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InputTableViewCell.ID forIndexPath:indexPath];
	
	cell.inputTextField.returnKeyType = UIReturnKeyNext;
	if (indexPath.section == ProfileSectionIndex) {
		if (indexPath.item == EmailCellIndex) {
			cell.inputTextField.enabled = NO;
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
	}
	cell.inputTextField.delegate = self;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

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
	
	if (self.emailTextfield) {
		[views addObject:self.emailTextfield];
	}
	if (self.nicknameTextfield) {
		[views addObject:self.nicknameTextfield];
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
	if (self.linkedinTextfield) {
		[views addObject:self.linkedinTextfield];
	}
	if (self.aboutCell.aboutTextView) {
		[views addObject:self.aboutCell.aboutTextView];
	}
	self.inputViewsCollection.textInputViews =  views;
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

		[[APIClient sharedInstance] updateUserWithEmail:nil
                                               username:self.nicknameTextfield.text
                                               fullname:nil
                                            companyname:self.companyNameTextfield.text
											   password:@""
                                                website:self.websiteTextfield.text
                                               facebook:self.facebookTextfield.text
                                               linkedin:self.linkedinTextfield.text
                                                  phone:self.phoneTextfield.text
                                            description:self.aboutCell.aboutTextView.text
                                                 avatar:[Utils scaledImage:self.avatarImage]
												 logo:[Utils scaledImage:self.logoImage]
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

@end
