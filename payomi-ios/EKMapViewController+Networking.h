//
//  EKMapViewController+Networking.h
//  payomi-ios
//
//  Created by Elie El Khoury on 2/25/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "EKMapViewController.h"

#import "EKMapViewController+Animations.h"
#import "EKMapViewController+MapStyling.h"
#import "UIViewController+Helpers.h"
#import "Constants.h"

#import "User.h"

@interface EKMapViewController (Networking)

- (void)setupFIRReferences;

- (void)loginToFacebook;
- (void)logoutOfFacebook;

@end
