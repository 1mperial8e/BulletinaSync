//
//  DefaultSettingsTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface DefaultSettingsTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *settingTitleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *settingSwitch;

@end
