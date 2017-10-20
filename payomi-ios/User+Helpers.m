//
//  User+Helpers.m
//  payomi-ios
//
//  Created by Elie El Khoury on 10/20/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "User+Helpers.h"

@implementation User (Helpers)

+ (User *)userFromJSON:(NSString *)userJSONString {
    
    NSData *data = [userJSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    User *retrievedUser = [User new];
    
    [jsonDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [retrievedUser setValue:obj forKey:(NSString *)key];
    }];
    
    return retrievedUser;
}

+ (User *)updateUser:(User *)existingUser from:(User *)newUser {
    
    User *delta = [User new];

    delta.firstName = newUser.firstName.length > 0 ? newUser.firstName : existingUser.firstName;
    delta.lastName = newUser.lastName.length > 0 ? newUser.lastName : existingUser.lastName;
    delta.profilePicture = newUser.profilePicture.length > 0 ? newUser.profilePicture : existingUser.profilePicture;
    
    return delta;
}

#pragma mark - Helpers

- (NSString *)convertToJSON {
    
    NSDictionary *details = @{
                              @"firstName" : self.firstName.length > 0 ? self.firstName : @"",
                              @"lastName" : self.lastName.length > 0 ? self.lastName : @"",
                              @"profilePicture" : self.profilePicture.length > 0 ? self.profilePicture : @""
                              };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:details
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData) {
        
        NSLog(@"Got an error converting to JSONString: %@", error);
        return nil;
        
    } else {
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

@end
