//
//  BusinessProfileLogoTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BusinessProfileLogoTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UITextView *companyDescriptionTextView;
@property (weak, nonatomic) UserModel *user;

@end
