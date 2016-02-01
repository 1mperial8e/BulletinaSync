//
//  ItemsListTableViewController.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ItemTableViewCell.h"

@interface ItemsListTableViewController : UITableViewController

//@property (assign, nonatomic) UserAccountType profileType;

- (CGFloat)itemCellHeightForText:(NSString *)text andImage:(UIImage *)image;
- (CGFloat)heighOfImageViewForImage:(UIImage *)image;

- (void)tableViewSetup;
- (void)setupNavigationBar;

- (void)itemImageTap:(UITapGestureRecognizer *)sender;

@end
