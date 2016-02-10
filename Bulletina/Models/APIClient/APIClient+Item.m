//
//  APIClient+Item.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "APIClient+Item.h"

// Models
#import "LocationManager.h"

@implementation APIClient (Item)

#pragma mark - Categories

- (void)categoriesListWithCompletion:(ResponseBlock)completion
{
    [self performGET:@"/api/v1/ad_types.json" withParameters:nil response:completion];
}

#pragma mark - AddNew

- (void)addNewItemWithName:(NSString *)name description:(NSString *)description price:(NSString *)price adType:(NSInteger)adType image:(UIImage *)image withCompletion:(ResponseBlock)completion;
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"passtoken" : self.passtoken}];
    NSMutableDictionary *itemParameters = [NSMutableDictionary dictionary];
    [itemParameters setValue:@(adType) forKey:@"ad_type_id"];
    [itemParameters setValue:price ? price : @"" forKey:@"price"];
//    [itemParameters setValue:name ? name : @"" forKey:@"name"];
    [itemParameters setValue:description ? description : @"" forKey:@"description"];
    [itemParameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.latitude) forKey:@"latitude"];
    [itemParameters setValue:@([LocationManager sharedManager].currentLocation.coordinate.longitude) forKey:@"longitude"];
//    [itemParameters setValue:@YES forKey:@"active"];
    [itemParameters setValue:@(self.currentUser.userId) forKey:@"user_id"];

    NSArray *dataArray;
    if (image) {
        dataArray = @[[self multipartFileWithContents:UIImageJPEGRepresentation(image, 1.0f) fileName:@"image.jpg" mimeType:@"image/jpeg" parameterName:@"item[image]"]];
    }
    
    [parameters setValue:itemParameters forKey:@"item"];

    [self performPOST:@"/api/v1/items.json" withParameters:parameters multipartData:dataArray response:completion];
}

@end
