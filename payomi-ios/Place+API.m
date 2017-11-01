//
//  Place+API.m
//  payomi-ios
//
//  Created by Elie El Khoury on 10/25/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "Place+API.h"

@implementation Place (API)

+ (void)getPlacesForUser:(NSString *)token withBlock:(PlaceSuccessBlock)successBlock withErrors:(PlaceErrorBlock)errorBlock {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]
                                     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    [manager GET:[NSString stringWithFormat:@"%@%@", kBaseURL, kUserPlacesAPIPath]
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {

             NSError *error;
             NSArray *places = [Place arrayOfModelsFromDictionaries:responseObject error:&error];
             
             NSLog(@"\n \n items: %@", places);
             
             successBlock(nil);

         } failure:^(NSURLSessionTask *operation, NSError *error) {

             NSLog(@"Error: %@", error);
             errorBlock(error, @"error message", 0);
         }];
}

@end
