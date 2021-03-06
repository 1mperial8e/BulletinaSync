//
//  MainPageController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "MainPageController.h"
#import "SelectNewAdCategoryTableViewController.h"

typedef NS_ENUM(NSUInteger, SegmentIndexes) {
	NearbyIndex,
	FavoritesIndex
};

@interface MainPageController () <UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation MainPageController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self addSearchBar];
	[self performSelector:@selector(loadCategories) withObject:nil afterDelay:[APIClient sharedInstance].requestStartDelay];
	[self performSelector:@selector(loadReportReasons) withObject:nil afterDelay:[APIClient sharedInstance].requestStartDelay];
	[self performSelector:@selector(checkMessages) withObject:nil afterDelay:[APIClient sharedInstance].requestStartDelay];
	
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([APIClient sharedInstance].requestStartDelay + 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!weakSelf.downloadTask) {
            [weakSelf loadData:YES];
        }
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        return self.hasMore ? 44.f : 0;
    }
	return [ItemTableViewCell itemCellHeightForItemModel:self.itemsList[indexPath.item]];
}

#pragma mark - Setup

- (void)tableViewSetup
{
	[super tableViewSetup];

	UIView *backView = [UIView new];
	backView.backgroundColor = [UIColor mainPageBGColor];
	self.tableView.backgroundView = backView;
	
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor appOrangeColor];
	[self.tableView insertSubview:refreshControl atIndex:0];
	[refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    self.refresh = refreshControl;
    
	UIView *adsPlaceholder = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50)];
	UILabel *adsPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 -60, 15, 200, 21)];
	adsPlaceholderLabel.text = @"Ads placeholder";
	[adsPlaceholder addSubview:adsPlaceholderLabel];
	adsPlaceholder.backgroundColor = [UIColor appOrangeColor];

	[self.navigationController.view addSubview:adsPlaceholder];	
}

- (void)setupNavigationBar
{
	[super setupNavigationBar];
	[Application setStatusBarStyle:UIStatusBarStyleDefault];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AddNew_navbarIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewButtonAction:)];

	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Profile_navbarIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(profileButtonAction:)];
	
	UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"Nearby", @"Favorites"]];
	segment.selectedSegmentIndex = 0;
	[segment addTarget:self action:@selector(segmentedControlSwitch:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = segment;
}

- (void)addSearchBar
{
	self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
	self.searchBar.delegate = self;
	self.searchBar.barTintColor = [UIColor mainPageBGColor];
	self.searchBar.tintColor = [UIColor appOrangeColor];
    self.searchBar.backgroundColor = [UIColor mainPageBGColor];
    
	CALayer *bottomBorder = [CALayer layer];
	bottomBorder.backgroundColor = [[UIColor lightGrayColor] CGColor];
	bottomBorder.frame = CGRectMake(0, CGRectGetHeight(self.searchBar.frame), CGRectGetWidth(self.searchBar.frame), 1.0f);
	[self.searchBar.layer addSublayer:bottomBorder];

	UITextField *searchField;
	NSUInteger numViews = [self.searchBar.subviews count];
	for (int i = 0; i < numViews; i++) {
		NSUInteger numSubViews = [[self.searchBar.subviews objectAtIndex:i].subviews count];
		for (int j = 0; j < numSubViews; j++) {
			if ([[[self.searchBar.subviews objectAtIndex:i].subviews objectAtIndex:j] isKindOfClass:[UITextField class]]) {
				searchField = [[self.searchBar.subviews objectAtIndex:i].subviews objectAtIndex:j];
			}
		}
	}
	if (searchField) {
		[searchField setBackgroundColor:[UIColor colorWithRed:221 / 255.0f green:221 / 255.0f blue:219 / 255.0f alpha:1.0]];
		[searchField setBorderStyle:UITextBorderStyleNone];
		[searchField.layer setCornerRadius:5];
	}
	[self.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
	
	self.tableView.tableHeaderView = self.searchBar;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:YES];
	searchBar.text = @"";
    self.searchString = @"";
    [self loadData:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchString = searchText;
	[self loadData:YES];
}

#pragma mark - Actions

- (void)addNewButtonAction:(id)sender
{
    if ([APIClient sharedInstance].currentUser.customerTypeId == AnonymousAccount) {
        [Utils showWarningWithMessage:@"Only registered users can post new items. Please update your account."];
    } else {
        SelectNewAdCategoryTableViewController *selectCategoryTableViewController = [SelectNewAdCategoryTableViewController new];
        UINavigationController *selectCategoryNavigationController = [[UINavigationController alloc] initWithRootViewController:selectCategoryTableViewController];
        [self.navigationController presentViewController:selectCategoryNavigationController animated:YES completion:nil];
    }
}

- (void)profileButtonAction:(id)sender
{
	ProfileTableViewController *profileTableViewController = [ProfileTableViewController new];
	UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController:profileTableViewController];
	[self.navigationController presentViewController:profileNavigationController animated:YES completion:nil];
}

- (void)segmentedControlSwitch:(UISegmentedControl *)sender
{
	__weak typeof(self) weakSelf = self;
	if (sender.selectedSegmentIndex == FavoritesIndex) {
		[UIView animateWithDuration:.3f animations:^{
			[weakSelf.tableView setContentOffset:CGPointMake(0, -(weakSelf.topOffset - CGRectGetHeight(weakSelf.searchBar.frame)))];
		} completion:^(BOOL finished) {
			weakSelf.tableView.tableHeaderView = nil;
			[weakSelf.tableView setContentOffset:CGPointMake(0, -weakSelf.topOffset)];
			[weakSelf loadData:YES];
            [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
		}];
	} else {
		[self.tableView setContentOffset:CGPointMake(0, -(self.topOffset - CGRectGetHeight(self.searchBar.frame)))];
		self.tableView.tableHeaderView = self.searchBar;
		[UIView animateWithDuration:.3f animations:^{
			[weakSelf.tableView setContentOffset:CGPointMake(0, -weakSelf.topOffset)];
		}completion:^(BOOL finished) {
			[weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
			[weakSelf loadData:YES];
		}];
	}
}

#pragma mark - Data

- (void)loadData:(BOOL)reloadAll
{
    [self.downloadTask cancel];
    if (reloadAll) {
        self.hasMore = YES;
        self.currentPage = 0;
    } else {
        self.currentPage++;
    }
    __weak typeof(self) weakSelf = self;
	
	if (((UISegmentedControl *)self.navigationItem.titleView).selectedSegmentIndex == NearbyIndex) {
		self.downloadTask = [[APIClient sharedInstance] fetchItemsWithSearchText:self.searchString page:self.currentPage withCompletion:^(id response, NSError *error, NSInteger statusCode) {
			if ([weakSelf.refresh isRefreshing]) {
				[weakSelf.refresh endRefreshing];
			}
			if (error) {
				[super failedToDownloadItemsWithError:error];
			} else {
				NSAssert([response isKindOfClass:[NSArray class]], @"Unknown response from server");
				NSArray *items = [ItemModel arrayWithDictionariesArray:response];
				[super downloadedItems:items afterReload:reloadAll];
			}
		}];
	} else {
		self.downloadTask = [[APIClient sharedInstance] loadMyFavoriteItemsForPage:self.currentPage withCompletion:^(id response, NSError *error, NSInteger statusCode) {
			if ([weakSelf.refresh isRefreshing]) {
				[weakSelf.refresh endRefreshing];
			}
			if (error) {
				[super failedToDownloadItemsWithError:error];
			} else {
				NSAssert([response isKindOfClass:[NSArray class]], @"Unknown response from server");
				NSArray *items = [ItemModel arrayWithDictionariesArray:response];
				[super downloadedItems:items afterReload:reloadAll];
			}
		}];
	}	
}

#pragma mark - Private

- (void)refreshTable:(UIRefreshControl *)sender
{
	[self.searchBar resignFirstResponder];
	[self.searchBar setShowsCancelButton:NO animated:YES];
    [self loadData:YES];
}

- (void)loadCategories
{
	[[APIClient sharedInstance] categoriesListWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (!error) {
			NSParameterAssert([response isKindOfClass:[NSArray class]]);
			[Utils storeValue:response forKey:CategoriesListKey];
			
			if (![Defaults objectForKey:CategoriesSettingsKey] && ![Defaults objectForKey:CategoriesListKey]) {
				NSMutableDictionary *categoriesSettings = [NSMutableDictionary new];
				
				for (NSInteger i = 0; i < ((NSArray *)response).count; i++){
					CategoryModel *currentCategory = [[CategoryModel alloc] initWithDictionary:response[i]];
					[categoriesSettings setValue:@YES forKey:@(currentCategory.categoryId).stringValue];
				}
				[Utils storeValue:categoriesSettings forKey:CategoriesSettingsKey];
			}
		}
	}];
}

- (void)loadReportReasons
{
	[[APIClient sharedInstance] reportReasonsListWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (!error) {
			NSParameterAssert([response isKindOfClass:[NSArray class]]);
			[Utils storeValue:response forKey:ReportReasonsListKey];
		}
	}];
}

- (CGFloat)topOffset
{
	return Application.statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
}

- (void)checkMessages
{
	[[APIClient sharedInstance] fetchMyUnreadMessagesCountWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (error) {
			[Utils showErrorForStatusCode:statusCode];
		} else {
			NSParameterAssert([response isKindOfClass:[NSDictionary class]]);
			[self addBadgeWithNumber:[response[@"count"] integerValue]];
		}
	}];
}

- (void)addBadgeWithNumber:(NSInteger)number
{
	UILabel *numberBadge = [[UILabel alloc] initWithFrame:CGRectMake(15, -5, 18, 18)];
	numberBadge.backgroundColor =[UIColor redColor];
	numberBadge.clipsToBounds = YES;
	numberBadge.layer.cornerRadius = CGRectGetHeight(numberBadge.frame) / 2;
	numberBadge.text =[NSString stringWithFormat:@"%li",number];
	numberBadge.textColor = [UIColor whiteColor];
	numberBadge.font = [UIFont systemFontOfSize:13];
	numberBadge.textAlignment = NSTextAlignmentCenter;
	
	UIButton *profileButton = [UIButton  buttonWithType:UIButtonTypeSystem];
	profileButton.frame = CGRectMake(0, 0, 22, 22);
	profileButton.layer.cornerRadius = 8;
	[profileButton setImage:[UIImage imageNamed:@"Profile_navbarIcon"]  forState:UIControlStateNormal];
	[profileButton addTarget:self action:@selector(profileButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[profileButton addSubview:numberBadge];
	
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:profileButton];
	self.navigationItem.leftBarButtonItem = barButton;
}

@end
