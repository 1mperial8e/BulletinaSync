//
//  MessageTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/21/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MessageTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageCreateDateLabel;


@end
