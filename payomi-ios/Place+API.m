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
             
             successBlock(places);

         } failure:^(NSURLSessionTask *operation, NSError *error) {

             NSLog(@"Error: %@", error);
             errorBlock(error, @"error message", 0);
         }];
}

+ (void)addPlace:(Place *)place forUser:(NSString *)token withBlock:(PlacePOSTSuccessBlock)successBlock withErrors:(PlaceErrorBlock)errorBlock {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]
                                     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *dict = [place toDictionary];

    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseURL, kUserPlacesAPIPath]
       parameters:dict
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSLog(@"success posting Place !");
              
              NSError *error;
              Place *placeObj = [[Place alloc] initWithDictionary:responseObject error:&error];
              
              successBlock(placeObj);

          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              NSLog(@"error: %@", error);
          }];
}

+ (void)removePlace:(Place *)place forUser:(NSString *)token withBlock:(PlaceDELETESuccessBlock)successBlock withErrors:(PlaceErrorBlock)errorBlock {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]
                                     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    [manager DELETE:[NSString stringWithFormat:@"%@%@/%@", kBaseURL, kUserPlacesAPIPath, place._key]
         parameters:nil
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               
                NSLog(@"success removing Place !");
                successBlock();
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
                errorBlock(error, task.taskDescription, 0);
            }];
}

@end
