//
//  VCThumbnailGridView.m
//  
//
//  Created by Vinay Chavan on 19/03/11.
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

#import "VCThumbnailGridView.h"

@interface VCThumbnailGridView()

@property (nonatomic, retain) NSMutableArray *thumbnailButtons;
@property (nonatomic, retain) NSMutableArray *reusableThumbnailButtons;

@end

@implementation VCThumbnailGridView

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

@synthesize thumbnailButtons = _thumbnailButtons;
@synthesize reusableThumbnailButtons = _reusableThumbnailButtons;

@synthesize isEditing = _isEditing;
@synthesize selectedIndexes = _selectedIndexes;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_delegate = nil;
		_dataSource = nil;

		_scrollView = [[UIScrollView alloc] initWithFrame:frame];
		_scrollView.delegate = self;
		[self addSubview:_scrollView];

		self.clipsToBounds = YES;
		
		_selectedIndexes = [[NSMutableIndexSet alloc] init];
    }
    return self;
}

- (void)layoutSubviews {
	_scrollView.frame = self.bounds;

	// set current visible views
	[self layoutThumbnails];
}

- (void)dealloc {
	[_scrollView release], _scrollView = nil;
	[_thumbnailButtons release], _thumbnailButtons = nil;
	[_reusableThumbnailButtons release], _reusableThumbnailButtons = nil;
	[_selectedIndexes release], _selectedIndexes = nil;
    [super dealloc];
}


#pragma mark - Private Methods

- (void)didTapImageThumbnail:(VCThumbnailButton *)imageView {
	if (!self.isEditing) {
		if ([self.delegate respondsToSelector:@selector(thumbnailGridView:didSelectThumbnailAtIndex:)]) {
			[self.delegate thumbnailGridView:self didSelectThumbnailAtIndex:imageView.tag];
		}
	}else {
		if ([self.dataSource respondsToSelector:@selector(thumbnailGridView:canEditThumbnailAtIndex:)]) {
			NSInteger index = imageView.tag;
			VCThumbnailButton *thumbnailView = [self thumbnailAtIndex:index];
			if ([self.dataSource thumbnailGridView:self canEditThumbnailAtIndex:index]) {
				if ([_selectedIndexes containsIndex:index]) {
					[_selectedIndexes removeIndex:index];
					[thumbnailView setSelected:NO animated:YES];
				}else {
					[_selectedIndexes addIndex:index];
					[thumbnailView setSelected:YES animated:YES];
				}
			}
		}
	}
}


#pragma mark - Reuse Queue Logic

- (void)queueReusableThumbnailButton:(VCThumbnailButton *)aThumbnailButton
{
	NSUInteger reusableQueueLimit = _numberOfThumbnailsInRow * 2;
	
	if ([self.reusableThumbnailButtons count] >= reusableQueueLimit) {
		return;
	}
	
	[self.reusableThumbnailButtons addObject:aThumbnailButton];
}

- (VCThumbnailButton *)dequeueReusableThumbnail
{
	if ([self.reusableThumbnailButtons count] == 0) return nil;
	
	VCThumbnailButton *button = nil;
	
	button = [[self.reusableThumbnailButtons lastObject] retain]; // retain to avoid crash
	[self.reusableThumbnailButtons removeLastObject];

	return [button autorelease];
}

- (void)removeThumbnailButtonAtIndex:(NSUInteger)index
{	
    if ([self.thumbnailButtons objectAtIndex:index] != [NSNull null]) {
		VCThumbnailButton *thumbnailButton = [self.thumbnailButtons objectAtIndex:index];
        [self queueReusableThumbnailButton:thumbnailButton];
        [thumbnailButton removeFromSuperview];
        [self.thumbnailButtons replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

#pragma mark - Layout

- (NSRange)visibleThumbnailsRange
{
	CGPoint offset = _scrollView.contentOffset;

	CGFloat topVisibleRow = floor(offset.y / _rowHeight);
	NSInteger location = topVisibleRow * _numberOfThumbnailsInRow;
	if (location < 0) {
		location = 0;
	}

	CGFloat topMargin = offset.y - (topVisibleRow * _rowHeight);
	CGFloat visibleHeight = _scrollView.bounds.size.height + topMargin;
	CGFloat visibleRows = visibleHeight / _rowHeight;
	NSUInteger length = ceilf(visibleRows) * _numberOfThumbnailsInRow;
	if (location + length >= _numberOfThumbnails) {
		length = _numberOfThumbnails - location;
	}
	
	return NSMakeRange(location, length);
}

- (void)layoutThumbnails
{
	NSRange visibleThumbnailsRange = [self visibleThumbnailsRange];
	
	if (NSEqualRanges(currentVisibleRange, visibleThumbnailsRange)) {
		return;
	}

//	NSLog(@"%i : %i", visibleThumbnailsRange.location, visibleThumbnailsRange.length);
	currentVisibleRange = visibleThumbnailsRange;
	
	// layout visible items
	for (NSUInteger i = 0; i < visibleThumbnailsRange.length; i++) {
		[self layoutThumbnailAtIndex:i + visibleThumbnailsRange.location];
	}
	
	// remove above and below items
	for (NSUInteger i = 0; i < visibleThumbnailsRange.location; i++) {
		[self removeThumbnailButtonAtIndex:i];
	}
	
	for (NSUInteger i = visibleThumbnailsRange.location + visibleThumbnailsRange.length; i < _numberOfThumbnails; i++) {
		[self removeThumbnailButtonAtIndex:i];
	}
}

- (void)layoutThumbnailAtIndex:(NSUInteger)index
{
	// get thumbnail at index
	VCThumbnailButton *thumbnailButton = [self.thumbnailButtons objectAtIndex:index];
	if ((id)thumbnailButton == [NSNull null]) {
		// if it is null then get it from delegate
		if ([self.dataSource respondsToSelector:@selector(thumbnailGridView:thumbnailViewAtIndex:reusableThumbnailView:)]) {
			thumbnailButton = [self.dataSource thumbnailGridView:self thumbnailViewAtIndex:index];
			thumbnailButton.tag = index;
			[thumbnailButton addTarget:self action:@selector(didTapImageThumbnail:) forControlEvents:UIControlEventTouchUpInside];
			[thumbnailButton setSelected:[_selectedIndexes containsIndex:index] animated:NO];
		}
	}
	
	// add at places
	[self.thumbnailButtons replaceObjectAtIndex:index withObject:thumbnailButton];
	[_scrollView addSubview:thumbnailButton];
	
	// set frame
	CGFloat row = index / _numberOfThumbnailsInRow;
	CGRect frame = CGRectMake(_thumbnailSpacing + ((index % _numberOfThumbnailsInRow) * (_thumbnailWidth + _thumbnailSpacing)),
							  (row * _rowHeight) + _thumbnailSpacing,
							  _thumbnailWidth,
							  _rowHeight - _thumbnailSpacing);
//	NSLog(@"%i", index);
	thumbnailButton.frame = frame;
}

#pragma mark - Public Methods

- (void)reloadData {
	// remove all old views
	for (UIView *view in self.thumbnailButtons) {
		if ([view isKindOfClass:[VCThumbnailButton class]]) {
			[view removeFromSuperview];
		}
	}
	
	// get number of thumbnails
	if ([self.dataSource respondsToSelector:@selector(numberOfThumbnailsInThumbnailGridView:)]) {
		_numberOfThumbnails = [self.dataSource numberOfThumbnailsInThumbnailGridView:self];
	}
	_numberOfThumbnails = MAX(_numberOfThumbnails, 0);
	
	if ([self.dataSource respondsToSelector:@selector(numberOfThumbnailsInRowForThumbnailGridView:)]) {
		_numberOfThumbnailsInRow = [self.dataSource numberOfThumbnailsInRowForThumbnailGridView:self];
	}
	_numberOfThumbnailsInRow = MAX(_numberOfThumbnailsInRow, 2);
	
	_thumbnailSpacing = 0.0f;
	if ([self.delegate respondsToSelector:@selector(spacingOfThumbnailsInThumbnailGridView:)]) {
		_thumbnailSpacing = [self.delegate spacingOfThumbnailsInThumbnailGridView:self];
	}
	
	// calc thumbnail height
	if ([self.delegate respondsToSelector:@selector(heightForRowsInThumbnailGridView:)]) {
		_rowHeight = [self.delegate heightForRowsInThumbnailGridView:self];
	}else {
		CGFloat width = (self.bounds.size.width - (_thumbnailSpacing * (_numberOfThumbnailsInRow+1))) / _numberOfThumbnailsInRow;
		_rowHeight = width + _thumbnailSpacing;
	}
	
	// calc thumbnail width
	_thumbnailWidth = (_scrollView.bounds.size.width - (_thumbnailSpacing * (_numberOfThumbnailsInRow + 1))) / _numberOfThumbnailsInRow;
	
	// initialize thumbnails arry with null objects
	self.thumbnailButtons = [NSMutableArray array]; // removes older items from array and its refreshed
	for (NSUInteger i = 0; i < _numberOfThumbnails; i++) {
		[self.thumbnailButtons addObject:[NSNull null]];
	}
	
	// set content size for scroll view
	_numberOfRows = _numberOfThumbnails / _numberOfThumbnailsInRow;
	if (_numberOfThumbnails % _numberOfThumbnailsInRow != 0) {
		_numberOfRows += 1;
	}
	_scrollView.contentSize = CGSizeMake(self.bounds.size.width, _numberOfRows * _rowHeight + _thumbnailSpacing);
	
	// set thumbnail pool size for reusability, should be double of _numberOfThumbnailsInRow
	self.reusableThumbnailButtons = [NSMutableArray array];
	
	// call for layout
	[self setNeedsLayout];
}

- (VCThumbnailButton *)thumbnailAtIndex:(NSInteger)index
{
	return [self.thumbnailButtons objectAtIndex:index];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[_selectedIndexes removeAllIndexes];

	// set editing property
	NSRange visibleThumbnailsRange = [self visibleThumbnailsRange];
	for (NSUInteger i = 0; i < visibleThumbnailsRange.length; i++) {
		VCThumbnailButton *thumbnail = [self thumbnailAtIndex:i + visibleThumbnailsRange.location];
		if (thumbnail != (id)[NSNull null]) {
			[thumbnail setEditing:editing animated:animated];
		}
	}

	_isEditing = editing;
}


#pragma mark - Property Methods



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	// check logic here
	[self layoutThumbnails];
}


@end
