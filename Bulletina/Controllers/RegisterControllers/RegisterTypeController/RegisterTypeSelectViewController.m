//
//  RegisterTypeSelectViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "RegisterTypeSelectViewController.h"
#import "PersonalRegisterTableViewController.h"

@interface RegisterTypeSelectViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topInsetConstraint;

@end

@implementation RegisterTypeSelectViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[self navigationController] setNavigationBarHidden:NO animated:NO];
	self.title = @"Register account";
	self.navigationController.navigationBar.backItem.title = @"Cancel";
	self.view.backgroundColor = [UIColor mainPageBGColor];
	
	self.topInsetConstraint.constant = ([self topBarHeight] + self.topInsetConstraint.constant) * [self heightCoefficient];
	[self.view layoutIfNeeded];
}

#pragma mark - Actions

- (IBAction)personalAccountSelectButtonTap:(id)sender
{
	PersonalRegisterTableViewController *personalRegisterTableViewController = [PersonalRegisterTableViewController new];
	[self.navigationController pushViewController:personalRegisterTableViewController animated:YES];
}

- (IBAction)businessAccountSelectButtonTap:(id)sender
{
	
}

- (IBAction)moreInfoButtonTap:(id)sender
{
	
}

#pragma mark - Utils

- (CGFloat)heightCoefficient
{
	return ScreenHeight / 667;
}

- (CGFloat)topBarHeight
{
	return CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight(Application.statusBarFrame);
}

@end
