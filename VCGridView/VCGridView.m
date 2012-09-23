//
//  VCGridView.m
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

#import "VCGridView.h"

@interface VCGridView()

@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, retain) NSMutableArray *reusableCells;

@end

@implementation VCGridView

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

@synthesize cells = _cells;
@synthesize reusableCells = _reusableCells;

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
	[self layoutCells];
}

- (void)dealloc {
	[_scrollView release], _scrollView = nil;
	[_cells release], _cells = nil;
	[_reusableCells release], _reusableCells = nil;
	[_selectedIndexes release], _selectedIndexes = nil;
    [super dealloc];
}


#pragma mark - Private Methods

- (void)didTapImageCell:(VCGridViewCell *)imageView {
	if (!self.isEditing) {
		if ([self.delegate respondsToSelector:@selector(gridView:didSelectCellAtIndex:)]) {
			[self.delegate gridView:self didSelectCellAtIndex:imageView.tag];
		}
	}else {
		if ([self.dataSource respondsToSelector:@selector(gridView:canEditCellAtIndex:)]) {
			NSUInteger index = imageView.tag;
			VCGridViewCell *cell = [self cellAtIndex:index];
			if ([self.dataSource gridView:self canEditCellAtIndex:index]) {
				if ([_selectedIndexes containsIndex:index]) {
					[_selectedIndexes removeIndex:index];
					[cell setSelected:NO animated:YES];
				}else {
					[_selectedIndexes addIndex:index];
					[cell setSelected:YES animated:YES];
				}
			}
		}
	}
}

- (void)updateContentSize
{
	// set content size for scroll view
	_numberOfRows = _numberOfCells / _numberOfCellsInRow;
	if (_numberOfCells % _numberOfCellsInRow != 0) {
		_numberOfRows += 1;
	}
	_scrollView.contentSize = CGSizeMake(self.bounds.size.width, _numberOfRows * _rowHeight);	
}

#pragma mark - Reuse Queue Logic

- (void)queueReusableCellButton:(VCGridViewCell *)aCellButton
{
	NSUInteger reusableQueueLimit = _numberOfCellsInRow * 2;
	
	if ([self.reusableCells count] >= reusableQueueLimit) {
		return;
	}
	
	[self.reusableCells addObject:aCellButton];
}

- (VCGridViewCell *)dequeueReusableCell
{
	if ([self.reusableCells count] == 0) return nil;
	
	VCGridViewCell *button = nil;
	
	button = [[self.reusableCells lastObject] retain]; // retain to avoid crash
	[self.reusableCells removeLastObject];

	return [button autorelease];
}

- (void)prepareReuseCellButtonAtIndex:(NSUInteger)index
{
	VCGridViewCell *cellButton = [self cellAtIndex:index];
    if (cellButton != (id)[NSNull null]) {
		[cellButton setFrame:CGRectZero];
        [cellButton removeFromSuperview];
		[cellButton removeTarget:self action:@selector(didTapImageCell:) forControlEvents:UIControlEventTouchUpInside];
        [self queueReusableCellButton:cellButton];
        [self.cells replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

#pragma mark - Layout

- (NSRange)visibleCellsRange
{
	CGPoint offset = _scrollView.contentOffset;

	CGFloat topVisibleRow = floor(offset.y / _rowHeight);
	NSInteger location = topVisibleRow * _numberOfCellsInRow;
	if (location < 0) {
		location = 0;
	}

	CGFloat topMargin = offset.y - (topVisibleRow * _rowHeight);
	CGFloat visibleHeight = _scrollView.bounds.size.height + topMargin;
	CGFloat visibleRows = visibleHeight / _rowHeight;
	NSUInteger length = ceilf(visibleRows) * _numberOfCellsInRow;
	if (location + length >= _numberOfCells) {
		length = _numberOfCells - location;
	}
	
	return NSMakeRange(location, length);
}

- (void)layoutCellAtIndex:(NSUInteger)index
{
	// get cell at index
	VCGridViewCell *cellButton = [self cellAtIndex:index];
	
	// add at places
	[self.cells replaceObjectAtIndex:index withObject:cellButton];
	[_scrollView insertSubview:cellButton atIndex:0];
	
	// set frame
	CGFloat row = index / _numberOfCellsInRow;
	CGRect frame = CGRectMake((index % _numberOfCellsInRow) * _cellWidth,
							  row * _rowHeight,
							  _cellWidth,
							  _rowHeight);
	cellButton.frame = frame;
}

- (void)layoutCells
{
	NSRange visibleCellsRange = [self visibleCellsRange];
	
	if (NSEqualRanges(currentVisibleRange, visibleCellsRange)) {
		return;
	}
	
	currentVisibleRange = visibleCellsRange;
	
	// layout visible items
	for (NSUInteger i = 0; i < visibleCellsRange.length; i++) {
		[self layoutCellAtIndex:i + visibleCellsRange.location];
	}
	
	// prepare for reuse above and below items
	for (NSUInteger i = 0; i < visibleCellsRange.location; i++) {
		[self prepareReuseCellButtonAtIndex:i];
	}
	
	for (NSUInteger i = visibleCellsRange.location + visibleCellsRange.length; i < _numberOfCells; i++) {
		[self prepareReuseCellButtonAtIndex:i];
	}
}


#pragma mark - Public Methods

- (void)reloadData {
	// remove all old views
	for (UIView *view in self.cells) {
		if ([view isKindOfClass:[VCGridViewCell class]]) {
			[view removeFromSuperview];
		}
	}
	
	// get number of Cells
	if ([self.dataSource respondsToSelector:@selector(numberOfCellsInGridView:)]) {
		_numberOfCells = [self.dataSource numberOfCellsInGridView:self];
	}
	_numberOfCells = MAX(_numberOfCells, 0);
	
	if ([self.dataSource respondsToSelector:@selector(numberOfCellsInRowForGridView:)]) {
		_numberOfCellsInRow = [self.dataSource numberOfCellsInRowForGridView:self];
	}
	_numberOfCellsInRow = MAX(_numberOfCellsInRow, 2);
	
	// calc cell width
	_cellWidth = self.bounds.size.width / _numberOfCellsInRow;

	// calc cell height
	if ([self.delegate respondsToSelector:@selector(heightForRowsInGridView:)]) {
		_rowHeight = [self.delegate heightForRowsInGridView:self];
	}else {
		_rowHeight = _cellWidth;
	}
		
	// initialize Cells arry with null objects
	self.cells = [NSMutableArray array]; // removes older items from array and its refreshed
	for (NSUInteger i = 0; i < _numberOfCells; i++) {
		[self.cells addObject:[NSNull null]];
	}
	
	// update content size
	[self updateContentSize];
	
	// set cell pool size for reusability, should be double of _numberOfCellsInRow
	self.reusableCells = [NSMutableArray array];
	
	// call for layout
	[self setNeedsLayout];
}

- (VCGridViewCell *)cellAtIndex:(NSUInteger)index
{
	VCGridViewCell *cellButton = [self.cells objectAtIndex:index];
	if ((id)cellButton == [NSNull null]) {
		// if it is null then get it from delegate
		if ([self.dataSource respondsToSelector:@selector(gridView:cellAtIndex:)]) {
			cellButton = [self.dataSource gridView:self cellAtIndex:index];
		}
		[cellButton addTarget:self action:@selector(didTapImageCell:) forControlEvents:UIControlEventTouchUpInside];
	}

	cellButton.tag = index;
	[cellButton setSelected:[_selectedIndexes containsIndex:index] animated:NO];

	return cellButton;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[_selectedIndexes removeAllIndexes];

	// set editing property
	NSRange visibleCellsRange = [self visibleCellsRange];
	for (NSUInteger i = 0; i < visibleCellsRange.length; i++) {
		VCGridViewCell *cell = [self cellAtIndex:i + visibleCellsRange.location];
		if (cell != (id)[NSNull null]) {
			[cell setEditing:editing animated:animated];
		}
	}

	_isEditing = editing;
}

- (void)insertCellAtIndex:(NSUInteger)index animated:(BOOL)animated
{
	[self.cells insertObject:[NSNull null] atIndex:index];
	_numberOfCells++;
	[self updateContentSize];

	NSRange visibleRange = [self visibleCellsRange];
	if (index < visibleRange.location + visibleRange.length)
	{
		currentVisibleRange = NSMakeRange(0, 0);//force layout
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationsEnabled:animated];

		[self layoutCells];
		
		[UIView commitAnimations];
	}
}

- (void)removeCellAtIndex:(NSUInteger)index animated:(BOOL)animated
{
	[self.cells removeObjectAtIndex:index];
	_numberOfCells--;
	[self updateContentSize];
	
	NSRange visibleRange = [self visibleCellsRange];
	if (index < visibleRange.location + visibleRange.length)
	{
		currentVisibleRange = NSMakeRange(0, 0); //force layout
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationsEnabled:animated];
		
		[self layoutCells];
		
		[UIView commitAnimations];
	}
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	// check logic here
	[self layoutCells];
}


@end
