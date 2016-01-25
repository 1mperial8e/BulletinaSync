//
//  MessageTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MessageLabel.h"

typedef NS_ENUM(NSUInteger, MessageType){
    MessageTypeUnknown,
    MessageTypeIncoming,
    MessageTypeOutgoing
};

@interface MessageTableViewCell : BaseTableViewCell

- (instancetype)initCellWithReuseIdentifier:(NSString *)identifier;
- (void)configureCellWithMessageType:(MessageType)type;

@end
