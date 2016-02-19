//
//  ProfileTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

// Controllers
#import "ProfileTableViewController.h"
#import "IndividualProfileEditTableViewController.h"
#import "BusinessProfileEditTableViewController.h"
#import "MyItemsTableViewController.h"
#import "MessageTableViewController.h"
#import "AnonymusProfileEditTableViewController.h"
#import "ChangePasswordTableViewController.h"
#import "SearchSettingsTableViewController.h"

// Cells
#import "ProfileDefaultTableViewCell.h"
#import "IndividualProfileLogoTableViewCell.h"
#import "BusinessProfileLogoTableViewCell.h"

// Views
#import "BulletinaLoaderView.h"

// Models
#import "APIClient+Session.h"
#import "APIClient+User.h"

#import "UIImageView+AFNetworking.h"

static CGFloat const PersonalLogoCellHeigth = 220;
static CGFloat const BusinessLogoCellHeigth = 252;
static CGFloat const DefaultCellHeigth = 44;

static NSInteger const CellsCount = 9;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	LogoCellIndex,
	EditProfileCellIndex,
	MyItemsCellIndex,
	MessagesCellIndex,
	SearchSettingsCellIndex,
	InAppPurchaseCellIndex,
	AboutCellIndex,
	ChangePasswordIndex,
	LogOutCellIndex
};

@interface ProfileTableViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) UIImageView *topBackgroundImageView;
@property (weak, nonatomic) NSLayoutConstraint *backgroundTopConstraint;
@property (weak, nonatomic) NSLayoutConstraint *backgroundHeightConstraint;

@property (strong, nonatomic) BulletinaLoaderView *loader;

@end

@implementation ProfileTableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.user = [APIClient sharedInstance].currentUser;
    self.loader = [[BulletinaLoaderView alloc] initWithView:self.navigationController.view andText:nil];
    
	[self tableViewSetup];
	[self setupNavBar];
    [self reloadUser];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.user = [APIClient sharedInstance].currentUser;
    [self.tableView reloadData];
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
	if (self.user.customerTypeId == BusinessAccount) {
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
    cell.companyNameLabel.text = self.user.companyName;
    cell.companyPhoneLabel.text = [NSString stringWithFormat:@"Phone:%@", self.user.phone];
    [cell.companyDescriptionTextView setEditable:YES];
    cell.companyDescriptionTextView.text = self.user.about;
    [cell.companyDescriptionTextView setEditable:NO];
    if (self.user.avatarUrl) {
        [cell.logoImageView setImageWithURL:self.user.avatarUrl];;
    }
    cell.logoImageView.layer.cornerRadius = 8.0f;
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
    if (self.user.customerTypeId == AnonymousAccount) {
        cell.userFullNameLabel.text = @"Anonymus";
    } else {
        cell.userFullNameLabel.text = self.user.name;
        cell.userNicknameLabel.text = self.user.login;
        [cell.aboutMeTextView setEditable:YES];
        cell.aboutMeTextView.text = self.user.about;
        [cell.aboutMeTextView setEditable:NO];
        if (self.user.avatarUrl) {
            [cell.logoImageView setImageWithURL:self.user.avatarUrl];;
        }
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
	} else  if (indexPath.item == ChangePasswordIndex) {
		cell.label.text = @"Change Password";
		cell.iconImageView.image = [UIImage imageNamed:@"ChangePassword"];
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
        height = [self heightForTopCell];
        self.backgroundHeightConstraint.constant = height;
	} else if (self.user.customerTypeId == AnonymousAccount && indexPath.row == ChangePasswordIndex) {
		height = 0;
	}
	return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.item) {
        case EditProfileCellIndex: {
            [self showEditProfileController];
            break;
        }
        case LogOutCellIndex: {
            [self logout];
            break;
        }
        case MessagesCellIndex: {
            MessageTableViewController *messageTableViewController = [MessageTableViewController new];
            [self.navigationController pushViewController:messageTableViewController animated:YES];
            break;
        }
        case SearchSettingsCellIndex: {
            SearchSettingsTableViewController *searchSettingsTableViewController = [SearchSettingsTableViewController new];
            [self.navigationController pushViewController:searchSettingsTableViewController animated:YES];
            break;
        }
        case ChangePasswordIndex: {
            ChangePasswordTableViewController *changePasswordController = [ChangePasswordTableViewController new];
            [self.navigationController pushViewController:changePasswordController animated:YES];
            break;
        }
        default:
            break;
    }
    if (indexPath.item == MyItemsCellIndex) {
        if ([APIClient sharedInstance].currentUser.customerTypeId == AnonymousAccount) {
            [Utils showWarningWithMessage:@"Only registered users can post items. Please update your account."];
        } else {
            MyItemsTableViewController *itemsTableViewController = [MyItemsTableViewController new];
			itemsTableViewController.user = [APIClient sharedInstance].currentUser;
            [self.navigationController pushViewController:itemsTableViewController animated:YES];
        }
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

- (void)showEditProfileController
{
    if (self.user.customerTypeId == BusinessAccount) {
        BusinessProfileEditTableViewController *businessProfileEditTableViewController = [BusinessProfileEditTableViewController new];
        [self.navigationController pushViewController:businessProfileEditTableViewController animated:YES];
    } else if (self.user.customerTypeId == IndividualAccount) {
        IndividualProfileEditTableViewController *individualProfileEditTableViewController = [IndividualProfileEditTableViewController new];
        [self.navigationController pushViewController:individualProfileEditTableViewController animated:YES];
    } else {
        AnonymusProfileEditTableViewController *anonymusProfileEditTableViewController = [AnonymusProfileEditTableViewController new];
        [self.navigationController pushViewController:anonymusProfileEditTableViewController animated:YES];
    }
}

#pragma mark - Utils

- (CGFloat)heightForTopCell
{
	if (self.user.customerTypeId == BusinessAccount) {
		return [self heighForBusinessLogoCell];
	}
	return [self heighForPersonalLogoCell];
}

- (CGFloat)heighForBusinessLogoCell
{
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:BusinessProfileLogoTableViewCell.ID owner:self options:nil];
	BusinessProfileLogoTableViewCell *cell = [topLevelObjects firstObject];
	CGSize size = CGSizeZero;
	[cell.companyDescriptionTextView setEditable:YES];
	cell.companyDescriptionTextView.text = self.user.about;
	[cell.companyDescriptionTextView setEditable:NO];
	if (cell.companyDescriptionTextView.text.length) {
		size = [cell.companyDescriptionTextView sizeThatFits:CGSizeMake(ScreenWidth - 60, MAXFLOAT)];
	} else {
		size = CGSizeMake(0, 0);
	}
	return (size.height + BusinessLogoCellHeigth);
}

- (CGFloat)heighForPersonalLogoCell
{
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:IndividualProfileLogoTableViewCell.ID owner:self options:nil];
	IndividualProfileLogoTableViewCell *cell = [topLevelObjects firstObject];
	CGSize size = CGSizeZero;
	[cell.aboutMeTextView setEditable:YES];
	cell.aboutMeTextView.text = self.user.about;
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
	if (self.user) {
		__weak typeof(self) weakSelf = self;
		[[APIClient sharedInstance] showUserWithUserId:self.user.userId withCompletion:^(id response, NSError *error, NSInteger statusCode) {
			if (!error) {
                NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
                UserModel *user = [UserModel modelWithDictionary:response];
                weakSelf.user = user;
                [Utils storeValue:response forKey:CurrentUserKey];
                [[APIClient sharedInstance] updateCurrentUser:user];
                [[APIClient sharedInstance] updatePasstokenWithDictionary:response];
				
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
			}
		}];
	}
}

#pragma mark - Setup

- (void)setupNavBar
{
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appOrangeColor]}];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTap:)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title = @"My Bulletina";
}

- (void)tableViewSetup
{	
	[self.tableView registerNib:ProfileDefaultTableViewCell.nib forCellReuseIdentifier:ProfileDefaultTableViewCell.ID];
	[self.tableView registerNib:IndividualProfileLogoTableViewCell.nib forCellReuseIdentifier:IndividualProfileLogoTableViewCell.ID];
	[self.tableView registerNib:BusinessProfileLogoTableViewCell.nib forCellReuseIdentifier:BusinessProfileLogoTableViewCell.ID];
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 30, 0)];
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	[self addBackgroundView];
}

- (void)addBackgroundView
{
	UIView *backgroundView = [[UIView alloc] init];
	UIImageView *backgroundImageView = [[UIImageView alloc] init];
	[backgroundView addSubview:backgroundImageView];
	backgroundImageView.image = [UIImage imageNamed:@"TopBackground"];
	backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.tableView.backgroundView = backgroundView;
	self.tableView.backgroundColor = [UIColor whiteColor];
	self.backgroundTopConstraint = [NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeTop multiplier:1.0f constant:64];
	[backgroundView addConstraint:self.backgroundTopConstraint];
	
	self.backgroundHeightConstraint = [NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:[self heightForTopCell]];
	[backgroundImageView addConstraint:self.backgroundHeightConstraint];
	
	[backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	self.topBackgroundImageView = backgroundImageView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat scaleCoef = 1 + (scrollView.contentOffset.y < -64 ? (fabs(scrollView.contentOffset.y + 64.0) / 120) : 0);
	self.topBackgroundImageView.transform = CGAffineTransformMakeScale(scaleCoef, scaleCoef);
	self.backgroundTopConstraint.constant = scrollView.contentOffset.y < 0 ? fabs(scrollView.contentOffset.y) : -scrollView.contentOffset.y;
}

@end
