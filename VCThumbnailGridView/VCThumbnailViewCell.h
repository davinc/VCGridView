//
//  VCThumbnailViewCell.h
//  Demo
//
//  Created by Vinay Chavan on 22/08/11.
//  Copyright 2011 Vinay Chavan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VCImageView.h"

@interface VCThumbnailViewCell : UITableViewCell {
    VCImageView *imageView1;
    VCImageView *imageView2;
    VCImageView *imageView3;
    VCImageView *imageView4;
}

@property (nonatomic, retain) VCImageView *imageView1;
@property (nonatomic, retain) VCImageView *imageView2;
@property (nonatomic, retain) VCImageView *imageView3;
@property (nonatomic, retain) VCImageView *imageView4;

@end
