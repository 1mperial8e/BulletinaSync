//
//  ItemTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

@protocol ItemCellDelegate <NSObject>

@optional

- (void)showActionSheetForItem:(id)item;
- (void)showUserForItem:(id)item;
- (void)openMessagesForItem:(id)item;

@end

#import "BaseTableViewCell.h"
#import "ItemModel.h"
#import "IconCollectionViewCell.h"

//Categories
#import "UIImageView+AFNetworking.h"

@interface ItemTableViewCell : BaseTableViewCell

@property (weak, nonatomic) id<ItemCellDelegate> delegate;
@property (weak, nonatomic) ItemModel *cellItem;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

+ (CGFloat)itemCellHeightForItemModel:(ItemModel *)item;

@end
