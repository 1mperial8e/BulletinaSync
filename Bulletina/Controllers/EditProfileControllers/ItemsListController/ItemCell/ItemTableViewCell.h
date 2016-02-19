//
//  ItemTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

@protocol ItemCellDelegate <NSObject>

@optional

- (void)showActionSheetWithItemCell:(id)cell;

@end

#import "BaseTableViewCell.h"
#import "ItemModel.h"

//Categories
#import "UIImageView+AFNetworking.h"

static CGFloat const priceContainerHeigth = 43.0f;
static CGFloat const ItemTableViewCellHeigth = 105.0f;

@interface ItemTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *iconsCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *itemStateButton;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
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
@property (weak, nonatomic) id<ItemCellDelegate> delegate;
@property (weak, nonatomic) ItemModel *cellItem;

//temp
@property (strong, nonatomic) UIImage *itemImage;

+ (CGFloat)itemCellHeightForItemModel:(ItemModel *)item;

@end
