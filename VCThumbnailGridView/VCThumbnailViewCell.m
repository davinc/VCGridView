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

@synthesize thumbnails = _thumbnails;
@synthesize thumbnailCount = _thumbnailCount;
@synthesize thumbnailSize = _thumbnailSize;
@synthesize thumbnailSpacing = _thumbnailSpacing;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width thumbnailCount:(NSInteger)count thumbnailSpacing:(CGFloat)spacing
{
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if (self) {
		self.thumbnailCount = count;
		CGFloat screenwidth = width;
		_thumbnailSpacing = spacing;
		CGFloat width = (screenwidth - (_thumbnailSpacing * (self.thumbnailCount + 1))) / self.thumbnailCount;
		self.thumbnailSize = CGSizeMake(width, width);
		
		_thumbnails = [[NSMutableArray alloc] initWithCapacity:self.thumbnailCount];
	}
	return self;
}

- (void)layoutSubviews
{
	VCThumbnailButton *thumbnailButton = nil;
	_thumbnailSize.height = self.bounds.size.height - _thumbnailSpacing;
	for (int counter = 0; counter < [self.thumbnails count]; counter++) {
		thumbnailButton = [_thumbnails objectAtIndex:counter];
		thumbnailButton.frame = CGRectMake(_thumbnailSpacing + (counter * (self.thumbnailSize.width + _thumbnailSpacing)),
										   _thumbnailSpacing/2,
										   self.thumbnailSize.width,
										   self.thumbnailSize.height);
	}
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
	
    // Configure the view for the selected state
	for (VCThumbnailButton *thumbnail in self.thumbnails) {
		[thumbnail setEditing:editing animated:animated];
	}
}

- (void)dealloc
{
	[_thumbnails removeAllObjects];
	[_thumbnails release], _thumbnails = nil;
    [super dealloc];
}


- (VCThumbnailButton *)thumbnailAtIndex:(NSInteger)index
{
	if (index >= [_thumbnails count]) {
		return nil;
	}
	
	return [_thumbnails objectAtIndex:index];
}
@end
