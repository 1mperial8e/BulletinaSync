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

static CGFloat const ImageCellHeigth = 197;
static CGFloat const PriceCellHeigth = 44;

static NSInteger const CellsCount = 3;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	ImageCellIndex,
	PriceCellIndex,
	TextCellIndex
};

@interface AddNewItemTableViewController () <UITextViewDelegate, ImageActionSheetControllerDelegate>

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
	if (indexPath.item == ImageCellIndex) {
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
		return ImageCellHeigth * HeigthCoefficient;
	} else if (indexPath.row == PriceCellIndex) {
		return PriceCellHeigth * HeigthCoefficient;
	} else if (indexPath.row == TextCellIndex) {
		return [self heightForTextCell];
	}
	return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark - Cells

- (NewItemImageTableViewCell *)imageCellForIndexPath:(NSIndexPath *)indexPath
{
	NewItemImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NewItemImageTableViewCell.ID forIndexPath:indexPath];
	cell.borderView.layer.borderColor = [UIColor appOrangeColor].CGColor;
	cell.borderView.layer.borderWidth = 1.0f;
	if (self.itemImage) {
		cell.itemImageView.image = self.itemImage;
	} else {
		cell.itemImageView.image = nil;
	}
	[cell.selectImageButton addTarget:self action:@selector(selectImageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	cell.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
	return cell;
}

- (NewItemPriceTableViewCell *)priceCellForIndexPath:(NSIndexPath *)indexPath
{
	NewItemPriceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NewItemPriceTableViewCell.ID forIndexPath:indexPath];
	cell.priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
	return cell;
}

- (NewItemTextTableViewCell *)textCellForIndexPath:(NSIndexPath *)indexPath
{
	self.textCell = [self.tableView dequeueReusableCellWithIdentifier:NewItemTextTableViewCell.ID forIndexPath:indexPath];
	self.textCell.textView.delegate = self;
	self.textCell.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
	self.textCell.textView.returnKeyType = UIReturnKeyDone;
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
	CGFloat height = ceil([textView sizeThatFits:CGSizeMake(ScreenWidth - 34, MAXFLOAT)].height + 0.5);
	if (textView.contentSize.height > height + 1 || textView.contentSize.height < height - 1) {
		[self.tableView beginUpdates];
		[self.tableView endUpdates];
		
		CGRect textViewRect = [self.tableView convertRect:textView.frame fromView:textView.superview];
		textViewRect.origin.y += 5;
		[self.tableView scrollRectToVisible:textViewRect animated:YES];
	}
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

@end
