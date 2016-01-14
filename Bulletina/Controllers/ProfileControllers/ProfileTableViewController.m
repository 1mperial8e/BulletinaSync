//
//  ProfileTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ProfileDefaultTableViewCell.h"

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self tableViewSetup];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileDefaultTableViewCell.ID forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}



/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

#pragma mark - Setup

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
//	self.tableView.separatorColor = [UIColor clearColor];
	
	[self.tableView registerNib:ProfileDefaultTableViewCell.nib forCellReuseIdentifier:ProfileDefaultTableViewCell.ID];
//	[self.tableView registerNib:InputTableViewCell.nib forCellReuseIdentifier:InputTableViewCell.ID];
//	[self.tableView registerNib:ButtonTableViewCell.nib forCellReuseIdentifier:ButtonTableViewCell.ID];
//	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
}

@end
