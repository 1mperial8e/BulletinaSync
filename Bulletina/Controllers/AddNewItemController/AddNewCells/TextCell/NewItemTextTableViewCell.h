//
//  NewItemTextTableViewCell.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "PHTextView.h"

@interface NewItemTextTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet PHTextView *textView;
@property (assign, nonatomic) BOOL isEdited;

@end
