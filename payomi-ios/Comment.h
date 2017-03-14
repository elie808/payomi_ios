//
//  Comment.h
//  payomi-ios
//
//  Created by Elie El Khoury on 11/3/16.
//  Copyright © 2016 Elie El Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Friend.h"

@interface Comment : NSObject

@property (strong, nonatomic) Friend *commenter;
@property (strong, nonatomic) NSString *review;
@property (strong, nonatomic) NSDate *reviewDate;
@property (assign, nonatomic) BOOL isMyComment;

@end
