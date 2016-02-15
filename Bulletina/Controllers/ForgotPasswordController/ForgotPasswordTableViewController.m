//
//  ForgotPasswordTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

// Controllers
#import "ForgotPasswordTableViewController.h"

// Cells
#import "SuccessPasswordTableViewCell.h"
#import "ResetPasswordTableViewCell.h"

// Models
#import "APIClient+User.h"

static CGFloat const ResetPasswordCellHeight = 235;

@interface ForgotPasswordTableViewController () <UITextFieldDelegate>

@property (assign, nonatomic) BOOL resetSuccess;
@property (weak, nonatomic) UITextField *emailTextfield;

@end

@implementation ForgotPasswordTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.resetSuccess = NO;
	[self setupUI];
	[self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Application setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView endEditing:YES];
}

#pragma mark - Setup

- (void)setupUI
{
	self.title = @"Reset password";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNavBarAction:)];
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appOrangeColor]}];
}

- (void)setupTableView
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
	CGFloat height = ResetPasswordCellHeight;
	return height;
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
	} else if (![Utils isValidEmail:self.emailTextfield.text UseHardFilter:NO]) {
        [Utils showWarningWithMessage:@"Email is not valid"];
	} else {
        [self.tableView endEditing:YES];
        __weak typeof(self) weakSelf = self;
        [[APIClient sharedInstance] forgotPasswordWithEmail:self.emailTextfield.text withCompletion:^(id response, NSError *error, NSInteger statusCode) {
            if (error) {
                if (response[@"error"]) {
                    [Utils showErrorWithMessage:response[@"error"]];
                } else {
                    [Utils showErrorForStatusCode:statusCode];
                }
            } else {
                weakSelf.resetSuccess = YES;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
	}
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.tableView endEditing:YES];
	return YES;
}

@end
