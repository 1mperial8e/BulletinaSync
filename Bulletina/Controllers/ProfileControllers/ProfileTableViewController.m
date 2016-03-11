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
@property (assign, nonatomic) CGFloat topCellHeight;
@property (assign, nonatomic) NSInteger unreadMessagesCount;

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
	[self performSelector:@selector(checkMessages) withObject:nil afterDelay:[APIClient sharedInstance].requestStartDelay];
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
    self.topBackgroundImageView.frame = CGRectMake(0, self.topOffset, ScreenWidth, [self heightForTopCell]);
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
	UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)];
	
	if (self.user.avatarUrl) {
		[cell.avatarImageView addGestureRecognizer:imageTapGesture];
	}
	
	if (self.user.logoUrl) {
		[cell.logoImageView addGestureRecognizer:imageTapGesture];
	}
	
    return cell;
}

- (IndividualProfileLogoTableViewCell *)individualLogoCellForIndexPath:(NSIndexPath *)indexPath
{
    IndividualProfileLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:IndividualProfileLogoTableViewCell.ID forIndexPath:indexPath];
	cell.user = self.user;
	UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)];

	if (self.user.avatarUrl) {
		[cell.logoImageView addGestureRecognizer:imageTapGesture];
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
		if (self.unreadMessagesCount) {
			cell.messagesBadge.hidden = NO;
			cell.messagesBadge.text = [NSString stringWithFormat:@"%li", self.unreadMessagesCount];
			cell.messagesBadge.layer.cornerRadius = CGRectGetHeight(cell.messagesBadge.frame) / 2;
		} else {
			cell.messagesBadge.hidden = YES;
		}
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

- (void)avatarTap:(UITapGestureRecognizer *)sender
{
	if (((UIImageView *)sender.view).image) {
		CGRect cellFrame = [self.navigationController.view convertRect:sender.view.superview.superview.frame fromView:self.tableView];
		CGRect imageViewRect = sender.view.frame;
        imageViewRect.origin.y += cellFrame.origin.y;
		
		FullScreenImageViewController *imageController = [FullScreenImageViewController new];
		imageController.image = ((UIImageView *)sender.view).image;
		imageController.presentationRect = imageViewRect;
		imageController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
		[self.navigationController presentViewController:imageController animated:NO completion:nil];
	}
}

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
    CGFloat height = 0;
	if (self.user.customerTypeId == BusinessAccount) {
		height = [BusinessProfileLogoTableViewCell heightForBusinessLogoCellWithUser:self.user];
	} else {
		height = [IndividualProfileLogoTableViewCell heightForIndividualAvatarCellWithUser:self.user];
	}
	self.topCellHeight = height;
    return height;
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

- (void)checkMessages
{
    __weak typeof(self) weakSelf = self;
	[[APIClient sharedInstance] fetchMyUnreadMessagesCountWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (error) {
			[Utils showErrorForStatusCode:statusCode];
		} else {
			NSParameterAssert([response isKindOfClass:[NSDictionary class]]);
			weakSelf.unreadMessagesCount = [response[@"count"] integerValue];
			[weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:MessagesCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}];
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
	[backgroundImageView setClipsToBounds:YES];
    self.topBackgroundImageView = backgroundImageView;
    self.tableView.backgroundView = backgroundView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= -self.topOffset) {
        CGRect frame = self.topBackgroundImageView.frame;
        frame.origin.y = scrollView.contentOffset.y < 0 ? fabs(scrollView.contentOffset.y) : -scrollView.contentOffset.y;
		frame.size.width = ScreenWidth;
		frame.origin.x = 0;
        self.topBackgroundImageView.frame = frame;
	} else {
        if (self.topBackgroundImageView.transform.a < 1.01) {
            self.topBackgroundImageView.frame = CGRectMake(0, self.topOffset, ScreenWidth, self.topCellHeight);
        }
		CGFloat scaleCoef = 1 + (scrollView.contentOffset.y <= -self.topOffset ? (fabs(scrollView.contentOffset.y + self.topOffset) / (self.topCellHeight * 0.5)) : 0);
        self.topBackgroundImageView.transform = CGAffineTransformMakeScale(scaleCoef, scaleCoef);
	}
}

@end
