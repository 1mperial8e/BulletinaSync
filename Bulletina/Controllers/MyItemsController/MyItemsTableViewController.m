//
//  MyItemsTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

// Controllers
#import "MyItemsTableViewController.h"

// Cells
#import "IndividualProfileLogoTableViewCell.h"
#import "BusinessProfileLogoTableViewCell.h"

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	LogoCellIndex	
};

@interface MyItemsTableViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) UIImageView *topBackgroundImageView;
@property (weak, nonatomic) NSLayoutConstraint *backgroundTopConstraint;
@property (weak, nonatomic) NSLayoutConstraint *backgroundHeightConstraint;

@end

@implementation MyItemsTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self reloadUser];
	[self tableViewSetup];
	[self setupNavigationBar];
    if ([APIClient sharedInstance].currentUser.userId == self.user.userId) {
        self.navigationItem.title = @"My Bulletina";
    } else {
        self.navigationItem.title = self.user.title;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

#pragma mark - API

- (void)fetchItemListWithSearchString:(NSString *)searchString
{
	__weak typeof(self) weakSelf = self;
//		[[APIClient sharedInstance] fetchItemsWithOffset:@10 limit:@85 withCompletion:
//	[[APIClient sharedInstance] fetchItemsForSearchSettingsAndPage:0 withCompletion:
	[[APIClient sharedInstance]fetchItemsForUserId:self.user.userId withCompletion:
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
	 }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [super tableView:tableView numberOfRowsInSection:section] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item == LogoCellIndex) {
		return [self logoCellForIndexPath:indexPath];
	}	
	return [super defaultCellForIndexPath:indexPath forMyItems:YES];
}

#pragma mark - Cells

- (UITableViewCell *)logoCellForIndexPath:(NSIndexPath *)indexPath
{
	self.backgroundHeightConstraint.constant = [self heightForTopCell];
	if (self.user.customerTypeId == BusinessAccount) {
		return [self businessLogoCellForIndexPath:indexPath];
	} else {
		return [self individualLogoCellForIndexPath:indexPath];
	}
}

- (BusinessProfileLogoTableViewCell *)businessLogoCellForIndexPath:(NSIndexPath *)indexPath
{
	BusinessProfileLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BusinessProfileLogoTableViewCell.ID forIndexPath:indexPath];
    cell.user = self.user;
	return cell;
}

- (IndividualProfileLogoTableViewCell *)individualLogoCellForIndexPath:(NSIndexPath *)indexPath
{
	IndividualProfileLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:IndividualProfileLogoTableViewCell.ID forIndexPath:indexPath];
	cell.user = self.user;
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == LogoCellIndex) {
		return [self heightForTopCell];
	}
	return [ItemTableViewCell itemCellHeightForItemModel:self.itemsList[indexPath.item - 1]];
}

#pragma mark - Actions

- (void)doneButtonTap:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)showUserForItem:(ItemModel *)item
{
	//Do nothing
}

#pragma mark - Utils

- (void)reloadUser
{
	if (self.user.userId) {
		__weak typeof(self) weakSelf = self;
		[[APIClient sharedInstance] showUserWithUserId:self.user.userId withCompletion:^(id response, NSError *error, NSInteger statusCode) {
			if (!error) {
				NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
				UserModel *user = [UserModel modelWithDictionary:response];
				weakSelf.user = user;
				
				dispatch_async(dispatch_get_main_queue(), ^{
					[weakSelf.tableView reloadData];
				});
			}
		}];
	}
}

- (CGFloat)heightForTopCell
{
	if (self.user.customerTypeId == BusinessAccount) {
		return [BusinessProfileLogoTableViewCell heightForBusinessLogoCellWithUser:self.user];
	}
	return [IndividualProfileLogoTableViewCell heightForIndividualAvatarCellWithUser:self.user];
}

#pragma mark - Setup

- (void)setupNavigationBar
{
	[super setupNavigationBar];
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)tableViewSetup
{
	[super tableViewSetup];
	
	[self.tableView registerNib:IndividualProfileLogoTableViewCell.nib forCellReuseIdentifier:IndividualProfileLogoTableViewCell.ID];
	[self.tableView registerNib:BusinessProfileLogoTableViewCell.nib forCellReuseIdentifier:BusinessProfileLogoTableViewCell.ID];
	[self addBackgroundView];
}

- (void)addBackgroundView
{
	self.tableView.backgroundView = nil;
	UIView *backgroundView = [[UIView alloc] init];
	UIImageView *backgroundImageView = [[UIImageView alloc] init];
	[backgroundView addSubview:backgroundImageView];
	backgroundView.backgroundColor = [UIColor mainPageBGColor];
	backgroundImageView.image = [UIImage imageNamed:@"TopBackground"];
	backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.backgroundTopConstraint = [NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeTop multiplier:1.0f constant:64];
	[backgroundView addConstraint:self.backgroundTopConstraint];
	self.backgroundHeightConstraint = [NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:[self heightForTopCell]];
	[backgroundImageView addConstraint: self.backgroundHeightConstraint];
	
	[backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
	[backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	self.topBackgroundImageView = backgroundImageView;
	self.tableView.backgroundView = backgroundView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat scaleCoef = 1.12 + (scrollView.contentOffset.y < -64 ? (fabs(scrollView.contentOffset.y + 64.0) / 120) : 0);
	self.topBackgroundImageView.transform = CGAffineTransformMakeScale(scaleCoef, scaleCoef);
	self.backgroundTopConstraint.constant = scrollView.contentOffset.y < 0 ? fabs(scrollView.contentOffset.y) : -scrollView.contentOffset.y;
}

@end
