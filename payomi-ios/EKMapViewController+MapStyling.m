//
//  EKMapViewController+MapStyling.m
//  payomi-ios
//
//  Created by Elie El Khoury on 12/2/16.
//  Copyright © 2016 Elie El Khoury. All rights reserved.
//

#import "EKMapViewController+MapStyling.h"
#import "Constants.h"
#import "UIImage+Helpers.h"

static NSString * const kEmojiFace = @"😀";

@implementation EKMapViewController (MapStyling)

- (void)styleMap {
    
    // create a GMSCameraPosition that tells the map to display the
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:1.290270 longitude:103.851959 zoom:kMapZoom];
    
    // CGRectZero frame to enable full screen map
    self.mapView = [GMSMapView mapWithFrame:self.mapUIView.bounds camera:camera];
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.myLocationEnabled = YES;
    
    // listen to the myLocation property of GMSMapView.
    [self.mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
    // set the GMSMapView object as the view controller's view
    [self.mapUIView addSubview:self.mapView];
    
    // style map
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *styleUrl = [mainBundle URLForResource:@"map-styling" withExtension:@"json"];
    NSError *error;
    
    // set the map style by passing the URL for style.json.
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
    self.mapView.mapStyle = style;
}

- (void)placeForPlaceID:(NSString *)placeID completion:(void(^)(GMSPlace *place))success {
    
    [self.placesClient lookUpPlaceID:placeID callback:^(GMSPlace *place, NSError *error) {
        
        if (error != nil) {
            return;
        }
        
        if (place != nil) {
            
            success(place);
            
        } else {
            
            success(nil);
        }
    }];
}

- (GMSMarker *)addMarkerForGMSPlace:(GMSPlace *)place markerSelected:(BOOL)selectMarker {
    
    UILabel *markerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMarkerDimmension, kMarkerDimmension)];
    markerLabel.backgroundColor = [UIColor clearColor];
    markerLabel.text = [NSString stringWithFormat:@"%@", kEmojiFace];
    
    GMSMarker *marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(place.coordinate.latitude,
                                                                                 place.coordinate.longitude)];
    marker.title = place.formattedAddress;
    marker.snippet = place.name;
    marker.icon = [UIImage imageFromLabel:markerLabel]; //[UIImage imageNamed:@"smiley_marker"];
    marker.userData = place;
    marker.map = self.mapView;
    
    if (selectMarker) {
        [self.mapView setSelectedMarker:marker];
    }
    
    return marker;
}

- (GMSMarker *)addMarkerForPlace:(Place *)place markerSelected:(BOOL)selectMarker {
    
    UILabel *markerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMarkerDimmension, kMarkerDimmension)];
    markerLabel.backgroundColor = [UIColor clearColor];
    markerLabel.text = [NSString stringWithFormat:@"%@", kEmojiFace];
    
//    GMSMarker *marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake((CLLocationDegrees)[place.latitude doubleValue],
//                                                    
//                                                                                 (CLLocationDegrees)[place.longitude doubleValue])];

    
    NSLog(@"address: %@", place.placeAddress);
    
    GMSMarker *marker = [GMSMarker markerWithPosition:
                         CLLocationCoordinate2DMake((CLLocationDegrees)40.622425400000004,
                                                    (CLLocationDegrees)-73.97557189999999)];
    
    marker.title = place.placeAddress;
    marker.snippet = place.placeName;
    marker.icon = [UIImage imageFromLabel:markerLabel]; //[UIImage imageNamed:@"smiley_marker"];
    marker.userData = place;
    marker.map = self.mapView;
    
    if (selectMarker) {
        [self.mapView setSelectedMarker:marker];
    }
    
    return marker;
}

- (void)removeMarker:(GMSMarker *)marker {
    marker.map = nil;
}

#pragma mark - Helpers

- (void)createMarkers {
    
    __weak EKMapViewController *weakSelf = self;
    
    [self placeForPlaceID:@"ChIJEeThBBIZ2jERUPxGbQZMkBc" completion:^(GMSPlace *place) {
        [weakSelf addMarkerForGMSPlace:place markerSelected:NO];
    }];
    
    [self placeForPlaceID:@"ChIJuScwyhQZ2jERtyWGpD1pVEs" completion:^(GMSPlace *place) {
        [weakSelf addMarkerForGMSPlace:place markerSelected:NO];
    }];
    
    [self placeForPlaceID:@"ChIJbSX5nxQZ2jER7XXItxRWZLg" completion:^(GMSPlace *place) {
        [weakSelf addMarkerForGMSPlace:place markerSelected:NO];
    }];
    
    [self placeForPlaceID:@"ChIJEeThBBIZ2jERUPxGbQZMkBc" completion:^(GMSPlace *place) {
        [weakSelf addMarkerForGMSPlace:place markerSelected:NO];
    }];
    
    [self placeForPlaceID:@"ChIJvfVMLg0Z2jERkFMLgRq2diw" completion:^(GMSPlace *place) {
        [weakSelf addMarkerForGMSPlace:place markerSelected:NO];
    }];
    
    [self placeForPlaceID:@"ChIJE1u78EMa2jERbEnmDns_vQo" completion:^(GMSPlace *place) {
        [weakSelf addMarkerForGMSPlace:place markerSelected:NO];
    }];
    
    [self placeForPlaceID:@"ChIJdZOLiiMR2jERxPWrUs9peIg" completion:^(GMSPlace *place) {
        [weakSelf addMarkerForGMSPlace:place markerSelected:NO];
    }];
}

@end
