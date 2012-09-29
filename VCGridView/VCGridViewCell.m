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

@implementation VCGridViewCell

@synthesize contentView = _contentView;
@synthesize backgroundView = _backgroundView;
@synthesize selectedBackgroundView = _selectedBackgroundView;
@synthesize editingSelectionOverlayView = _editingSelectionOverlayView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.autoresizesSubviews = YES;

		_containerView = [[UIView alloc] initWithFrame:self.bounds];
		_containerView.userInteractionEnabled = NO;
		_containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:_containerView];

		_selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
		_selectedBackgroundView.backgroundColor = [UIColor redColor];
		_selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_containerView addSubview:_selectedBackgroundView];

		_backgroundView = [[UIView alloc] initWithFrame:self.bounds];
		_backgroundView.backgroundColor = [UIColor whiteColor];
		_backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_containerView addSubview:_backgroundView];

		_contentView = [[UIView alloc] initWithFrame:self.bounds];
		_contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_containerView addSubview:_contentView];

		_editingSelectionOverlayView = [[UIView alloc] initWithFrame:self.bounds];
		_editingSelectionOverlayView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
		_editingSelectionOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_containerView addSubview:_editingSelectionOverlayView];
}
    return self;
}

- (void)dealloc {
	[_containerView release], _containerView = nil;
	[_contentView release], _contentView = nil;
	[_backgroundView release], _backgroundView = nil;
	[_selectedBackgroundView release], _selectedBackgroundView = nil;
	[_editingSelectionOverlayView release], _editingSelectionOverlayView = nil;
    [super dealloc];
}

- (void)layoutSubviews {
	
}



#pragma mark - Private Methods


#pragma mark - Public Methods

- (void)setEditingSelectionOverlayView:(UIView *)editingSelectionOverlayView
{
	if (_editingSelectionOverlayView != editingSelectionOverlayView) {
		[_editingSelectionOverlayView removeFromSuperview];
		[_editingSelectionOverlayView release], _editingSelectionOverlayView = nil;

		_editingSelectionOverlayView = [editingSelectionOverlayView retain];
		if (self.editing && self.selected) {
			_editingSelectionOverlayView.alpha = 1.0;
		}else {
			_editingSelectionOverlayView.alpha = 0.0f;
		}
		[_containerView insertSubview:_editingSelectionOverlayView aboveSubview:_contentView];
	}
}

- (BOOL)isHighlighted
{
	return _cellFlags.highlighted;
}

- (void)setHighlighted:(BOOL)highlighted
{
	if (_cellFlags.highlighted != highlighted) {
		_cellFlags.highlighted = highlighted;
		
		if (_cellFlags.highlighted) {
			_backgroundView.alpha = 0.0f;
		}else {
			_backgroundView.alpha = 1.0f;
		}
	}
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationsEnabled:animated];
	
	[self setHighlighted:highlighted];
	
	[UIView commitAnimations];
}

- (BOOL)isSelected
{
	return _cellFlags.selected;
}

- (void)setSelected:(BOOL)selected
{
	_cellFlags.selected = selected;
	if (_cellFlags.selected) {
		self.editingSelectionOverlayView.alpha = 1.0;
	}else {
		self.editingSelectionOverlayView.alpha = 0.0;
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationsEnabled:animated];
	
	[self setSelected:selected];

	[UIView commitAnimations];
}


- (BOOL)isEditing
{
	return _cellFlags.editing;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	if (_cellFlags.editing != editing) {
		_cellFlags.editing = editing;
		[self setSelected:NO animated:YES];
	}
}


@end
