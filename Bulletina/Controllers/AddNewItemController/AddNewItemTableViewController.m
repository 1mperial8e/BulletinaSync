//
//  AddNewItemTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "AddNewItemTableViewController.h"

static NSInteger const CellsCount = 3;

@interface AddNewItemTableViewController ()

@end

@implementation AddNewItemTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = self.category;
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNavBarAction:)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Publish" style:UIBarButtonItemStylePlain target:self action:nil];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	}
	cell.textLabel.text = @"OK";
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions

- (void)cancelNavBarAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
