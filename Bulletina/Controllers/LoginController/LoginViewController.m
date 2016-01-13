//
//  LoginViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

// Controllers
#import "LoginViewController.h"
#import "MainPageController.h"

// Cells
#import "LogoTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "LoginButtonTableViewCell.h"
#import "TryBeforeTableViewCell.h"

// Helpers
#import "TextInputNavigationCollection.h"

static CGFloat const LogoTableViewCellHeigthCoeff = 0.372;			//248.0f / 667.0f;
static CGFloat const TextfieldTableViewCellHeigthCoeff = 0.072;		//48.0f / 667.0f;
static CGFloat const LoginButtonTableViewCellHeigthCoeff = 0.177;	//118.0f / 667.0f;
static CGFloat const TryBeforeTableViewCellHeigthCoeff = 0.294;		//196.0f / 667.0f;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	LogoCellIndex,
	UsernameTextfieldIndex,
	PasswordTextfieldIndex,
	LoginButtonCellIndex,
	TryBeforeCellIndex
};

@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UITextField *usernameTextfield;
@property (weak, nonatomic) UITextField *passwordTextfield;

@property (strong, nonatomic) TextInputNavigationCollection *inputViewsCollection;

@end

@implementation LoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self tableViewSetup];
    [self setupUI];
    [self setupDefaults];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.inputViewsCollection.textInputViews = @[self.usernameTextfield, self.passwordTextfield];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == LogoCellIndex) {
		return [self logoCellForIndexPath:indexPath];
	} else if (indexPath.row == UsernameTextfieldIndex || indexPath.row == PasswordTextfieldIndex) {
		return [self textFieldCellForIndexPath:indexPath];
	} else if (indexPath.row == LoginButtonCellIndex) {
		return [self loginButtonCellForIndexPath:indexPath];
	} else if (indexPath.row == TryBeforeCellIndex) {
		return [self TryBeforeCellForIndexPath:indexPath];
	}
	return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = [self heigthForCell:TextfieldTableViewCellHeigthCoeff];
	if (indexPath.row == LogoCellIndex) {
		return [self heigthForCell:LogoTableViewCellHeigthCoeff];
	} else if (indexPath.row == LoginButtonCellIndex) {
		return [self heigthForCell:LoginButtonTableViewCellHeigthCoeff];
	} else if (indexPath.row == TryBeforeCellIndex) {
		return [self heigthForCell:TryBeforeTableViewCellHeigthCoeff];
	}
	return height;
}

- (CGFloat)heigthForCell:(CGFloat)cellHeigthCoeff
{
    CGFloat height = cellHeigthCoeff * CGRectGetHeight([UIScreen mainScreen].bounds);
    return height;
}

#pragma mark - Setup

- (void)setupUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"Login";
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self setNeedsStatusBarAppearanceUpdate];
}

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

- (void)setupDefaults
{
    self.inputViewsCollection = [TextInputNavigationCollection new];
}

#pragma mark - Cells

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
	if (indexPath.row == PasswordTextfieldIndex) {
		cell.textField.placeholder = @"Password:";
        cell.textField.secureTextEntry = YES;
        cell.textField.returnKeyType = UIReturnKeyDone;
        self.passwordTextfield = cell.textField;
    } else {
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        cell.textField.returnKeyType = UIReturnKeyNext;
        self.usernameTextfield = cell.textField;
    }
    cell.textField.delegate = self;
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}

- (LoginButtonTableViewCell *)loginButtonCellForIndexPath:(NSIndexPath *)indexPath
{
	LoginButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LoginButtonTableViewCell.ID forIndexPath:indexPath];
	cell.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
	cell.loginButton.layer.borderWidth = 1.0f;
	[cell.loginButton.layer setCornerRadius:6.0f];
	cell.backgroundColor = [UIColor clearColor];
	[cell.loginButton addTarget:self action:@selector(loginButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	[cell.forgotButton addTarget:self action:@selector(forgotButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	
	return cell;
}

- (TryBeforeTableViewCell *)TryBeforeCellForIndexPath:(NSIndexPath *)indexPath
{
	TryBeforeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TryBeforeTableViewCell.ID forIndexPath:indexPath];
	[cell.tryButton.layer setCornerRadius:6.0f];
	cell.backgroundColor = [UIColor clearColor];
	[cell.tryButton addTarget:self action:@selector(tryBeforeSignupButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	[cell.signupButton addTarget:self action:@selector(signupButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	
	return cell;
}

#pragma mark - StatusBar setup

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (void)tryBeforeSignupButtonTap:(id)sender
{
	MainPageController *mainPageController = [MainPageController new];
	UINavigationController *mainPageNavigationController = [[UINavigationController alloc] initWithRootViewController:mainPageController];
	[self.navigationController presentViewController:mainPageNavigationController animated:YES completion:nil];
}

- (void)signupButtonTap:(id)sender
{
}

- (void)loginButtonTap:(id)sender
{
}

- (void)forgotButtonTap:(id)sender
{
    
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
