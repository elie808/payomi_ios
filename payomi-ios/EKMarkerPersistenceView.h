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

typedef NS_ENUM(NSInteger, PersistenceViewMode) {
    PersistenceViewModeKeepRemove,
    PersistenceViewModeKeep,
    PersistenceViewModeRemove
};

@protocol EKMarkerPersistenceViewDelegate <NSObject>
- (void)didTapKeepMarkerButton:(GMSPlace *)place;
- (void)didTapRemoveMarkerButton:(GMSMarker *)marker;
@end

@interface EKMarkerPersistenceView : UIView

@property (assign, nonatomic) PersistenceViewMode mode;
@property (strong, nonatomic) id<EKMarkerPersistenceViewDelegate> delegate;
@property (strong, nonatomic) GMSMarker *selectedMarker;

@property (strong, nonatomic) IBOutlet UIButton *keepButton;
@property (strong, nonatomic) IBOutlet UIButton *removeButton;

- (void)showPersistenceViewInMode:(PersistenceViewMode)mode;
- (void)hidePersistenceView;

- (IBAction)didTapKeepMarkerButton:(id)sender;
- (IBAction)didTapRemoveMarkerButton:(id)sender;

@end
