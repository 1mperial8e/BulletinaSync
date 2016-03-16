//
//  ConversationModel.h
//  Bulletina
//
//  Created by Stas Volskyi on 2/10/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseModel.h"
#import "MessageModel.h"
#import "ItemModel.h"

@interface ConversationModel : BaseModel

@property (assign, nonatomic) NSInteger conversationId;
@property (assign, nonatomic) NSInteger unreadMessagesCount;
@property (strong, nonatomic) ItemModel *relatedPost;
@property (strong, nonatomic) MessageModel *lastMessage;

@end
