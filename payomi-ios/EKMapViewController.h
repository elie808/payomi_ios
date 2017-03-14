//
//  ViewController.h
//  payomi-ios
//
//  Created by Elie El Khoury on 10/31/16.
//  Copyright © 2016 Elie El Khoury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKMapButtons.h"
@import GoogleMaps;
@import GooglePlaces;
@import Firebase;
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "EKMarkerPersistenceView.h"

@interface EKMapViewController : UIViewController <UIGestureRecognizerDelegate, EKMarkerPersistenceViewDelegate>

@property (strong, nonatomic) FIRDatabaseReference *dbRef;

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) GMSPlacesClient *placesClient;

@property (assign, nonatomic) BOOL buttonsShowing;

@property (strong, nonatomic) NSMutableArray *fetchedPlacesArray;

@property (strong, nonatomic) IBOutlet EKMarkerPersistenceView *markerPersistenceWindow;

@property (strong, nonatomic) IBOutlet EKMapButtons *addCurrentLocationButton;
@property (strong, nonatomic) IBOutlet EKMapButtons *filterMarkersButton;
@property (strong, nonatomic) IBOutlet EKMapButtons *searchLocationButton;
@property (strong, nonatomic) IBOutlet EKMapButtons *profileButton;
@property (strong, nonatomic) IBOutlet FBSDKProfilePictureView *loginButton;

@property (strong, nonatomic) IBOutlet UIView *mapUIView;

@end

