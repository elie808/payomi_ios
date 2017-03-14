//
//  EKMapViewController+Networking.m
//  payomi-ios
//
//  Created by Elie El Khoury on 2/25/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//
/*
 DB hierarchy
 
-markerWithFBID
---FacebookID
-----placeID
-------comments
-------placeIDValue
 */

#import "EKMapViewController+Networking.h"

static NSString * const kPlaceIDDictionarykey = @"placeID";

@implementation EKMapViewController (Networking)

#pragma mark - Facebook Login

- (void)loginToFacebook {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                
                                if (error) {
                                    NSLog(@"Process error");
                                    
                                } else if (result.isCancelled) {
                                    
                                    NSLog(@"Cancelled");
                                    
                                } else {
                                    
                                    NSLog(@"Logged in ~~~~ NAME: %@ \n \n", [FBSDKProfile currentProfile].name);
                                    
                                    self.profileButton.hidden = NO;
                                    [self fetchDataForId:[FBSDKProfile currentProfile].userID];
                                    
                                    // [self performSegueWithIdentifier:@"unwindSegue" sender:nil];
                                }
                            }];
}

- (void)logoutOfFacebook {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logOut];
}

#pragma mark - FireBase Setup

- (void)setupFIRReferences {
    
    self.placesClient = [GMSPlacesClient sharedClient];
    
    self.dbRef = [[FIRDatabase database] reference];
}

#pragma mark - Firebase Fetch

- (void)fetchDataForId:(NSString *)facebookID {
    
    NSLog(@"------FETCHING DATA...");
    
    if (facebookID && facebookID.length > 0) {
        
        FIRDatabaseReference *tempRef = [[self.dbRef child:kMarkersForUser] child:facebookID];
        
        [tempRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            if (snapshot.value != [NSNull null]) {
                
                NSDictionary *fetchedPlaces = snapshot.value;
                NSLog(@"------GOT %lu PLACES", (unsigned long)fetchedPlaces.count);
                
                __weak EKMapViewController *weakSelf = self;
                
                for (int i = 0; i < fetchedPlaces.count; i++) {
                    
                    NSDictionary *placeDict = [fetchedPlaces valueForKey:[[fetchedPlaces allKeys] objectAtIndex:i]];
                    NSString *placeID = [placeDict valueForKey:kPlaceIDDictionarykey];
                    
                    // draw markers on map
                    [self placeForPlaceID:placeID completion:^(GMSPlace *place) {
                        [weakSelf addMarkerForPlace:place markerSelected:NO];
                    }];
                }
            }
        }];
        
    } else {
        
        [self showMessage:@"Try to re-login into your Facebook account"
                withTitle:@"Trouble 😮"
          completionBlock:^(UIAlertAction *action) {}];
    }
}

- (void)fetchData {
    
    NSLog(@"\n \n FETCHING ALL DATA...");
    
    FIRDatabaseReference *tempRef = [self.dbRef child:kMarkersForUser];
    
    [tempRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if (snapshot.value != [NSNull null]) {
            
            NSDictionary *fetchedPlaces = snapshot.value;
            
            __weak EKMapViewController *weakSelf = self;
            
            for (int i = 0; i < fetchedPlaces.count; i++) {
                
                NSDictionary *placeDict = [fetchedPlaces valueForKey:[[fetchedPlaces allKeys] objectAtIndex:i]];
                NSLog(@"placeDict: %@", placeDict);
                NSString *placeID = [[placeDict valueForKey:[[placeDict allKeys] objectAtIndex:0]] valueForKey:kPlaceIDDictionarykey];
                NSLog(@"placeID: %@", placeID);
                
                // draw markers on map
                [self placeForPlaceID:placeID completion:^(GMSPlace *place) {
                    [weakSelf addMarkerForPlace:place markerSelected:NO];
                }];
            }
        }
    }];
}

#pragma mark - Firebase Add/Remove

- (void)addPlaceToDB:(GMSPlace*)place forID:(NSString*)facebookID {
    
    NSDictionary *postDict = @{kPlaceIDDictionarykey:place.placeID, @"comments":@0};
    
    FIRDatabaseReference *markerWithFBID = [self.dbRef child:kMarkersForUser];
    
    if (facebookID && facebookID.length > 0) {
        
        FIRDatabaseReference *userFBID = [[markerWithFBID child:facebookID] child:place.placeID];
        [userFBID setValue:postDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {}];
        
    } else {
        
        [self showMessage:@"Try to re-login to your Facebook account" withTitle:@"Trouble 😮" completionBlock:^(UIAlertAction *action) {}];
    }
}

- (void)removePlaceFromDB:(GMSPlace*)place forID:(NSString*)facebookID {
    
    if (facebookID && facebookID.length > 0) {
        
        FIRDatabaseReference *commentsRef = [[[self.dbRef child:kReviewsKey] child:place.placeID] child:facebookID];
        FIRDatabaseReference *markerRef = [[[self.dbRef child:kMarkersForUser] child:facebookID] child:place.placeID];
        FIRDatabaseReference *userPostRef = [[[self.dbRef child:@"UserProfileVC"] child:facebookID] child:place.placeID];
        
        [userPostRef removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        }];
        
        [markerRef removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        }];
        
        [commentsRef removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        }];
        
    }
}

@end
