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
	
	if (indexPath.item%2) {
		cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:249/255.0 blue:237/255.0 alpha:1.0f];
	}
	//temp
	
	return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.tableView.editing)
	{
		return UITableViewCellEditingStyleDelete;
	}
	
	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.dataSource removeObjectAtIndex:indexPath.row];
	
	[self.tableView beginUpdates];
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.tableView endUpdates];
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
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTap:)];
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
			self.dataSource = [response mutableCopy];
			[self.tableView reloadData];
		}
	}];
}

- (void)editTap:(id)sender {
	[self.tableView setEditing: YES animated: YES];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTap:)];
}

- (void)doneTap:(id)sender {
	[self.tableView setEditing: NO animated: YES];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTap:)];
}

@end
