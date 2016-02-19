//
//  AddNewItemTableViewController.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "CategoryModel.h"
#import "ItemModel.h"

@interface AddNewItemTableViewController : UITableViewController

@property (strong, nonatomic) CategoryModel *category;
@property (weak, nonatomic) ItemModel *adItem;

@end
