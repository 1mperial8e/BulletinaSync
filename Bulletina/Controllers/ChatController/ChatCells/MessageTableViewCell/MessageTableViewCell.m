//
//  MessageTableViewCell.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "MessageTableViewCell.h"

static CGFloat const DefaultBorderWidth = 1.f;
static CGFloat const MessageFontSize    = 14.f;

@interface MessageTableViewCell ()

@property (strong, nonatomic) MessageLabel *messageLabel;
@property (strong, nonatomic) UIImageView  *messageAvatar;
@property (strong, nonatomic) CAShapeLayer *tailLayer;

@end

@implementation MessageTableViewCell

#pragma mark - Initialization

- (instancetype)initCellWithReuseIdentifier:(NSString *)identifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) {
        [self setup];
    }
    return self;
}

#pragma mark - Lifecycle

- (void)dealloc
{
    self.messageLabel = nil;
    self.messageAvatar = nil;
    self.tailLayer = nil;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
   
    [self.messageLabel removeFromSuperview];
    [self.messageAvatar removeFromSuperview];
    [self.tailLayer removeFromSuperlayer];
    
    [self.messageLabel removeConstraints:self.messageLabel.constraints];
    [self.messageAvatar removeConstraints:self.messageAvatar.constraints];
}

#pragma mark - Setup

- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.messageLabel = [MessageLabel new];
    self.messageLabel.backgroundColor = [UIColor whiteColor];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont systemFontOfSize:MessageFontSize];
    self.messageLabel.layer.borderWidth = DefaultBorderWidth;
    UIColor *borderColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1];
    self.messageLabel.layer.borderColor = borderColor.CGColor;
    
    self.messageAvatar = [UIImageView new];
    self.messageAvatar.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageAvatar.backgroundColor = [UIColor whiteColor];
    
    self.tailLayer = [CAShapeLayer new];
    self.tailLayer.strokeColor = borderColor.CGColor;
    self.tailLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.messageAvatar];
    [self.contentView addSubview:self.messageLabel];
}

#pragma mark - Public Methods

- (void)configureCellWithMessageType:(MessageType)type;
{
    [self.contentView addSubview:self.messageAvatar];
    [self.contentView addSubview:self.messageLabel];
    
    NSDictionary *views = @{
                            @"avatar":self.messageAvatar,
                            @"message":self.messageLabel
                            };
    NSDictionary *metrics = @{
                                 @"avatarTopMargin":@12,
                                    @"avatarHeight":@34,
                                @"messageTopMargin":@16,
                             @"messageBottomMargin":@0
                            };
    
    if (type == MessageTypeIncoming) {
       [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[avatar(==avatarHeight)]-15-[message]-10-|"
                                                                                                            options:0
                                                                                                            metrics:metrics
                                                                                                              views:views]];
    } else if (type == MessageTypeOutgoing) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[message]-15-[avatar(==avatarHeight)]-10-|"
                                                                                                                                 options:0
                                                                                                                                 metrics:metrics
                                                                                                                                   views:views]];
    }
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-avatarTopMargin-[avatar(==avatarHeight)]"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-messageTopMargin-[message]-messageBottomMargin-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:views]];
    
    [self layoutIfNeeded];
    
    self.messageAvatar.layer.cornerRadius = CGRectGetHeight(self.messageAvatar.bounds) / 2;
    self.messageAvatar.layer.masksToBounds = YES;
    
    self.messageLabel.layer.cornerRadius = 6.f;
    self.messageLabel.layer.masksToBounds = YES;
    
    CGFloat tailWeight = 10.f;
    CGFloat tailHeight = 8.f;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(tailWeight , 0.f)];
    [maskPath addLineToPoint:CGPointMake(0.f, tailHeight / 2.f)];
    [maskPath addLineToPoint:CGPointMake(tailWeight , tailHeight)];
    
    if (type == MessageTypeIncoming) {
        self.tailLayer.frame = CGRectMake(CGRectGetMinX(self.messageLabel.frame) - tailWeight + DefaultBorderWidth, CGRectGetMinY(self.messageLabel.frame) + 10, tailWeight, tailHeight);
        self.tailLayer.transform =  CATransform3DMakeRotation(0, 0, 0, 0);
    } else if (type == MessageTypeOutgoing) {
        self.tailLayer.frame = CGRectMake(CGRectGetMaxX(self.messageLabel.frame) - DefaultBorderWidth, CGRectGetMinY(self.messageLabel.frame) + 10, tailWeight, tailHeight);
        self.tailLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    }
    
    self.tailLayer.path = maskPath.CGPath;
    [self.contentView.layer addSublayer:self.tailLayer];
}

@end
