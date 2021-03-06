//
//  ItemsListTableViewController.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

// Controllers
#import "ProfileTableViewController.h"
#import "SelectNewAdCategoryTableViewController.h"
#import "FullScreenImageViewController.h"
#import "ReasonSelectTableViewController.h"
#import "MessageTableViewController.h"
#import "ConversationsListTableViewController.h"

// Views
#import "ItemTableViewCell.h"

// Models
#import "APIClient+Item.h"
#import "APIClient+User.h"
#import "APIClient+Message.h"

@interface ItemsListTableViewController : UITableViewController <ItemCellDelegate>

@property (strong, nonatomic) UIRefreshControl *refresh;

@property (strong, nonatomic) NSMutableArray *itemsList;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) BOOL hasMore;

@property (copy, nonatomic) NSString *searchString;

- (ItemTableViewCell *)defaultCellForIndexPath:(NSIndexPath *)indexPath forMyItems:(BOOL)myItems;
#pragma mark - Setup
- (void)tableViewSetup;
- (void)setupNavigationBar;

#pragma mark - Data
@property (weak, nonatomic) NSURLSessionTask *downloadTask;

- (void)downloadedItems:(NSArray *)items afterReload:(BOOL)afterReload;
- (void)failedToDownloadItemsWithError:(NSError *)error;

- (void)loadData:(BOOL)reloadAll;

@end
