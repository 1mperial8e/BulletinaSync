//
//  ConversationsListTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/21/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Conrtollers
#import "MessageTableViewController.h"
#import "ConversationsListTableViewController.h"

//Cells
#import "ConversationTableViewCell.h"

//Models
#import "APIClient+Message.h"

//Categories
#import "UIImageView+AFNetworking.h"

static CGFloat const DefaultTableViewCellHeight = 65.f;
static NSString *const ViewControllerTitle = @"Messages";

@interface ConversationsListTableViewController ()

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ConversationsListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self prepareUI];
	[self prepareDataSource];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self conversationCellForIndexPath:indexPath];
}

#pragma mark - Cells

- (ConversationTableViewCell *)conversationCellForIndexPath:(NSIndexPath *)indexPath
{
	ConversationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ConversationTableViewCell.ID forIndexPath:indexPath];
	
	//temp
	if (indexPath.item > 1) {
		cell.badgeView.hidden = YES;
	}
	if (self.item.imagesUrl) {
		[cell.itemImageView setImageWithURL:self.item.imagesUrl];
	}
	if (self.item.userAvatarThumbUrl) {
		[cell.userAvatarImageView setImageWithURL:self.item.userAvatarThumbUrl];
	}
	//temp
	
	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return DefaultTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	MessageTableViewController *messageTableViewController = [MessageTableViewController new];
	messageTableViewController.item = self.item;
	[self.navigationController pushViewController:messageTableViewController animated:YES];
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
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)prepareTableView
{
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	[self.tableView registerNib:ConversationTableViewCell.nib forCellReuseIdentifier:ConversationTableViewCell.ID];
}

- (void)prepareDataSource
{
	[[APIClient sharedInstance] fetchConversationsListWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (error) {
			if (response[@"error_message"]) {
				[Utils showErrorWithMessage:response[@"error_message"]];
			} else {
				[Utils showErrorForStatusCode:statusCode];
			}
		} else {
			NSParameterAssert([response isKindOfClass:[NSArray class]]);
			self.dataSource = response;
			[self.tableView reloadData];
		}
	}];
}

@end
