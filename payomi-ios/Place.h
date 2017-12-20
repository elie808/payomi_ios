//
//  Place.h
//  payomi-ios
//
//  Created by Elie El Khoury on 10/25/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface Place : JSONModel

@property (nonatomic) NSString <Optional> *_key;
@property (nonatomic) NSString <Optional> *placeId;
@property (nonatomic) NSString <Optional> *placeName;
@property (nonatomic) NSString <Optional> *placeAddress;
@property (nonatomic) NSString <Optional> *longitude;
@property (nonatomic) NSString <Optional> *latitude;

@end
