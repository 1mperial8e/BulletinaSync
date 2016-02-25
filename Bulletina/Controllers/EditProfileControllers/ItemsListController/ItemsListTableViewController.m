//
//  ItemsListTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

// Controllers
#import "ItemsListTableViewController.h"
#import "MyItemsTableViewController.h"
#import "AddNewItemTableViewController.h"
#import "MainPageController.h"

// Cells
#import "LoadingTableViewCell.h"

@implementation ItemsListTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self tableViewSetup];
    [self setupNavigationBar];
    [self registerObservers];
    
    self.hasMore = YES;
    self.currentPage = 0;
    self.itemsList = [NSMutableArray array];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Data

- (void)downloadedItems:(NSArray *)items afterReload:(BOOL)afterReload
{
    self.hasMore = !(items.count % ItemsPerPage);
    
    NSMutableArray *idPaths = [NSMutableArray array];
    NSInteger nextIndex = 0;
    
    // Remove cells if data was reloaded
    if ([self isKindOfClass:[MyItemsTableViewController class]]) {
        nextIndex++; // First cell is profile cell
    }
    
    if (afterReload) {
        for (int i = 0; i < self.itemsList.count; i++) {
            [idPaths addObject:[NSIndexPath indexPathForItem:nextIndex inSection:0]];
            nextIndex++;
        }
        [self.tableView beginUpdates];
        [self.itemsList removeAllObjects];
        [self.tableView deleteRowsAtIndexPaths:idPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
    }
    
    if ((items.count && !afterReload) || [self isKindOfClass:[MyItemsTableViewController class]]) {
        // Insert new items
        nextIndex = self.itemsList.count;
        if ([self isKindOfClass:[MyItemsTableViewController class]]) {
            nextIndex++; // First cell is profile cell
        }
        for (int i = 0; i < items.count; i++) {
            [idPaths addObject:[NSIndexPath indexPathForItem:nextIndex inSection:0]];
            nextIndex++;
        }
        [self.tableView beginUpdates];
        [self.itemsList addObjectsFromArray:items];
        [self.tableView insertRowsAtIndexPaths:idPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } else {
        [self.itemsList addObjectsFromArray:items];
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

- (void)failedToDownloadItemsWithError:(NSError *)error
{
    self.hasMore = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    if (!self.itemsList.count) {
        // show error message
    }
}

- (void)loadData:(BOOL)reloadAll
{
    assert(@"Implement in subclass");
    // Dumny
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        return 1;
    }
	return self.itemsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        LoadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LoadingTableViewCell ID] forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor mainPageBGColor];
        return cell;
    }
	return [self defaultCellForIndexPath:indexPath forMyItems:NO];
}

#pragma mark - Cells

- (ItemTableViewCell *)defaultCellForIndexPath:(NSIndexPath *)indexPath forMyItems:(BOOL)myItems
{
	ItemTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemTableViewCell.ID forIndexPath:indexPath];
	NSInteger dataIndex = myItems ? indexPath.item - 1 : indexPath.item;
	cell.cellItem = self.itemsList[dataIndex];	
	cell.delegate = self;
	UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemImageTap:)];
	[cell.itemImageView addGestureRecognizer:imageTapGesture];
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        LoadingTableViewCell *loadingCell = (LoadingTableViewCell *)cell;
        cell.clipsToBounds = YES;
        loadingCell.separatorInset = UIEdgeInsetsMake(0, ScreenHeight, 0, 0);
        [loadingCell.loadingIndicator startAnimating];
        if (self.hasMore && !self.downloadTask) {
            [self loadData:NO];
        }
    }
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

#pragma mark - Setup

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	[self.tableView registerNib:ItemTableViewCell.nib forCellReuseIdentifier:ItemTableViewCell.ID];
    [self.tableView registerNib:LoadingTableViewCell.nib forCellReuseIdentifier:LoadingTableViewCell.ID];
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupNavigationBar
{
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appOrangeColor]}];
}

- (void)registerObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletedItemNotification:) name:DeletedItemNotificaionName object:nil];
    if ([self isKindOfClass:[MainPageController class]]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChangedNotification:) name:SettingsChangedNotificaionName object:nil];
    }
}

#pragma mark - ItemCellDelegate

- (void)showUserForItem:(ItemModel *)item
{
	MyItemsTableViewController *itemsTableViewController = [MyItemsTableViewController new];
	itemsTableViewController.user = [[UserModel alloc] initWithItem:item];
	[self.navigationController pushViewController:itemsTableViewController animated:YES];
}

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
            ReportTableViewController *reportTableViewController = [[ReportTableViewController alloc] initWithItemId:item.itemId andUserId:[APIClient sharedInstance].currentUser.userId];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:reportTableViewController];
            [weakSelf.navigationController presentViewController:navigationController animated:YES completion:nil];
        }]];
    }
    
	[self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - API

- (void)deleteItemWithId:(NSInteger)itemId
{
	[[APIClient sharedInstance] deleteItemWithId:itemId withCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (error) {
			if (response[@"error_message"]) {
				[Utils showErrorWithMessage:response[@"error_message"]];
            } else {
				[Utils showErrorForStatusCode:statusCode];
			}
		} else {
            [[NSNotificationCenter defaultCenter] postNotificationName:DeletedItemNotificaionName object:nil userInfo:@{ItemIDNotificaionKey : @(itemId)}];
		}
	}];
}

#pragma mark - Notifications

- (void)deletedItemNotification:(NSNotification *)notification
{
    NSInteger itemId = [notification.userInfo[ItemIDNotificaionKey] integerValue];
    NSParameterAssert(itemId);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemId == %li", itemId];
    NSArray *filteredArray = [self.itemsList filteredArrayUsingPredicate:predicate];
    if (filteredArray.count) {
        NSUInteger itemIndex = [self.itemsList indexOfObject:filteredArray.firstObject];
        if ([self isKindOfClass:[MyItemsTableViewController class]]) {
            itemIndex++; // first cell is profile cell
        }
        [self.tableView beginUpdates];
        [self.itemsList removeObject:filteredArray.firstObject];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:itemIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

- (void)settingsChangedNotification:(NSNotification *)notification
{
    DLog(@"Reload data after changed settings");
    [self loadData:YES];
}

@end
