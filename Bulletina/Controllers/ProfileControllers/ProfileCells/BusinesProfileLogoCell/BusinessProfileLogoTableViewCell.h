//
//  BusinessProfileLogoTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BusinessProfileLogoTableViewCell : BaseTableViewCell

@property (weak, nonatomic) UserModel *user;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

+ (CGFloat)heightForBusinessLogoCellWithUser:(UserModel *)user;

@end
