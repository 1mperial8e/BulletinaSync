//
//  EditProfileAboutTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface EditProfileAboutTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomInsetConstraint;

@end
