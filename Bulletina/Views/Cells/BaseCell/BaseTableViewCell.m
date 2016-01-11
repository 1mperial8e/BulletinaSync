//
//  BaseTableViewCell.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

#pragma mark - Static

+ (NSString *)ID
{
	return NSStringFromClass(self.class);
}

+ (UINib *)nib
{
	return [UINib nibWithNibName:self.ID bundle:nil];
}

@end
