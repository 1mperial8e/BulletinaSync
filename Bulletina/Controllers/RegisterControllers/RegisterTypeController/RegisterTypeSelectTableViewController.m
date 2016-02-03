//
//  RegisterTypeTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/20/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

// Controllers
#import "RegisterTypeSelectTableViewController.h"
#import "PersonalRegisterTableViewController.h"
#import "BusinessRegisterTableViewController.h"

// Cells
#import "AccountTypeTableViewCell.h"

static NSString *const ViewControllerTitle = @"Register account";
static NSString *const SectionTitle        = @"Choose account type";
static NSString *const ButtonTitle         = @"Cancel";

static NSString *const kAccountImageName   = @"AccountImageName";
static NSString *const kAccountTitleString = @"AccountTitleString";

static CGFloat const DefaultTableViewSectionHeaderHeight = 20.f;
static CGFloat const DefaultTableViewHeaderHeight        = 77.f;
static CGFloat const DefaultTableViewCellHeight          = 135.f;
static CGFloat const DefaultTableViewCellCount           = 1.f;

typedef NS_ENUM(NSUInteger, AccountTypeIndex) {
    AccountTypePersonalIndex,
    AccountTypeBusinessIndex
};

@interface RegisterTypeSelectTableViewController () <AccountTypeTableViewCellDelegate>

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation RegisterTypeSelectTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareUI];
    [self prepareTableView];
    [self prepareDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Application setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return DefaultTableViewCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AccountTypeTableViewCell.ID forIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(AccountTypeTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.dataSource[indexPath.section][kAccountTitleString];
    NSString *imageName = self.dataSource[indexPath.section][kAccountImageName];
    [cell configureCellForTitle:title imageName:imageName];
    [cell hideMoreInfoButton:!indexPath.section];
    cell.delegate = self;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DefaultTableViewCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [UIView new];
    [sectionHeader setBackgroundColor:[UIColor clearColor]];
    return sectionHeader;
}
                             
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ? DefaultTableViewSectionHeaderHeight : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == AccountTypePersonalIndex) {
        [self selectPersonalAccount];
    } else if (indexPath.section == AccountTypeBusinessIndex) {
        [self selectBusinessAccount];
    }
}

#pragma mark - AccountTypeTableViewCellDelegate

- (void)pressMoreInfoButton
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - Private Methods

- (void)prepareUI
{
    self.title = ViewControllerTitle;
    self.view.backgroundColor = [UIColor mainPageBGColor];
    [self prepareNavigationBar];
}

- (void)registerNibs
{
    [self.tableView registerNib:AccountTypeTableViewCell.nib forCellReuseIdentifier:AccountTypeTableViewCell.ID];
}

- (void)prepareNavigationBar
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.backItem.title = @"Cancel";
}

- (void)prepareTableView
{
    [self registerNibs];
    [self prepareTableViewHeader];
}

- (void)prepareTableViewHeader
{
    UILabel *tableHeaderView = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth([UIScreen mainScreen].bounds), DefaultTableViewHeaderHeight)];
    tableHeaderView.textColor = [UIColor colorWithRed:102.f/255.f green:102.f/255.f blue:102.f/255.f alpha:1.f];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    tableHeaderView.textAlignment = NSTextAlignmentCenter;
    tableHeaderView.text = SectionTitle;
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)prepareDataSource
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AccountTypes" ofType:@"plist"];
    self.dataSource = [NSArray arrayWithContentsOfFile:path];
    [self.tableView reloadData];
}

- (void)selectPersonalAccount
{
    PersonalRegisterTableViewController *personalRegisterTableViewController = [PersonalRegisterTableViewController new];
    [self.navigationController pushViewController:personalRegisterTableViewController animated:YES];
}

- (void)selectBusinessAccount
{
    BusinessRegisterTableViewController *businessRegisterTableViewController = [BusinessRegisterTableViewController new];
    [self.navigationController pushViewController:businessRegisterTableViewController animated:YES];
}

@end
