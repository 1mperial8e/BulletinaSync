//
//  MessageTableViewCell.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/21/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelMassage;
@property (weak, nonatomic) IBOutlet UILabel *labelBadge;

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
    self.imageViewAvatar.layer.cornerRadius = CGRectGetWidth(self.imageViewAvatar.bounds) / 2;
    self.imageViewAvatar.layer.masksToBounds = YES;
    self.labelBadge.layer.cornerRadius = CGRectGetHeight(self.labelBadge.bounds) / 2;
    self.labelBadge.layer.masksToBounds = YES;
    
    //TODO: delete
    self.labelBadge.text = [NSString stringWithFormat:@"%d", arc4random_uniform(10)];
}

@end
