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

//Temp
@property (strong, nonatomic) NSString *itemText;
@property (strong, nonatomic) UIImage *itemImage;
@property (assign, nonatomic) BOOL itemHasPrice;

- (CGFloat)itemCellHeightForText:(NSString *)text andImage:(UIImage *)image;
- (CGFloat)heighOfImageViewForImage:(UIImage *)image;

- (void)tableViewSetup;
- (void)setupNavigationBar;

- (void)itemImageTap:(UITapGestureRecognizer *)sender;
- (ItemTableViewCell *)defaultCellForIndexPath:(NSIndexPath *)indexPath;


@end
