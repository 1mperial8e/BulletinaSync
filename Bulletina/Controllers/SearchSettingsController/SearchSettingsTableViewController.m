//
//  SearchSettingsTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

// Controllers
#import "SearchSettingsTableViewController.h"
#import "APIClient.h"

// Views
#import "CategoryHeaderView.h"
#import "DefaultSettingsTableViewCell.h"
#import "SearchAreaTableViewCell.h"

// Models
#import "APIClient+Item.h"
#import "CategoryModel.h"

static NSInteger const SectionsCount = 3;
static NSInteger const UserTypesCount = 2;

static NSInteger const SearchAreaSectionsIndex = 0;
static NSInteger const CategoryFilterSectionsIndex = 1;
static NSInteger const UserTypeSectionsIndex = 2;

@interface SearchSettingsTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *categoriesArray;
@property (weak, nonatomic) UIProgressView *areaProgressView;
@property (weak, nonatomic) UISwitch *showPersonalAdsSwitch;
@property (weak, nonatomic) UISwitch *showBusinessAdsSwitch;

@property (assign, nonatomic) BOOL showBusinessAds;
@property (assign, nonatomic) BOOL showPersonalAds;
@property (assign, nonatomic) CGFloat searchArea;

@property (strong, nonatomic) NSMutableDictionary *categoriesSettings;

@end

@implementation SearchSettingsTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.categoriesArray = [CategoryModel arrayWithDictionariesArray:[Defaults objectForKey:CategoriesListKey]];
    self.navigationItem.title = @"Search filter";

    [self loadCategories];
	[self tableViewSetup];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:ShowBusinessAdsKey]) {
		self.showBusinessAds = [defaults boolForKey:ShowBusinessAdsKey];
	}
	if ([defaults objectForKey:ShowPersonaAdsKey]) {
		self.showPersonalAds = [defaults boolForKey:ShowPersonaAdsKey];
	}
	if ([defaults objectForKey:SearchAreaKey]) {
		self.searchArea = [defaults floatForKey:SearchAreaKey];
	} else {
		self.searchArea = 0.5;
	}
	if ([defaults objectForKey:CategoriesSettingsKey]) {
		self.categoriesSettings = [[defaults dictionaryForKey:CategoriesSettingsKey] mutableCopy];
	} else {
		self.categoriesSettings = [NSMutableDictionary new];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[Utils storeValue:@(self.showPersonalAdsSwitch.on) forKey:ShowPersonaAdsKey];
	[Utils storeValue:@(self.showBusinessAdsSwitch.on) forKey:ShowBusinessAdsKey];
	[Utils storeValue:@(self.searchArea) forKey:SearchAreaKey];
	[Utils storeValue:self.categoriesSettings forKey:CategoriesSettingsKey];
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
	UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areaSliderTap:)];
	[searchAreaCell.areaSliderCatcherView addGestureRecognizer:sliderTap];
	
	UIPanGestureRecognizer *sliderPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(areaSliderPan:)];
	[searchAreaCell.areaSliderCatcherView addGestureRecognizer:sliderPan];
	self.areaProgressView = searchAreaCell.areaSlider;
	self.areaProgressView.progress = self.searchArea;
	self.areaProgressView.progressTintColor = [UIColor appOrangeColor];
	self.areaProgressView.layer.cornerRadius = 2;
	return searchAreaCell;
}

- (UITableViewCell *)categoryFilterCellForIndexPath:(NSIndexPath *)indexPath
{
	DefaultSettingsTableViewCell *settingCell = [self.tableView dequeueReusableCellWithIdentifier:DefaultSettingsTableViewCell.ID forIndexPath:indexPath];
	CategoryModel *currentCategory = (CategoryModel *)self.categoriesArray[indexPath.row];
	settingCell.settingTitleLabel.text = currentCategory.name;
	if (self.categoriesSettings[@(currentCategory.categoryId).stringValue]) {
		BOOL isOn = [self.categoriesSettings[@(currentCategory.categoryId).stringValue] boolValue];
		[settingCell.settingSwitch setOn:isOn];
	}
	settingCell.settingSwitch.tag = currentCategory.categoryId;
	[settingCell.settingSwitch addTarget:self action:@selector(changeSetting:) forControlEvents:UIControlEventValueChanged];
	return settingCell;
}

- (void)changeSetting:(UISwitch *)sender
{
	[self.categoriesSettings setValue:@(sender.on) forKey:@(sender.tag).stringValue];
}

- (UITableViewCell *)userTypeCellForIndexPath:(NSIndexPath *)indexPath
{
	DefaultSettingsTableViewCell *settingCell = [self.tableView dequeueReusableCellWithIdentifier:DefaultSettingsTableViewCell.ID forIndexPath:indexPath];
	if (indexPath.item == 0) {
		settingCell.settingTitleLabel.text = @"Company Ads";
		[settingCell.settingSwitch setOn:self.showBusinessAds];
		self.showBusinessAdsSwitch = settingCell.settingSwitch;
	} else {
		settingCell.settingTitleLabel.text = @"Individual Ads";
		[settingCell.settingSwitch setOn:self.showPersonalAds];
		self.showPersonalAdsSwitch = settingCell.settingSwitch;
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
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	[self.tableView registerNib:DefaultSettingsTableViewCell.nib forCellReuseIdentifier:DefaultSettingsTableViewCell.ID];
	[self.tableView registerNib:SearchAreaTableViewCell.nib forCellReuseIdentifier:SearchAreaTableViewCell.ID];
}

- (void)loadCategories
{
    __weak typeof(self) weakSelf = self;
    [[APIClient sharedInstance] categoriesListWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
        if (!error) {
            NSParameterAssert([response isKindOfClass:[NSArray class]]);
            weakSelf.categoriesArray = [CategoryModel arrayWithDictionariesArray:response];
            [weakSelf.tableView reloadData];
            [Utils storeValue:response forKey:CategoriesListKey];
        }
    }];
}

#pragma mark - Actions

- (void)areaSliderTap:(UITapGestureRecognizer *)tap
{
	UIView *sliderFakeView = (UIView *)tap.view;
	CGPoint tapPoint = [tap locationInView:sliderFakeView];
	CGFloat percentage = tapPoint.x / CGRectGetWidth(sliderFakeView.bounds);
	[self.areaProgressView setProgress:percentage animated:NO];
	self.searchArea = self.areaProgressView.progress;
}

- (void)areaSliderPan:(UIPanGestureRecognizer *)pan
{
	UIView *sliderFakeView = (UIView *)pan.view;
	CGPoint tapPoint = [pan locationInView:sliderFakeView];
	CGFloat percentage = tapPoint.x / CGRectGetWidth(sliderFakeView.bounds);
	[self.areaProgressView setProgress:percentage animated:NO];
	self.searchArea = self.areaProgressView.progress;
}

@end
