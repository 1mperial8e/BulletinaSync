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
	
	self.sectionTitles =@[@"Custom",@"User",@"Session",@"Item",@"Message",@"Other"];
	self.rowTitles = @{@"Custom":@[@"TestUIWithFakeIndividualAccount", @"TestUIWithFakeBusinessAccount"], @"User":@[@"UserGenerate", @"UserShow", @"UserCreate", @"UserUpdate", @"UserDestroy"], @"Session":@[@"SessionCreate - Login", @"SessionDestroy - Logout"], @"Item":@[@"ItemIndex", @"ItemShow", @"ItemCreate", @"ItemUpdate", @"ItemDestroy"], @"Message":@[@"MessageIndex", @"MessageShow", @"MessageCreate", @"MessageUpdate", @"MessageDestroy"],@"Other":@[@"ReportCreate" ,@"AdTypes" ,@"Countries" ,@"CustomerTypes" ,@"Languages" ,@"ReportReasons"]};
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
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if ([cell.textLabel.text isEqualToString:@"UserGenerate"]) {
		
			[self.loader show];
			__weak typeof(self) weakSelf = self;
		
			[[APIClient sharedInstance] generateUserWithCompletion:^(id response, NSError *error, NSInteger statusCode) {
				[weakSelf.loader hide];
				if (error) {
					DLog(@"Generate user: %@",error);
		            [Utils showErrorForStatusCode:statusCode];
				} else {
		            NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
					DLog(@"Generate user: %@",response);
					UserModel *generatedUser = [UserModel modelWithDictionary:response];
					[[APIClient sharedInstance] updateCurrentUser:generatedUser];
					[[APIClient sharedInstance] updateUserPasswordWithDictionary:response];
					[Utils showWarningWithMessage:@"User successfully generated. Now you can Login"];
				}
			}];
		
	} else if ([cell.textLabel.text isEqualToString:@"TestUIWithFakeIndividualAccount"]) {
		NSDictionary *fakeUser = @{@"banned":@NO, @"customer_type_id":@2, @"description":@"Here is some description of personal profile", @"email":@"myemail@bulletina.net", @"id":@5, @"login":@"myFakeLogin", @"name":@"myFullName"};
		[[APIClient sharedInstance] updateCurrentUser:[UserModel modelWithDictionary:fakeUser]];
		[self showMainPage];
	} else if ([cell.textLabel.text isEqualToString:@"TestUIWithFakeBusinessAccount"]) {
		NSDictionary *fakeUser = @{@"banned":@NO, @"customer_type_id":@3, @"description":@"Here is some description of business profile", @"email":@"myemail@bulletina.net", @"id":@5, @"login":@"myFakeLogin", @"company_name":@"myCompanyName"};
		[[APIClient sharedInstance] updateCurrentUser:[UserModel modelWithDictionary:fakeUser]];
		[self showMainPage];
	} else if ([cell.textLabel.text isEqualToString:@"SessionCreate - Login"]) {
		[self createLoginSessionWithEmail:@"784900e9-d708-4e88-8b84-0ac8bac04620@bulletina.net" password:@"r0)Z@pX-HTpa"];
	}
}

#pragma mark - Utils

- (void)showMainPage
{
	MainPageController *mainPageController = [MainPageController new];
	UINavigationController *mainPageNavigationController = [[UINavigationController alloc] initWithRootViewController:mainPageController];
	[self.navigationController presentViewController:mainPageNavigationController animated:YES completion:nil];
}

- (void)createLoginSessionWithEmail:(NSString *)email password:(NSString *)password
{
	__weak typeof(self) weakSelf = self;
	[self.loader show];
	[[APIClient sharedInstance]loginSessionWithEmail:email password:password endpointArn:@"" deviceToken:@"" operatingSystem:@"" deviceType:@"" currentLattitude:[LocationManager sharedManager].currentLocation.coordinate.latitude currentLongitude:[LocationManager sharedManager].currentLocation.coordinate.longitude withCompletion:^(id response, NSError *error, NSInteger statusCode) {
		[weakSelf.loader hide];
		if (error) {
			[Utils showErrorForStatusCode:statusCode];
			DLog(@"Login: %@", error);
		} else {
			NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server");
			[[APIClient sharedInstance] updatePasstokenWithDictionary:response];
			[[APIClient sharedInstance] updateCurrentUser:[UserModel modelWithDictionary:response]];
			DLog(@"Login: %@", response);
			[Utils showWarningWithMessage:@"Login successfull. Now you have passtoken"];
		}
	}];
}


@end
