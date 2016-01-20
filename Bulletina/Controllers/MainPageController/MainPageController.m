//
//  MainPageController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "MainPageController.h"
#import "ItemTableViewCell.h"
#import "CustomRefreshControlView.h"
#import "ProfileTableViewController.h"
#import "SelectNewAdCategoryTableViewController.h"
#import "FullScreenImageViewController.h"

static CGFloat const ItemTableViewCellHeigth = 140.0f;

@interface MainPageController () <UISearchBarDelegate>

@property (strong, nonatomic) UISearchController *searchController;

@property (assign, nonatomic) ProfileType profileType;

//Temp
@property (strong, nonatomic) NSString *itemText;
@property (strong, nonatomic) UIImage *itemImage;

@end

@implementation MainPageController

- (void)viewDidLoad
{
    [super viewDidLoad];	
	[self tableViewSetup];
	[self setupNavigationBar];
	[self addSearchBar];
	
	//Temp
	self.itemText = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor.	ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor. sed do eiusmod tempor.";
	
	self.itemImage = [UIImage imageNamed:@"ItemExample"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ItemTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	cell.itemImageView.image = self.itemImage;
	cell.itemViewHeightConstraint.constant = [self heighForImageView];
	[self.view layoutIfNeeded];
	if (indexPath.item % 2) {
        [cell.itemStateButton setTitle:@"NEW" forState:UIControlStateNormal];
        cell.itemStateButton.backgroundColor = [UIColor mainPageGreenColor];
        cell.itemStateButton.hidden = NO;
	}
	[cell.itemTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	cell.itemTextView.text = self.itemText;
	UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemImageTap:)];
	[cell.itemImageView addGestureRecognizer:imageTapGesture];
	
	cell.itemStateButton.layer.cornerRadius = 7;
	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self itemCellHeightForIndexPath:indexPath];
}

- (CGFloat)itemCellHeightForIndexPath:(NSIndexPath *)indexPath
{
	CGFloat textViewHeigth = 0;
	ItemTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:ItemTableViewCell.ID owner:nil options:nil].firstObject;
	cell.itemTextView.text = self.itemText;
	[cell.itemTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	textViewHeigth = ceil([cell.itemTextView sizeThatFits:CGSizeMake(ScreenWidth - 32, MAXFLOAT)].height);
	return ItemTableViewCellHeigth + [self heighForImageView] + textViewHeigth;
}

- (CGFloat)heighForImageView
{
	CGFloat imageViewHeigth = 0;
	if (self.itemImage) {
		CGFloat ratio = self.itemImage.size.height / self.itemImage.size.width;
		imageViewHeigth = (ScreenWidth - 32) * ratio;
	}
	return imageViewHeigth;
}

#pragma mark - Setup

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	[self.tableView registerNib:ItemTableViewCell.nib forCellReuseIdentifier:ItemTableViewCell.ID];
	self.tableView.backgroundColor = [UIColor mainPageBGColor];
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
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

- (UIStatusBarStyle) preferredStatusBarStyle
{
	return UIStatusBarStyleDefault;
}

- (void)setupNavigationBar
{	
	[self setNeedsStatusBarAppearanceUpdate];
	
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	[self.navigationController.navigationBar
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appOrangeColor]}];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AddNew_navbarIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewButtonAction:)];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Profile_navbarIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(profileButtonAction:)];
	
	UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"Nearby",@"Favorites"]];
	segment.selectedSegmentIndex = 0;
	[segment addTarget:self action:@selector(segmentedControlSwitch:) forControlEvents:UIControlEventValueChanged];
	self.profileType = IndividualProfile;
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
	SelectNewAdCategoryTableViewController *selectCategoryTableViewController = [SelectNewAdCategoryTableViewController new];
	UINavigationController *selectCategoryNavigationController = [[UINavigationController alloc] initWithRootViewController:selectCategoryTableViewController];
	[self.navigationController presentViewController:selectCategoryNavigationController animated:YES completion:nil];
}

- (void)profileButtonAction:(id)sender
{
	ProfileTableViewController *profileTableViewController = [ProfileTableViewController new];
	profileTableViewController.profileType = self.profileType;
	UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController:profileTableViewController];
	[self.navigationController presentViewController:profileNavigationController animated:YES completion:nil];
}

- (void)segmentedControlSwitch:(UISegmentedControl *)sender
{
	if (sender.selectedSegmentIndex == 0) {
		self.profileType = IndividualProfile;
	} else {
		self.profileType = BusinessProfile;
	}
}

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

#pragma mark - Utils

- (void)refreshTable:(id)sender
{	
	[(UIRefreshControl *)sender endRefreshing];
}

@end
