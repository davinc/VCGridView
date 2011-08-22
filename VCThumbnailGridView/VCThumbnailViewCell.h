//
//  VCThumbnailViewCell.h
//  Demo
//
//  Created by Vinay Chavan on 22/08/11.
//  Copyright 2011 Vinay Chavan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VCThumbnailButton.h"

@interface VCThumbnailViewCell : UITableViewCell {
    VCThumbnailButton *imageView1;
    VCThumbnailButton *imageView2;
    VCThumbnailButton *imageView3;
    VCThumbnailButton *imageView4;
}

@property (nonatomic, retain) VCThumbnailButton *imageView1;
@property (nonatomic, retain) VCThumbnailButton *imageView2;
@property (nonatomic, retain) VCThumbnailButton *imageView3;
@property (nonatomic, retain) VCThumbnailButton *imageView4;

@end
