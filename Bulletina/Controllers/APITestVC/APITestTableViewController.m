//
//  APITestTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APITestTableViewController.h"
#import "MainPageController.h"

#import "BulletinaLoaderView.h"

// Models
#import "APIClient+User.h"
#import "APIClient+Session.h"
#import "UserModel.h"
#import "LocationManager.h"

@interface APITestTableViewController ()

@property (strong, nonatomic) NSDictionary *rowTitles;
@property (strong, nonatomic) NSArray *sectionTitles;
@property (strong, nonatomic) BulletinaLoaderView *loader;

@end

@implementation APITestTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title =@"API TEST";
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	self.loader = [[BulletinaLoaderView alloc] initWithView:self.navigationController.view andText:nil];
	
	self.sectionTitles =@[@"Custom",@"User",@"Session"]; //,@"Item",@"Message",@"Other"];
	self.rowTitles = @{@"Custom":@[@"TestUIWithFakeIndividualAccount", @"TestUIWithFakeBusinessAccount"], @"User":@[@"UserGenerate", @"UserShow", @"UserCreate", @"UserUpdate", @"UserDestroy"], @"Session":@[@"SessionCreate - Login", @"SessionDestroy - Logout"]};//, @"Item":@[@"ItemIndex", @"ItemShow", @"ItemCreate", @"ItemUpdate", @"ItemDestroy"], @"Message":@[@"MessageIndex", @"MessageShow", @"MessageCreate", @"MessageUpdate", @"MessageDestroy"],@"Other":@[@"ReportCreate" ,@"AdTypes" ,@"Countries" ,@"CustomerTypes" ,@"Languages" ,@"ReportReasons"]};
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.rowTitles[self.sectionTitles[section]]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	}
	cell.textLabel.text =  ((NSArray *)self.rowTitles[self.sectionTitles[indexPath.section]])[indexPath.item];
	cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.font = [UIFont systemFontOfSize:17];
	cell.selectionStyle =  UITableViewCellSelectionStyleNone;
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return self.sectionTitles[section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.loader show];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	 if ([cell.textLabel.text isEqualToString:@"TestUIWithFakeIndividualAccount"]) {
		NSDictionary *fakeUser = @{@"banned":@NO, @"customer_type_id":@2, @"description":@"Here is some description of personal profile", @"email":@"myemail@bulletina.net", @"id":@5, @"login":@"myFakeLogin", @"name":@"myFullName"};
		[[APIClient sharedInstance] updateCurrentUser:[UserModel modelWithDictionary:fakeUser]];
		[self showMainPageAnimated:YES];
	} else if ([cell.textLabel.text isEqualToString:@"TestUIWithFakeBusinessAccount"]) {
		NSDictionary *fakeUser = @{@"banned":@NO, @"customer_type_id":@3, @"description":@"Here is some description of business profile", @"email":@"myemail@bulletina.net", @"id":@5, @"phone":@"+1234567890", @"login":@"myFakeLogin", @"company_name":@"myCompanyName"};
		[[APIClient sharedInstance] updateCurrentUser:[UserModel modelWithDictionary:fakeUser]];
		[self showMainPageAnimated:YES];
	} else if ([cell.textLabel.text isEqualToString:@"UserGenerate"]) {
		[self generateUser];
	} else if ([cell.textLabel.text isEqualToString:@"UserCreate"]) {
		[self userCreate];
	} else if ([cell.textLabel.text isEqualToString:@"UserShow"]) {
		[self showUser];
	} else if ([cell.textLabel.text isEqualToString:@"UserUpdate"]) {
				[self updateUser];
	} else if ([cell.textLabel.text isEqualToString:@"UserDestroy"]) {
				[self destroyUser];
	} else if ([cell.textLabel.text isEqualToString:@"SessionCreate - Login"]) {
//		NSString *userEmail = [APIClient sharedInstance].currentUser ? [APIClient sharedInstance].currentUser.email : @"myemail@bulletina.net";
	} if ([cell.textLabel.text isEqualToString:@"SessionDestroy - Logout"]) {
		[self logoutSession];
	}
}

#pragma mark - Utils

- (void)showMainPageAnimated:(BOOL)animated
{
	[self.loader hide];
	MainPageController *mainPageController = [MainPageController new];
	UINavigationController *mainPageNavigationController = [[UINavigationController alloc] initWithRootViewController:mainPageController];
	[self.navigationController presentViewController:mainPageNavigationController animated:animated completion:nil];
}

- (void)generateUser
{
	__weak typeof(self) weakSelf = self;
	[[APIClient sharedInstance] generateUserWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
		[weakSelf.loader hide];
		if (error) {
			DLog(@"Generate user: %@ \n %li",error, statusCode);
			[Utils showErrorForStatusCode:statusCode];
		} else {
			NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
			DLog(@"Generate user: %@",response);
			UserModel *generatedUser = [UserModel modelWithDictionary:response];
			[[APIClient sharedInstance] updateCurrentUser:generatedUser];
			[[APIClient sharedInstance] updatePasstokenWithDictionary:response];
			[Utils showWarningWithMessage:[NSString stringWithFormat:@"User with id:%li successfully generated. And Logined. Now you have passtoken",generatedUser.userId]];
		}
	}];
}

- (void)userCreate
{
	__weak typeof(self) weakSelf = self;
	[[APIClient sharedInstance] createUserWithEmail:@"myemail2@bulletina.net" username:@"testUsername2" password:@"123" languageId:@"" customerTypeId:2 companyname:@"" website:@"" phone:@"" avatar:nil withCompletion:^(id response, NSError *error, NSInteger statusCode) {
		[weakSelf.loader hide];
		if (error) {
			DLog(@"Create user: %@ \n %li",error, statusCode);
			[Utils showErrorForStatusCode:statusCode];
		} else {
			NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
			DLog(@"Create user: %@",response);
			UserModel *generatedUser = [UserModel modelWithDictionary:response];
			[Utils showWarningWithMessage:[NSString stringWithFormat:@"User with id:%li successfully created.",generatedUser.userId]];
		}
	}];
}

- (void)showUser
{
	__weak typeof(self) weakSelf = self;
	if ([APIClient sharedInstance].passtoken) {
		[[APIClient sharedInstance] showUserWithUserId:33 withCompletion:^(id response, NSError *error, NSInteger statusCode) {
			[weakSelf.loader hide];
			if (error) {
				DLog(@"Show user: %@ \n %li",error, statusCode);
				[Utils showErrorForStatusCode:statusCode];
			} else {
				NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
				DLog(@"Show user: %@",response);
				UserModel *generatedUser = [UserModel modelWithDictionary:response];
				[Utils showWarningWithMessage:[NSString stringWithFormat:@"User with id:%li successfully showed.",generatedUser.userId]];
			}
		}];
	} else {
		[Utils showWarningWithMessage:@"You need passtoken. Please log in"];
		[self.loader hide];
	}
}

- (void)updateUser
{
	__weak typeof(self) weakSelf = self;
	if ([APIClient sharedInstance].passtoken) {
		[[APIClient sharedInstance] updateUserWithUsername:@"updatedUsername" fullname:@"myFullName" companyname:@"" password:@"123" website:@"" facebook:@"" linkedin:@"" phone:@"123" description:@"updated description" avatar:nil withCompletion:^(id response, NSError *error, NSInteger statusCode) {
			[weakSelf.loader hide];
			if (error) {
				DLog(@"Update user: %@ \n %li",error, statusCode);
				[Utils showErrorForStatusCode:statusCode];
			} else {
				NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
				DLog(@"Update user: %@",response);
				[Utils showWarningWithMessage:@"User successfully updated."];
			}
		}];
	} else {
		[Utils showWarningWithMessage:@"You need passtoken. Please log in"];
		[self.loader hide];
	}
}

- (void)destroyUser
{
	__weak typeof(self) weakSelf = self;
	if ([APIClient sharedInstance].passtoken) {
		[[APIClient sharedInstance] destroyUserWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
			[weakSelf.loader hide];
			if (error) {
				DLog(@"Destroy user: %@ \n %li",error, statusCode);
				[Utils showErrorForStatusCode:statusCode];
			} else {
				NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
				DLog(@"Destroy user: %@",response);
				[Utils showWarningWithMessage:@"User successfully destroyed."];
			}
		}];
	} else {
		[Utils showWarningWithMessage:@"You need passtoken. Please log in"];
		[self.loader hide];
	}
}

- (void)createLoginSessionWithEmail:(NSString *)email password:(NSString *)password
{
	__weak typeof(self) weakSelf = self;
	[[APIClient sharedInstance]loginSessionWithUsername:email password:password withCompletion:^(id response, NSError *error, NSInteger statusCode) {
		[weakSelf.loader hide];
		if (error) {
			[Utils showErrorForStatusCode:statusCode];
			DLog(@"Login: %@ \n %li",error, statusCode);
		} else {
			NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
			[[APIClient sharedInstance] updatePasstokenWithDictionary:response];
			[[APIClient sharedInstance] updateCurrentUser:[UserModel modelWithDictionary:response]];
			DLog(@"Login: %@", response);
			[Utils showWarningWithMessage:[NSString stringWithFormat:@"User with id:%li successfully login. Now you have passtoken",[APIClient sharedInstance].currentUser.userId]];
		}
	}];
}

- (void)logoutSession
{
	__weak typeof(self) weakSelf = self;
	if ([APIClient sharedInstance].passtoken) {
		[[APIClient sharedInstance] logoutSessionWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
			[weakSelf.loader hide];
			if (error) {
				[Utils showErrorForStatusCode:statusCode];
				DLog(@"Logout: %@ \n %li",error, statusCode);
			} else {
				DLog(@"Logout: %@", response);
				[Utils showWarningWithMessage:@"Logout successfully"];
			}
		}];
	} else {
		[Utils showWarningWithMessage:@"You need passtoken. Please log in"];
		[self.loader hide];
	}
}

@end
