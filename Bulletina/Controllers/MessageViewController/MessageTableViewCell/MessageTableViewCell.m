//
//  MessageTableViewCell.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/21/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end

@implementation MessageTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self prepareUI];
}

#pragma mark - Layout

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

#pragma mark - Private Methods

- (void)prepareUI
{
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.bounds) / 2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.badgeLabel.layer.cornerRadius = CGRectGetHeight(self.badgeLabel.bounds) / 2;
    self.badgeLabel.layer.masksToBounds = YES;
    
    //TODO: delete
    self.badgeLabel.text = [NSString stringWithFormat:@"%d", arc4random_uniform(10)];
}

@end
