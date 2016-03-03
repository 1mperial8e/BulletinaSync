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
@property (assign, nonatomic) CGFloat topCellHeight;
@end

@implementation MyItemsTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self reloadUser];
    if ([APIClient sharedInstance].currentUser.userId == self.user.userId) {
        self.navigationItem.title = @"My Bulletina";
    } else {
        self.navigationItem.title = self.user.title;
    }
	
	__weak typeof(self) weakSelf = self;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([APIClient sharedInstance].requestStartDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		if (!weakSelf.downloadTask) {
			[weakSelf loadData:YES];
		}
	});
}

#pragma mark - API

- (void)reloadUser
{
    if (self.user.userId) {
        __weak typeof(self) weakSelf = self;
        [[APIClient sharedInstance] showUserWithUserId:self.user.userId withCompletion: ^(id response, NSError *error, NSInteger statusCode) {
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

- (void)loadData:(BOOL)reloadAll
{
    [self.downloadTask cancel];
	self.currentPage++;
    if (reloadAll) {
        self.hasMore = YES;
        self.currentPage = 0;
    }
    __weak typeof(self) weakSelf = self;
	
    self.downloadTask =
//	[[APIClient sharedInstance] loadMyFavoriteItemsWithCompletion:
//	[[APIClient sharedInstance] fetchItemsForUserId:self.user.userId page:self.currentPage withCompletion:
	[[APIClient sharedInstance]fetchAllItemsForUserId:self.user.userId page:self.currentPage  withCompletion:
						 ^(id response, NSError *error, NSInteger statusCode) {
        if ([weakSelf.refresh isRefreshing]) {
            [weakSelf.refresh endRefreshing];
        }
        if (error) {
            [super failedToDownloadItemsWithError:error];
        } else {
            NSAssert([response isKindOfClass:[NSArray class]], @"Unknown response from server");
//			NSArray *items = [ItemModel arrayWithFavoritreDictionariesArray:response];
			NSArray *items = [ItemModel arrayWithDictionariesArray:response];
            [super downloadedItems:items afterReload:reloadAll];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
		return [super tableView:tableView numberOfRowsInSection:section] + 1; // plus profile cell
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.item == LogoCellIndex) {
		return [self logoCellForIndexPath:indexPath];
	}	else if (!indexPath.section && indexPath.item != LogoCellIndex){
		return [super defaultCellForIndexPath:indexPath forMyItems:YES];
	}
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
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
    [cell.logoImageView addGestureRecognizer:imageTapGesture];
	return cell;
}

- (IndividualProfileLogoTableViewCell *)individualLogoCellForIndexPath:(NSIndexPath *)indexPath
{
	IndividualProfileLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:IndividualProfileLogoTableViewCell.ID forIndexPath:indexPath];
	cell.user = self.user;
    UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)];
    [cell.logoImageView addGestureRecognizer:imageTapGesture];
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.item == LogoCellIndex) {
		return [self heightForTopCell];
    } else if (indexPath.section) {
        return self.hasMore ? 44.f : 0;
    }
	return [ItemTableViewCell itemCellHeightForItemModel:self.itemsList[indexPath.item - 1]];
}

#pragma mark - Actions

- (void)avatarTap:(UITapGestureRecognizer *)sender
{
    if (self.user.avatarUrl && ((UIImageView *)sender.view).image) {
        CGRect cellFrame = [self.navigationController.view convertRect:sender.view.superview.superview.frame fromView:self.tableView];
        CGRect imageViewRect = sender.view.frame;
        imageViewRect.origin.x = ([UIScreen mainScreen].bounds.size.width - imageViewRect.size.width) / 2;
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
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)showUserForItem:(ItemModel *)item
{
	//Do nothing
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
	if (scrollView.contentOffset.y > -self.topOffset) {
		CGRect frame = self.topBackgroundImageView.frame;
		frame.origin.y = scrollView.contentOffset.y < 0 ? fabs(scrollView.contentOffset.y) : -scrollView.contentOffset.y;
		self.topBackgroundImageView.frame = frame;
	} else {
        if (self.topBackgroundImageView.transform.a < 1.01) {
            self.topBackgroundImageView.frame = CGRectMake(0, self.topOffset, ScreenWidth, self.topCellHeight);
        }
        CGFloat scaleCoef = 1 + (scrollView.contentOffset.y < -self.topOffset ? (fabs(scrollView.contentOffset.y + self.topOffset) / (self.topCellHeight * 0.5)) : 0);
        self.topBackgroundImageView.transform = CGAffineTransformMakeScale(scaleCoef, scaleCoef);
	}
}

@end
