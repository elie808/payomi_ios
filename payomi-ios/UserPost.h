//
//  UserPost.h
//  payomi-ios
//
//  Created by Elie El Khoury on 2/27/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPost : NSObject

@property (strong, nonatomic) NSString *placeID;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *placeName;
@property (strong, nonatomic) NSString *date; //TODO: convert to NSDATE

@end
