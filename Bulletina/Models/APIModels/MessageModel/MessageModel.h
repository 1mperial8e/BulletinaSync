//
//  MessageModel.h
//  Bulletina
//
//  Created by Stas Volskyi on 2/10/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"

@interface MessageModel : BaseModel

@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UserModel *relatedUser;
@property (assign, nonatomic) BOOL isRead;

@end
