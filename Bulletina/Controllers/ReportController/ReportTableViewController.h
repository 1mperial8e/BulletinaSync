//
//  ReportTableViewController.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

@interface ReportTableViewController : UITableViewController

@property (assign, nonatomic) NSInteger reportedItemId;
@property (assign, nonatomic) NSInteger reportedUserId;

- (instancetype)initWithItemId:(NSInteger)itemId andUserId:(NSInteger)userId;

@end
