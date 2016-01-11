//
//  LoginViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "LoginViewController.h"

#import "LogoTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "LoginButtonTableViewCell.h"
#import "ForgotPasswordTableViewCell.h"
#import "TryBeforeTableViewCell.h"
#import "SignupTableViewCell.h"

static CGFloat const LoginTableViewCellHeigth = 44.0f;
static CGFloat const LogoTableViewCellHeigth = 244.0f;
static CGFloat const ButtonTableViewCellHeigth = 50.0f;

@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
	self.title = @"Login";
	
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1; //7
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		return [self logoCellForIndexPath:indexPath];
	} else if (indexPath.row == 1) {
//		return [self textFieldCell];
	} else if (indexPath.row == 2) {
//		return [self textFieldCell];
	} else if (indexPath.row == 3) {
//		return [self loginButtonCell];
	} else if (indexPath.row == 4) {
//		return [self forgotPasswordCell];
	} else if (indexPath.row == 5) {
//		return [self tryBeforeCell];
	} else if (indexPath.row == 6) {
//		return [self signupCell];
	}

	return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = LoginTableViewCellHeigth;
	if (indexPath.row == 0) {
		return LogoTableViewCellHeigth;
	} else if (indexPath.row == 6) {
		
	}
	return height;
}

#pragma mark - Setup Cells

- (LogoTableViewCell *)logoCellForIndexPath:(NSIndexPath *)indexPath
{
	LogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LogoTableViewCell.ID forIndexPath:indexPath];
	return cell;
}

@end
