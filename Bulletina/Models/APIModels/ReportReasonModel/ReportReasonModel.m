//
//  ReportReasonModel.m
//  Bulletina
//
//  Created by Stas Volskyi on 2/10/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "ReportReasonModel.h"

@implementation ReportReasonModel

- (void)parseDictionary:(NSDictionary *)dictionary
{
	_name = dictionary[@"name"];
	_text = dictionary[@"description"];
//	_reasonId = [dictionary[@"id"] longValue];
	_reasonId = 1;
#warning reasonId needed
	_active = [dictionary[@"active"]boolValue];
}

@end
