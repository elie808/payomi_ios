//
//  ViewController.m
//  payomi-ios
//
//  Created by Elie El Khoury on 10/31/16.
//  Copyright © 2016 Elie El Khoury. All rights reserved.
//

/*
 GMSMARKER placed on map.
 GMSPlace is fetched from server. Attached to the GMSMarker userData field.
 When user taps on marker infoWindow -> the contained GMSPlace is passed to the ReviewVC
*/

#import "EKMapViewController.h"

#import "EKReviewViewController.h"
#import "EKSearchLocationViewController.h"
#import "Constants.h"
#import "EKMapViewController+Animations.h"
#import "EKMapViewController+MapStyling.h"
#import "EKMapViewController+MapDelegate.h"
#import "EKMapViewController+SearchDelegate.h"
#import "EKMapViewController+Networking.h"
#import "UIViewController+Helpers.h"

static NSString * const kSearchSegueID = @"searchSegue";
static NSString * const kLoginSegueID = @"loginVC";
static NSString * const kReviewSegueID = @"reviewSegue";
static NSString * const kProfileSegueID = @"userProfileSegue";

static NSString * const kPlaceIDDictionarykey = @"placeID";

@implementation EKMapViewController {
    UISearchController *_searchController;
    GMSAutocompleteResultsViewController *_resultsViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupFIRReferences];
    
    [self styleMap];
    self.mapView.delegate = self;
    
//    self.markerInfoWindow = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, 250, 70)];
//    [self.view addSubview:self.markerInfoWindow];
//    self.markerInfoWindow.hidden = YES;
    
    self.buttonsShowing = YES;
    self.profileButton.hidden = YES;
    
    self.markerPersistenceWindow.delegate = self;
    [self.markerPersistenceWindow hidePersistenceView];
    
    // check if Facebook user logged in
    if ([FBSDKAccessToken currentAccessToken]) {
        
        self.profileButton.hidden = NO;
        [self.loginButton setProfileID:@"me"];
        
        // get user's places
        [self fetchDataForId:[FBSDKProfile currentProfile].userID];
    }
    
    self.loginButton.clipsToBounds = YES;
    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height/2;
    self.loginButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.loginButton.layer.borderWidth = 1.0;
    self.loginButton.userInteractionEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.mapView.frame = self.mapUIView.bounds;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
//    self.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:14];
}

#pragma mark - EKMarkerPersistenceViewDelegate methods

- (void)didTapKeepMarkerButton:(GMSPlace *)place {

    [self addPlaceToDB:self.selectedMarker.userData forID:[FBSDKProfile currentProfile].userID];
    
    self.selectedMarker = nil;
    [self.markerPersistenceWindow hidePersistenceView];
}

- (void)didTapRemoveMarkerButton:(GMSMarker *)marker {
    
    [self removePlaceFromDB:marker.userData forID:[FBSDKProfile currentProfile].userID];
    [self removeMarker:marker];
    
    self.selectedMarker = nil;
    [self.markerPersistenceWindow hidePersistenceView];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kSearchSegueID] ) {
        
        if ([FBSDKAccessToken currentAccessToken]) {

            EKSearchLocationViewController *acController = segue.destinationViewController;
            acController.delegate = self;
        
        } else {
            
            [self showMessage:@"You'll need to sign in first !" withTitle:@"😵" completionBlock:^(UIAlertAction *action) {}];
        }
    }
    
    if ([segue.identifier isEqualToString:kReviewSegueID]) {

        EKReviewViewController *reviewVC = segue.destinationViewController;
        
        if (sender && [sender isKindOfClass:[GMSPlace class]]) {
            reviewVC.placeObj = sender;
        }
    }
    
}

- (IBAction)unwindLoginToMap:(UIStoryboardSegue *)segue {}

- (IBAction)unwindReviewToMap:(UIStoryboardSegue *)segue {}

- (IBAction)unwindUserProfileToMap:(UIStoryboardSegue *)segue {}

#pragma mark - Actions

- (IBAction)didTapSearchButton:(id)sender {}

- (IBAction)didTapProfileButton:(id)sender {
    
    [self performSegueWithIdentifier:kProfileSegueID sender:nil];
}

- (IBAction)didTapFilterButton:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Only show"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
//    CGFloat margin = 8.0F;
//    UIView *customView = [[UIView alloc]
//                          initWithFrame:CGRectMake(margin, margin, alertController.view.bounds.size.width - margin * 4.0F, 100.0F)];
//    customView.backgroundColor = [UIColor greenColor];
//    [alertController.view addSubview:customView];
    
    UIAlertAction *myLocationsAction = [UIAlertAction actionWithTitle:@"My Locations"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                
                                                                if ([FBSDKAccessToken currentAccessToken]) {
                                                                    
                                                                    [self.mapView clear];
                                                                    [self fetchDataForId:[FBSDKProfile currentProfile].userID];
                                                                } else {
                                                                    
                                                                    [self showMessage:@"You'll need to sign in first !"
                                                                            withTitle:@"😵"
                                                                      completionBlock:^(UIAlertAction *action) {}];
                                                                }
                                                            }];
    
    UIAlertAction *friendsLocationsAction = [UIAlertAction actionWithTitle:@"My Friends' Locations"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  
                                                                  if ([FBSDKAccessToken currentAccessToken]) {
                                                                  
                                                                      [self.mapView clear];
                                                                      [self fetchData];
                                                                  
                                                                  } else {
                                                                      
                                                                      [self showMessage:@"You'll need to sign in first !"
                                                                              withTitle:@"😵"
                                                                        completionBlock:^(UIAlertAction *action) {}];
                                                                  }
                                                              }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {}];
    
    [alertController addAction:myLocationsAction];
    [alertController addAction:friendsLocationsAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (IBAction)didTapLoginButton:(UITapGestureRecognizer *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"User Login"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    // Actions
    UIAlertAction *facebookLoginAction = [UIAlertAction actionWithTitle:@"Facebook Login"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  [self loginToFacebook];
                                                              }];
    
    UIAlertAction *facebookLogoffAction = [UIAlertAction actionWithTitle:@"Logoff Facebook"
                                                                  style:UIAlertActionStyleDestructive
                                                                handler:^(UIAlertAction *action) {
                                                                    [self logoutOfFacebook];
                                                                }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {}];
    
    if ([FBSDKAccessToken currentAccessToken]) {

        [alertController addAction:facebookLogoffAction];
        
    } else {
        
        [alertController addAction:facebookLoginAction];
    }
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

@end
