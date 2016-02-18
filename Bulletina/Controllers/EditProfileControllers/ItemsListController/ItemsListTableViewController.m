//
//  ItemsListTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ItemsListTableViewController.h"
#import "MyItemsTableViewController.h"

@interface ItemsListTableViewController ()

@end

@implementation ItemsListTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.loader = [[BulletinaLoaderView alloc] initWithView:self.navigationController.view andText:nil];
	[self performSelector:@selector(fetchItemListWithLoader:) withObject:nil afterDelay:[APIClient sharedInstance].requestStartDelay];	
}
	
#pragma mark - API

- (void)fetchItemListWithLoader:(BOOL)needLoader
{
	if (needLoader) {
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
	
	UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemImageTap:)];
	[cell.itemImageView addGestureRecognizer:imageTapGesture];
	
	UITapGestureRecognizer *userTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTap:)];
	[cell.infoView addGestureRecognizer:userTapGesture];
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

- (void)userTap:(UITapGestureRecognizer *)sender
{
	__weak typeof(self) weakSelf = self;
	[[APIClient sharedInstance] showUserWithUserId:sender.view.tag withCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (!error) {
			NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
			UserModel *user = [UserModel modelWithDictionary:response];			
//			weakSelf.user = user;
//			[Utils storeValue:response forKey:CurrentUserKey];
//			[[APIClient sharedInstance] updateCurrentUser:user];
//			[[APIClient sharedInstance] updatePasstokenWithDictionary:response];
			dispatch_async(dispatch_get_main_queue(), ^{
				MyItemsTableViewController *itemsTableViewController = [MyItemsTableViewController new];
				itemsTableViewController.user = user;
				[weakSelf.navigationController pushViewController:itemsTableViewController animated:YES];
			});
		}
	}];
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

@end
