//
//  BusinessLogoTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BusinessLogoTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectLogoButton;
@property (weak, nonatomic) IBOutlet UIButton *selectAvatarButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end
