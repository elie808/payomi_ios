//
//  EKReviewViewController+Networking.h
//  payomi-ios
//
//  Created by Elie El Khoury on 2/26/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "EKReviewViewController.h"
#import "Constants.h"
#import "Comment.h"

@interface EKReviewViewController (Networking)

- (void)setupFIRReferences;
- (void)fetchCommentsWithBlock:(void (^)(NSMutableArray *commentsArray))success;
- (void)addCommentToDB:(Comment*)comment withBlock:(void (^)(Comment * comment))success;

@end
