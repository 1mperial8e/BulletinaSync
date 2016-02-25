//
//  LoadingTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 2/25/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface LoadingTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
