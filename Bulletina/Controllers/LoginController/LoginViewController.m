//
//  LoginViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "LoginViewController.h"

#import "LogoTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "LoginButtonTableViewCell.h"
#import "TryBeforeTableViewCell.h"

static CGFloat const LogoTableViewCellHeigth = 252.0f;
static CGFloat const TextfieldTableViewCellHeigth = 48.0f;
static CGFloat const LoginButtonTableViewCellHeigth = 118.0f;
static CGFloat const TryBeforeTableViewCellHeigth = 197.0f;
static CGFloat const IPhone6ScreenHeigth = 667.0f;


typedef NS_ENUM(NSUInteger, CellsIndexPaths) {
	LogoCellIndexPath,
	UsernameTextfieldIndexPath,
	PasswordTextfieldIndexPath,
	LoginButtonCellIndexPath,
	TryBeforeCellIndexPath
};

@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
	self.title = @"Login";
	[self tableViewSetup];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == LogoCellIndexPath) {
		return [self logoCellForIndexPath:indexPath];
	} else if (indexPath.row == UsernameTextfieldIndexPath || indexPath.row == PasswordTextfieldIndexPath) {
		return [self textFieldCellForIndexPath:indexPath];
	} else if (indexPath.row == LoginButtonCellIndexPath) {
		return [self loginButtonCellForIndexPath:indexPath];
	} else if (indexPath.row == TryBeforeCellIndexPath) {
		return [self TryBeforeCellForIndexPath:indexPath];
	}
	return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = TextfieldTableViewCellHeigth;
	if (indexPath.row == LogoCellIndexPath) {
		return [self heigthForCell:LogoTableViewCellHeigth];
	}  else if (indexPath.row == LoginButtonCellIndexPath) {
		return [self heigthForCell:LoginButtonTableViewCellHeigth];
	} else if (indexPath.row == TryBeforeCellIndexPath) {
		return [self heigthForCell:TryBeforeTableViewCellHeigth];
	}
	return height;
}

#pragma mark - Setup Cells

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	self.tableView.separatorColor = [UIColor clearColor];
	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = [UIScreen mainScreen].bounds;
	gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:241/255.0f green:158/255.0f blue:15/255.0f alpha:1] CGColor], (id)[[UIColor colorWithRed:231/255.0f green:144/255.0f blue:16/255.0f alpha:1] CGColor], (id)[[UIColor colorWithRed:219/255.0f green:129/255.0f blue:16/255.0f alpha:1] CGColor],  (id)[[UIColor colorWithRed:196/255.0f green:99/255.0f blue:18/255.0f alpha:1] CGColor],  nil];
	gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.25], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:1.0], nil];
	[self.view.layer insertSublayer:gradient atIndex:0];
	
	[self.tableView registerNib:LogoTableViewCell.nib forCellReuseIdentifier:LogoTableViewCell.ID];
	[self.tableView registerNib:TextFieldTableViewCell.nib forCellReuseIdentifier:TextFieldTableViewCell.ID];
	[self.tableView registerNib:LoginButtonTableViewCell.nib forCellReuseIdentifier:LoginButtonTableViewCell.ID];
	[self.tableView registerNib:TryBeforeTableViewCell.nib forCellReuseIdentifier:TryBeforeTableViewCell.ID];
}

- (CGFloat)heigthForCell:(CGFloat)cellHeigth
{
	return (cellHeigth * MAX(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))) / IPhone6ScreenHeigth;
}

- (LogoTableViewCell *)logoCellForIndexPath:(NSIndexPath *)indexPath
{
	LogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LogoTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}

- (TextFieldTableViewCell *)textFieldCellForIndexPath:(NSIndexPath *)indexPath
{
	TextFieldTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TextFieldTableViewCell.ID forIndexPath:indexPath];
	cell.textField.placeholder = @"Username:";
	if (indexPath.row == PasswordTextfieldIndexPath) {
		cell.textField.placeholder = @"Password:";
	}
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}

- (LoginButtonTableViewCell *)loginButtonCellForIndexPath:(NSIndexPath *)indexPath
{
	LoginButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LoginButtonTableViewCell.ID forIndexPath:indexPath];
	cell.button.layer.borderColor = [UIColor whiteColor].CGColor;
	cell.button.layer.borderWidth = 1.0f;
	[cell.button.layer setCornerRadius:6.0f];
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}

- (TryBeforeTableViewCell *)TryBeforeCellForIndexPath:(NSIndexPath *)indexPath
{
	TryBeforeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TryBeforeTableViewCell.ID forIndexPath:indexPath];
	[cell.button.layer setCornerRadius:6.0f];
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}

@end
