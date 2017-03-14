//
//  EKMarkerPersistenceView.h
//  payomi-ios
//
//  Created by Elie El Khoury on 3/13/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;
@import GooglePlaces;

@protocol EKMarkerPersistenceViewDelegate <NSObject>
- (void)didTapKeepMarkerButton:(GMSPlace *)place;
- (void)didTapRemoveMarkerButton:(GMSMarker *)marker;
@end

@interface EKMarkerPersistenceView : UIView

@property (strong, nonatomic) GMSMarker *selectedMarker;
@property (strong, nonatomic) id<EKMarkerPersistenceViewDelegate> delegate;

- (IBAction)didTapKeepMarkerButton:(id)sender;
- (IBAction)didTapRemoveMarkerButton:(id)sender;

@end
