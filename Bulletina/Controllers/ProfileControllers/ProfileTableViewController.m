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

static CGFloat const PersonalLogoCellHeigth = 215;
static CGFloat const BusinessLogoCellHeigth = 182;//252
static CGFloat const BusinessLogoButtonsContainerHeight = 41;
static CGFloat const BusinessLogoPhoneContainerHeight = 29;
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
    cell.user = self.user;
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
		
		cell.aboutMeTextView.text = self.user.about;
		cell.aboutMeTextView.font = [UIFont systemFontOfSize:13];
		cell.aboutMeTextView.textColor = [UIColor whiteColor];
		cell.aboutMeTextView.textAlignment = NSTextAlignmentCenter;
		[cell.aboutMeTextView setTextContainerInset:UIEdgeInsetsZero];
		
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
	((ItemsListTableViewController *)((UINavigationController*)self.navigationController.presentingViewController).viewControllers.firstObject).reloadNeeded = YES;
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
	
	cell.companyDescriptionTextView.text = self.user.about;
	cell.companyDescriptionTextView.font = [UIFont systemFontOfSize:13];
	cell.companyDescriptionTextView.textColor = [UIColor whiteColor];
	cell.companyDescriptionTextView.textAlignment = NSTextAlignmentCenter;
	[cell.companyDescriptionTextView setTextContainerInset:UIEdgeInsetsZero];
	
	if (cell.companyDescriptionTextView.text.length) {
		size = [cell.companyDescriptionTextView sizeThatFits:CGSizeMake(ScreenWidth - 60, MAXFLOAT)];
	} else {
		size = CGSizeMake(0, 0);
	}
	
	CGFloat extraHeight = 0;
//	if (self.user.website.length || self.user.facebook.length || self.user.linkedin.length) {
		extraHeight += BusinessLogoButtonsContainerHeight;
//	}
//	if (self.user.phone.length) {
		extraHeight += BusinessLogoPhoneContainerHeight;
//	}
	return (size.height + BusinessLogoCellHeigth + extraHeight);
}

- (CGFloat)heighForPersonalLogoCell
{
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:IndividualProfileLogoTableViewCell.ID owner:self options:nil];
	IndividualProfileLogoTableViewCell *cell = [topLevelObjects firstObject];
	CGSize size = CGSizeZero;
	
	cell.aboutMeTextView.text = self.user.about;
	cell.aboutMeTextView.font = [UIFont systemFontOfSize:13];
	cell.aboutMeTextView.textColor = [UIColor whiteColor];
	cell.aboutMeTextView.textAlignment = NSTextAlignmentCenter;
	[cell.aboutMeTextView setTextContainerInset:UIEdgeInsetsZero];
	
	if (cell.aboutMeTextView.text.length) {
		size = [cell.aboutMeTextView sizeThatFits:CGSizeMake(ScreenWidth - 60, MAXFLOAT)];
	} else {
		size = CGSizeMake(0, 0);
	}
	return (size.height + PersonalLogoCellHeigth);
}

- (CGFloat)topOffset
{
    return Application.statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
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
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopBackground"]];
    backgroundImageView.frame = CGRectMake(0, self.topOffset, ScreenWidth, [self heightForTopCell]);
    [backgroundView addSubview:backgroundImageView];
    backgroundView.backgroundColor = [UIColor mainPageBGColor];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.topBackgroundImageView = backgroundImageView;
    self.tableView.backgroundView = backgroundView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= -self.topOffset) {
        CGRect frame = self.topBackgroundImageView.frame;
        frame.origin.y = scrollView.contentOffset.y < 0 ? fabs(scrollView.contentOffset.y) : -scrollView.contentOffset.y;
        self.topBackgroundImageView.frame = frame;
    }
    CGFloat scaleCoef = 1 + (scrollView.contentOffset.y < -self.topOffset ? (fabs(scrollView.contentOffset.y + self.topOffset) / ([self heightForTopCell] * 0.5)) : 0);
    self.topBackgroundImageView.transform = CGAffineTransformMakeScale(scaleCoef, scaleCoef);
}

@end
