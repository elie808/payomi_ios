//
//  UIImage+Helpers.m
//  payomi-ios
//
//  Created by Elie El Khoury on 12/12/16.
//  Copyright © 2016 Elie El Khoury. All rights reserved.
//

#import "UIImage+Helpers.h"

@implementation UIImage (Helpers)

/// create UIImage from UILabel
+ (UIImage *)imageFromLabel:(UILabel *)label {
    
    // Create a "canvas" (image context) to draw in. (opaque background set to NO)
    UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, 0.0);
    
    // Make the CALayer to draw in our "canvas".
    [[label layer] renderInContext: UIGraphicsGetCurrentContext()];
    
    // Fetch an UIImage of our "canvas".
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Stop the "canvas" from accepting any input.
    UIGraphicsEndImageContext();
    
    // Return the image.
    return image;
}

@end
