//
//  BaseRegisterProfileTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseRegisterProfileTableViewController.h"

@interface BaseRegisterProfileTableViewController ()

@end

@implementation BaseRegisterProfileTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tempUser = [UserModel new];	
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
	CGSize textSize = [newText sizeWithAttributes:@{NSFontAttributeName:[textField font]}];
	if ((textSize.width + 20) < CGRectGetWidth(textField.frame) || [string isEqualToString:@""]) {
		if (textField.placeholder == TextFieldPasswordPlaceholder) {
			self.tempUser.password = newText;
		} else if (textField.placeholder == TextFieldRePasswordPlaceholder) {
			self.tempUser.rePassword = newText;
		} else if (textField.placeholder == TextFieldWebsitePlaceholder) {
			self.tempUser.website = newText;
		} else if (textField.placeholder == TextFieldPhonePlaceholder) {
			self.tempUser.phone = newText;
		} else if (textField.placeholder == TextFieldFullnamePlaceholder) {
			self.tempUser.name = newText;
		} else if (textField.placeholder == TextFieldCompanyNamePlaceholder) {
			self.tempUser.companyName = newText;
		} else if (textField.placeholder == TextFieldNicknamePlaceholder) {
			self.tempUser.login = newText;
		} else if (textField.placeholder == TextFieldEmailPlaceholder) {
			self.tempUser.email = newText;
		}
		return YES;
	} else {
		return NO;
	}
}


@end
