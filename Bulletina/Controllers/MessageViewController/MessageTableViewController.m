//
//  MessageTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/21/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Conrtollers
#import "MessageTableViewController.h"
#import "MyItemsTableViewController.h"

//Cells
#import "MessageTableViewCell.h"
#import "ItemInfoTableViewCell.h"

//Models
#import "APIClient+Message.h"

//Categories
#import "UIImageView+AFNetworking.h"

static CGFloat const DefaultTableViewCellHeight = 55.f;
static CGFloat const ItemInfoTableViewCellHeight = 65.f;
static NSUInteger const ItemInfoTableViewCellIndex = 0;
static NSString *const ViewControllerTitle = @"Messages";

@interface MessageTableViewController ()

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation MessageTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareUI];
    [self prepareDataSource];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item == ItemInfoTableViewCellIndex) {
		return [self itemInfoCellForIndexPath:indexPath];
	} else {
		return [self messageCellForIndexPath:indexPath];
	}
}

#pragma mark - Cells

- (ItemInfoTableViewCell *)itemInfoCellForIndexPath:(NSIndexPath *)indexPath
{
	ItemInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemInfoTableViewCell.ID forIndexPath:indexPath];
	if (self.item.imagesUrl) {
		[cell.itemImageView setImageWithURL:self.item.imagesUrl];
	}
	
	if (self.item.text) {
		cell.itemTextLabel.text = self.item.text;
	}
	
	return cell;
}

- (MessageTableViewCell *)messageCellForIndexPath:(NSIndexPath *)indexPath
{
	MessageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MessageTableViewCell.ID forIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	if (self.item.userAvatarThumbUrl) {
		[cell.userAvatarImageView setImageWithURL:self.item.userAvatarThumbUrl];
	}
	
	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item == ItemInfoTableViewCellIndex) {
		return ItemInfoTableViewCellHeight;
	}
	return DefaultTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.item == ItemInfoTableViewCellIndex) {
		MyItemsTableViewController *itemsTableViewController = [MyItemsTableViewController new];
		//temp
		if (self.item) {
			itemsTableViewController.user = [[UserModel alloc] initWithItem:self.item];
			itemsTableViewController.item = self.item;
		} else {
			itemsTableViewController.user = [APIClient sharedInstance].currentUser;
		}
		//temp
		[self.navigationController pushViewController:itemsTableViewController animated:YES];
	}
}

#pragma mark - Private Methods

- (void)prepareUI
{
    self.title = ViewControllerTitle;
	self.view.backgroundColor = [UIColor mainPageBGColor];

    [self prepareNavigationBar];
    [self prepareTableView];
}

- (void)prepareNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)prepareTableView
{
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:MessageTableViewCell.nib forCellReuseIdentifier:MessageTableViewCell.ID];
	[self.tableView registerNib:ItemInfoTableViewCell.nib forCellReuseIdentifier:ItemInfoTableViewCell.ID];
}

- (void)prepareDataSource
{
	[[APIClient sharedInstance] fetchMyMessagesWithPage:0 withCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (error) {
			if (response[@"error_message"]) {
				[Utils showErrorWithMessage:response[@"error_message"]];
			} else {
				[Utils showErrorForStatusCode:statusCode];
			}
		} else {
			//			[Utils showWarningWithMessage:@"Request succeeded. Need further implementation"];
		}
	}];
	
    self.dataSource = [NSMutableArray arrayWithObjects:@1, @2, @3, nil];
    [self.tableView reloadData];
}

@end
