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

static CGFloat const PersonalLogoCellHeigth = 220;
static CGFloat const BusinessLogoCellHeigth = 252;

static NSInteger const CellsCount = 3;

typedef NS_ENUM(NSUInteger, CellsIndexes) {
	LogoCellIndex	
};

@interface MyItemsTableViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) UIImageView *topBackgroundImageView;
@property (weak, nonatomic) NSLayoutConstraint *backgroundTopConstraint;

//Temp
@property (strong, nonatomic) NSString *itemText;
@property (strong, nonatomic) UIImage *itemImage;

@end

@implementation MyItemsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self tableViewSetup];
	[self setupNavigationBar];
	
	self.title = @"My Bulletina";
	
	//Temp
	self.itemText = @"Lorem ipsum dolor sit er elit lamet, consectetaur ci l li um adi pis ici ng pe cu, sed do eiu smod tempor.	ipsum dolor sit er elit lamet, consectetaur c i ll iu m adipisicing pecu, sed do eiusmod tempor dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor. sed do eiusmod tempor.";
	
	self.itemImage = [UIImage imageNamed:@"ItemExample"];
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

- (ItemTableViewCell *)defaultCellForIndexPath:(NSIndexPath *)indexPath
{
	ItemTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemTableViewCell.ID forIndexPath:indexPath];
	cell.backgroundColor = [UIColor mainPageBGColor];
	
	cell.itemImageView.image = self.itemImage;
	cell.itemViewHeightConstraint.constant = [self heighOfImageViewForImage:self.itemImage];
	[self.view layoutIfNeeded];
	
	if (indexPath.item % 2) {
		[cell.itemStateButton setTitle:@"NEW" forState:UIControlStateNormal];
		cell.itemStateButton.backgroundColor = [UIColor mainPageGreenColor];
		cell.itemStateButton.hidden = NO;
	}
	
	[cell.itemTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    cell.itemTextView.editable = YES;
    cell.itemTextView.text = self.itemText;
    cell.itemTextView.editable = NO;
	UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemImageTap:)];
	[cell.itemImageView addGestureRecognizer:imageTapGesture];
	
	cell.itemStateButton.layer.cornerRadius = 7;
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == LogoCellIndex) {
		return [self heightForTopCell];
	}
	return [self itemCellHeightForText:self.itemText andImage:self.itemImage];
}

#pragma mark - Actions

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

- (void)addCustomBorderToButton:(UIButton *)button
{
	button.layer.borderColor = [UIColor whiteColor].CGColor;
	button.layer.borderWidth = 1.0f;
	button.layer.cornerRadius = 5;
}

#pragma mark - Setup

- (void)setupNavigationBar
{
	[super setupNavigationBar];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTap:)];
	self.navigationItem.hidesBackButton = YES;
}

- (void)tableViewSetup
{
	[super tableViewSetup];
	
	[self.tableView registerNib:IndividualProfileLogoTableViewCell.nib forCellReuseIdentifier:IndividualProfileLogoTableViewCell.ID];
	[self.tableView registerNib:BusinessProfileLogoTableViewCell.nib forCellReuseIdentifier:BusinessProfileLogoTableViewCell.ID];
	UIView *backgroundView = [[UIView alloc] init];
	UIImageView *backgroundImageView = [[UIImageView alloc] init];
	[backgroundView addSubview:backgroundImageView];
	backgroundView.backgroundColor = [UIColor mainPageBGColor];
	backgroundImageView.image = [UIImage imageNamed:@"TopBackground"];
	backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.tableView.backgroundView = backgroundView;
	self.backgroundTopConstraint = [NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeTop multiplier:1.0f constant:64];
	[backgroundView addConstraint:self.backgroundTopConstraint];
	[backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:[self heightForTopCell]]];
	[backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	self.topBackgroundImageView = backgroundImageView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat scaleCoef = 1 + (scrollView.contentOffset.y < -64 ? (fabs(scrollView.contentOffset.y + 64.0) / 120) : 0);
	self.topBackgroundImageView.transform = CGAffineTransformMakeScale(scaleCoef, scaleCoef);
	self.backgroundTopConstraint.constant = scrollView.contentOffset.y < 0 ? fabs(scrollView.contentOffset.y) : -scrollView.contentOffset.y;
}


@end
