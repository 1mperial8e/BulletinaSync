//
//  ReportTableViewController.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ReportReasonModel.h"

@interface ReportTableViewController : UITableViewController

@property (assign, nonatomic) NSInteger reportedItemId;
@property (assign, nonatomic) NSInteger reportedUserId;
@property (strong, nonatomic) ReportReasonModel *reasonModel;

- (instancetype)initWithItemId:(NSInteger)itemId andUserId:(NSInteger)userId;

@end
