//
//  BusinessProfileLogoTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BusinessProfileLogoTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyPhoneLabel;
@property (weak, nonatomic) IBOutlet UITextView *companyDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *linkedInButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkedinLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *websiteTrailingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *websiteWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *facebookWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkedinWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsContainerHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneContainerHeightConstraint;



@end
