//
//  EKSettings.h
//  payomi-ios
//
//  Created by Elie El Khoury on 10/20/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "User+Helpers.h"

#import <JNKeychain/JNKeychain.h>

@interface EKSettings : NSObject

+ (BOOL)saveUser:(User *)user;
+ (User *)getSavedUser;
+ (BOOL)deleteSavedUser;
//+ (BOOL)updateSavedUser:(User *)updatedUser;

@end
