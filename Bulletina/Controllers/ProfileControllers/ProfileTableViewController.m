//
//  ProfileTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Controllers
#import "ProfileTableViewController.h"
#import "IndividualProfileEditTableViewController.h"
#import "BusinessProfileEditTableViewController.h"
#import "MyItemsTableViewController.h"
#import "MessageTableViewController.h"

//Cells
#import "ProfileDefaultTableViewCell.h"
#import "IndividualProfileLogoTableViewCell.h"
#import "BusinessProfileLogoTableViewCell.h"
#import "SearchSettingsTableViewController.h"

//Models
#import "APIClient+Session.h"


static CGFloat const PersonalLogoCellHeigth = 220;
static CGFloat const BusinessLogoCellHeigth = 252;
static CGFloat const DefaultCellHeigth = 44;

static NSInteger const CellsCount = 8;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	LogoCellIndex,
	EditProfileCellIndex,
	MyItemsCellIndex,
	MessagesCellIndex,
	SearchSettingsCellIndex,
	InAppPurchaseCellIndex,
	AboutCellIndex,
	LogOutCellIndex
};

@interface ProfileTableViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) UIImageView *topBackgroundImageView;
@property (weak, nonatomic) NSLayoutConstraint *backgroundTopConstraint;

@end

@implementation ProfileTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self tableViewSetup];
	[self setupNavBar];
	
	self.title = @"My Bulletina";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item == LogoCellIndex) {
		return [self logoCellForIndexPath:indexPath];
	}
	return [self defaultCellForIndexPath:indexPath];
}

#pragma mark - Cells

- (UITableViewCell *)logoCellForIndexPath:(NSIndexPath *)indexPath
{
	if ([APIClient sharedInstance].currentUser.customer_type_id == BusinessAccount) {
		BusinessProfileLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BusinessProfileLogoTableViewCell.ID forIndexPath:indexPath];
		[self addCustomBorderToButton:cell.websiteButton];
		[self addCustomBorderToButton:cell.facebookButton];
		[self addCustomBorderToButton:cell.instagramButton];
		[self addCustomBorderToButton:cell.linkedInButton];
		cell.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
		cell.companyNameLabel.text = [APIClient sharedInstance].currentUser.company_name;
		cell.companyPhoneLabel.text = [APIClient sharedInstance].currentUser.phone;
		cell.companyDescriptionTextView.text = [APIClient sharedInstance].currentUser.about;
		
		return cell;
	}
	IndividualProfileLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:IndividualProfileLogoTableViewCell.ID forIndexPath:indexPath];
	cell.aboutMeTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	cell.logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
	cell.logoImageView.layer.borderWidth = 2.0f;
	cell.logoImageView.layer.cornerRadius = CGRectGetHeight(cell.logoImageView.frame) / 2;
	cell.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
	
	cell.userFullNameLabel.text = [APIClient sharedInstance].currentUser.name;
	cell.userNicknameLabel.text = [APIClient sharedInstance].currentUser.login;
	cell.aboutMeTextView.text = [APIClient sharedInstance].currentUser.about;
	
	return cell;
}

- (void)addCustomBorderToButton:(UIButton *)button
{
	button.layer.borderColor = [UIColor whiteColor].CGColor;
	button.layer.borderWidth = 1.0f;
	button.layer.cornerRadius = 5;
}

- (ProfileDefaultTableViewCell *)defaultCellForIndexPath:(NSIndexPath *)indexPath
{
	ProfileDefaultTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ProfileDefaultTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor whiteColor];
	
	if (indexPath.item == EditProfileCellIndex) {
		cell.label.text = @"Edit profile";
		cell.iconImageView.image = [UIImage imageNamed:@"EditProfile"];
	} else if (indexPath.item == MyItemsCellIndex) {
		cell.label.text = @"My items";
		cell.iconImageView.image = [UIImage imageNamed:@"MyItems"];
	} else if (indexPath.item == MessagesCellIndex) {
		cell.label.text = @"Messages";
		cell.iconImageView.image = [UIImage imageNamed:@"Messages"];
	} else if (indexPath.item == SearchSettingsCellIndex) {
		cell.label.text = @"Search settings";
		cell.iconImageView.image = [UIImage imageNamed:@"SearchSettings"];
	} else if (indexPath.item == InAppPurchaseCellIndex) {
		cell.label.text = @"In-app purchase";
		cell.iconImageView.image = [UIImage imageNamed:@"InAppPurchase"];
	} else if (indexPath.item == AboutCellIndex) {
		cell.label.text = @"About bulletina";
		cell.iconImageView.image = [UIImage imageNamed:@"AboutBulletina"];
	} else if (indexPath.item == LogOutCellIndex) {
		cell.label.text = @"Log out";
		cell.iconImageView.image = [UIImage imageNamed:@"LogOut"];
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = DefaultCellHeigth * HeigthCoefficient;
	if (indexPath.row == LogoCellIndex) {
		return [self heightForTopCell];
	}
	return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.item == EditProfileCellIndex) {
		if ([APIClient sharedInstance].currentUser.customer_type_id == BusinessAccount) {
			BusinessProfileEditTableViewController *businessProfileEditTableViewController = [BusinessProfileEditTableViewController new];
			[self.navigationController pushViewController:businessProfileEditTableViewController animated:YES];
		} else {
			IndividualProfileEditTableViewController *individualProfileEditTableViewController = [IndividualProfileEditTableViewController new];
			[self.navigationController pushViewController:individualProfileEditTableViewController animated:YES];
		}
	} else if (indexPath.item == LogOutCellIndex) {
		[[APIClient sharedInstance] logoutSessionWithUserId:[APIClient sharedInstance].currentUser.userId passtoken:[APIClient sharedInstance].passtoken withCompletion:^(id response, NSError *error, NSInteger statusCode) {
			if (error) {
				DLog(@"%@",error);
			} else {
				DLog(@"%@",response);
			}
		}];
		[self.navigationController dismissViewControllerAnimated:NO completion:nil];
		[self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];		
    } else if (indexPath.item == MessagesCellIndex) {
        MessageTableViewController *messageTableViewController = [MessageTableViewController new];
        [self.navigationController pushViewController:messageTableViewController animated:YES];
    } else if (indexPath.item == SearchSettingsCellIndex) {
		SearchSettingsTableViewController *searchSettingsTableViewController = [SearchSettingsTableViewController new];
		[self.navigationController pushViewController:searchSettingsTableViewController animated:YES];
	}	else if (indexPath.item == MyItemsCellIndex) {
		MyItemsTableViewController *itemsTableViewController = [MyItemsTableViewController new];
		[self.navigationController pushViewController:itemsTableViewController animated:YES];
	}
}

#pragma mark - Actions

- (void)doneButtonTap:(id)sender
{
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utils

- (CGFloat)heightForTopCell
{
	if ([APIClient sharedInstance].currentUser.customer_type_id == BusinessAccount) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:BusinessProfileLogoTableViewCell.ID owner:self options:nil];
		BusinessProfileLogoTableViewCell *cell = [topLevelObjects firstObject];
		CGSize size = CGSizeZero;
		cell.companyDescriptionTextView.text = [APIClient sharedInstance].currentUser.about;
		size = [cell.companyDescriptionTextView sizeThatFits:CGSizeMake(ScreenWidth - 60, MAXFLOAT)];
		return (size.height + BusinessLogoCellHeigth);
	}
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:IndividualProfileLogoTableViewCell.ID owner:self options:nil];
	IndividualProfileLogoTableViewCell *cell = [topLevelObjects firstObject];
	CGSize size = CGSizeZero;
	cell.aboutMeTextView.text = [APIClient sharedInstance].currentUser.about;
	size = [cell.aboutMeTextView sizeThatFits:CGSizeMake(ScreenWidth - 60, MAXFLOAT)];
	return (size.height + PersonalLogoCellHeigth);
}

#pragma mark - Setup

- (void)setupNavBar
{
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	[self.navigationController.navigationBar
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appOrangeColor]}];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTap:)];
}

- (void)tableViewSetup
{	
	[self.tableView registerNib:ProfileDefaultTableViewCell.nib forCellReuseIdentifier:ProfileDefaultTableViewCell.ID];
	[self.tableView registerNib:IndividualProfileLogoTableViewCell.nib forCellReuseIdentifier:IndividualProfileLogoTableViewCell.ID];
	[self.tableView registerNib:BusinessProfileLogoTableViewCell.nib forCellReuseIdentifier:BusinessProfileLogoTableViewCell.ID];	
	
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 30, 0)];
	UIView *backgroundView = [[UIView alloc] init];
	UIImageView *backgroundImageView = [[UIImageView alloc] init];
	[backgroundView addSubview:backgroundImageView];
		backgroundImageView.image = [UIImage imageNamed:@"TopBackground"];
	backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.tableView.backgroundView = backgroundView;
	self.tableView.backgroundColor = [UIColor whiteColor];
	self.backgroundTopConstraint = [NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeTop multiplier:1.0f constant:64];
	[backgroundView addConstraint:self.backgroundTopConstraint];
	
	[backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:[self heightForTopCell]]];
	 
	[backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	self.topBackgroundImageView = backgroundImageView;
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat scaleCoef = 1 + (scrollView.contentOffset.y < -64 ? (fabs(scrollView.contentOffset.y + 64.0) / 120) : 0);
	self.topBackgroundImageView.transform = CGAffineTransformMakeScale(scaleCoef, scaleCoef);
	self.backgroundTopConstraint.constant = scrollView.contentOffset.y < 0 ? fabs(scrollView.contentOffset.y) : -scrollView.contentOffset.y;
}

@end
