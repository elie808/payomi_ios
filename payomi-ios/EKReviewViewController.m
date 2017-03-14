//
//  EKReviewViewController.m
//  payomi-ios
//
//  Created by Elie El Khoury on 10/31/16.
//  Copyright © 2016 Elie El Khoury. All rights reserved.
//

#import "EKReviewViewController.h"
#import "Comment.h"
#import "EKReviewTableViewCell.h"
#import "EKReviewHeaderView.h"
#import "Constants.h"
#import "UIImage+Helpers.h"
#import "UIViewController+Helpers.h"
#import "EKReviewViewController+Networking.h"

/*
 DB hierarchy
 
 -commentsTestIDs
 ---placeID
 -----AutoID
 -------comment
 -------user
 */

static NSString * const kEmojiFace = @"🤔";

static CGFloat const kAnimationDuration = 0.25;

static NSString * const kCellID = @"cellId";
static NSString * const kPlaceHolderText = @"What do you like about this place?";
static NSString * const kEditablePostPlaceHolderText = @"What changed since last time?";

static NSString * const kHeaderXIB = @"ReviewTableHeaderView";
static CGFloat const kHeaderHeight = 62;

@interface EKReviewViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (strong, nonatomic) GMSMapView *mapView;

@property (assign, nonatomic) CGPoint lastContentOffset;
@property (assign, nonatomic) BOOL keyboardShowing;

@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@end

@implementation EKReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: Provide default location    
    if (!self.placeObj) {}
    
    [self setupMap];
    
    self.dataSourceArray = [[NSMutableArray alloc] init];
    
    self.tableView.estimatedRowHeight = 95.0;

    self.commentBox.textColor = [UIColor lightGrayColor];
    self.commentBox.text = kPlaceHolderText;

    [self setupFIRReferences];
    
    __weak EKReviewViewController *weakSelf = self;
    [self fetchCommentsWithBlock:^(NSMutableArray *commentsArray) {
    
        [weakSelf.dataSourceArray removeAllObjects];
    
        [weakSelf.dataSourceArray addObjectsFromArray:commentsArray];
        
        [weakSelf.tableView reloadData];
        
        if ([self containsMyPost:weakSelf.dataSourceArray]) {
            self.commentBox.text = kEditablePostPlaceHolderText;
            [self.postButton setTitle:@"Edit" forState:UIControlStateNormal];
        }
    }];
    
//    [self createDummyComments];
}

/// Check if the selected Work items are less than workCount
- (BOOL)containsMyPost:(NSMutableArray *)array {
    
    NSArray *myPosts = [array
                        filteredArrayUsingPredicate:[NSPredicate
                                                     predicateWithFormat:@"isMyComment = %@", [NSNumber numberWithBool: YES]]];
    
    return myPosts.count > 0 ? YES : NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // set to YES to enable resizing the textView when the commentView changes height
    [self.commentView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    self.mapView.frame = self.mapUIView.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    EKReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];

    Comment *commentObj = [self.dataSourceArray objectAtIndex:indexPath.row];

    cell.cellReviewLabel.text = commentObj.review;
    cell.cellNameLabel.text = commentObj.commenter.username;
    cell.cellProfileImageView.image = commentObj.commenter.profilePic;

    cell.cellProfileImageView.layer.cornerRadius = 27;
    cell.cellProfileImageView.layer.masksToBounds = YES;
    
    if (commentObj.isMyComment) {
        cell.cellEditableImageView.hidden = NO;
    } else {
        cell.cellEditableImageView.hidden = YES;
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    EKReviewHeaderView *headerView =  [[[NSBundle mainBundle] loadNibNamed:kHeaderXIB owner:self options:nil] objectAtIndex:0];
    
    headerView.titleLabel.text = self.placeObj.name;
    headerView.subTitleLabel.text = self.placeObj.formattedAddress;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderHeight;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    CGPoint currentOffset = scrollView.contentOffset;
//
//    // scrolling down
//    if (self.keyboardShowing && fabs(currentOffset.y - self.lastContentOffset.y) > 25) {
//        
//        [self.commentBox resignFirstResponder];
//    }
//    
//    self.lastContentOffset = currentOffset;
//}

#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView {
    
    CGRect frame = textView.frame;
    
    CGFloat heightDiff = textView.contentSize.height - frame.size.height;
    
    self.commentBox.frame = CGRectMake(textView.frame.origin.x,
                                textView.frame.origin.y,
                                textView.frame.size.width,
                                textView.contentSize.height);
    
    if (fabs(heightDiff) > 10 ) {
        
        self.commentView.frame = CGRectMake(self.commentView.frame.origin.x,
                                            self.commentView.frame.origin.y - heightDiff,
                                            self.commentView.frame.size.width,
                                            self.commentView.frame.size.height + heightDiff);
        
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                            self.tableView.frame.origin.y,
                                            self.tableView.frame.size.width,
                                            self.tableView.frame.size.height - heightDiff);
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ( [textView.text isEqualToString:kPlaceHolderText] || [textView.text isEqualToString:kEditablePostPlaceHolderText] ) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = kPlaceHolderText;
        textView.textColor = [UIColor lightGrayColor];
    }
    
    [textView resignFirstResponder];
}

// set review length
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return textView.text.length + (text.length - range.length) <= kCharCountLimit;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if (!self.keyboardShowing) {
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            
            CGRect tableviewFrame = self.tableView.frame;
            tableviewFrame.size.height = tableviewFrame.size.height - keyboardSize.height;
            self.tableView.frame = tableviewFrame;
            
            CGRect commentViewFrame = self.commentView.frame;
            commentViewFrame.origin.y = commentViewFrame.origin.y - keyboardSize.height;
            self.commentView.frame = commentViewFrame;

            if (self.dataSourceArray.count > 0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSourceArray.count-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:NO];
            }
           
            self.keyboardShowing = YES;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if (self.keyboardShowing) {
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            
            CGRect commentViewFrame = self.commentView.frame;
            commentViewFrame.origin.y = commentViewFrame.origin.y + keyboardSize.height;
            self.commentView.frame = commentViewFrame;
            
            CGRect tableviewFrame = self.tableView.frame;
            tableviewFrame.size.height = tableviewFrame.size.height + keyboardSize.height;
            self.tableView.frame = tableviewFrame;
            
            self.keyboardShowing = NO;
        }];
    }
}

#pragma mark - Navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
*/

#pragma mark - Action

- (IBAction)didTapShareButton:(id)sender {
    
    // Open Google Maps app
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
//    
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f&q=%f,%f",
//                                           self.placeObj.coordinate.latitude,
//                                           self.placeObj.coordinate.longitude,
//                                           self.placeObj.coordinate.latitude,
//                                           self.placeObj.coordinate.longitude]];
//        
//        [[UIApplication sharedApplication] openURL:url];
//    
//    } else {
//        
//        NSLog(@"Can't use comgooglemaps://");
//    }
    
    // create a message
    NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?center=%f,%f",
                            self.placeObj.coordinate.latitude, self.placeObj.coordinate.longitude];

    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:@[urlString]
                                                                            applicationActivities:nil];
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    // access the completion handler
    controller.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *error){
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}

- (IBAction)didTapPostButton:(id)sender {
    
    Friend *friend1 = [Friend new];
    friend1.username = [FBSDKProfile currentProfile].name;
    friend1.profilePic = [UIImage imageNamed:@"profile_pic_placeholder"];
    
    Comment *comment = [Comment new];
    comment.commenter = friend1;
    
    if ([FBSDKAccessToken currentAccessToken]) {

        if (![self.commentBox.text isEqualToString:kPlaceHolderText] &&
            ![self.commentBox.text isEqualToString:kEditablePostPlaceHolderText]) {
            
            self.commentBox.text = [self.commentBox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if (self.commentBox.text.length > 0) {
                
                comment.review = self.commentBox.text;
                
                __weak EKReviewViewController *weakSelf = self;
                [self addCommentToDB:comment withBlock:^(Comment *comment) {
                    
                    weakSelf.commentBox.text = @"";
                    
    //                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSourceArray.count-1 inSection:0]
    //                                      atScrollPosition:UITableViewScrollPositionBottom
    //                                              animated:NO];
                }];
                
            }
        }
    
    } else {
        
        [self showMessage:@"You need to sign in!" withTitle:@"You need to sign in!" completionBlock:^(UIAlertAction *action) {}];
    }
}

#pragma mark - Helpers

- (void)createDummyComments {
    
    Friend *friend1 = [Friend new];
    friend1.username = @"First User";
    friend1.profilePic = [UIImage imageNamed:@"profile_pic_placeholder"];
    
    Comment *comment1 = [Comment new];
    comment1.commenter = friend1;
    comment1.review = @"First review is here";
    
    //    Friend *friend2 = [Friend new];
    //    friend2.username = @"Second User";
    //    friend2.profilePic = [UIImage imageNamed:@"profile_pic_placeholder"];
    //
    //    Comment *comment2 = [Comment new];
    //    comment2.commenter = friend2;
    //    comment2.review = @"Second review is here";
    
    [self.dataSourceArray addObjectsFromArray:@[comment1]];
}

- (void)setupMap {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.placeObj.coordinate.latitude
                                                            longitude:self.placeObj.coordinate.longitude
                                                                 zoom:14];
    
    self.mapView = [GMSMapView mapWithFrame:self.mapUIView.bounds camera:camera];
    self.mapView.myLocationEnabled = YES;
    
    [self.mapUIView addSubview:self.mapView];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *styleUrl = [mainBundle URLForResource:@"map-styling" withExtension:@"json"];
    NSError *error;
    
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
    if (!style) { NSLog(@"The style definition could not be loaded: %@", error); }
    self.mapView.mapStyle = style;

    [self createMarker];
}

- (void)createMarker {
    
    GMSMarker *marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(self.placeObj.coordinate.latitude,
                                                                                 self.placeObj.coordinate.longitude)];
    
    UILabel *markerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMarkerDimmension, kMarkerDimmension)];
    markerLabel.backgroundColor = [UIColor clearColor];
    markerLabel.text = [NSString stringWithFormat:@"%@", kEmojiFace];
    
    marker.icon = [UIImage imageFromLabel:markerLabel]; //[UIImage imageNamed:@"market_red"];
    marker.map = self.mapView;
}

@end
