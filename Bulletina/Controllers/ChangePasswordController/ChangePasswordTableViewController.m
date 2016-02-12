//
//  ChangePasswordTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ChangePasswordTableViewController.h"
#import "InputTableViewCell.h"
#import "ButtonTableViewCell.h"


// Helpers
#import "TextInputNavigationCollection.h"
#import "BulletinaLoaderView.h"

static NSInteger const CellsCount = 4;
static CGFloat const InputCellHeigth = 48;
static CGFloat const ButtonCellHeigth = 52;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	SaveButtonCellIndex = 3
};

@interface ChangePasswordTableViewController () <UITableViewDataSource, UITabBarControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UITextField *textFieldOldPassword;
@property (weak, nonatomic) UITextField *textFieldPassword;
@property (weak, nonatomic) UITextField *textFieldRepassword;

@property (strong, nonatomic) TextInputNavigationCollection *inputViewsCollection;
@property (strong, nonatomic) BulletinaLoaderView *loader;

@end

@implementation ChangePasswordTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Change password";	

    [self.tableView registerNib:InputTableViewCell.nib forCellReuseIdentifier:InputTableViewCell.ID];
	[self.tableView registerNib:ButtonTableViewCell.nib forCellReuseIdentifier:ButtonTableViewCell.ID];

	self.tableView.backgroundColor = [UIColor mainPageBGColor];
	[self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 30, 0)];
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	self.inputViewsCollection = [TextInputNavigationCollection new];
	self.loader = [[BulletinaLoaderView alloc] initWithView:self.navigationController.view andText:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[self refreshInputViews];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
	if (indexPath.row == SaveButtonCellIndex) {
		cell = [self buttonCellForIndexPath:indexPath];
	} else {
		cell = [self dataFieldCellForIndexPath:indexPath];
	}
    return cell;
}

#pragma mark - Configure cells

- (UITableViewCell *)dataFieldCellForIndexPath:(NSIndexPath *)indexPath
{
    InputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InputTableViewCell.ID forIndexPath:indexPath];
	cell.inputTextField.returnKeyType = UIReturnKeyNext;
	cell.inputTextField.delegate = self;
    if (indexPath.row == 0) {
        cell.inputTextField.placeholder = @"old password";
        cell.inputTextField.secureTextEntry = YES;
        self.textFieldOldPassword = cell.inputTextField;
    } else if (indexPath.row == 1) {
        cell.inputTextField.placeholder = @"password";
        cell.inputTextField.secureTextEntry = YES;
        self.textFieldPassword = cell.inputTextField;
    } else if (indexPath.row == 2) {
        cell.inputTextField.placeholder = @"retype password";
        cell.inputTextField.secureTextEntry = YES;
        self.textFieldRepassword = cell.inputTextField;
		cell.inputTextField.returnKeyType = UIReturnKeyDone;
    }
	cell.backgroundColor = [UIColor mainPageBGColor];
    return cell;
}

- (UITableViewCell *)buttonCellForIndexPath:(NSIndexPath *)indexPath
{
	ButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ButtonTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	cell.saveButton.layer.cornerRadius = 5;
	[cell.saveButton addTarget:self action:@selector(saveChangesAction:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == SaveButtonCellIndex) {
		 return ButtonCellHeigth * HeigthCoefficient;
	} else {
		return InputCellHeigth * HeigthCoefficient;
	}
}

#pragma mark - Actions

- (void)saveChangesAction:(id)sender
{
    if (!self.textFieldOldPassword.text.length || !self.textFieldPassword.text.length || !self.textFieldRepassword.text.length) {
        [Utils showErrorWithMessage: @"All fields are required"];
    } else if (self.textFieldPassword.text.length && self.textFieldRepassword.text.length && !self.textFieldOldPassword.text.length) {
        [Utils showErrorWithMessage:@"Please enter your old password"];
    } else if (self.textFieldOldPassword.text.length && (!self.textFieldRepassword.text.length || !self.textFieldPassword.text.length)) {
        [Utils showErrorWithMessage:@"Please enter your new password"];
    } else if (![self.textFieldPassword.text isEqualToString:self.textFieldRepassword.text]) {
        [Utils showErrorWithMessage:@"Password and repassword doesn't match."];
    } else {
		//request here
    }
}

#pragma mark - Utils

- (void)refreshInputViews
{
	NSMutableArray *views = [[NSMutableArray alloc] init];
	if (self.textFieldOldPassword) {
		[views addObject:self.textFieldOldPassword];
	}
	if (self.textFieldPassword) {
		[views addObject:self.textFieldPassword];
	}
	if (self.textFieldRepassword) {
		[views addObject:self.textFieldRepassword];
	}
	self.inputViewsCollection.textInputViews =  views;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[self.inputViewsCollection inputViewWillBecomeFirstResponder:textField];
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.inputViewsCollection next];
	return NO;
}

@end
