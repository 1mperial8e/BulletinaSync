//
//  AccountTypeTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/20/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol AccountTypeTableViewCellDelegate <NSObject>

- (void)pressMoreInfoButton;

@end

@interface AccountTypeTableViewCell : BaseTableViewCell

@property (weak, nonatomic) id<AccountTypeTableViewCellDelegate> delegate;

- (void)configureCellForTitle:(NSString *)title imageName:(NSString *)imageName;
- (void)hideMoreInfoButton:(BOOL)hide;

@end
