//
//  ReportReasonModel.h
//  Bulletina
//
//  Created by Stas Volskyi on 2/10/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseModel.h"

@interface ReportReasonModel : BaseModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) NSInteger reasonId;
@property (assign, nonatomic) BOOL active;

@end
