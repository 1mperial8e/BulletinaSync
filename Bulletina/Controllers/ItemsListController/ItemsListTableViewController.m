//
//  ItemsListTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ItemsListTableViewController.h"
#import "ProfileTableViewController.h"
#import "SelectNewAdCategoryTableViewController.h"
#import "FullScreenImageViewController.h"

static CGFloat const ItemTableViewCellHeigth = 105.0f;
static CGFloat const priceContainerHeigth = 43.0f;

@interface ItemsListTableViewController ()

@end

@implementation ItemsListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.loader = [[BulletinaLoaderView alloc] initWithView:self.navigationController.view andText:nil];
	[self fetchItemList];
//	//Temp
//	self.cellItem = [ItemModel new];	
//	self.cellItem.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur ci l li um adi pis ici ng pe cu, sed do eiu smod tempor.	ipsum dolor sit er elit lamet, consectetaur c i ll iu m adipisicing pecu, sed do eiusmod tempor dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor. sed do eiusmod tempor.";
//	self.cellItem.category.hasPrice = YES;
//	
	self.itemImage = [UIImage imageNamed:@"ItemExample"];
}
	
#pragma mark - API

- (void)fetchItemList
{
	[self.loader show];
	__weak typeof(self) weakSelf = self;
	[[APIClient sharedInstance] fetchItemsWithOffset:@0 limit:@35 withCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (error) {
			if (response[@"error_message"]) {
				[Utils showErrorWithMessage:response[@"error_message"]];
			} else {
				[Utils showErrorForStatusCode:statusCode];
			}
		} else {
			NSAssert([response isKindOfClass:[NSArray class]], @"Unknown response from server");
			self.itemsList = [ItemModel arrayWithDictionariesArray:response];
			[self.tableView reloadData];
			//			UserModel *generatedUser = [UserModel modelWithDictionary:response[@"user"]];
			//			[Utils storeValue:response[@"user"] forKey:CurrentUserKey];
			//			[[APIClient sharedInstance] updateCurrentUser:generatedUser];
			//			[[APIClient sharedInstance] updatePasstokenWithDictionary:response];
			//			dispatch_async(dispatch_get_main_queue(), ^{
			//				[weakSelf showMainPageAnimated:YES];
			//			});
		}
		[weakSelf.loader hide];
	}];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.itemsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self defaultCellForIndexPath:indexPath];
}

#pragma mark - Cells

- (ItemTableViewCell *)defaultCellForIndexPath:(NSIndexPath *)indexPath
{
	ItemTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	
//	cell.itemImageView.image = self.itemImage;
	if (((ItemModel *)self.itemsList[indexPath.item]).imagesUrl.length) {
		[cell.itemImageView setImageWithURL:[NSURL URLWithString:((ItemModel *)self.itemsList[indexPath.item]).imagesUrl]];
	}
	cell.itemViewHeightConstraint.constant = [self heighOfImageViewForImage:cell.itemImageView.image];
	[self.view layoutIfNeeded];
	
	if (indexPath.item % 2) {
		[cell.itemStateButton setTitle:@"NEW" forState:UIControlStateNormal];
		cell.itemStateButton.backgroundColor = [UIColor mainPageGreenColor];
		cell.itemStateButton.hidden = NO;
	}
	if (((ItemModel *)self.itemsList[indexPath.item]).category.hasPrice) {
		cell.priceContainerHeightConstraint.constant = priceContainerHeigth;
		cell.priceValueLabel.text = ((ItemModel *)self.itemsList[indexPath.item]).price;
		cell.priceTitleLabel.text = ((ItemModel *)self.itemsList[indexPath.item]).category.name;
	} else {
		cell.priceContainerHeightConstraint.constant = 0.0;
	}
	
	[cell.itemTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	cell.itemTextView.editable = YES;
	cell.itemTextView.text = ((ItemModel *)self.itemsList[indexPath.item]).text;
	cell.itemTextView.editable = NO;
	UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemImageTap:)];
	[cell.itemImageView addGestureRecognizer:imageTapGesture];
	
	cell.itemStateButton.layer.cornerRadius = 7;
	return cell;
}

#pragma mark - Actions

- (void)itemImageTap:(UITapGestureRecognizer *)sender
{
	if (((UIImageView *)sender.view).image) {
		CGRect cellFrame = [self.navigationController.view convertRect:sender.view.superview.superview.frame fromView:self.tableView];
		CGRect imageViewRect = sender.view.frame;
		imageViewRect.origin.x = ([UIScreen mainScreen].bounds.size.width - imageViewRect.size.width) / 2;
		imageViewRect.origin.y = cellFrame.origin.y + CGRectGetHeight(self.navigationController.navigationBar.frame);
		
		FullScreenImageViewController *imageController = [FullScreenImageViewController new];
		imageController.image = ((UIImageView *)sender.view).image;
		imageController.presentationRect = imageViewRect;
		imageController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
		[self.navigationController presentViewController:imageController animated:NO completion:nil];
	}
}

#pragma mark - Utils

- (CGFloat)itemCellHeightForText:(NSString *)text andImage:(UIImage *)image hasPrice:(BOOL)hasPrice
{
	CGFloat textViewHeigth = 0;
	ItemTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:ItemTableViewCell.ID owner:nil options:nil].firstObject;
    cell.itemTextView.editable = YES;
    cell.itemTextView.text = text;
    cell.itemTextView.editable = NO;
	[cell.itemTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	textViewHeigth = ceil([cell.itemTextView sizeThatFits:CGSizeMake(ScreenWidth - 32, MAXFLOAT)].height);
	return ItemTableViewCellHeigth + [self heighOfImageViewForImage:image] + textViewHeigth + (hasPrice ? priceContainerHeigth : 0.0);
}

- (CGFloat)heighOfImageViewForImage:(UIImage *)image
{
	CGFloat imageViewHeigth = 0;
	if (image) {
		CGFloat ratio = image.size.height / image.size.width;
		imageViewHeigth = (ScreenWidth - 32) * ratio;
	}
	return imageViewHeigth;
}

#pragma mark - Setup

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	[self.tableView registerNib:ItemTableViewCell.nib forCellReuseIdentifier:ItemTableViewCell.ID];
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupNavigationBar
{
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	[self.navigationController.navigationBar
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appOrangeColor]}];
}

@end
