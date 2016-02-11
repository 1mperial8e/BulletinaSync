//
//  MainPageController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "MainPageController.h"
#import "SelectNewAdCategoryTableViewController.h"

@interface MainPageController () <UISearchBarDelegate>

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation MainPageController

- (void)viewDidLoad
{
	[self loadCategories];
    [super viewDidLoad];	
	[self tableViewSetup];
	[self setupNavigationBar];
	[self addSearchBar];
}

//#pragma mark - Table view data source
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 3;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	return [self defaultCellForIndexPath:indexPath];
//}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIImage *testImage;
	if (((ItemModel *)self.itemsList[indexPath.item]).imagesUrl.length) {
		testImage = self.itemImage;
	} else {
		testImage = nil;
	}
	return [self itemCellHeightForText:((ItemModel *)self.itemsList[indexPath.item]).text andImage:testImage];
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
	
	UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"Nearby",@"Favorites"]];
	segment.selectedSegmentIndex = 0;
	[segment addTarget:self action:@selector(segmentedControlSwitch:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = segment;
}

- (void)addSearchBar
{
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchBar.delegate = self;
	self.searchController.searchBar.barTintColor =  [UIColor mainPageBGColor];
	self.searchController.searchBar.tintColor =  [UIColor appOrangeColor];
	
	CALayer *bottomBorder = [CALayer layer];
	bottomBorder.backgroundColor = [[UIColor lightGrayColor] CGColor];
	bottomBorder.frame = CGRectMake(0, CGRectGetHeight(self.searchController.searchBar.frame), CGRectGetWidth(self.searchController.searchBar.frame), 1.0f);
	[self.searchController.searchBar.layer addSublayer:bottomBorder];
	
	UITextField *searchField;
	NSUInteger numViews = [self.searchController.searchBar.subviews count];
	for (int i = 0; i < numViews; i++) {
		NSUInteger numSubViews = [[self.searchController.searchBar.subviews objectAtIndex:i].subviews count];
		for (int j = 0; j < numSubViews; j++) {
			if ([[[self.searchController.searchBar.subviews objectAtIndex:i].subviews objectAtIndex:j] isKindOfClass:[UITextField class]]) {
				searchField = [[self.searchController.searchBar.subviews objectAtIndex:i].subviews objectAtIndex:j];
			}
		}
	}
	if (searchField) {
		[searchField setBackgroundColor:[UIColor colorWithRed:221 / 255.0f green:221 / 255.0f blue:219 / 255.0f alpha:1.0]];
		[searchField setBorderStyle:UITextBorderStyleNone];
		[searchField.layer setCornerRadius:5];
	}
	[self.searchController.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
	self.tableView.tableHeaderView = self.searchController.searchBar;
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
 //switch
}

#pragma mark - Utils

- (void)refreshTable:(id)sender
{	
	[self fetchItemListWithLoader:NO];
	[(UIRefreshControl *)sender endRefreshing];
}

- (void)loadCategories
{
	[[APIClient sharedInstance] categoriesListWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (!error) {
			NSParameterAssert([response isKindOfClass:[NSArray class]]);
			[Utils storeValue:response forKey:CategoriesListKey];
		}
	}];
}

@end
