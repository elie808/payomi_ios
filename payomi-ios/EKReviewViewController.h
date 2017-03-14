//
//  EKReviewViewController.h
//  payomi-ios
//
//  Created by Elie El Khoury on 10/31/16.
//  Copyright © 2016 Elie El Khoury. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;
@import GooglePlaces;
@import Firebase;
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface EKReviewViewController : UIViewController

//@property (strong, nonatomic) GMSAddress *addressObj;
@property (strong, nonatomic) GMSPlace *placeObj;

@property (strong, nonatomic) FIRDatabaseReference *dbRef;
@property (strong, nonatomic) FIRDatabaseReference *commentsRef;
@property (strong, nonatomic) NSMutableArray *fetchedCommentsArray;

@property (strong, nonatomic) IBOutlet UIView *mapUIView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (strong, nonatomic) IBOutlet UITextView *commentBox;
@property (strong, nonatomic) IBOutlet UIButton *postButton;

@end
