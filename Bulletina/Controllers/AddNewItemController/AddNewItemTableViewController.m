//
//  AddNewItemTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "AddNewItemTableViewController.h"

//Cells
#import "NewItemTextTableViewCell.h"
#import "NewItemPriceTableViewCell.h"
#import "NewItemImageTableViewCell.h"
#import "ImageActionSheetController.h"
#import "AddImageButtonTableViewCell.h"

static CGFloat const PriceCellHeigth = 44;

static NSInteger const CellsCount = 4;
NSString * const TextViewPlaceholderText = @"Write your description here. Use #hashtags for making your ad more searchable.";

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	CameraButtonCellIndex,
	TextCellIndex,
	PriceCellIndex,
	ImageCellIndex
};

@interface AddNewItemTableViewController () <UITextViewDelegate, ImageActionSheetControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NewItemTextTableViewCell *textCell;
@property (strong,nonatomic) UIImage *itemImage;

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
		return PriceCellHeigth * HeigthCoefficient;
	} else if (indexPath.row == TextCellIndex) {
		return [self heightForTextCell];
	}
	return height;
}

- (CGFloat)heightForImageCell
{
	if (self.itemImage) {
		CGFloat ratio = self.itemImage.size.height / self.itemImage.size.width;		
		return (ScreenWidth - 30) * ratio + 16;
	}
	return 0;
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
	} else {
		cell.itemImageView.image = nil;
	}
	return cell;
}

- (NewItemPriceTableViewCell *)priceCellForIndexPath:(NSIndexPath *)indexPath
{
	NewItemPriceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NewItemPriceTableViewCell.ID forIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.priceTextField.delegate = self;
	return cell;
}

- (NewItemTextTableViewCell *)textCellForIndexPath:(NSIndexPath *)indexPath
{
	self.textCell = [self.tableView dequeueReusableCellWithIdentifier:NewItemTextTableViewCell.ID forIndexPath:indexPath];
	self.textCell.textView.delegate = self;
	self.textCell.textView.text = TextViewPlaceholderText;
	[self.textCell.textView setTextContainerInset:UIEdgeInsetsMake(10, 20, 5, 20)];
	self.textCell.textView.returnKeyType = UIReturnKeyDone;
	self.textCell.selectionStyle = UITableViewCellSelectionStyleNone;
	return self.textCell;
}

#pragma mark - Actions

- (void)cancelNavBarAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
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
	self.title = self.category;
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNavBarAction:)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Publish" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)tableViewSetup
{
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 5, 0)];
	
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	self.tableView.backgroundColor = [UIColor mainPageBGColor];
	
	[self.tableView registerNib:AddImageButtonTableViewCell.nib forCellReuseIdentifier:AddImageButtonTableViewCell.ID];
	[self.tableView registerNib:NewItemImageTableViewCell.nib forCellReuseIdentifier:NewItemImageTableViewCell.ID];
	[self.tableView registerNib:NewItemPriceTableViewCell.nib forCellReuseIdentifier:NewItemPriceTableViewCell.ID];
	[self.tableView registerNib:NewItemTextTableViewCell.nib forCellReuseIdentifier:NewItemTextTableViewCell.ID];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	if ([textView.text isEqualToString:TextViewPlaceholderText]) {
		textView.text = @"";
		textView.textColor = [UIColor blackColor];
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[self performTextViewText];
}

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
	[self performTextViewText];
}

#pragma mark - ImageActionSheetControllerDelegate

- (void)imageActionSheetControllerDidReceiveError:(NSError *)error
{
	NSLog(@"%@", error);
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

- (CGFloat)heightForTextCell
{
	if (!self.textCell) {
		self.textCell = [[NSBundle mainBundle] loadNibNamed:NewItemTextTableViewCell.ID owner:nil options:nil].firstObject;
	}
	CGFloat height = ceil([self.textCell.textView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
	return height + 50.f;
}

- (void)updateImage:(UIImage *)image;
{
	self.itemImage = image;
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:ImageCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)performTextViewText
{
	if ([self.textCell.textView.text isEqualToString:@""])
	{
		self.textCell.textView.text = TextViewPlaceholderText;
		self.textCell.textView.textColor = [UIColor lightGrayColor];
	}
	
	CGFloat height = ceil([self.textCell.textView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
	if (self.textCell.textView.contentSize.height > height + 1 || self.textCell.textView.contentSize.height < height - 1) {
		[self.tableView beginUpdates];
		[self.tableView endUpdates];
		
		CGRect textViewRect = [self.tableView convertRect:self.textCell.textView.frame fromView:self.textCell.textView.superview];
		textViewRect.origin.y += 5;
		[self.tableView scrollRectToVisible:textViewRect animated:YES];
	}
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.tableView endEditing:YES];
	return NO;
}

@end
