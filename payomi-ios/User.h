//
//  User.h
//  payomi-ios
//
//  Created by Elie El Khoury on 10/19/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface User : JSONModel
//_id
@property (nonatomic) NSString <Optional>  *firstName;
@property (nonatomic) NSString <Optional> *lastName;
@property (nonatomic) NSString <Optional> *profilePicture;
//@property (nonatomic) NSArray <Favorites *> <Optional> *favorites;
//@property (nonatomic) NSArray <Optional> *roles;

//@property (nonatomic) BOOL profileComplete;

@end
