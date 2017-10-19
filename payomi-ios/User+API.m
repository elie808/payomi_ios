//
//  User+API.m
//  payomi-ios
//
//  Created by Elie El Khoury on 10/19/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "User+API.h"

@implementation User (API)

//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    [manager GET:BaseURLString
//      parameters:nil
//        progress:nil
//         success:^(NSURLSessionTask *task, id responseObject) {
//
//             NSLog(@"JSON: %@", responseObject);
//
//         } failure:^(NSURLSessionTask *operation, NSError *error) {
//
//             NSLog(@"Error: %@", error);
//         }];

/*
AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]
                                 initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

manager.requestSerializer = [AFJSONRequestSerializer serializer];
[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

Login *user = [Login new];
user.email = @"fouad.kada@gmail.com";
user.password = @"password";
NSDictionary *dict = [user toDictionary];

[manager POST:LoginURLString
   parameters:dict
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
          NSLog(@"success!");
          
          NSError *error;
          User *country = [[User alloc] initWithDictionary:responseObject error:&error];
          
          NSLog(@"COUNTRY.fName: %@", country.fName);
          NSLog(@"COUNTRY.products: %@", country.favorites);
          NSLog(@"COUNTRY.roles: %@", country.roles);
          
          NSLog(@"country.profileComplete: %@", country.profileComplete ? @"YES" : @"NO");
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          
          NSLog(@"error: %@", error);
      }];
*/

 
@end
