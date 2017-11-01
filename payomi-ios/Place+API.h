//
//  Place+API.h
//  payomi-ios
//
//  Created by Elie El Khoury on 10/25/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "Place.h"
#import "EKNetworkingConstants.h"
#import <AFNetworking/AFNetworking.h>

typedef void (^PlaceSuccessBlock)(NSArray <Place *> *placesArray);
typedef void (^PlaceErrorBlock)(NSError *error, NSString *errorMessage, NSInteger statusCode);

@interface Place (API)

+ (void)getPlacesForUser:(NSString *)token withBlock:(PlaceSuccessBlock)successBlock withErrors:(PlaceErrorBlock)errorBlock;

@end
