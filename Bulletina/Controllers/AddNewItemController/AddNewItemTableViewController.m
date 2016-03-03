//
//  AddNewItemTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "AddNewItemTableViewController.h"
#import "ItemsListTableViewController.h"

// Cells
#import "NewItemTextTableViewCell.h"
#import "NewItemPriceTableViewCell.h"
#import "NewItemImageTableViewCell.h"
#import "ImageActionSheetController.h"
#import "AddImageButtonTableViewCell.h"

// Models
#import "APIClient+Item.h"

//Categories
#import "UIImageView+AFNetworking.h"


static CGFloat const PriceCellHeigth = 44;

static NSInteger const CellsCount = 4;
static NSString *const TextViewPlaceholderText = @"Write your description here. Use #hashtags for making your ad more searchable.";

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	CameraButtonCellIndex,
	TextCellIndex,
	PriceCellIndex,
	ImageCellIndex
};

@interface AddNewItemTableViewController () <UITextViewDelegate, ImageActionSheetControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NewItemTextTableViewCell *textCell;
@property (strong, nonatomic) UIImage *itemImage;
@property (strong, nonatomic) UITextField *priceTextField;;

@end

@implementation AddNewItemTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{	
    [super viewDidLoad];
	[self tableViewSetup];
	[self setupUI];
	
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item == CameraButtonCellIndex) {
		return [self cameraButtonCellForIndexPath:indexPath];
	} else if (indexPath.item == ImageCellIndex) {
		return [self imageCellForIndexPath:indexPath];
	} else if (indexPath.item == PriceCellIndex) {
		return [self priceCellForIndexPath:indexPath];
	} else if (indexPath.item == TextCellIndex) {
		return [self textCellForIndexPath:indexPath];
	}
	return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = PriceCellHeigth * HeigthCoefficient;
	if (indexPath.row == ImageCellIndex) {
		return [self heightForImageCell];
	} else if (indexPath.row == PriceCellIndex) {
		if (self.category.hasPrice || self.adItem.category.hasPrice) {
			return PriceCellHeigth * HeigthCoefficient;
		} else {
			return 0.0;
		}		
	} else if (indexPath.row == TextCellIndex) {
		return [self heightForTextCell];
	} else if (indexPath.row == CameraButtonCellIndex && self.adItem) {
		return 0.0;
	}
	return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.item == CameraButtonCellIndex) {
		[self selectImageButtonTap:nil];
	}
}

#pragma mark - Cells

- (AddImageButtonTableViewCell *)cameraButtonCellForIndexPath:(NSIndexPath *)indexPath
{
	AddImageButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AddImageButtonTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor appOrangeColor];
	return cell;
}

- (NewItemImageTableViewCell *)imageCellForIndexPath:(NSIndexPath *)indexPath
{
	NewItemImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NewItemImageTableViewCell.ID forIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (self.itemImage) {
		cell.itemImageView.image = self.itemImage;
	} else if (self.adItem.imagesUrl) {
		[cell.itemImageView setImageWithURL:self.adItem.imagesUrl];
	} else {
		cell.itemImageView.image = nil;
	}
//	[cell.itemImageView addObserver:self forKeyPath:@"image" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	return cell;
}

- (NewItemPriceTableViewCell *)priceCellForIndexPath:(NSIndexPath *)indexPath
{
	NewItemPriceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NewItemPriceTableViewCell.ID forIndexPath:indexPath];
	cell.clipsToBounds = YES;
	if (!cell.priceTextField.text.length) {
		cell.priceTextField.text = self.adItem ? self.adItem.price : @"";
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.priceTextField.delegate = self;
	self.priceTextField = cell.priceTextField;
	
	return cell;
}

- (NewItemTextTableViewCell *)textCellForIndexPath:(NSIndexPath *)indexPath
{
	self.textCell = [self.tableView dequeueReusableCellWithIdentifier:NewItemTextTableViewCell.ID forIndexPath:indexPath];
	self.textCell.clipsToBounds = YES;
	if (!self.textCell.textView.text.length && !self.textCell.isEdited) {
		self.textCell.textView.text = self.adItem ? self.adItem.text : @"";
	}
	self.textCell.textView.placeholder = TextViewPlaceholderText;
	self.textCell.textView.delegate = self;
	self.textCell.textView.textColor = [UIColor appDarkTextColor];
	[self.textCell.textView setTextContainerInset:UIEdgeInsetsMake(10, 20, 5, 20)];
	self.textCell.textView.returnKeyType = UIReturnKeyDone;
	self.textCell.selectionStyle = UITableViewCellSelectionStyleNone;
	return self.textCell;
}

#pragma mark - Actions

- (void)publishNavBarAction:(id)sender
{
	__weak typeof(self) weakSelf = self;
	if (![self.textCell.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
		[Utils showWarningWithMessage:@"Description is requied"];	
	} else if (![LocationManager sharedManager].currentLocation) {
		[Utils showLocationErrorOnViewController:self];		
	} else {
        [self.tableView endEditing:YES];
		if (!self.adItem) {
			[[APIClient sharedInstance] addNewItemWithDescription:self.textCell.textView.text price:self.priceTextField.text adType:self.category.categoryId image:[Utils scaledImage:self.itemImage] withCompletion:^(id response, NSError *error, NSInteger statusCode) {
				if (error) {
					if (response[@"error_message"]) {
						[Utils showErrorWithMessage:response[@"error_message"]];
					} else {
						[Utils showErrorForStatusCode:statusCode];
					}
				} else {
					//item added,  message needed
				}
			}];
		} else {
			[[APIClient sharedInstance] updateItemId:self.adItem.itemId withDescription:self.textCell.textView.text price:self.priceTextField.text adType:self.adItem.category.categoryId image:[Utils scaledImage:self.itemImage] withCompletion:^(id response, NSError *error, NSInteger statusCode) {
				if (error) {
					if (response[@"error_message"]) {
						[Utils showErrorWithMessage:response[@"error_message"]];
					} else {
						[Utils showErrorForStatusCode:statusCode];
					}
				} else {
					NSAssert([response isKindOfClass:[NSDictionary class]], @"Unknown response from server (update item)");
					ItemModel *updatedItem = [ItemModel modelWithDictionary:response];
					
					//temp
					updatedItem.userNickname = weakSelf.adItem.userNickname;
					updatedItem.userAvatarThumbUrl = weakSelf.adItem.userAvatarThumbUrl;
					updatedItem.userCompanyName = weakSelf.adItem.userCompanyName;
					updatedItem.userFullname = weakSelf.adItem.userFullname;
					updatedItem.userUserAvatarUrl = weakSelf.adItem.userUserAvatarUrl;
					updatedItem.userId = weakSelf.adItem.userId;
					//temp
					
					[[NSNotificationCenter defaultCenter] postNotificationName:UpdatedItemNotificaionName object:nil userInfo:@{ItemNotificaionKey : updatedItem}];
				}
			}];
		}
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)cancelNavBarAction:(id)sender
{
	if (self.adItem) {
		[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

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

#pragma mark - Setup

- (void)setupUI
{
	self.navigationItem.title =  self.adItem ? @"Edit" : self.category.name;
	if (self.adItem) {
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNavBarAction:)];
	}
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Publish" style:UIBarButtonItemStylePlain target:self action:@selector(publishNavBarAction:)];
}

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 25, 0)];
	
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	self.tableView.backgroundColor = [UIColor mainPageBGColor];
	
	[self.tableView registerNib:AddImageButtonTableViewCell.nib forCellReuseIdentifier:AddImageButtonTableViewCell.ID];
	[self.tableView registerNib:NewItemImageTableViewCell.nib forCellReuseIdentifier:NewItemImageTableViewCell.ID];
	[self.tableView registerNib:NewItemPriceTableViewCell.nib forCellReuseIdentifier:NewItemPriceTableViewCell.ID];
	[self.tableView registerNib:NewItemTextTableViewCell.nib forCellReuseIdentifier:NewItemTextTableViewCell.ID];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
{
	if ([string isEqualToString:@"\n"]) {
		[self.view endEditing:YES];
		return  NO;
	}
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	self.textCell.isEdited = YES;
	CGFloat height = ceil([self.textCell.textView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
	if (self.textCell.textView.contentSize.height > height + 1 || self.textCell.textView.contentSize.height < height - 1 || !textView.text.length) {
		[self.tableView beginUpdates];
		[self.tableView endUpdates];
		
		CGRect textViewRect = [self.tableView convertRect:self.textCell.textView.frame fromView:self.textCell.textView.superview];
		textViewRect.origin.y += 5;
		[self.tableView scrollRectToVisible:textViewRect animated:YES];
	}
}

#pragma mark - ImageActionSheetControllerDelegate

- (void)imageActionSheetControllerDidReceiveError:(NSError *)error
{
	DLog(@"%@", error);
}

- (void)imageActionSheetControllerDidSelectImageWithPicker:(UIImage *)image
{
	[self updateImage:image];
}

- (void)imageActionSheetControllerDidTakeImageWithPicker:(UIImage *)image
{
	[self updateImage:image];
}

#pragma mark - Utils

- (CGFloat)heightForImageCell
{
	CGFloat ratio;
	if (self.itemImage) {
		ratio = self.itemImage.size.height / self.itemImage.size.width;
	} else if (self.adItem.imagesUrl) {
		ratio = self.adItem.imageHeight / self.adItem.imageWidth;
	} else {
		return 0;
	}
	return (ScreenWidth - 30) * ratio + 16;
}

- (CGFloat)heightForTextCell
{
	if (!self.textCell) {
		self.textCell = [[NSBundle mainBundle] loadNibNamed:NewItemTextTableViewCell.ID owner:nil options:nil].firstObject;
	}
	if (!self.textCell.textView.text.length && !self.textCell.isEdited) {
		self.textCell.textView.text = self.adItem ? self.adItem.text : @"";
	}

	CGFloat height;
	if (!self.textCell.textView.text.length) {
		self.textCell.textView.text = TextViewPlaceholderText;
		height = ceil([self.textCell.textView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
		self.textCell.textView.text = @"";
	} else {
		height = ceil([self.textCell.textView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
	}
	return height + 50.f;
}

- (void)updateImage:(UIImage *)image;
{
	self.itemImage = image;
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:ImageCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.tableView endEditing:YES];
	return NO;
}

#pragma mark - Notifications

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqual:@"image"]) {
		
	}
}

@end
