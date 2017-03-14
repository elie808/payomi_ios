//
//  EKUserProfileViewController.m
//  payomi-ios
//
//  Created by Elie El Khoury on 2/25/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "EKUserProfileViewController.h"

static NSString * const kProfileCell = @"profileCellID";
static NSString * const kPlaceIDDictionarykey = @"placeID";

static NSString * const kReviewSegueID = @"placeReviewSegue";

@implementation EKUserProfileViewController {
    NSMutableArray *_dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArray = [NSMutableArray new];
    
    [self setupFIRReferences];
    
    //
    [self fetchDataForId:@"616122031907471"];
}

#pragma mark - FireBase Setup

- (void)setupFIRReferences {
    
    self.dbRef = [[FIRDatabase database] reference];
    self.reviewsRef = [self.dbRef child:@"userPosts"];
}

#pragma mark - Firebase Fetch

- (void)fetchDataForId:(NSString *)facebookID {
    
    NSLog(@"\n \n FETCHING DATA FOR FB ID: %@", facebookID);
    
    if (facebookID && facebookID.length > 0) {

        [self.reviewsRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {

            if (snapshot.value != [NSNull null]) {
                
                NSDictionary *allUserPlaces = snapshot.value;
                
                NSDictionary *userPosts = [allUserPlaces valueForKey:[[allUserPlaces allKeys] objectAtIndex:0]];

                if (userPosts && userPosts.count >= 1) {
                    
                    for (int i = 0; i < userPosts.count; i++) {
                        
                        NSString *placeID = [[userPosts allKeys] objectAtIndex:i];

                        NSDictionary *post = [userPosts valueForKey:placeID];

                        UserPost *postObj = [UserPost new];
                        postObj.placeID = placeID;
                        postObj.comment = [post valueForKey:@"comment"];
                        postObj.date = [post valueForKey:@"date"];
                        postObj.placeName = [post valueForKey:@"placeName"];

                        [_dataSourceArray addObject:postObj];
                    }

                    [self.tableView reloadData];
                }
            }
        }];
        
    } else {
        
        [self showMessage:@"Try to re-login into your Facebook account"
                withTitle:@"Trouble 😮"
          completionBlock:^(UIAlertAction *action) {}];
    }
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileCell forIndexPath:indexPath];
    
    UserPost *postObj = [_dataSourceArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = postObj.placeName;
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserPost *postObj = [_dataSourceArray objectAtIndex:indexPath.row];
    
    [[GMSPlacesClient sharedClient] lookUpPlaceID:postObj.placeID callback:^(GMSPlace *place, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            
            NSLog(@"Place name %@", place.name);
            NSLog(@"Place address %@", place.formattedAddress);
            NSLog(@"Place placeID %@", place.placeID);
            NSLog(@"Place attributions %@", place.attributions);
            
            [self performSegueWithIdentifier:kReviewSegueID sender:place];
            
        } else {
            
            NSLog(@"No place details for %@", postObj.placeID);
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kReviewSegueID]) {
        
//        UINavigationController *navController = [segue destinationViewController];
//        EKReviewViewController *reviewVC = (EKReviewViewController *)([navController viewControllers][0]);
        EKReviewViewController *reviewVC = [segue destinationViewController];

        if (sender && [sender isKindOfClass:[GMSPlace class]]) {
            reviewVC.placeObj = sender;
        }
    }
    
}


@end
