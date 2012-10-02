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
@synthesize highlightedBackgroundView = _highlightedBackgroundView;
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

		_highlightedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
		_highlightedBackgroundView.backgroundColor = [UIColor clearColor];
		_highlightedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_containerView addSubview:_highlightedBackgroundView];

		_backgroundView = [[UIView alloc] initWithFrame:self.bounds];
		_backgroundView.backgroundColor = [UIColor clearColor];
		_backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_containerView addSubview:_backgroundView];

		_contentView = [[UIView alloc] initWithFrame:self.bounds];
		_contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_containerView addSubview:_contentView];

		_editingSelectionOverlayView = [[UIView alloc] initWithFrame:self.bounds];
		_editingSelectionOverlayView.backgroundColor = [UIColor clearColor];
		_editingSelectionOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_containerView addSubview:_editingSelectionOverlayView];
}
    return self;
}

- (void)dealloc {
	[_containerView release], _containerView = nil;
	[_contentView release], _contentView = nil;
	[_backgroundView release], _backgroundView = nil;
	[_highlightedBackgroundView release], _highlightedBackgroundView = nil;
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

- (void)setHighlightedBackgroundView:(UIView *)highlightedBackgroundView
{
	if (_highlightedBackgroundView != highlightedBackgroundView) {
		[_highlightedBackgroundView removeFromSuperview];
		[_highlightedBackgroundView release], _highlightedBackgroundView = nil;

		_highlightedBackgroundView = [highlightedBackgroundView retain];
		
		[_containerView insertSubview:_highlightedBackgroundView belowSubview:_backgroundView];
	}
}

- (BOOL)isHighlighted
{
	return _cellFlags.highlighted;
}

- (void)setHighlighted:(BOOL)highlighted
{
	_cellFlags.highlighted = highlighted;
	
	if (_cellFlags.highlighted) {
		_backgroundView.alpha = 0.0f;
		_highlightedBackgroundView.alpha = 1.0f;
	}else {
		_backgroundView.alpha = 1.0f;
		_highlightedBackgroundView.alpha = 0.0f;
	}
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	if (animated) {
		[UIView animateWithDuration:0.3
						 animations:^{
							 [self setHighlighted:highlighted];
						 }];
	}else {
		[self setHighlighted:highlighted];
	}
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
	if (animated) {
		[UIView animateWithDuration:0.3
						 animations:^{
							 [self setSelected:selected];
						 }];
	}else {
		[self setSelected:selected];
	}
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
