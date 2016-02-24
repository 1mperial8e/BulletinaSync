//
//  ReportTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ReportTableViewController.h"

//Cell
#import "NewItemTextTableViewCell.h"

// Models
#import "APIClient+Item.h"


static NSString *const TextViewPlaceholderText = @"Write your comments";

static NSInteger const CellsCount = 1;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	TextCellIndex,
	ReasonCellIndex
};

@interface ReportTableViewController () <UITextViewDelegate>

@property (strong, nonatomic) NewItemTextTableViewCell *textCell;

@end

@implementation ReportTableViewController

#pragma mark - init

- (instancetype)initWithItemId:(NSInteger)itemId andUserId:(NSInteger)userId
{
	self = [super init];
	if (self) {
		_reportedItemId = itemId;
		_reportedUserId = userId;
	}
	return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 5, 0)];
	
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	self.tableView.backgroundColor = [UIColor mainPageBGColor];

	[self.tableView registerNib:NewItemTextTableViewCell.nib forCellReuseIdentifier:NewItemTextTableViewCell.ID];
	
	self.navigationItem.title = @"Report";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNavBarAction:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(publishNavBarAction:)];
}

#pragma mark - Table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item == TextCellIndex) {
		return [self textCellForIndexPath:indexPath];
	}
	return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 44 * HeigthCoefficient;
	if (indexPath.row == TextCellIndex) {
		return [self heightForTextCell];
	}
	return height;
}

#pragma mark - Cells

- (NewItemTextTableViewCell *)textCellForIndexPath:(NSIndexPath *)indexPath
{
	self.textCell = [self.tableView dequeueReusableCellWithIdentifier:NewItemTextTableViewCell.ID forIndexPath:indexPath];
	self.textCell.textView.placeholder = TextViewPlaceholderText;
	self.textCell.textView.delegate = self;
	self.textCell.textView.textColor = [UIColor blackColor];
	[self.textCell.textView setTextContainerInset:UIEdgeInsetsMake(10, 20, 5, 20)];
	self.textCell.textView.returnKeyType = UIReturnKeyDone;
	self.textCell.selectionStyle = UITableViewCellSelectionStyleNone;
	return self.textCell;
}

#pragma mark - Utils

- (CGFloat)heightForTextCell
{
	if (!self.textCell) {
		self.textCell = [[NSBundle mainBundle] loadNibNamed:NewItemTextTableViewCell.ID owner:nil options:nil].firstObject;
	}
	CGFloat height;
	if (!self.textCell.textView.text.length) {
		self.textCell.textView.text = TextViewPlaceholderText;
		height = ceil([self.textCell.textView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
		self.textCell.textView.text = @"";
	} else {
		height = ceil([self.textCell.textView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
	}
	return height + 50.f;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
{
	if ([string isEqualToString:@"\n"]) {
		[self.view endEditing:YES];
		return  NO;
	}
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	CGFloat height = ceil([self.textCell.textView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
	if (self.textCell.textView.contentSize.height > height + 1 || self.textCell.textView.contentSize.height < height - 1 || !textView.text.length) {
		[self.tableView beginUpdates];
		[self.tableView endUpdates];
		
		CGRect textViewRect = [self.tableView convertRect:self.textCell.textView.frame fromView:self.textCell.textView.superview];
		textViewRect.origin.y += 5;
		[self.tableView scrollRectToVisible:textViewRect animated:YES];
	}
}

#pragma mark - Actions

- (void)publishNavBarAction:(id)sender
{
	if (!self.textCell.textView.text.length) {
		[Utils showWarningWithMessage:@"Description is requied"];
	} else {
		[self.navigationController dismissViewControllerAnimated:YES completion:nil];
		[[APIClient sharedInstance]reportItemWithId:self.reportedItemId andUserId:self.reportedUserId description:@"Test" reasonId:1 withCompletion:^(id response, NSError *error, NSInteger statusCode) {
			if (error) {
				if (response[@"error_message"]) {
					[Utils showErrorWithMessage:response[@"error_message"]];
				} else {
					[Utils showErrorForStatusCode:statusCode];
				}
			} else {
				//ok
				//[self.navigationController dismissViewControllerAnimated:YES completion:nil];
				[Utils showWarningWithMessage:@"response Ok. needs further implementation."];
			}
		}];
	}
}

- (void)cancelNavBarAction:(id)sender
{
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
