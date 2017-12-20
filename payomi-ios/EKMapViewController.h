//
//  ViewController.h
//  payomi-ios
//
//  Created by Elie El Khoury on 10/31/16.
//  Copyright © 2016 Elie El Khoury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import GoogleMaps;
@import GooglePlaces;
@import Firebase;

#import "EKMarkerPersistenceView.h"
#import "EKMapButtons.h"

#import "User.h"
#import "Place.h"

#import "User+API.h"
#import "Place+API.h"

@interface EKMapViewController : UIViewController <UIGestureRecognizerDelegate, EKMarkerPersistenceViewDelegate>

@property (strong, nonatomic) FIRDatabaseReference *dbRef;

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) GMSPlacesClient *placesClient;

@property (strong, nonatomic) NSMutableArray *fetchedPlacesArray;

@property (assign, nonatomic) BOOL buttonsShowing;
@property (assign, nonatomic) GMSMarker *selectedMarker;

@property (strong, nonatomic) IBOutlet EKMarkerPersistenceView *markerPersistenceWindow;

@property (strong, nonatomic) IBOutlet EKMapButtons *addCurrentLocationButton;
@property (strong, nonatomic) IBOutlet EKMapButtons *filterMarkersButton;
@property (strong, nonatomic) IBOutlet EKMapButtons *searchLocationButton;
@property (strong, nonatomic) IBOutlet EKMapButtons *profileButton;
@property (strong, nonatomic) IBOutlet FBSDKProfilePictureView *loginButton;

@property (strong, nonatomic) IBOutlet UIView *mapUIView;

@end

