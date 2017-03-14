//
//  EKReviewViewController+Networking.m
//  payomi-ios
//
//  Created by Elie El Khoury on 2/26/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "EKReviewViewController+Networking.h"

static NSString * const kUserKey = @"user";
static NSString * const kCommentKey = @"comment";

@implementation EKReviewViewController (Networking)

- (void)setupFIRReferences {
    
    self.dbRef = [[FIRDatabase database] reference];
    self.commentsRef = [self.dbRef child:kReviewsKey];
}

- (void)fetchCommentsWithBlock:(void (^)(NSMutableArray *commentsArray))success {
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    FIRDatabaseReference *newChildKey = [self.commentsRef child:self.placeObj.placeID];
    
    [newChildKey observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if (snapshot.value != [NSNull null]) {
        
            NSDictionary *fetchedCommentsDict = snapshot.value;
            
            if (fetchedCommentsDict.count > 0) {
                
                [tempArray removeAllObjects];
                
                for (int i = 0; i < fetchedCommentsDict.count; i++) {
                    
                    NSDictionary *commentDict = [fetchedCommentsDict valueForKey:[[fetchedCommentsDict allKeys] objectAtIndex:i]];
                    
                    Friend *dummyFriend = [Friend new];
                    dummyFriend.username = commentDict[kUserKey];
                    dummyFriend.profilePic = [UIImage imageNamed:@"profile_pic_placeholder"];
                    
                    Comment *comment = [Comment new];
                    comment.commenter = dummyFriend;
                    comment.review = commentDict[kCommentKey];
                    
                    // check if the name in the fetched comment is mine
                    if ( [commentDict[kUserKey] isEqualToString:[FBSDKProfile currentProfile].name] ) {
                        comment.isMyComment = YES;
                    }
                    
                    [tempArray addObject:comment];
                }
                
                success(tempArray);
            }
        }
    }];
}

- (void)addCommentToDB:(Comment*)comment withBlock:(void (^)(Comment * comment))success {
    
    // post comment to commentsTestIDs
    NSDictionary *postDict = @{kUserKey:comment.commenter.username, kCommentKey:comment.review};
    
    FIRDatabaseReference *newChildKey = [[[self.dbRef child:kReviewsKey] child:self.placeObj.placeID]
                                         child:[FBSDKProfile currentProfile].userID];
    
    [newChildKey setValue:postDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (!error) {
            success(comment);
        }
    }];
    
    // add node to User Posts tree
    FIRDatabaseReference *userPosts = [self.dbRef child:kUserProfile];
    
    FIRDatabaseReference *postPlaceID = [[userPosts child:[FBSDKProfile currentProfile].userID] child:self.placeObj.placeID];
    NSDictionary *userPosted = @{@"placeName":self.placeObj.name, kCommentKey:comment.review, @"date":@"1/1/1989"};
    
    [postPlaceID setValue:userPosted withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (!error) {
            
        }
    }];
    
}

@end
