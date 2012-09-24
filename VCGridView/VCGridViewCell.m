//
//  VCGridViewCell.m
//  Demo
//
//  Created by Vinay Chavan on 07/08/12.
//
//  Copyright (C) 2012 by Vinay Chavan
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

#import "VCGridViewCell.h"

#import <QuartzCore/QuartzCore.h>

@implementation VCGridViewCell

@synthesize isSelected;
@synthesize isEditing;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.autoresizesSubviews = YES;
		self.userInteractionEnabled = YES;
		self.contentMode = UIViewContentModeScaleAspectFit;
//		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//		self.layer.borderWidth = 1.0f;

		selectedIndicatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		selectedIndicatorImageView.alpha = 0.0;
		selectedIndicatorImageView.image = [UIImage imageNamed:@"check.png"];
		[selectedIndicatorImageView sizeToFit];
		[self addSubview:selectedIndicatorImageView];
	}
    return self;
}

- (void)dealloc {
	[selectedIndicatorImageView release], selectedIndicatorImageView = nil;
    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	selectedIndicatorImageView.frame = CGRectMake(self.bounds.size.width - selectedIndicatorImageView.bounds.size.width,
												  self.bounds.size.height - selectedIndicatorImageView.bounds.size.height,
												  selectedIndicatorImageView.bounds.size.width,
												  selectedIndicatorImageView.bounds.size.height);
}



#pragma mark - Private Methods


#pragma mark - Public Methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	isSelected = selected;
	
	//	DebugLog(@"Index:%i selected:%i", self.tag, selected);
	
	if (animated) [UIView beginAnimations:nil context:nil];
	
	if (isSelected)
	{
		selectedIndicatorImageView.alpha = 1.0;
	}
	else
	{
		selectedIndicatorImageView.alpha = 0.0;
	}
	if (animated) [UIView commitAnimations];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	if (isEditing != editing) {
		isEditing = editing;
		[self setSelected:NO animated:YES];
	}
}


@end
