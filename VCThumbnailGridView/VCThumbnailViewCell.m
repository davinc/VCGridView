//
//  VCThumbnailViewCell.m
//  Demo
//
//  Created by Vinay Chavan on 22/08/11.
//  
//  Copyright (C) 2011 by Vinay Chavan
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions: 
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "VCThumbnailViewCell.h"

@implementation VCThumbnailViewCell

@synthesize imageView1, imageView2, imageView3, imageView4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		imageView1 = [[VCThumbnailButton alloc] initWithFrame:CGRectMake(4, 2, 75, 75)];
		imageView1.backgroundColor = [UIColor whiteColor];
		imageView1.shouldShowActivityIndicator = YES;
		[self addSubview:imageView1];
		
		imageView2 = [[VCThumbnailButton alloc] initWithFrame:CGRectMake(83, 2, 75, 75)];
		imageView2.backgroundColor = [UIColor whiteColor];
		imageView2.shouldShowActivityIndicator = YES;
		[self addSubview:imageView2];
		
		imageView3 = [[VCThumbnailButton alloc] initWithFrame:CGRectMake(162, 2, 75, 75)];
		imageView3.backgroundColor = [UIColor whiteColor];
		imageView3.shouldShowActivityIndicator = YES;
		[self addSubview:imageView3];
		
		imageView4 = [[VCThumbnailButton alloc] initWithFrame:CGRectMake(241, 2, 75, 75)];
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
