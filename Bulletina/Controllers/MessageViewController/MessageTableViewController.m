//
//  MessageTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/21/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Conrtollers
#import "MessageTableViewController.h"

//Cells
#import "MessageTableViewCell.h"

#import "APIClient+Message.h"

static CGFloat const DefaultTableViewCellHeight = 55.f;
static NSString *const ViewControllerTitle = @"Messages";

@interface MessageTableViewController ()

@property (weak, nonatomic) NSMutableArray *dataSource;

@end

@implementation MessageTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareUI];
    [self prepareDataSource];
	
	[[APIClient sharedInstance] fetchMyMessagesWithPage:0 withCompletion:^(id response, NSError *error, NSInteger statusCode) {
		if (error) {
			if (response[@"error_message"]) {
				[Utils showErrorWithMessage:response[@"error_message"]];
			} else {
				[Utils showErrorForStatusCode:statusCode];
			}
		} else {
			[Utils showWarningWithMessage:@"Request succeeded. Need further implementation"];
		}
	}];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageTableViewCell.ID forIndexPath:indexPath];
    //TODO: configure cell
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return DefaultTableViewCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 0.f)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //TODO: show ChatViewController
}

#pragma mark - Private Methods

- (void)prepareUI
{
    self.title = ViewControllerTitle;
    [self prepareNavigationBar];
    [self prepareTableView];
}

- (void)prepareNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor mainPageBGColor];
}

- (void)prepareTableView
{
    [self.tableView registerNib:MessageTableViewCell.nib forCellReuseIdentifier:MessageTableViewCell.ID];
}

- (void)prepareDataSource
{
    //TODO: get messages list
    //TODO: remove hardcoded data source
    self.dataSource = [NSMutableArray arrayWithObjects:@1, @2, @3, nil];
    [self.tableView reloadData];
}

@end
