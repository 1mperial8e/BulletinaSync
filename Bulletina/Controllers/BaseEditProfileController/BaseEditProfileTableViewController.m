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
	
	self.tempUser = [[APIClient sharedInstance].currentUser copy];
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
	[self.tableView registerNib:AvatarTableViewCell.nib forCellReuseIdentifier:AvatarTableViewCell.ID];
	[self.tableView registerNib:BusinessLogoTableViewCell.nib forCellReuseIdentifier:BusinessLogoTableViewCell.ID];
	[self.tableView registerNib:InputTableViewCell.nib forCellReuseIdentifier:InputTableViewCell.ID];
	[self.tableView registerNib:ButtonTableViewCell.nib forCellReuseIdentifier:ButtonTableViewCell.ID];
	[self.tableView registerNib:EditProfileAboutTableViewCell.nib forCellReuseIdentifier:EditProfileAboutTableViewCell.ID];
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 30, 0)];
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];	
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
	if (!self.avatarImage) {
        if ([APIClient sharedInstance].currentUser.avatarUrl) {
            [cell.avatarImageView setImageWithURL:[APIClient sharedInstance].currentUser.avatarUrl];
        }
    } else {
        cell.avatarImageView.image = self.avatarImage;
    }
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);

	[cell.selectImageButton addTarget:self action:@selector(selectImageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
}

- (BusinessLogoTableViewCell *)logoCellForIndexPath:(NSIndexPath *)indexPath
{
	BusinessLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BusinessLogoTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	
    if (!self.avatarImage) {
        if ([APIClient sharedInstance].currentUser.avatarUrl) {
            [cell.avatarImageView setImageWithURL:[APIClient sharedInstance].currentUser.avatarUrl];
        }
    } else {
        cell.avatarImageView.image = self.avatarImage;
    }
	
	if (!self.logoImage) {
		if ([APIClient sharedInstance].currentUser.companyLogoUrl) {
			[cell.logoImageView setImageWithURL:[APIClient sharedInstance].currentUser.companyLogoUrl];
		}
	} else {
		cell.logoImageView.image = self.logoImage;
	}
	
	cell.avatarImageView.layer.borderColor = [UIColor colorWithRed:205 / 255.0f green:205 / 255.0f blue:205 / 255.0f alpha:1.0f].CGColor;
	cell.avatarImageView.layer.borderWidth = 5.0f;
	cell.avatarImageView.layer.cornerRadius = CGRectGetHeight(cell.avatarImageView.frame) / 2;
	cell.selectAvatarButton.tag = AvatarImageIndex;
	
	cell.logoImageView.layer.borderColor = [UIColor colorWithRed:205 / 255.0f green:205 / 255.0f blue:205 / 255.0f alpha:1.0f].CGColor;
	cell.logoImageView.layer.borderWidth = 1.0f;
	cell.logoImageView.layer.cornerRadius = 13;
	cell.selectLogoButton.tag = LogoImageIndex;
	
	[cell.selectLogoButton addTarget:self action:@selector(selectImageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	[cell.selectAvatarButton addTarget:self action:@selector(selectImageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	cell.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (EditProfileAboutTableViewCell *)aboutCellForIndexPath:(NSIndexPath *)indexPath
{
	self.aboutCell = [self.tableView dequeueReusableCellWithIdentifier:EditProfileAboutTableViewCell.ID forIndexPath:indexPath];
	
	self.aboutCell.aboutTextView.delegate = self;
	[self.aboutCell.aboutTextView setTextContainerInset:UIEdgeInsetsMake(20, 0, 15, 0)];
	self.aboutCell.aboutTextView.textContainer.lineFragmentPadding = 0;
	self.aboutCell.aboutTextView.placeholder = TextViewPlaceholderText;

	if (!self.aboutCell.aboutTextView.text.length && !self.aboutCell.isEdited) {
		self.aboutCell.aboutTextView.text = [APIClient sharedInstance].currentUser.about.length ? [APIClient sharedInstance].currentUser.about : @"";
	}
	if ([APIClient sharedInstance].currentUser.customerTypeId != AnonymousAccount) {
        self.aboutCell.aboutTextView.returnKeyType = UIReturnKeyDone;
	}
	self.aboutCell.selectionStyle = UITableViewCellSelectionStyleNone;

	return self.aboutCell ;
}

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
	DLog(@"Not implemented");
}

#pragma mark - Utils

- (CGFloat)heightForAboutCell
{
	if (!self.aboutCell) {
		self.aboutCell = [[NSBundle mainBundle] loadNibNamed:EditProfileAboutTableViewCell.ID owner:nil options:nil].firstObject;
	}
	[self.aboutCell.aboutTextView setTextContainerInset:UIEdgeInsetsMake(20, 0, 15, 0)];
	
	if (!self.aboutCell.aboutTextView.text.length && !self.aboutCell.isEdited) {
		self.aboutCell.aboutTextView.text = [APIClient sharedInstance].currentUser.about.length ? [APIClient sharedInstance].currentUser.about : @"";
	}
	
	CGFloat height;
	if (!self.aboutCell.aboutTextView.text.length) {
		self.aboutCell.aboutTextView.text = TextViewPlaceholderText;
		height = ceil([self.aboutCell.aboutTextView sizeThatFits:CGSizeMake(ScreenWidth - 30, MAXFLOAT)].height + 0.5);
		self.aboutCell.aboutTextView.text = @"";
	} else {
		height = ceil([self.aboutCell.aboutTextView sizeThatFits:CGSizeMake(ScreenWidth - 30, MAXFLOAT)].height + 2.5);
	}
	return height + 5.f;
}

- (void)updateImage:(UIImage *)image forImageIndex:(NSInteger)imageIndex
{
	if (imageIndex == LogoImageIndex) {
		self.logoImage = image;
	} else {
		self.avatarImage = image;
	}
	
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:LogoCellSharedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
	CGSize textSize = [newText sizeWithAttributes:@{NSFontAttributeName:[textField font]}];
	if ((textSize.width + 20) < CGRectGetWidth(textField.frame) || [string isEqualToString:@""]) {
		if (textField.placeholder == TextFieldLinkedinPlaceholder) {
			self.tempUser.linkedin = newText;
		} else if (textField.placeholder == TextFieldFacebookPlaceholder) {
			self.tempUser.facebook = newText;
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
	self.aboutCell.isEdited = YES;
	CGFloat height = ceil([textView sizeThatFits:CGSizeMake(ScreenWidth - 30, MAXFLOAT)].height + 0.5);
	if (textView.contentSize.height > height + 1 || textView.contentSize.height < height - 1 || !textView.text.length) {
		[self.tableView beginUpdates];
		[self.tableView endUpdates];
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

@end
