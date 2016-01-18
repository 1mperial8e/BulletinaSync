//
//  ItemTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ItemTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *iconsCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *itemStateButton;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

@end
