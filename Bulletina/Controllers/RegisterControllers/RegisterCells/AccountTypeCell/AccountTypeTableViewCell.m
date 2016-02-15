//
//  AccountTypeTableViewCell.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/20/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "AccountTypeTableViewCell.h"

@interface AccountTypeTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopImageView;

@property (weak, nonatomic) IBOutlet UIImageView *accountImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreInfoButton;

@end

@implementation AccountTypeTableViewCell

#pragma mark - Public Methods

- (void)configureCellForTitle:(NSString *)title imageName:(NSString *)imageName
{
    self.titleLabel.text = title;
    self.accountImageView.image = [UIImage imageNamed:imageName];
}

- (void)hideMoreInfoButton:(BOOL)hide
{
    [self.moreInfoButton setHidden:hide];
    
    self.constraintTopImageView.constant = hide ? 22.f :4.f;
}

#pragma mark - IBActions

- (IBAction)moreInfoButtonTouchUpInside:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pressMoreInfoButton)]) {
        [self.delegate performSelector:@selector(pressMoreInfoButton) withObject:nil];
    }
}

@end
