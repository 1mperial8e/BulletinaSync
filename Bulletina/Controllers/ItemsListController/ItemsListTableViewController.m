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

static CGFloat const ItemTableViewCellHeigth = 148.0f;

@interface ItemsListTableViewController ()

@end

@implementation ItemsListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (CGFloat)itemCellHeightForText:(NSString *)text andImage:(UIImage *)image
{
	CGFloat textViewHeigth = 0;
	ItemTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:ItemTableViewCell.ID owner:nil options:nil].firstObject;
    cell.itemTextView.editable = YES;
    cell.itemTextView.text = text;
    cell.itemTextView.editable = NO;
	[cell.itemTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	textViewHeigth = ceil([cell.itemTextView sizeThatFits:CGSizeMake(ScreenWidth - 32, MAXFLOAT)].height);
	return ItemTableViewCellHeigth + [self heighOfImageViewForImage:image] + textViewHeigth;
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
