//
//  EKMapViewController+MapStyling.h
//  payomi-ios
//
//  Created by Elie El Khoury on 12/2/16.
//  Copyright © 2016 Elie El Khoury. All rights reserved.
//

#import "EKMapViewController.h"
@import GoogleMaps;
@import GooglePlaces;

@interface EKMapViewController (MapStyling)

- (void)styleMap;

/// add marker to map. Choose to have it selected or nah 
- (void)addMarkerForPlace:(GMSPlace*)place markerSelected:(BOOL)selectMarker;

/// remove marker off map
- (void)removeMarker:(GMSMarker *)marker;

/// lookup and return a GMSPlace object from the Place ID string
- (void)placeForPlaceID:(NSString *)placeID completion:(void(^)(GMSPlace *place))success;

/// create stubs for testing
- (void)createMarkers;

@end
