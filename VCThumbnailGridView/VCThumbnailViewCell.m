//
//  VCThumbnailViewCell.m
//  Demo
//
//  Created by Vinay Chavan on 22/08/11.
//  Copyright 2011 Vinay Chavan. All rights reserved.
//

#import "VCThumbnailViewCell.h"

@implementation VCThumbnailViewCell

@synthesize imageView1, imageView2, imageView3, imageView4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		imageView1 = [[VCImageView alloc] initWithFrame:CGRectMake(4, 2, 75, 75)];
		imageView1.backgroundColor = [UIColor whiteColor];
		imageView1.shouldShowActivityIndicator = YES;
		[self addSubview:imageView1];
		
		imageView2 = [[VCImageView alloc] initWithFrame:CGRectMake(83, 2, 75, 75)];
		imageView2.backgroundColor = [UIColor whiteColor];
		imageView2.shouldShowActivityIndicator = YES;
		[self addSubview:imageView2];
		
		imageView3 = [[VCImageView alloc] initWithFrame:CGRectMake(162, 2, 75, 75)];
		imageView3.backgroundColor = [UIColor whiteColor];
		imageView3.shouldShowActivityIndicator = YES;
		[self addSubview:imageView3];
		
		imageView4 = [[VCImageView alloc] initWithFrame:CGRectMake(241, 2, 75, 75)];
		imageView4.backgroundColor = [UIColor whiteColor];
		imageView4.shouldShowActivityIndicator = YES;
		[self addSubview:imageView4];
		
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    // Configure the view for the selected state
	[imageView1 setEditing:editing animated:animated];
	[imageView2 setEditing:editing animated:animated];
	[imageView3 setEditing:editing animated:animated];
	[imageView4 setEditing:editing animated:animated];
}

- (void)dealloc
{
	[imageView1 release];
	[imageView2 release];
	[imageView3 release];
	[imageView4 release];
    [super dealloc];
}

@end
