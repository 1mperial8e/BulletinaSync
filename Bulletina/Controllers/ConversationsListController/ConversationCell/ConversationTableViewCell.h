//
//  ConversationTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/21/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ConversationTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageCreateDateLabel;
@property (weak, nonatomic) IBOutlet UIView *badgeView;

@end
