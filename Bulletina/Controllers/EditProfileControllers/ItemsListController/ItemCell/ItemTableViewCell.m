//
//  ItemTableViewCell.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "ReportTableViewController.h"
#import "APIClient+Item.h"

static CGFloat const priceContainerHeigth = 43.0f;
static CGFloat const ItemTableViewCellHeigth = 105.0f;
static CGFloat const iconCellHeigth = 20;
static CGFloat const iconCellCount = 4;
static NSInteger const TwentyFourHours = 86400;

typedef NS_ENUM(NSUInteger, iconCellsIndexes) {
	FavoriteCellIndex,
	ChatCellIndex,
	ShareCellIndex,
	MoreCellIndex,
};

@interface ItemTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *iconsCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *itemStateButton;
@property (weak, nonatomic) IBOutlet UITextView *itemTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceValueLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IconCollectionViewCell *favoriteCell;
@property (weak, nonatomic) IconCollectionViewCell *shareCell;
@property (weak, nonatomic) IconCollectionViewCell *chatCell;
@property (weak, nonatomic) IconCollectionViewCell *moreCell;

@property (weak, nonatomic) NSURLSessionTask *favouritesTask;

@end

@implementation ItemTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self.itemTextView setTextContainerInset:UIEdgeInsetsZero];
	self.iconsCollectionView.backgroundColor = [UIColor clearColor];
	self.iconsCollectionView.dataSource = self;
	self.iconsCollectionView.delegate = self;	
	[self.iconsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([IconCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([IconCollectionViewCell class])];
}

- (void)prepareForReuse
{
	self.itemStateButton.hidden = YES;
	self.itemImageView.image = nil;
    self.avatarImageView.layer.cornerRadius = 0;
}

#pragma mark - Info

- (void)setCellItem:(ItemModel *)cellItem
{
	_cellItem = cellItem;
	[self updateContent];
}

- (void)updateContent
{
	self.backgroundColor = [UIColor mainPageBGColor];
	self.distanceLabel.text = self.cellItem.distance;
	self.timeAgoLabel.text = [self stringWithTimeAgoForItem];
	
	if (self.cellItem.userCompanyName.length) {
		self.usernameLabel.text = self.cellItem.userCompanyName;
	} else if (self.cellItem.userFullname.length) {
		self.usernameLabel.text = self.cellItem.userFullname;
	} else if (self.cellItem.userNickname.length) {
		self.usernameLabel.text = self.cellItem.userNickname;
	}
	
	if (self.cellItem.userAvatarThumbUrl) {
		[self.avatarImageView setImageWithURL:self.cellItem.userAvatarThumbUrl];
		self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.bounds) / 2;
	}
	
	if (self.cellItem.imagesUrl) {
		[self.itemImageView setImageWithURL:self.cellItem.imagesUrl];
		self.itemViewHeightConstraint.constant = [self heighOfImageViewForItem:self.cellItem];
	} else {
		self.itemViewHeightConstraint.constant = 0.0;
	}
	
	self.priceContainerHeightConstraint.constant = priceContainerHeigth;
	self.priceTitleLabel.text = self.cellItem.category.name;
	if (self.cellItem.category.hasPrice) {
		self.priceValueLabel.text = self.cellItem.price;
	} else {
		self.priceValueLabel.text = @"";
	}
	
	self.itemTextView.editable = YES;
	self.itemTextView.text = self.cellItem.text;
	self.itemTextView.font = [UIFont systemFontOfSize:15];
	self.itemTextView.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
	self.itemTextView.editable = NO;
	
	if ([self floatTimeAgo] < TwentyFourHours) {
		[self.itemStateButton setTitle:@"NEW" forState:UIControlStateNormal];
		self.itemStateButton.backgroundColor = [UIColor mainPageGreenColor];
		self.itemStateButton.hidden = NO;
		self.itemStateButton.layer.cornerRadius = 7;
	}
	
	UITapGestureRecognizer *userTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTap:)];
	[self.infoView addGestureRecognizer:userTapGesture];
    
    [self.iconsCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return iconCellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	IconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([IconCollectionViewCell class]) forIndexPath:indexPath];
	if (indexPath.item == FavoriteCellIndex) {
		self.favoriteCell = cell;
		if (self.cellItem.isFavorite) {
			cell.iconImageView.image = [UIImage imageNamed:@"FavoriteActive"];
		} else {
			cell.iconImageView.image = [UIImage imageNamed:@"FavoriteNotActive"];
		}
	} else if (indexPath.item == ChatCellIndex) {
		self.chatCell = cell;
		if (self.cellItem.isChatActive) {
			cell.iconImageView.image = [UIImage imageNamed:@"ChatActive"];
		} else {
			cell.iconImageView.image = [UIImage imageNamed:@"ChatNotActive"];
		}
	} else if (indexPath.item == ShareCellIndex) {
		self.shareCell = cell;
		cell.iconImageView.image = [UIImage imageNamed:@"Share"];
	} else if (indexPath.item == MoreCellIndex) {
		self.moreCell = cell;
		cell.iconImageView.image = [UIImage imageNamed:@"More"];
	}	
	return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	IconCollectionViewCell *cell = (IconCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
	if (indexPath.item == MoreCellIndex) {
		if ([self.delegate respondsToSelector:@selector(showActionSheetForItem:)]) {
			[self.delegate showActionSheetForItem:self.cellItem];
		}
	} else if (indexPath.item == FavoriteCellIndex) {
        [self setFavorite];
	} else if (indexPath.item == ChatCellIndex) {
		if (self.cellItem.isChatActive) {
			cell.iconImageView.image = [UIImage imageNamed:@"ChatNotActive"];
		} else {
			cell.iconImageView.image = [UIImage imageNamed:@"ChatActive"];
		}
		self.cellItem.isChatActive = !self.cellItem.isChatActive;
	} else if (indexPath.item == ShareCellIndex) {
        [self shareItem];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat averageWidth = CGRectGetWidth([UIScreen mainScreen].bounds) / (iconCellCount + 1);
	return CGSizeMake(averageWidth, iconCellHeigth);
}

#pragma mark - Utils

//- (NSString *)stringWithDistanceToItem
//{
//	CGFloat itemLatitude = [self.cellItem.latitude floatValue];
//	CGFloat itemLongitude = [self.cellItem.longitude floatValue];
//	CLLocation *itemLocation = [[CLLocation alloc] initWithLatitude:itemLatitude longitude:itemLongitude];
//	
//	CLLocationDistance distance = [[LocationManager sharedManager].currentLocation distanceFromLocation:itemLocation];
//	NSString *distanceString;
//	if (distance < 1000) {
//		distanceString = @"1 km";
//	} else {
//		distanceString = [NSString stringWithFormat:@"%0.1f km", (distance / 1000.0)];
//	}
//	return distanceString;
//}

- (NSString *)stringWithTimeAgoForItem
{
	NSTimeInterval timeAgo = [self floatTimeAgo];
	NSString *timeString;
	if (timeAgo < 60) {
		timeString = @"just now";
	} else if (timeAgo < 3600) {
		timeString = [NSString stringWithFormat:@"%.f min", timeAgo / 60];
	} else if (timeAgo < 86400) {
		timeString = [NSString stringWithFormat:@"%.f h", timeAgo / 3600];
	} else if (timeAgo < 2592000) {
		timeString = [NSString stringWithFormat:@"%.f d", timeAgo / 86400];
	} else if (timeAgo < 31104000) {
		timeString = [NSString stringWithFormat:@"%.f m", timeAgo / 2592000];
	} else {
		timeString = [NSString stringWithFormat:@"%.1f y", timeAgo / 2592000.0];
	}
	return timeString;
}

- (NSTimeInterval)floatTimeAgo
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.'SSS'Z'"];
	[dateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"UTC"]];
	NSDate *itemDate = [[NSDate alloc] init];
	if (self.cellItem.createdAt.length ) {
		itemDate = [dateFormatter dateFromString:self.cellItem.createdAt];
	} else {
		itemDate = [NSDate date];
	}
	NSTimeInterval timeAgo = [[NSDate date] timeIntervalSinceDate: itemDate];
	return timeAgo;
}

+ (CGFloat)itemCellHeightForItemModel:(ItemModel *)item
{
	CGFloat textViewHeigth = 0;
		ItemTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:ItemTableViewCell.ID owner:nil options:nil].firstObject;
	cell.cellItem = item;
	textViewHeigth = ceil([cell.itemTextView sizeThatFits:CGSizeMake(ScreenWidth - 32, MAXFLOAT)].height);

	CGFloat height = ItemTableViewCellHeigth + [cell heighOfImageViewForItem:item] + textViewHeigth + priceContainerHeigth;
	return height;
}

- (CGFloat)heighOfImageViewForItem:(ItemModel *)item
{
	CGFloat imageViewHeigth = 0;
	if (item.imagesUrl) {
		CGFloat ratio = item.imageHeight / item.imageWidth;
		imageViewHeigth = (ScreenWidth - 32) * ratio;
	}
	return imageViewHeigth;
}

#pragma mark - Actions

- (void)userTap:(UITapGestureRecognizer *)sender
{
	if ([self.delegate respondsToSelector:@selector(showUserForItem:)]) {
		[self.delegate showUserForItem:self.cellItem];
	}
}

- (void)shareItem
{
    NSMutableArray *shareItems = [NSMutableArray array];
    if (self.itemImageView.image) {
        [shareItems addObject:self.itemImageView.image];
    }
    NSString *shareText = [self.cellItem.text stringByAppendingFormat:@". %@. There will be a link to the item. #bulletina", self.cellItem.price];
    [shareItems addObject:shareText];
    UIActivityViewController *shareVC = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    shareVC.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (activityError) {
            DLog(@"Sharing error: %@", activityError);
        }
    };
    [[Utils topViewController] presentViewController:shareVC animated:YES completion:nil];
}

- (void)setFavorite
{
    [self.favouritesTask cancel];
    __weak typeof(self) weakSelf = self;
    void (^completion)(BOOL) = ^(BOOL isFavourite) {
        UIImage *image = isFavourite ? [UIImage imageNamed:@"FavoriteActive"] : [UIImage imageNamed:@"FavoriteNotActive"];
        weakSelf.cellItem.isFavorite = isFavourite;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.favoriteCell.iconImageView.image = image;
        });
    };
    if (self.cellItem.isFavorite) {
        self.favoriteCell.iconImageView.image = [UIImage imageNamed:@"FavoriteNotActive"];
        self.cellItem.isFavorite = NO;
        self.favouritesTask = [[APIClient sharedInstance] removeFavoriteItemId:self.cellItem.itemId withCompletion:^(id response, NSError *error, NSInteger statusCode) {
            completion(error);
        }];
    } else {
        self.favoriteCell.iconImageView.image = [UIImage imageNamed:@"FavoriteActive"];
        self.cellItem.isFavorite = YES;
        self.favouritesTask = [[APIClient sharedInstance] addFavoriteItemId:self.cellItem.itemId withCompletion:^(id response, NSError *error, NSInteger statusCode) {
            completion(!error);
        }];
    }
}

@end
