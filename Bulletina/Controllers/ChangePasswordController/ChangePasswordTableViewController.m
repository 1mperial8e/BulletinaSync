//
//  ChangePasswordTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

// Controllers
#import "ChangePasswordTableViewController.h"

// Cells
#import "InputTableViewCell.h"
#import "ButtonTableViewCell.h"

// Helpers
#import "TextInputNavigationCollection.h"
#import "BulletinaLoaderView.h"

// Models
#import "APIClient+User.h"

static NSInteger const CellsCount = 4;
static CGFloat const InputCellHeigth = 48;
static CGFloat const ButtonCellHeigth = 52;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	SaveButtonCellIndex = 3
};

@interface ChangePasswordTableViewController () <UITableViewDataSource, UITextFieldDelegate>

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

    [self setupTableView];
    [self setupDefaults];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[self refreshInputViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView endEditing:YES];
}

#pragma mark - Setup

- (void)setupTableView
{
    [self.tableView registerNib:InputTableViewCell.nib forCellReuseIdentifier:InputTableViewCell.ID];
    [self.tableView registerNib:ButtonTableViewCell.nib forCellReuseIdentifier:ButtonTableViewCell.ID];
    
    self.tableView.backgroundColor = [UIColor mainPageBGColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 30, 0)];
}

- (void)setupDefaults
{
   	self.inputViewsCollection = [TextInputNavigationCollection new];
    self.loader = [[BulletinaLoaderView alloc] initWithView:self.navigationController.view andText:nil];
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
    cell.inputTextField.secureTextEntry = YES;
    cell.inputTextField.returnKeyType = UIReturnKeyNext;
    if (indexPath.row == 0) {
        cell.inputTextField.placeholder = @"Old password";
        self.textFieldOldPassword = cell.inputTextField;
    } else if (indexPath.row == 1) {
        cell.inputTextField.placeholder = @"New password";
        self.textFieldPassword = cell.inputTextField;
    } else if (indexPath.row == 2) {
        cell.inputTextField.placeholder = @"Retype new password";
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
        [self.tableView endEditing:YES];
        __weak typeof(self) weakSelf = self;
        [self.loader show];
		[[APIClient sharedInstance] changePassword:self.textFieldOldPassword.text withNewPassword:self.textFieldPassword.text withCompletion:^(id response, NSError *error, NSInteger statusCode) {
            if (error) {
                if (response[@"error"]) {
                    [Utils showErrorWithMessage:response[@"error"]];
                } else {
                    [Utils showErrorForStatusCode:statusCode];
                }
            } else {
                [weakSelf passwordChanged];
            }
            [weakSelf.loader hide];
        }];
    }
}

- (void)passwordChanged
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSBundle mainBundle].infoDictionary[@"CFBundleName"] message:@"Password changed successfully" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
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
	self.inputViewsCollection.textInputViews = views;
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
	return YES;
}

@end
