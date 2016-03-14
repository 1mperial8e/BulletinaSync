//
//  MyItemsTableViewController.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//
#import "ItemsListTableViewController.h"

@interface MyItemsTableViewController : ItemsListTableViewController

@property (strong, nonatomic) UserModel *user;
@property (strong, nonatomic) ItemModel *item;

@end
