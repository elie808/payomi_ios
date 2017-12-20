//
//  EKMarkerPersistenceView.m
//  payomi-ios
//
//  Created by Elie El Khoury on 3/13/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "EKMarkerPersistenceView.h"

@implementation EKMarkerPersistenceView

- (void)showPersistenceViewInMode:(PersistenceViewMode)mode {
    
    self.hidden = NO;
    
    switch (mode) {
        case PersistenceViewModeKeepRemove: {
            self.keepButton.hidden = NO;
            self.removeButton.hidden = NO;
        } break;
            
        case PersistenceViewModeKeep: {
            self.keepButton.hidden = NO;
            self.removeButton.hidden = YES;
        } break;
            
        case PersistenceViewModeRemove: {
            self.keepButton.hidden = YES;
            self.removeButton.hidden = NO;
        } break;
            
        default: break;
    }
}

- (void)hidePersistenceView {

    self.hidden = YES;
    self.selectedMarker = nil;
}

- (IBAction)didTapKeepMarkerButton:(id)sender {
    
    if (self.delegate) {
        
        NSLog(@"TAP KEEEEEEP: %@", self.selectedMarker);
        
        GMSPlace *gmsPlace = (GMSPlace *)self.selectedMarker.userData;
        
        // convert GMSPlace (saved inside the the userData property for the selected GMSMarker) into a Place object
        Place *placeObj = [Place new];
        placeObj.placeId = gmsPlace.placeID;
        placeObj.placeName = gmsPlace.name;
        placeObj.placeAddress = gmsPlace.formattedAddress;
        placeObj.latitude = [NSString stringWithFormat:@"%f", gmsPlace.coordinate.latitude];
        placeObj.longitude = [NSString stringWithFormat:@"%f", gmsPlace.coordinate.longitude];
        
        [self.delegate didTapKeepMarkerButton:placeObj];
    }
}

- (IBAction)didTapRemoveMarkerButton:(id)sender {
  
    if (self.delegate) {
        
        NSLog(@"TAP REMOOOOOOOVE: %@", self.selectedMarker);
        [self.delegate didTapRemoveMarkerButton:self.selectedMarker];
    }
    
}

@end
