//
//  BaseEditProfileTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseEditProfileTableViewController.h"
#import "UIImageView+AFNetworking.h"

@interface BaseEditProfileTableViewController ()

@end

@implementation BaseEditProfileTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self tableViewSetup];
	[self setupDefaults];
	[self setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self refreshInputViews];
}

#pragma mark - Setup

- (void)setupUI
{
	self.navigationItem.title = @"Edit profile";
	self.view.backgroundColor = [UIColor mainPageBGColor];
}

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	self.tableView.separatorColor = [UIColor clearColor];
	[self.tableView registerNib:AvatarTableViewCell.nib forCellReuseIdentifier:AvatarTableViewCell.ID];
	[self.tableView registerNib:BusinessLogoTableViewCell.nib forCellReuseIdentifier:BusinessLogoTableViewCell.ID];
	[self.tableView registerNib:InputTableViewCell.nib forCellReuseIdentifier:InputTableViewCell.ID];
	[self.tableView registerNib:ButtonTableViewCell.nib forCellReuseIdentifier:ButtonTableViewCell.ID];
	[self.tableView registerNib:EditProfileAboutTableViewCell.nib forCellReuseIdentifier:EditProfileAboutTableViewCell.ID];
	
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 30, 0)];
}

- (void)setupDefaults
{
	self.inputViewsCollection = [TextInputNavigationCollection new];
	self.loader = [[BulletinaLoaderView alloc] initWithView:self.navigationController.view andText:nil];
}

- (void)refreshInputViews
{
	DLog(@"Not implemented");
}

#pragma mark - Cells

- (AvatarTableViewCell *)avatarCellForIndexPath:(NSIndexPath *)indexPath
{
	AvatarTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AvatarTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	cell.avatarImageView.layer.borderColor = [UIColor grayColor].CGColor;
	cell.avatarImageView.layer.borderWidth = 5.0f;
	cell.avatarImageView.layer.cornerRadius = CGRectGetHeight(cell.avatarImageView.frame) / 2;
	if (!self.logoImage) {
        if ([APIClient sharedInstance].currentUser.avatarUrl) {
            [cell.avatarImageView setImageWithURL:[APIClient sharedInstance].currentUser.avatarUrl];
        }
    } else {
        cell.avatarImageView.image = self.logoImage;
    }
    
	[cell.selectImageButton addTarget:self action:@selector(selectImageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
}

- (BusinessLogoTableViewCell *)logoCellForIndexPath:(NSIndexPath *)indexPath
{
	BusinessLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BusinessLogoTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
    if (!self.logoImage) {
        if ([APIClient sharedInstance].currentUser.avatarUrl) {
            [cell.logoImageView setImageWithURL:[APIClient sharedInstance].currentUser.avatarUrl];
        }
    } else {
        cell.logoImageView.image = self.logoImage;
    }
	cell.logoImageView.layer.borderColor = [UIColor grayColor].CGColor;
	cell.logoImageView.layer.borderWidth = 2.0f;
	cell.logoImageView.layer.cornerRadius = 10;
	
	[cell.selectImageButton addTarget:self action:@selector(selectImageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
}

- (EditProfileAboutTableViewCell *)aboutCellForIndexPath:(NSIndexPath *)indexPath
{
	self.aboutCell = [self.tableView dequeueReusableCellWithIdentifier:EditProfileAboutTableViewCell.ID forIndexPath:indexPath];
	self.aboutCell .backgroundColor = [UIColor mainPageBGColor];
	self.aboutCell.aboutTextView.returnKeyType = UIReturnKeyNext;
	self.aboutCell.aboutTextView.delegate = self;
	[self.aboutCell.aboutTextView setTextContainerInset:UIEdgeInsetsMake(10, 5, 10, 5)];
	self.aboutCell.aboutTextView.layer.borderColor = [UIColor colorWithRed:225 / 255.0f green:225 / 255.0f  blue:225 / 255.0f  alpha:1].CGColor;
	self.aboutCell.aboutTextView.layer.borderWidth = 1.0f;
	self.aboutCell.aboutTextView.layer.cornerRadius = 5;
	self.aboutCell.aboutTextView.textColor = [UIColor blackColor];
	if (![APIClient sharedInstance].currentUser.about.length && !self.aboutCell.aboutTextView.text.length) {
		self.aboutCell.aboutTextView.placeholder = TextViewPlaceholderText;
	} else if ([APIClient sharedInstance].currentUser.about.length && !self.aboutCell.aboutTextView.text.length) {
		self.aboutCell.aboutTextView.text = [APIClient sharedInstance].currentUser.about;
	}
	if ([APIClient sharedInstance].currentUser.customerTypeId != AnonymousAccount) {
        self.aboutCell.aboutTextView.returnKeyType = UIReturnKeyDone;
	}
	return self.aboutCell ;
}

- (ButtonTableViewCell *)buttonCellForIndexPath:(NSIndexPath *)indexPath
{
	ButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ButtonTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	cell.saveButton.layer.cornerRadius = 5;
	[cell.saveButton addTarget:self action:@selector(saveButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
}

#pragma mark - Actions

- (void)selectImageButtonTap:(id)sender
{
	ImageActionSheetController *imageController = [ImageActionSheetController new];
	imageController.delegate = self;
	imageController.cancelButtonTintColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
	imageController.tintColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
	__weak typeof(self) weakSelf = self;
	imageController.photoDidSelectImageInPreview = ^(UIImage *image) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		[strongSelf updateImage:image];
	};
	[self presentViewController:imageController animated:YES completion:nil];
}

- (void)saveButtonTap:(id)sender
{
	DLog(@"Not implemented");
}

#pragma mark - Utils

- (CGFloat)heightForAboutCell
{
	if (!self.aboutCell) {
		self.aboutCell = [[NSBundle mainBundle] loadNibNamed:EditProfileAboutTableViewCell.ID owner:nil options:nil].firstObject;
	}
	[self.aboutCell.aboutTextView setTextContainerInset:UIEdgeInsetsMake(10, 5, 10, 5)];
	CGFloat height;
	if (![APIClient sharedInstance].currentUser.about.length && !self.aboutCell.aboutTextView.text.length) {
		self.aboutCell.aboutTextView.text = TextViewPlaceholderText;
		height = ceil([self.aboutCell.aboutTextView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
		self.aboutCell.aboutTextView.text = @"";
	} else if ([APIClient sharedInstance].currentUser.about.length && !self.aboutCell.aboutTextView.text.length) {
		self.aboutCell.aboutTextView.text = [APIClient sharedInstance].currentUser.about;
		self.aboutCell.aboutTextView.textColor = [UIColor blackColor];
		height = ceil([self.aboutCell.aboutTextView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
	} else {
		height = ceil([self.aboutCell.aboutTextView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
	}
	return height + 5.f;
}

- (void)updateImage:(UIImage *)image;
{
	DLog(@"Not implemented");
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

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	[self.inputViewsCollection inputViewWillBecomeFirstResponder:textView];
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
{
	if ([string isEqualToString:@"\n"]) {
		[self.inputViewsCollection next];
		return  NO;
	}
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	CGFloat height = ceil([textView sizeThatFits:CGSizeMake(ScreenWidth - 30, MAXFLOAT)].height + 0.5);
	if (textView.contentSize.height > height + 1 || textView.contentSize.height < height - 1 || !textView.text.length) {
		[self.tableView beginUpdates];
		[self.tableView endUpdates];
	
		CGRect textViewRect = [self.tableView convertRect:textView.frame fromView:textView.superview];
		textViewRect.origin.y += 5;
		[self.tableView scrollRectToVisible:textViewRect animated:YES];
	}
}

@end
