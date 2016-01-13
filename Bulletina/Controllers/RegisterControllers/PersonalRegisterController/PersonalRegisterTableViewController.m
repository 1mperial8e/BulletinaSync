//
//  PersonalRegisterTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "PersonalRegisterTableViewController.h"
#import "AvatarTableViewCell.h"
#import "InputTableViewCell.h"
#import "ButtonTableViewCell.h"

//static CGFloat const LogoTableViewCellHeigthCoeff = 0.372;			//248.0f / 667.0f;
//static CGFloat const TextfieldTableViewCellHeigthCoeff = 0.072;		//48.0f / 667.0f;
//static CGFloat const LoginButtonTableViewCellHeigthCoeff = 0.177;	//118.0f / 667.0f;
//static CGFloat const TryBeforeTableViewCellHeigthCoeff = 0.294;		//196.0f / 667.0f;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	AvatarCellIndex,
	UsernameTextfieldIndex,
	PasswordTextfieldIndex,
	RetypePasswordTextfieldIndex,
	SaveButtonCellIndex
};


@interface PersonalRegisterTableViewController ()

@end

@implementation PersonalRegisterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self tableViewSetup];	
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
	
	if (indexPath.item == AvatarCellIndex) {
		AvatarTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AvatarTableViewCell.ID forIndexPath:indexPath];
		 return cell;
	}    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 44;//[self heigthForCell:TextfieldTableViewCellHeigthCoeff];
	if (indexPath.row == AvatarCellIndex) {
		return 218;//[self heigthForCell:LogoTableViewCellHeigthCoeff];
	}
//	else if (indexPath.row == LoginButtonCellIndex) {
//		return [self heigthForCell:LoginButtonTableViewCellHeigthCoeff];
//	} else if (indexPath.row == TryBeforeCellIndex) {
//		return [self heigthForCell:TryBeforeTableViewCellHeigthCoeff];
//	}
	return height;
}

- (CGFloat)heigthForCell:(CGFloat)cellHeigthCoeff
{
	CGFloat height = cellHeigthCoeff * CGRectGetHeight([UIScreen mainScreen].bounds);
	return height;
}


#pragma mark - Setup

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	self.tableView.separatorColor = [UIColor clearColor];
	
	[self.tableView registerNib:AvatarTableViewCell.nib forCellReuseIdentifier:AvatarTableViewCell.ID];
}


@end
