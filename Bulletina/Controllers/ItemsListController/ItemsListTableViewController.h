//
//  ItemsListTableViewController.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Controllers
#import "ProfileTableViewController.h"
#import "SelectNewAdCategoryTableViewController.h"
#import "FullScreenImageViewController.h"

//Views
#import "BulletinaLoaderView.h"
#import "ItemTableViewCell.h"

//Models
#import "ItemModel.h"
#import "APIClient+Item.h"

//Categories
#import "UIImageView+AFNetworking.h"

@interface ItemsListTableViewController : UITableViewController

@property (strong, nonatomic) BulletinaLoaderView *loader;
@property (strong, nonatomic) NSArray *itemsList;

////Temp
@property (strong, nonatomic) UIImage *itemImage;

- (CGFloat)itemCellHeightForText:(NSString *)text andImage:(UIImage *)image;
- (CGFloat)heighOfImageViewForImage:(UIImage *)image;

- (void)tableViewSetup;
- (void)setupNavigationBar;

- (void)itemImageTap:(UITapGestureRecognizer *)sender;
- (ItemTableViewCell *)defaultCellForIndexPath:(NSIndexPath *)indexPath forMyItems:(BOOL)myItems;

#pragma mark - API

- (void)fetchItemListWithLoader:(BOOL)needLoader;


@end
