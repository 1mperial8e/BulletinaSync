//
//  CategoryHeaderView.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "CategoryHeaderView.h"

@implementation CategoryHeaderView

+ (CGFloat)heightWithText:(NSString *)text
{
	CategoryHeaderView *headerView = [CategoryHeaderView new];
	headerView.sectionTitleLabel.text = text;
	CGFloat height;
	height = ceil([headerView.sectionTitleLabel sizeThatFits:CGSizeMake(ScreenWidth - 20, MAXFLOAT)].height + 40);
	return height;
}

@end
