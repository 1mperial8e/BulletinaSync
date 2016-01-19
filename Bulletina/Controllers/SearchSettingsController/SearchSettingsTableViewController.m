//
//  SearchSettingsTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Controllers
#import "SearchSettingsTableViewController.h"
#import "APIClient.h"

//Views
#import "CategoryHeaderView.h"
#import "DefaultSettingsTableViewCell.h"
#import "SearchAreaTableViewCell.h"

static NSInteger const SectionsCount = 3;
static NSInteger const UserTypesCount = 2;

static NSInteger const SearchAreaSectionsIndex = 0;
static NSInteger const CategoryFilterSectionsIndex = 1;
static NSInteger const UserTypeSectionsIndex = 2;

@interface SearchSettingsTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *categoriesArray;

@end

@implementation SearchSettingsTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self tableViewSetup];
	self.categoriesArray = [APIClient tempCategoriesList];
	
	self.title = @"Search filter";
	self.navigationController.navigationBar.topItem.title = @"Back";
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == SearchAreaSectionsIndex) {
		return 1;
	} else if (section == CategoryFilterSectionsIndex) {
		return self.categoriesArray.count;
	} else if (section == UserTypeSectionsIndex) {
		return UserTypesCount;
	} else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == SearchAreaSectionsIndex) {
		return [self searchAreaCellForIndexPath:indexPath];
	} else if (indexPath.section == CategoryFilterSectionsIndex) {
		return [self categoryFilterCellForIndexPath:indexPath];
	} else if (indexPath.section == UserTypeSectionsIndex) {
		return [self userTypeCellForIndexPath:indexPath];
	}
    return nil;
}

#pragma mark - Cells

- (UITableViewCell *)searchAreaCellForIndexPath:(NSIndexPath *)indexPath
{
	SearchAreaTableViewCell *searchAreaCell = [self.tableView dequeueReusableCellWithIdentifier:SearchAreaTableViewCell.ID forIndexPath:indexPath];
	[searchAreaCell.areaSlider setMinimumTrackTintColor:[UIColor appOrangeColor]];
	[searchAreaCell.areaSlider setMaximumTrackTintColor:[UIColor mainPageBGColor]];
	searchAreaCell.areaSlider.thumbTintColor = [UIColor colorWithWhite:1 alpha:0];
	return searchAreaCell;
}

- (UITableViewCell *)categoryFilterCellForIndexPath:(NSIndexPath *)indexPath
{
	DefaultSettingsTableViewCell *settingCell = [self.tableView dequeueReusableCellWithIdentifier:DefaultSettingsTableViewCell.ID forIndexPath:indexPath];
	settingCell.settingTitleLabel.text = self.categoriesArray[indexPath.row];
	return settingCell;
}

- (UITableViewCell *)userTypeCellForIndexPath:(NSIndexPath *)indexPath
{
	DefaultSettingsTableViewCell *settingCell = [self.tableView dequeueReusableCellWithIdentifier:DefaultSettingsTableViewCell.ID forIndexPath:indexPath];
	if (indexPath.item == 0) {
		settingCell.settingTitleLabel.text = @"Company Ads";
	} else {
		settingCell.settingTitleLabel.text = @"Individual Ads";
	}
	return settingCell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	CategoryHeaderView *headerView = [[CategoryHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 39)];
	if (section == SearchAreaSectionsIndex) {
		headerView.sectionTitleLabel.text = @"SEARCH AREA";
	} else if (section == CategoryFilterSectionsIndex) {
		headerView.sectionTitleLabel.text = @"CATEGORY FILTER";
	} else if (section == UserTypeSectionsIndex) {
		headerView.sectionTitleLabel.text = @"USER TYPE";
	}
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat heigth = 44;
	if (indexPath.section == SearchAreaSectionsIndex) {
		heigth = 51;
	}
	return heigth;
}

#pragma mark - Setup

- (void)tableViewSetup
{
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 5, 0)];
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	[self.tableView registerNib:DefaultSettingsTableViewCell.nib forCellReuseIdentifier:DefaultSettingsTableViewCell.ID];
	[self.tableView registerNib:SearchAreaTableViewCell.nib forCellReuseIdentifier:SearchAreaTableViewCell.ID];
}

@end
