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

@synthesize thumbnails;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier thumbnailCount:(NSInteger)count
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		CGFloat currentX = 0.0f;
		CGFloat width = (320 - (4 * (count+1))) / count;
		
		thumbnails = [[NSMutableArray alloc] initWithCapacity:count];
		
		VCThumbnailButton *thumbnailButton = nil;
		for (int counter = 0; counter < count; counter++) {
			thumbnailButton = [[VCThumbnailButton alloc] initWithFrame:CGRectMake(4 + (counter * (width+4)), 2, width, width)];
			thumbnailButton.backgroundColor = [UIColor whiteColor];
			thumbnailButton.shouldShowActivityIndicator = YES;
			[thumbnails addObject:thumbnailButton];
			[self addSubview:thumbnailButton];
			[thumbnailButton release], thumbnailButton = nil;
		}
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    // Configure the view for the selected state
	for (VCThumbnailButton *thumbnail in thumbnails) {
		[thumbnail setEditing:editing animated:animated];
	}
}

- (void)dealloc
{
	[thumbnails removeAllObjects];
	[thumbnails release], thumbnails = nil;
    [super dealloc];
}

@end
