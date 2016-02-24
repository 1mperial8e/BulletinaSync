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

// Views
#import "BulletinaLoaderView.h"

static CGFloat const ResetPasswordCellHeight = 235;

@interface ForgotPasswordTableViewController () <UITextFieldDelegate>

@property (assign, nonatomic) BOOL resetSuccess;
@property (weak, nonatomic) UITextField *emailTextfield;

@property (strong, nonatomic) BulletinaLoaderView *loader;
@property (weak, nonatomic) NSURLSessionTask *task;

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.loader = [[BulletinaLoaderView alloc] initWithView:self.view andText:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView endEditing:YES];
    [self.task cancel];
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
        [self.loader show];
        __weak typeof(self) weakSelf = self;
        self.task = [[APIClient sharedInstance] forgotPasswordWithEmail:self.emailTextfield.text withCompletion:^(id response, NSError *error, NSInteger statusCode) {
            if (error) {
                if (statusCode == 404) {
                    [Utils showErrorWithMessage:@"Email address isn't associated to account"];
                } else {
                    [Utils showErrorForStatusCode:statusCode];
                }
            } else {
                weakSelf.resetSuccess = YES;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [weakSelf.loader hide];
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
