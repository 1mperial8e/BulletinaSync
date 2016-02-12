//
//  ItemsListTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//
#import "ItemsListTableViewController.h"

static CGFloat const ItemTableViewCellHeigth = 105.0f;
static CGFloat const priceContainerHeigth = 43.0f;

@interface ItemsListTableViewController ()

@end

@implementation ItemsListTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.loader = [[BulletinaLoaderView alloc] initWithView:self.navigationController.view andText:nil];
	[self fetchItemListWithLoader:YES];

	self.itemImage = [UIImage imageNamed:@"ItemExample"];
}
	
#pragma mark - API

- (void)fetchItemListWithLoader:(BOOL)needLoader
{
	if (needLoader) {
		[self.loader show];
	}
	__weak typeof(self) weakSelf = self;
	[[APIClient sharedInstance] fetchItemsWithOffset:@50 limit:@85 withCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (error) {
			if (response[@"error_message"]) {
				[Utils showErrorWithMessage:response[@"error_message"]];
			} else {
                DLog(@"%@", error);
			}
		} else {
			NSAssert([response isKindOfClass:[NSArray class]], @"Unknown response from server");
			weakSelf.itemsList = [ItemModel arrayWithDictionariesArray:response];
			[weakSelf.tableView reloadData];
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
	return [self defaultCellForIndexPath:indexPath forMyItems:NO];
}

#pragma mark - Cells

- (ItemTableViewCell *)defaultCellForIndexPath:(NSIndexPath *)indexPath forMyItems:(BOOL)myItems
{
	ItemTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	
	NSInteger dataIndex = myItems ? indexPath.item -1 : indexPath.item;
	
	cell.distanceLabel.text = [self stringWithDistanceToItem:self.itemsList[dataIndex]];
	cell.timeAgoLabel.text = [self stringWithTimeAgoForItem:self.itemsList[dataIndex]];
	
	if (((ItemModel *)self.itemsList[dataIndex]).imagesUrl.length) {
		[cell.itemImageView setImageWithURL:[NSURL URLWithString:((ItemModel *)self.itemsList[dataIndex]).imagesUrl]];
		cell.itemViewHeightConstraint.constant = [self heighOfImageViewForImage:self.itemImage];
	} else {
		cell.itemViewHeightConstraint.constant = 0.0;
	}
	cell.priceContainerHeightConstraint.constant = priceContainerHeigth;
	cell.priceTitleLabel.text = ((ItemModel *)self.itemsList[dataIndex]).category.name;
	if (((ItemModel *)self.itemsList[dataIndex]).category.hasPrice) {
		cell.priceValueLabel.text = ((ItemModel *)self.itemsList[dataIndex]).price;
	} else {
		cell.priceValueLabel.text = @"";
	}
	[self.view layoutIfNeeded];
	
	if (dataIndex % 2) {
		[cell.itemStateButton setTitle:@"NEW" forState:UIControlStateNormal];
		cell.itemStateButton.backgroundColor = [UIColor mainPageGreenColor];
		cell.itemStateButton.hidden = NO;
	}
	[cell.itemTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	cell.itemTextView.editable = YES;
	cell.itemTextView.text = ((ItemModel *)self.itemsList[dataIndex]).text;
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

- (NSString *)stringWithDistanceToItem:(ItemModel *)item
{
	CLLocation *homeLocation = [[CLLocation alloc] initWithLatitude:[LocationManager sharedManager].currentLocation.coordinate.latitude longitude:[LocationManager sharedManager].currentLocation.coordinate.longitude];
	CGFloat itemLatitude = [item.latitude floatValue];
	CGFloat itemLongitude = [item.longitude floatValue];
	CLLocation *itemLocation = [[CLLocation alloc] initWithLatitude:itemLatitude longitude:itemLongitude];
	
	CLLocationDistance distance = [homeLocation distanceFromLocation:itemLocation];
	NSString *distanceString;
	if (distance < 1000) {
		distanceString = [NSString stringWithFormat:@"%.f m", distance];
	} else {
		distanceString = [NSString stringWithFormat:@"%0.1f km", (distance / 1000.0)];
	}
	return distanceString;
}

- (NSString *)stringWithTimeAgoForItem:(ItemModel *)item
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.'SSS'Z'"];
	[dateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"UTC"]];
	NSDate *itemDate = [[NSDate alloc] init];
	itemDate = [dateFormatter dateFromString:item.createdAt];
	
	NSTimeInterval timeAgo = [[NSDate date] timeIntervalSinceDate: itemDate];
	NSString *timeString;
	if (timeAgo < 60) {
		timeString = @"now";
	} else if (timeAgo < 3600) {
		timeString = [NSString stringWithFormat:@"%.f m", timeAgo / 60];
	} else if (timeAgo < 86400) {
		timeString = [NSString stringWithFormat:@"%.f h", timeAgo / 3600];
	} else if (timeAgo < 259200) {
		timeString = [NSString stringWithFormat:@"%.f d", timeAgo / 86400];
	} else {
		timeString = [NSString stringWithFormat:@"%.1f y", timeAgo / 259200.0];
	}
	return timeString;
}

- (CGFloat)itemCellHeightForText:(NSString *)text andImage:(UIImage *)image
{
	CGFloat textViewHeigth = 0;
	ItemTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:ItemTableViewCell.ID owner:nil options:nil].firstObject;
    cell.itemTextView.editable = YES;
    cell.itemTextView.text = text;
    cell.itemTextView.editable = NO;
	[cell.itemTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	textViewHeigth = ceil([cell.itemTextView sizeThatFits:CGSizeMake(ScreenWidth - 32, MAXFLOAT)].height);
	return ItemTableViewCellHeigth + [self heighOfImageViewForImage:image] + textViewHeigth + priceContainerHeigth;
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
