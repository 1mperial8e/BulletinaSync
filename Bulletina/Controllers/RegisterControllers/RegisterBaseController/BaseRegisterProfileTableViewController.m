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
	if ((textSize.width + 5) < CGRectGetWidth(textField.frame) || [string isEqualToString:@""]) {
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
			self.tempUser.username = newText;
		} else if (textField.placeholder == TextFieldEmailPlaceholder) {
			self.tempUser.email = newText;
		}
		return YES;
	} else {
		return NO;
	}
}

#pragma mark - ImageActionSheetControllerDelegate

- (void)imageActionSheetControllerDidReceiveError:(NSError *)error
{
	DLog(@"%@", error);
}

- (void)imageActionSheetControllerDidSelectImageWithPicker:(UIImage *)image
{
	[self updateImage:image forImageIndex:self.currentImageIndex];
}

- (void)imageActionSheetControllerDidTakeImageWithPicker:(UIImage *)image
{
	[self updateImage:image forImageIndex:self.currentImageIndex];
}

#pragma mark - Utils

- (void)updateImage:(UIImage *)image forImageIndex:(NSInteger)imageIndex
{
	if (imageIndex == LogoImageIndex) {
		self.logoImage = image;
	} else {
		self.avatarImage = image;
	}
	
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:LogoCellSharedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Setup

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	
	[self.tableView registerNib:AvatarTableViewCell.nib forCellReuseIdentifier:AvatarTableViewCell.ID];
	[self.tableView registerNib:BusinessLogoTableViewCell.nib forCellReuseIdentifier:BusinessLogoTableViewCell.ID];
	[self.tableView registerNib:InputTableViewCell.nib forCellReuseIdentifier:InputTableViewCell.ID];
	[self.tableView registerNib:ButtonTableViewCell.nib forCellReuseIdentifier:ButtonTableViewCell.ID];
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupDefaults
{
	self.view.backgroundColor = [UIColor mainPageBGColor];
	
	self.inputViewsCollection = [TextInputNavigationCollection new];
	self.loader = [[BulletinaLoaderView alloc] initWithView:self.navigationController.view andText:nil];
}

#pragma mark - Actions

- (void)selectImageButtonTap:(UIButton *)sender
{
	self.currentImageIndex = sender.tag;
	ImageActionSheetController *imageController = [ImageActionSheetController new];
	imageController.delegate = self;
	imageController.cancelButtonTintColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
	imageController.tintColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
	__weak typeof(self) weakSelf = self;
	imageController.photoDidSelectImageInPreview = ^(UIImage *image) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		[strongSelf updateImage:image forImageIndex:self.currentImageIndex];
	};
	[self presentViewController:imageController animated:YES completion:nil];
}

- (void)saveButtonTap:(id)sender
{
	//implemented in subclasses
}

#pragma mark - Cells

- (ButtonTableViewCell *)buttonCellForIndexPath:(NSIndexPath *)indexPath
{
	ButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ButtonTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	cell.saveButton.layer.cornerRadius = 5;
	[cell.saveButton addTarget:self action:@selector(saveButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);

	return cell;
}


@end
