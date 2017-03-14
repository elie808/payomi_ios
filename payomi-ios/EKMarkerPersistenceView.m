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
        [self.delegate didTapKeepMarkerButton:self.selectedMarker.userData];
    }
}

- (IBAction)didTapRemoveMarkerButton:(id)sender {
  
    if (self.delegate) {
        
        NSLog(@"TAP REMOOOOOOOVE: %@", self.selectedMarker);
        [self.delegate didTapRemoveMarkerButton:self.selectedMarker];
    }
    
}

@end
