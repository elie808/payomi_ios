//
//  User+Helpers.h
//  payomi-ios
//
//  Created by Elie El Khoury on 10/20/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "User.h"

@interface User (Helpers)

+ (User *)userFromJSON:(NSString *)userJSONString;
+ (User *)updateUser:(User *)existingUser from:(User *)newUser;
- (NSString *)convertToJSON;

@end
