//
//  ItemTableViewCell.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "IconCollectionViewCell.h"

static CGFloat const iconCellHeigth = 20;
static CGFloat const iconCellCount = 4;

typedef NS_ENUM(NSUInteger, iconCellsIndexes) {
	FavoriteCellIndex,
	ChatCellIndex,
	ShareCellIndex,
	MoreCellIndex,
};

@interface ItemTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (NSString *)stringWithDistanceToItem;
- (NSString *)stringWithTimeAgoForItem;
- (CGFloat)heighOfImageViewForImage:(UIImage *)image;
- (void)updateContent;

@end

@implementation ItemTableViewCell

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		//temp
		self.itemImage = [UIImage imageNamed:@"ItemExample"];
	}
	return  self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self.itemTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	self.iconsCollectionView.backgroundColor = [UIColor clearColor];
	self.iconsCollectionView.dataSource = self;
	self.iconsCollectionView.delegate = self;	
	[self.iconsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([IconCollectionViewCell class])
													bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([IconCollectionViewCell class])];
}

- (void)prepareForReuse
{
	self.itemStateButton.hidden = YES;
	self.itemImageView.image = nil;
	self.itemViewHeightConstraint.constant = 0.0;
	self.priceContainerHeightConstraint.constant = 0.0;
}

- (void)setCellItem:(ItemModel *)cellItem
{
	_cellItem = cellItem;
	[self updateContent];
}

- (void)updateContent
{
	self.backgroundColor = [UIColor mainPageBGColor];
	self.distanceLabel.text = [self stringWithDistanceToItem];
	self.timeAgoLabel.text = [self stringWithTimeAgoForItem];
	
	if (self.cellItem.userNickname.length) {
		self.usernameLabel.text = self.cellItem.userNickname;
	}
	
	if (self.cellItem.userAvatarThumbUrl.length) {
		[self.avatarImageView setImageWithURL:[NSURL URLWithString:self.cellItem.userAvatarThumbUrl]];
		self.avatarImageView.layer.cornerRadius = 7;
	}
	
	if (self.cellItem.imagesUrl.length) {
		[self.itemImageView setImageWithURL:[NSURL URLWithString:self.cellItem.imagesUrl]];
		self.itemViewHeightConstraint.constant = [self heighOfImageViewForImage:self.itemImage];
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
	
	if ([self floatTimeAgo] < 86400) {
		[self.itemStateButton setTitle:@"NEW" forState:UIControlStateNormal];
		self.itemStateButton.backgroundColor = [UIColor mainPageGreenColor];
		self.itemStateButton.hidden = NO;
		self.itemStateButton.layer.cornerRadius = 7;
	}
	[self layoutIfNeeded];
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
		cell.iconImageView.image = [UIImage imageNamed:@"FavoriteNotActive"];
	} else if (indexPath.item == ChatCellIndex) {
		cell.iconImageView.image = [UIImage imageNamed:@"ChatNotActive"];
	} else if (indexPath.item == ShareCellIndex) {
		cell.iconImageView.image = [UIImage imageNamed:@"Share"];
	} else if (indexPath.item == MoreCellIndex) {
		cell.iconImageView.image = [UIImage imageNamed:@"More"];
	}	
	return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item == FavoriteCellIndex) {
	}
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat averageWidth = CGRectGetWidth([UIScreen mainScreen].bounds) / (iconCellCount + 1);
	return CGSizeMake(averageWidth, iconCellHeigth);
}

#pragma mark - Utils

- (NSString *)stringWithDistanceToItem
{
	CLLocation *homeLocation = [[CLLocation alloc] initWithLatitude:[LocationManager sharedManager].currentLocation.coordinate.latitude longitude:[LocationManager sharedManager].currentLocation.coordinate.longitude];
	CGFloat itemLatitude = [self.cellItem.latitude floatValue];
	CGFloat itemLongitude = [self.cellItem.longitude floatValue];
	CLLocation *itemLocation = [[CLLocation alloc] initWithLatitude:itemLatitude longitude:itemLongitude];
	
	CLLocationDistance distance = [homeLocation distanceFromLocation:itemLocation];
	NSString *distanceString;
	if (distance < 1000) {
		distanceString = @"1 km";
	} else {
		distanceString = [NSString stringWithFormat:@"%0.1f km", (distance / 1000.0)];
	}
	return distanceString;
}

- (NSString *)stringWithTimeAgoForItem
{
	NSTimeInterval timeAgo = [self floatTimeAgo];
	NSString *timeString;
	if (timeAgo < 60) {
		timeString = @"now";
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
	
	UIImage *sizeImage;
	if (cell.cellItem.imagesUrl.length) {
		sizeImage = cell.itemImage;
	} else {
		sizeImage = nil;
	}
	CGFloat height = ItemTableViewCellHeigth + [cell heighOfImageViewForImage:sizeImage] + textViewHeigth + priceContainerHeigth;
	return height;
}

- (CGFloat)heighOfImageViewForImage:(UIImage *)image
{
	CGFloat imageViewHeigth = 0;
	if (image) {
		CGFloat ratio = image.size.height / image.size.width;
		imageViewHeigth = (ScreenWidth - 32) * ratio;
	}
	return imageViewHeigth;
}

@end
