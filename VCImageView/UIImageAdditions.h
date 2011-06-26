//
//  UIImageAdditions.h
//  
//
//  Created by Vinay Chavan on 05/12/10.
//  Copyright 2010 Vinay Chavan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (RoundedCorner)
- (UIImage*)imageWithRoundedCorner:(int)corner;
@end

@interface UIImage (Resize)
- (UIImage*)imageWithSize:(CGSize)targetSize;
- (UIImage*)imageByAspectFillForSize:(CGSize)targetSize;
@end

@interface UIImage (Mask)
- (UIImage*)imageWithMask:(UIImage*)mask;
@end

