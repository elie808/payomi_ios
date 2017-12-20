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
                                    
                                    NSLog(@"FB TOKEN: %@", result.token.tokenString);
                                    
                                    self.profileButton.hidden = NO;
                                    
                                    [User loginCustomerWithFacebook:result.token.tokenString
                                                          withBlock:^(User *userObj) {
                                                              
                                                          }
                                                         withErrors:^(NSError *error, NSString *errorMessage, NSInteger statusCode) {
                                                             
                                                         }];
                                    
//                                    [self fetchDataForId:[FBSDKProfile currentProfile].userID];
                                    
                                    // [self performSegueWithIdentifier:@"unwindSegue" sender:nil];
                                }
                            }];
    
    ///////////
    
    // Login using Facebook account
    /*
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                
                                if (error) {
                                    
                                    NSLog(@"Process error");
                                    
                                } else if (result.isCancelled) {
                                    
                                    NSLog(@"Cancelled");
                                    
                                } else {
                                    
                                    NSLog(@"Logged in");
                                    NSLog(@"/n /n NAME: %@", [FBSDKProfile currentProfile].name);
                                    
                                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                    
                                    [Customer signUpCustomerWithFacebook:result.token.tokenString
                                                               withBlock:^(Customer *customerObj) {
                                                                   
                                                                   NSLog(@"USER SIGNED UP!!");
                                                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                   
                                                                   //                                                                       customerObj.fName = [result valueForKey:@"first_name"];
                                                                   //                                                                       customerObj.lName = [result valueForKey:@"last_name"];
                                                                   
                                                                   [EKSettings saveCustomer:customerObj];
                                                                   
                                                                   [self performSegueWithIdentifier:kEditProfileSegue sender:customerObj];
                                                                   
                                                               } withErrors:^(NSError *error, NSString *errorMessage, NSInteger statusCode) {
                                                                   
                                                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                   [self showMessage:errorMessage
                                                                           withTitle:@"There is something wrong"
                                                                     completionBlock:nil];
                                                               }];
                                    
                                }
                            }];
    */

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

#pragma mark - Firebase Add/Remove

@end
