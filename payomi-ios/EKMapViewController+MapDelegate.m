//
//  EKMapViewController+MapDelegate.m
//  payomi-ios
//
//  Created by Elie El Khoury on 1/21/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "EKMapViewController+MapDelegate.h"

#import "EKMapViewController+Animations.h"
#import "EKMapViewController+Networking.h"

#import "EKMapInfoWindow.h"

static NSString * const kInfoWindowXIB = @"InfoWindow";
static NSString * const kReviewSegueID = @"reviewSegue";

@implementation EKMapViewController (MapDelegate)

# pragma mark - GMSMapViewDelegate

// Custom InfoWindow
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    EKMapInfoWindow *infoView =  [[[NSBundle mainBundle] loadNibNamed:kInfoWindowXIB owner:self options:nil] objectAtIndex:0];
    
    infoView.layer.cornerRadius = 5;
    infoView.layer.masksToBounds = YES;
    
    infoView.titleLabel.text = marker.snippet;
    
    // get the width of the textLabel after setting the text in it
    CGRect titleLabelFrame = [infoView.titleLabel.text boundingRectWithSize:infoView.titleLabel.frame.size
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                 attributes:@{ NSFontAttributeName:infoView.titleLabel.font }
                                                                    context:nil];
    
    infoView.frame = CGRectMake(infoView.frame.origin.x, infoView.frame.origin.y,
                                titleLabelFrame.size.width + 30, // 30 to account for arrow and other elements of infoWindow
                                infoView.frame.size.height);
    
    self.markerPersistenceWindow.selectedMarker = marker;
    
    return infoView;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    
    GMSPlace *place = (GMSPlace*)marker.userData;
    [self performSegueWithIdentifier:kReviewSegueID sender:place];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
//    [self removeMarker:marker];
//    self.markerPersistenceWindow.selectedMarker = marker;
    self.markerPersistenceWindow.hidden = NO;
    
    return NO;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    self.markerPersistenceWindow.selectedMarker = nil;
    self.markerPersistenceWindow.hidden = YES;
}

//- (void)mapView:(GMSMapView *)mapView didLongPressInfoWindowOfMarker:(GMSMarker *)marker {
//    
//    [self removeMarker:marker];
//    [self removePlaceFromDB:marker.userData];
//}

#pragma mark - Camera methods

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    
    // hide buttons when map moves
    if (gesture && self.buttonsShowing) {
        
        // SDK bug - dispatch async, because there is already a CoreAnimation transaction happening...
        __weak EKMapViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.buttonsShowing = NO;
            [weakSelf hideButtons];
        });
    }
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    
    if (!self.buttonsShowing)
    {
        self.buttonsShowing = YES;
        [self showButtons];
    }
}

@end
