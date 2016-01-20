//
//  MyItemsTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "MyItemsTableViewController.h"
#import "FullScreenImageViewController.h"

//Cells
#import "IndividualProfileLogoTableViewCell.h"
#import "BusinessProfileLogoTableViewCell.h"
#import "ItemTableViewCell.h"

static CGFloat const ItemTableViewCellHeigth = 510.0f;
static CGFloat const PersonalLogoCellHeigth = 220;
static CGFloat const BusinessLogoCellHeigth = 252;

static NSInteger const CellsCount = 3;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	LogoCellIndex	
};

@interface MyItemsTableViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) UIImageView *topBackgroundImageView;
@property (weak, nonatomic) NSLayoutConstraint *backgroundTopConstraint;

@end

@implementation MyItemsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self tableViewSetup];
	[self setupNavBar];
	
	self.title = @"My Bulletina";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return CellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item == LogoCellIndex) {
		return [self logoCellForIndexPath:indexPath];
	}
	return [self defaultCellForIndexPath:indexPath];
}

#pragma mark - Cells

- (UITableViewCell *)logoCellForIndexPath:(NSIndexPath *)indexPath
{
	if (self.profileType == IndividualProfile) {
		IndividualProfileLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:IndividualProfileLogoTableViewCell.ID forIndexPath:indexPath];
		cell.aboutMeTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
		cell.logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
		cell.logoImageView.layer.borderWidth = 2.0f;
		cell.logoImageView.layer.cornerRadius = CGRectGetHeight(cell.logoImageView.frame) / 2;
		cell.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
		return cell;
	}
	BusinessProfileLogoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BusinessProfileLogoTableViewCell.ID forIndexPath:indexPath];
	[self addCustomBorderToButton:cell.websiteButton];
	[self addCustomBorderToButton:cell.facebookButton];
	[self addCustomBorderToButton:cell.instagramButton];
	[self addCustomBorderToButton:cell.linkedInButton];
	cell.separatorInset = UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
	return cell;
}

- (void)addCustomBorderToButton:(UIButton *)button
{
	button.layer.borderColor = [UIColor whiteColor].CGColor;
	button.layer.borderWidth = 1.0f;
	button.layer.cornerRadius = 5;
}

- (ItemTableViewCell *)defaultCellForIndexPath:(NSIndexPath *)indexPath
{
	ItemTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	
	if (indexPath.item % 2) {
		[cell.itemStateButton setTitle:@"NEW" forState:UIControlStateNormal];
		cell.itemStateButton.backgroundColor = [UIColor mainPageGreenColor];
		cell.itemStateButton.hidden = NO;
	}
	
	UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemImageTap:)];
	[cell.itemImageView addGestureRecognizer:imageTapGesture];
	
	cell.itemStateButton.layer.cornerRadius = 7;
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = ItemTableViewCellHeigth;
	if (indexPath.row == LogoCellIndex) {
		return [self heightForTopCell];
	}
	return height;
}

#pragma mark - Actions

- (void)itemImageTap:(UITapGestureRecognizer *)sender
{
	if (((UIImageView *)sender.view).image) {
		CGRect cellFrame = [self.navigationController.view convertRect:sender.view.superview.superview.frame fromView:self.tableView];
		CGRect imageViewRect = sender.view.frame;
		imageViewRect.origin.x = ([UIScreen mainScreen].bounds.size.width - imageViewRect.size.width) / 2;
		imageViewRect.origin.y = cellFrame.origin.y + CGRectGetHeight(self.navigationController.navigationBar.frame);
		
		FullScreenImageViewController *imageController = [FullScreenImageViewController new];
		imageController.image = ((UIImageView *)sender.view).image;
		imageController.presentationRect = imageViewRect;
		imageController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
		[self.navigationController presentViewController:imageController animated:NO completion:nil];
	}
}

- (void)doneButtonTap:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Utils

- (CGFloat)heightForTopCell
{
	if (self.profileType == IndividualProfile) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:IndividualProfileLogoTableViewCell.ID owner:self options:nil];
		IndividualProfileLogoTableViewCell *cell = [topLevelObjects firstObject];
		CGSize size = CGSizeZero;
		size = [cell.aboutMeTextView sizeThatFits:CGSizeMake(ScreenWidth - 60, MAXFLOAT)];
		return (size.height + PersonalLogoCellHeigth);
	}
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:BusinessProfileLogoTableViewCell.ID owner:self options:nil];
	BusinessProfileLogoTableViewCell *cell = [topLevelObjects firstObject];
	CGSize size = CGSizeZero;
	size = [cell.companyDescriptionTextView sizeThatFits:CGSizeMake(ScreenWidth - 60, MAXFLOAT)];
	return (size.height + BusinessLogoCellHeigth);
}

#pragma mark - Setup

- (void)setupNavBar
{
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor appOrangeColor]];
	[self.navigationController.navigationBar
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appOrangeColor]}];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTap:)];
	self.navigationItem.hidesBackButton = YES;
}

- (void)tableViewSetup
{
	[self.tableView registerNib:ItemTableViewCell.nib forCellReuseIdentifier:ItemTableViewCell.ID];
	[self.tableView registerNib:IndividualProfileLogoTableViewCell.nib forCellReuseIdentifier:IndividualProfileLogoTableViewCell.ID];
	[self.tableView registerNib:BusinessProfileLogoTableViewCell.nib forCellReuseIdentifier:BusinessProfileLogoTableViewCell.ID];
	
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 30, 0)];
	UIView *backgroundView = [[UIView alloc] init];
	UIImageView *backgroundImageView = [[UIImageView alloc] init];
	[backgroundView addSubview:backgroundImageView];
	backgroundView.backgroundColor = [UIColor mainPageBGColor];
	backgroundImageView.image = [UIImage imageNamed:@"TopBackground"];
	backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.tableView.backgroundView = backgroundView;
	self.tableView.backgroundColor = [UIColor whiteColor];
	self.backgroundTopConstraint = [NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeTop multiplier:1.0f constant:64];
	[backgroundView addConstraint:self.backgroundTopConstraint];
	
	[backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:[self heightForTopCell]]];
	
	[backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	self.topBackgroundImageView = backgroundImageView;
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat scaleCoef = 1 + (scrollView.contentOffset.y < -64 ? (fabs(scrollView.contentOffset.y + 64.0) / 120) : 0);
	self.topBackgroundImageView.transform = CGAffineTransformMakeScale(scaleCoef, scaleCoef);
	self.backgroundTopConstraint.constant = scrollView.contentOffset.y < 0 ? fabs(scrollView.contentOffset.y) : -scrollView.contentOffset.y;
}


@end
