//
//  ReasonSelectTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ReasonSelectTableViewController.h"
#import "ReportReasonModel.h"
#import "ReportTableViewController.h"

@interface ReasonSelectTableViewController ()

@property (strong, nonatomic) NSArray *reasonsArray;

@end

@implementation ReasonSelectTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.reasonsArray = [ReportReasonModel arrayWithDictionariesArray:[Defaults objectForKey:ReportReasonsListKey]];
}

#pragma mark - Setup

- (void)setupUI
{
	self.title = @"Select Reason";
	self.view.backgroundColor = [UIColor mainPageBGColor];
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupNavBar
{
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appOrangeColor]}];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNavBarAction:)];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reasonsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	}
	cell.textLabel.text = ((ReportReasonModel *)self.reasonsArray[indexPath.item]).name;
	cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.font = [UIFont systemFontOfSize:17];
	cell.selectionStyle =  UITableViewCellSelectionStyleNone;
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	ReportTableViewController *reportTableViewController = [ReportTableViewController new];
	reportTableViewController.reasonModel =  self.reasonsArray[indexPath.item];
	reportTableViewController.reportedUserId = self.reportedUserId;
	reportTableViewController.reportedItemId = self.reportedItemId;
	[self.navigationController pushViewController:reportTableViewController animated:YES];
}

#pragma mark - Actions

- (void)cancelNavBarAction:(id)sender
{
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
