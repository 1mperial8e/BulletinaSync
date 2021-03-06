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
#import "ForgotPasswordTableViewController.h"
#import "RegisterTypeSelectTableViewController.h"

// Cells
#import "LogoTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "LoginButtonTableViewCell.h"
#import "TryBeforeTableViewCell.h"

// Helpers
#import "TextInputNavigationCollection.h"
#import "BulletinaLoaderView.h"

// Models
#import "APIClient+User.h"
#import "APIClient+Session.h"
#import "UserModel.h"

static CGFloat const LogoTableViewCellHeigth = 248.0f;
static CGFloat const TextfieldTableViewCellHeigth = 48.0f;
static CGFloat const LoginButtonTableViewCellHeigth = 118.0f;
static CGFloat const TryBeforeTableViewCellHeigth = 196.0f;

static NSInteger const CellsCount = 5;

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

@property (strong, nonatomic) BulletinaLoaderView *loader;
@property (strong, nonatomic) TextInputNavigationCollection *inputViewsCollection;

@end

@implementation LoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupTableView];
    [self setupDefaults];
    if ([APIClient sharedInstance].currentUser) {
        [self showMainPageAnimated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.inputViewsCollection.textInputViews = @[self.usernameTextfield, self.passwordTextfield];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return CellsCount;
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
		return [self tryBeforeCellForIndexPath:indexPath];
	}
	return [tableView dequeueReusableCellWithIdentifier:LogoTableViewCell.ID];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = TextfieldTableViewCellHeigth * HeigthCoefficient;
	if (indexPath.row == LogoCellIndex) {
		height = LogoTableViewCellHeigth * HeigthCoefficient;
	} else if (indexPath.row == LoginButtonCellIndex) {
		height = LoginButtonTableViewCellHeigth * HeigthCoefficient;
	} else if (indexPath.row == TryBeforeCellIndex) {
		height = TryBeforeTableViewCellHeigth * HeigthCoefficient;
	}
	return height;
}

#pragma mark - Setup

- (void)setupUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"Login";
    [self.navigationController setNavigationBarHidden:YES animated:YES];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appOrangeColor]}];
    [Application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	[Application setStatusBarStyle:UIStatusBarStyleLightContent];
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];    
    self.passwordTextfield.text = nil;
    self.usernameTextfield.text = nil;
}

- (void)setupTableView
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
    self.loader = [[BulletinaLoaderView alloc] initWithView:self.navigationController.view andText:nil];
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
	cell.textField.placeholder = @"Email:";
	
	if (indexPath.row == PasswordTextfieldIndex) {
		cell.textField.placeholder = @"Password:";
        cell.textField.secureTextEntry = YES;
        cell.textField.returnKeyType = UIReturnKeyDone;
        self.passwordTextfield = cell.textField;
    } else {
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
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
	cell.loginButton.layer.cornerRadius = 6.0f;
	[cell.loginButton addTarget:self action:@selector(loginButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	[cell.forgotButton addTarget:self action:@selector(forgotButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor clearColor];
    
	return cell;
}

- (TryBeforeTableViewCell *)tryBeforeCellForIndexPath:(NSIndexPath *)indexPath
{
	TryBeforeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TryBeforeTableViewCell.ID forIndexPath:indexPath];
	cell.tryButton.layer.cornerRadius = 6.0f;
	[cell.tryButton addTarget:self action:@selector(tryBeforeSignupButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	[cell.signupButton addTarget:self action:@selector(signupButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor clearColor];

	return cell;
}

#pragma mark - Actions

- (void)tryBeforeSignupButtonTap:(id)sender
{
	if (![LocationManager sharedManager].currentLocation) {
		[Utils showLocationErrorOnViewController:self];
	} else {
		[self.loader show];
		__weak typeof(self) weakSelf = self;
		[[APIClient sharedInstance] generateUserWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
			if (error) {
				if (response[@"error_message"]) {
					[Utils showErrorWithMessage:response[@"error_message"]];
				} else {
					[Utils showErrorForStatusCode:statusCode];
				}
			} else {
				NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
				UserModel *generatedUser = [UserModel modelWithDictionary:response[@"user"]];
				[Utils storeValue:response[@"user"] forKey:CurrentUserKey];
				[[APIClient sharedInstance] updateCurrentUser:generatedUser];
				[[APIClient sharedInstance] updatePasstokenWithDictionary:response];
				dispatch_async(dispatch_get_main_queue(), ^{
					[weakSelf showMainPageAnimated:YES];
				});
			}
			[weakSelf.loader hide];
		}];
	}
}

- (void)signupButtonTap:(id)sender
{
    RegisterTypeSelectTableViewController *registerTypeSelectController = [RegisterTypeSelectTableViewController new];
    [self.navigationController pushViewController:registerTypeSelectController animated:YES];
}

- (void)loginButtonTap:(id)sender
{
	if (!self.usernameTextfield.text.length) {
		[Utils showErrorWithMessage:@"Email is required."];
	} else if (!self.passwordTextfield.text.length) {
		[Utils showErrorWithMessage:@"Password is required."];
	} else {
        [self.tableView endEditing:YES];
		
		if (![LocationManager sharedManager].currentLocation) {
			[Utils showLocationErrorOnViewController:self];
		} else {
			[self.loader show];
			__weak typeof(self) weakSelf = self;
			[[APIClient sharedInstance]loginSessionWithUsername:self.usernameTextfield.text password:self.passwordTextfield.text withCompletion:^(id response, NSError *error, NSInteger statusCode) {
				if (error) {
					if (response[@"error_message"]) {
						[Utils showErrorWithMessage:response[@"error_message"]];
					} else {
						[Utils showErrorForStatusCode:statusCode];
					}
				} else {
					NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
					UserModel *generatedUser = [UserModel modelWithDictionary:response[@"user"]];
					[Utils storeValue:response[@"user"] forKey:CurrentUserKey];
					[[APIClient sharedInstance] updateCurrentUser:generatedUser];
					[[APIClient sharedInstance] updatePasstokenWithDictionary:response];
					dispatch_async(dispatch_get_main_queue(), ^{
						[weakSelf showMainPageAnimated:YES];
					});
				}
				[weakSelf.loader hide];
			}];			
		}
	}
}

- (void)forgotButtonTap:(id)sender
{
	ForgotPasswordTableViewController *forgotPasswordTableViewController = [ForgotPasswordTableViewController new];
	UINavigationController *forgotNavigationController = [[UINavigationController alloc] initWithRootViewController:forgotPasswordTableViewController];
	[self.navigationController presentViewController:forgotNavigationController animated:YES completion:nil];
}

#pragma mark - Utils

- (void)showMainPageAnimated:(BOOL)animated
{
    if (!animated) {
     [self.loader show];
        animated = YES;
    }
    MainPageController *mainPageController = [MainPageController new];
    UINavigationController *mainPageNavigationController = [[UINavigationController alloc] initWithRootViewController:mainPageController];
    
    __weak typeof(self) weakSelf = self;
    [self.navigationController presentViewController:mainPageNavigationController animated:animated completion:^{
        [weakSelf.loader hide];
    }];
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
