//
//  MainPageController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "MainPageController.h"
#import "ItemTableViewCell.h"

static CGFloat const ItemTableViewCellHeigth = 510.0f;

@interface MainPageController () <UISearchBarDelegate>

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation MainPageController

- (void)viewDidLoad
{
    [super viewDidLoad];	
	[self tableViewSetup];
	[self setupNavigationBar];
	[self addSearchBar];
	
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
	[self.tableView addSubview:refreshControl];
	[refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ItemTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return ItemTableViewCellHeigth;
}

#pragma mark - Setup

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	[self.tableView registerNib:ItemTableViewCell.nib forCellReuseIdentifier:ItemTableViewCell.ID];
	self.tableView.backgroundColor = [UIColor colorWithRed:248 / 255.0f green:247 / 255.0f blue:241 / 255.0f alpha:1.0];
}


- (UIStatusBarStyle) preferredStatusBarStyle
{
	return UIStatusBarStyleDefault;
}

- (void)setupNavigationBar
{	
	[self setNeedsStatusBarAppearanceUpdate];
	
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:245 / 255.0f green:168 / 255.0f blue:67 / 255.0f alpha:1.0f]];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AddNew_navbarIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewButtonAction:)];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Profile_navbarIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(profileButtonAction:)];
	
	UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"Nearby",@"Favorites"]];
	segment.selectedSegmentIndex = 0;
	self.navigationItem.titleView = segment;
}

-(void)addSearchBar
{
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchBar.delegate = self;
	self.searchController.searchBar.barTintColor =  [UIColor colorWithRed:248 / 255.0f green:247 / 255.0f blue:241 / 255.0f alpha:1.0];
	self.tableView.tableHeaderView = self.searchController.searchBar;
}

#pragma mark - Actions

- (void)addNewButtonAction:(id)sender
{
	
}

- (void)profileButtonAction:(id)sender
{
	
}

#pragma mark - Utils

- (void)refreshTable:(id)sender
{
	NSLog(@"Refreshing");
	[(UIRefreshControl *)sender endRefreshing];
}

@end
