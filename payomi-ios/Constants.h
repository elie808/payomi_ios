//
//  Constants.h
//  payomi-ios
//
//  Created by Elie El Khoury on 11/30/16.
//  Copyright © 2016 Elie El Khoury. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#pragma mark - URL schemes

static NSString * const kGoogleMapsURLScheme = @"comgooglemaps://";

#pragma mark - Map Constants

static float const kMapZoom = 14.0;
static CGFloat const kMarkerDimmension = 25.0;

#pragma mark - Review constants

static NSInteger const kCharCountLimit = 140;

#pragma mark - FIR constants

static NSString *const kMarkersForUser = @"MapVC";      // Map VC root
static NSString * const kReviewsKey = @"ReviewsVC";     // Reviews VC root
static NSString * const kUserProfile = @"UserProfileVC"; // User Profile VC root

static NSString *const kUserIDsKey = @"userIDs";
static NSString *const kMapMarkersKey = @"mapMarkers";
static NSString *const kCommentsTestKey = @"commentsTestIDs";

#endif /* Constants_h */
