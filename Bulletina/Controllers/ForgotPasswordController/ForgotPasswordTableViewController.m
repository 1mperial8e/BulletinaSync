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

@interface ForgotPasswordTableViewController ()

@end

@implementation ForgotPasswordTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Reset password";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNavBarAction:)];
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	[self.navigationController.navigationBar
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appOrangeColor]}];
	
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
	ResetPasswordTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ResetPasswordTableViewCell.ID forIndexPath:indexPath];
	
	cell.resetButton.layer.cornerRadius = 5;
//	[cell.emailTextfield textRectForBounds:CGRectMake(20, 20, 10, 10)];
//	[cell.emailTextfield editingRectForBounds:CGRectMake(20, 20, 10, 10)];
//	settingCell.settingTitleLabel.text = self.categoriesArray[indexPath.row];
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat heigth = 235;
//	if (indexPath.section == SearchAreaSectionsIndex) {
//		heigth = 51;
//	}
	return heigth;
}

//#pragma mark - Lifecycle
//UITextFieldDelegate


#pragma mark - Actions

- (void)cancelNavBarAction:(id)sender
{
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
