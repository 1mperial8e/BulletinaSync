//
//  ItemsListTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ItemsListTableViewController.h"
#import "MyItemsTableViewController.h"
#import "AddNewItemTableViewController.h"

@interface ItemsListTableViewController ()

@end

@implementation ItemsListTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self performSelector:@selector(fetchItemListWithLoader:) withObject:@YES afterDelay:[APIClient sharedInstance].requestStartDelay];
}

#pragma mark - Accessors

- (BulletinaLoaderView *)loader
{
    if (!_loader) {
        _loader = [[BulletinaLoaderView alloc] initWithView:self.navigationController.view andText:nil];
    }
    return _loader;
}
	
#pragma mark - API

- (void)fetchItemListWithLoader:(id)needLoader
{
	if ([needLoader boolValue]) {
        [self.loader show];
	}
	__weak typeof(self) weakSelf = self;
//	[[APIClient sharedInstance] fetchItemsWithOffset:@0 limit:@85 withCompletion:
	[[APIClient sharedInstance] fetchItemsForSearchSettingsAndPage:0 withCompletion:
	 ^(id response, NSError *error, NSInteger statusCode) {
		if (error) {
			if (response[@"error_message"]) {
				[Utils showErrorWithMessage:response[@"error_message"]];
			} else if (statusCode == -1009) {
				[Utils showErrorWithMessage:@"Please check network connection and try again"];
			} else if (statusCode == 401) {
				[Utils showErrorUnknown];
			} else {
				[Utils showErrorUnknown];
			}
		} else {
			NSAssert([response isKindOfClass:[NSArray class]], @"Unknown response from server");
			weakSelf.itemsList = [ItemModel arrayWithDictionariesArray:response];
			[weakSelf.tableView reloadData];
		}
		[weakSelf.loader hide];
	}];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.itemsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self defaultCellForIndexPath:indexPath forMyItems:NO];
}

#pragma mark - Cells

- (ItemTableViewCell *)defaultCellForIndexPath:(NSIndexPath *)indexPath forMyItems:(BOOL)myItems
{
	ItemTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemTableViewCell.ID forIndexPath:indexPath];
	NSInteger dataIndex = myItems ? indexPath.item -1 : indexPath.item;
	cell.cellItem = self.itemsList[dataIndex];	
	cell.delegate = self;
	UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemImageTap:)];
	[cell.itemImageView addGestureRecognizer:imageTapGesture];
	return cell;
}

#pragma mark - Actions

- (void)itemImageTap:(UITapGestureRecognizer *)sender
{
	if (((UIImageView *)sender.view).image) {
		CGRect cellFrame = [self.navigationController.view convertRect:sender.view.superview.superview.frame fromView:self.tableView];
		CGRect imageViewRect = sender.view.frame;
		imageViewRect.origin.x = ([UIScreen mainScreen].bounds.size.width - imageViewRect.size.width) / 2;
		imageViewRect.origin.y = cellFrame.origin.y + CGRectGetHeight(self.navigationController.navigationBar.frame);
		
		FullScreenImageViewController *imageController = [FullScreenImageViewController new];
		imageController.image = ((UIImageView *)sender.view).image;
		imageController.presentationRect = imageViewRect;
		imageController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
		[self.navigationController presentViewController:imageController animated:NO completion:nil];
	}
}

- (void)showUserForItem:(ItemModel *)item
{
	MyItemsTableViewController *itemsTableViewController = [MyItemsTableViewController new];
	itemsTableViewController.userId = item.userId;
	[self.navigationController pushViewController:itemsTableViewController animated:YES];
}

#pragma mark - Setup

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	[self.tableView registerNib:ItemTableViewCell.nib forCellReuseIdentifier:ItemTableViewCell.ID];
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupNavigationBar
{
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appOrangeColor]}];
}

#pragma mark - ItemCellDelegate

- (void)showActionSheetForItem:(ItemModel *)item
{
	__weak typeof(self) weakSelf = self;
	UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	[actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

	if ([APIClient sharedInstance].currentUser.userId == item.userId) {
		[actionSheet addAction:[UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			AddNewItemTableViewController *editTableViewController = [AddNewItemTableViewController new];
			editTableViewController.adItem = item;
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editTableViewController];
			[weakSelf.navigationController presentViewController:navigationController animated:YES completion:nil];
		}]];
		[actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[weakSelf deleteItemWithId:item.itemId];
		}]];

    } else {
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Report" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            ReportTableViewController *reportTableViewController = [[ReportTableViewController alloc] initWithItemId:item.itemId andUserId:item.userId];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:reportTableViewController];
            [weakSelf.navigationController presentViewController:navigationController animated:YES completion:nil];
        }]];
    }
    
	[self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - Utils

- (void)deleteItemWithId:(NSInteger)itemId
{
	[[APIClient sharedInstance] deleteItemWithId:itemId withCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (error) {
			if (response[@"error_message"]) {
				[Utils showErrorWithMessage:response[@"error_message"]];
			} else if (statusCode == -1009) {
				[Utils showErrorWithMessage:@"Please check network connection and try again"];
			} else if (statusCode == 401) {
				[Utils showErrorUnknown];
			} else {
				[Utils showErrorUnknown];
			}
		} else {
			[Utils showWarningWithMessage:@"Deleted"];
			[self.tableView reloadData];
		}
	}];
}

@end
