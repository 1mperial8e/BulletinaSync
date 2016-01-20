//
//  ForgotPasswordTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ForgotPasswordTableViewController.h"

#import "SuccessPasswordTableViewCell.h"
#import "ResetPasswordTableViewCell.h"

#import "Utils.h"

@interface ForgotPasswordTableViewController () <UITextFieldDelegate>

@property (assign, nonatomic) BOOL resetSuccess;
@property (weak, nonatomic) UITextField *emailTextfield;

@end

@implementation ForgotPasswordTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupUI];
	[self setupTableView];
}

#pragma mark - Setup

- (void)setupUI
{
	self.title = @"Reset password";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNavBarAction:)];
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	[self.navigationController.navigationBar
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appOrangeColor]}];
}

- (void) setupTableView
{
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	self.tableView.backgroundColor = [UIColor mainPageBGColor];
	[self.tableView registerNib:SuccessPasswordTableViewCell.nib forCellReuseIdentifier:SuccessPasswordTableViewCell.ID];
	[self.tableView registerNib:ResetPasswordTableViewCell.nib forCellReuseIdentifier:ResetPasswordTableViewCell.ID];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.resetSuccess) {
		return [self successPasswordCellForIndexPath:indexPath];
	}
	return [self resetPasswordCellForIndexPath: indexPath];
}

#pragma mark - Cells

- (ResetPasswordTableViewCell *)resetPasswordCellForIndexPath:(NSIndexPath *)indexPath
{
	ResetPasswordTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ResetPasswordTableViewCell.ID forIndexPath:indexPath];
	cell.resetButton.layer.cornerRadius = 5;
	cell.emailTextfield.returnKeyType = UIReturnKeyDone;
	cell.emailTextfield.delegate =self;
	[cell.resetButton addTarget:self action:@selector(resetButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	self.emailTextfield = cell.emailTextfield;
	return cell;
}

- (SuccessPasswordTableViewCell *)successPasswordCellForIndexPath:(NSIndexPath *)indexPath
{
	SuccessPasswordTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SuccessPasswordTableViewCell.ID forIndexPath:indexPath];
	[cell.closeButton addTarget:self action:@selector(cancelNavBarAction:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat heigth = 235;
	return heigth;
}

#pragma mark - Actions

- (void)cancelNavBarAction:(id)sender
{
	[self.tableView endEditing:YES];
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetButtonTap:(id)sender
{
	if (!self.emailTextfield.text.length) {
		[Utils showWarningWithMessage:@"Email is required"];
	} else if ([Utils isValidEmail:self.emailTextfield.text UseHardFilter:NO]) {
		self.resetSuccess = YES;
		[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
	} else {
		[Utils showWarningWithMessage:@"Email is not valid"];
	}
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.tableView endEditing:YES];
	return NO;
}

@end
