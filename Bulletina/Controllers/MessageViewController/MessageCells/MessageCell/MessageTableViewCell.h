//
//  MessageTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/21/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

@protocol MessageCellDelegate <NSObject>

@optional

- (void)showUser:(id)user;

@end

#import "BaseTableViewCell.h"
#import "MessageModel.h"

@interface MessageTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageCreateDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) id<MessageCellDelegate> delegate;
@property (strong, nonatomic) MessageModel *message;

@end
