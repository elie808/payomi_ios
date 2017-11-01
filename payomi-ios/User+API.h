//
//  User+API.h
//  payomi-ios
//
//  Created by Elie El Khoury on 10/19/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "User.h"
#import "EKNetworkingConstants.h"
#import <AFNetworking/AFNetworking.h>

typedef void (^UserSignUpSuccessBlock)(User *userObj);
typedef void (^UserSignUpErrorBlock)(NSError *error, NSString *errorMessage, NSInteger statusCode);

@interface User (API)

+ (void)loginCustomerWithFacebook:(NSString *)fbToken withBlock:(UserSignUpSuccessBlock)successBlock withErrors:(UserSignUpErrorBlock)errorBlock;

/*
 - (void)fetchDataForId:(NSString *)facebookID;
 - (void)removePlaceFromDB:(GMSPlace*)place forID:(NSString*)facebookID;
 - (void)addPlaceToDB:(GMSPlace*)place forID:(NSString*)facebookID;
 
 - (void)loginToFacebook;
 - (void)logoutOfFacebook;
 */

@end
