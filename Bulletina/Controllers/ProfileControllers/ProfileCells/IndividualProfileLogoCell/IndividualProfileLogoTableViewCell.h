//
//  IndividualProfileLogoTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface IndividualProfileLogoTableViewCell : BaseTableViewCell

@property (weak, nonatomic) UserModel *user;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

+ (CGFloat)heightForIndividualAvatarCellWithUser:(UserModel *)user;

@end
