//
//  EKSettings.m
//  payomi-ios
//
//  Created by Elie El Khoury on 10/20/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "EKSettings.h"

static NSString * const kLoggedInCustomer   = @"payomi-loggedInUser";

@implementation EKSettings

+ (BOOL)saveUser:(User *)user {
 
    NSString *userJSONString = [customer convertToJSON];
    
    if ([JNKeychain saveValue:userJSONString forKey:kLoggedInCustomer]) {
        
        NSLog(@"User persisted!");
        return YES;
        
    } else {
        
        NSLog(@"Failed to save User!");
        return NO;
    }
}

+ (User *)getSavedUser {
 
    NSString *userJSONString = [JNKeychain loadValueForKey:kLoggedInCustomer];
    
    if (userJSONString && userJSONString.length > 0) {
        
        return [Customer customerFromJSON:userJSONString];
        
    } else {
        
        NSLog(@"Did NOT Retrieve any saved CUSTOMERs");
        
        return nil;
    }
}

+ (BOOL)deleteSavedUser {
    
    if ([JNKeychain deleteValueForKey:kLoggedInCustomer]) {
        
        // [EKSettings destroySessionCookies];
        // [EKSettings deleteUserLocation];
        
        // [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"Authorization" value:@""];
        
        NSLog(@"Deleted value for key '%@'. User is now: %@", kLoggedInCustomer, [JNKeychain loadValueForKey:kLoggedInCustomer]);
        return YES;
        
    } else {
        
        NSLog(@"Failed to delete!");
        return NO;
    }
}

//+ (BOOL)updateSavedUser:(User *)updatedUser {
//    
//    Customer *oldUser = [EKSettings getSavedCustomer];
//    
//    Customer *userToPersist = [Customer updateCustomer:oldUser from:updatedCustomer];
//    
//    NSString *userJSONString = [userToPersist convertToJSON];
//    
//    if ([JNKeychain saveValue:userJSONString forKey:kLoggedInCustomer]) {
//        
//        NSLog(@"Customer updated and persisted!");
//        return YES;
//        
//    } else {
//        
//        NSLog(@"Failed to update and persist Customer!");
//        return NO;
//    }
//    
//    return NO;
//}

@end
