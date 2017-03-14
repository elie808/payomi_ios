//
//  EKMapViewController+SearchDelegate.m
//  payomi-ios
//
//  Created by Elie El Khoury on 1/21/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "EKMapViewController+SearchDelegate.h"

#import "EKMapViewController+MapStyling.h"
#import "EKMapViewController+Networking.h"

#import "UIViewController+Helpers.h"
#import "Constants.h"

@implementation EKMapViewController (SearchDelegate)

#pragma mark - GMSAutocompleteViewControllerDelegate

// Handle the user's search
- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        // put marker on map
        [self addMarkerForPlace:place markerSelected:YES];
        
//        self.markerPersistenceWindow.hidden = NO;
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:place.coordinate.latitude
                                                                longitude:place.coordinate.longitude
                                                                     zoom:kMapZoom];
        [self.mapView animateToCameraPosition:camera];
        
        [self addPlaceToDB:place forID:[FBSDKProfile currentProfile].userID];
        
    } else {
        
        [self showMessage:@"You need to sign in before adding new places 😶"
                withTitle:[NSString stringWithFormat:@"Error adding %@", place.name] completionBlock:^(UIAlertAction *action) {}];
    }
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"\n \n \n \n AUTOCOMPLETE Error: %@", [error description]);
}

// User canceled the search operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
