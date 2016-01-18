//
//  SelectNewItemCategoryTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "SelectNewItemCategoryTableViewController.h"
#import "AddNewItemTableViewController.h"

#import "SelectCategoryHeaderView.h"

@interface SelectNewItemCategoryTableViewController ()

@property (strong, nonatomic) NSArray *categoriesArray;

@end

@implementation SelectNewItemCategoryTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupUI];
	[self setupNavBar];
	[self setupTableView];
	
	self.categoriesArray = @[@"For sale", @"For rent", @"Give away", @"Job request", @"Services", @"Annoucement", @"Lost & found", @"Other"];
}

#pragma mark - Setup

- (void)setupUI
{
	self.title = @"Select Category";
	self.view.backgroundColor = [UIColor mainPageBGColor];
}

- (void)setupNavBar
{
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNavBarAction:)];
}

- (void)setupTableView
{
	self.tableView.tableHeaderView = [[SelectCategoryHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 39)];
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoriesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	}
	cell.textLabel.text = self.categoriesArray[indexPath.item];
	cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.textColor = [UIColor appOrangeColor];
	cell.textLabel.font = [UIFont systemFontOfSize:17];
	
	cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DisclosureIndicator"]];
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	AddNewItemTableViewController *addNewTableViewController = [AddNewItemTableViewController new];
	addNewTableViewController.category = self.categoriesArray[indexPath.item];
	[self.navigationController pushViewController:addNewTableViewController animated:YES];
}

#pragma mark - Actions

- (void)cancelNavBarAction:(id)sender
{
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
