//
//  EditProfileAboutTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "PHTextView.h"

@interface EditProfileAboutTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet PHTextView *aboutTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomInsetConstraint;
@property (assign, nonatomic) BOOL isEdited;

@end
