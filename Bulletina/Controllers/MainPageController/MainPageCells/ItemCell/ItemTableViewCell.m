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

@end

@implementation ItemTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib
{
	[super awakeFromNib];
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


@end
