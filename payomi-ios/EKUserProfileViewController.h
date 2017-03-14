//
//  EKUserProfileViewController.h
//  payomi-ios
//
//  Created by Elie El Khoury on 2/25/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;
@import GooglePlaces;
@import Firebase;
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UIViewController+Helpers.h"
#import "EKReviewViewController.h"
#import "Constants.h"
#import "UserPost.h"

@interface EKUserProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) FIRDatabaseReference *dbRef;
@property (strong, nonatomic) FIRDatabaseReference *reviewsRef;

@property (strong, nonatomic) NSMutableArray *fetchedCommentsArray;

@end
