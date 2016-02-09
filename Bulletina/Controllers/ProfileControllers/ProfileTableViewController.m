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

// Views
#import "BulletinaLoaderView.h"

//Models
#import "APIClient+Session.h"
#import "APIClient+User.h"

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
@property (strong, nonatomic) BulletinaLoaderView *loader;

@end

@implementation ProfileTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self tableViewSetup];
	[self setupNavBar];
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.title = @"My Bulletina";
	[self reloadUser];
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
        return [self businessLogoCellForIndexPath:indexPath];
    } else {
        return [self individualLogoCellForIndexPath:indexPath];
    }
}

- (BusinessProfileLogoTableViewCell *)businessLogoCellForIndexPath:(NSIndexPath *)indexPath
{
    BusinessProfileLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BusinessProfileLogoTableViewCell.ID forIndexPath:indexPath];
    [self addCustomBorderToButton:cell.websiteButton];
    [self addCustomBorderToButton:cell.facebookButton];
    [self addCustomBorderToButton:cell.instagramButton];
    [self addCustomBorderToButton:cell.linkedInButton];
    cell.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
    cell.companyNameLabel.text = [APIClient sharedInstance].currentUser.company_name;
    cell.companyPhoneLabel.text = [NSString stringWithFormat:@"Phone:%@", [APIClient sharedInstance].currentUser.phone];
    [cell.companyDescriptionTextView setEditable:YES];
    cell.companyDescriptionTextView.text = [APIClient sharedInstance].currentUser.about;
    [cell.companyDescriptionTextView setEditable:NO];
    if ([APIClient sharedInstance].currentUser.avatar_url.length) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[APIClient sharedInstance].currentUser.avatar_url]];
        cell.logoImageView.image = [UIImage imageWithData:imageData];
    }
    return cell;
}

- (IndividualProfileLogoTableViewCell *)individualLogoCellForIndexPath:(NSIndexPath *)indexPath
{
    IndividualProfileLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:IndividualProfileLogoTableViewCell.ID forIndexPath:indexPath];
    cell.aboutMeTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.logoImageView.layer.borderWidth = 2.0f;
    cell.logoImageView.layer.cornerRadius = CGRectGetHeight(cell.logoImageView.frame) / 2;
    cell.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
	cell.userFullNameLabel.text = [APIClient sharedInstance].currentUser.name ? : @"Fullname";
    cell.userNicknameLabel.text = [APIClient sharedInstance].currentUser.login;
    [cell.aboutMeTextView setEditable:YES];
    cell.aboutMeTextView.text = [APIClient sharedInstance].currentUser.about;
    [cell.aboutMeTextView setEditable:NO];
    if ([APIClient sharedInstance].currentUser.avatar_url.length) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[APIClient sharedInstance].currentUser.avatar_url]];
        cell.logoImageView.image = [UIImage imageWithData:imageData];
    }
    return cell;
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
        [self logout];
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

- (void)logout
{
    [self.loader show];
    __weak typeof(self) weakSelf = self;
    [[APIClient sharedInstance] logoutSessionWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
        if (error) {
            [Utils showErrorForStatusCode:statusCode];
        } else {
            [[APIClient sharedInstance] updatePasstoken:@""];
            [[APIClient sharedInstance] updateCurrentUser:nil];
            [Defaults removeObjectForKey:CurrentUserKey];
            [Defaults synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __block UIViewController *rootVC = weakSelf.navigationController.presentingViewController;
                [weakSelf.navigationController dismissViewControllerAnimated:NO completion:^{
                    [rootVC dismissViewControllerAnimated:YES completion:nil];
                }];
			});
        }
        [weakSelf.loader hide];
    }];
}

#pragma mark - Utils

- (CGFloat)heightForTopCell
{
	if ([APIClient sharedInstance].currentUser.customer_type_id == BusinessAccount) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:BusinessProfileLogoTableViewCell.ID owner:self options:nil];
		BusinessProfileLogoTableViewCell *cell = [topLevelObjects firstObject];
		CGSize size = CGSizeZero;
		[cell.companyDescriptionTextView setEditable:YES];
		cell.companyDescriptionTextView.text = [APIClient sharedInstance].currentUser.about;
		[cell.companyDescriptionTextView setEditable:NO];
		if (cell.companyDescriptionTextView.text.length) {
			size = [cell.companyDescriptionTextView sizeThatFits:CGSizeMake(ScreenWidth - 60, MAXFLOAT)];
		} else {
			size = CGSizeMake(0, 0);
		}
		return (size.height + BusinessLogoCellHeigth);
	}
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:IndividualProfileLogoTableViewCell.ID owner:self options:nil];
	IndividualProfileLogoTableViewCell *cell = [topLevelObjects firstObject];
	CGSize size = CGSizeZero;
	[cell.aboutMeTextView setEditable:YES];
	cell.aboutMeTextView.text = [APIClient sharedInstance].currentUser.about;
	[cell.aboutMeTextView setEditable:NO];
	if (cell.aboutMeTextView.text.length) {
		size = [cell.aboutMeTextView sizeThatFits:CGSizeMake(ScreenWidth - 60, MAXFLOAT)];
	} else {
		size = CGSizeMake(0, -21);
	}	
	return (size.height + PersonalLogoCellHeigth);
}

- (void)addCustomBorderToButton:(UIButton *)button
{
	button.layer.borderColor = [UIColor whiteColor].CGColor;
	button.layer.borderWidth = 1.0f;
	button.layer.cornerRadius = 5;
}

- (void)reloadUser
{
	[self.loader show];
	__weak typeof(self) weakSelf = self;
	[[APIClient sharedInstance] showCurrentUserWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (error) {
			if (response[@"error_message"]) {
				[Utils showErrorWithMessage:response[@"error_message"]];
			} else {
				[Utils showErrorForStatusCode:statusCode];
			}
		} else {
			NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
			UserModel *generatedUser = [UserModel modelWithDictionary:response];
			[Utils storeValue:response forKey:CurrentUserKey];
			[[APIClient sharedInstance] updateCurrentUser:generatedUser];
			[[APIClient sharedInstance] updatePasstokenWithDictionary:response];
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.tableView reloadData];
			});
		}
		[weakSelf.loader hide];
	}];
}

#pragma mark - Setup

- (void)setupNavBar
{
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	[self.navigationController.navigationBar
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appOrangeColor]}];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTap:)];
    
    self.loader = [[BulletinaLoaderView alloc] initWithView:self.navigationController.view andText:nil];
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
