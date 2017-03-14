//
//  EKMarkerPersistenceView.m
//  payomi-ios
//
//  Created by Elie El Khoury on 3/13/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "EKMarkerPersistenceView.h"

@implementation EKMarkerPersistenceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didTapKeepMarkerButton:(id)sender {
    
    if (self.delegate) {
        NSLog(@"TAP KEEEEEEP: %@", self.selectedMarker);
    }
}

- (IBAction)didTapRemoveMarkerButton:(id)sender {
  
    if (self.delegate) {
        NSLog(@"TAP REMOOOOOOOVE: %@", self.selectedMarker);
        [self.delegate didTapRemoveMarkerButton:self.selectedMarker];
    }
    
}

@end
