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

@synthesize dataSource = _dataSource;

@synthesize cells = _cells;
@synthesize reusableCells = _reusableCells;

@synthesize isEditing = _isEditing;
@synthesize selectedIndexes = _selectedIndexes;

@synthesize gridCellsContainerView = _gridCellsContainerView;
@synthesize gridHeaderView = _gridHeaderView;
@synthesize gridFooterView = _gridFooterView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.delaysContentTouches = NO;
		self.canCancelContentTouches = YES;
		self.delegate = nil;
		self.dataSource = nil;
		_selectedIndexes = [[NSMutableIndexSet alloc] init];
		_numberOfCellsInRow = 1;
		
		_gridCellsContainerView = [[UIView alloc] initWithFrame:self.bounds];
		_gridCellsContainerView.backgroundColor = [UIColor clearColor];
		[self addSubview:_gridCellsContainerView];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self layoutCellsIfNeeded:NO];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self layoutCellsIfNeeded:YES];
}

- (void)dealloc {
	[_cells release], _cells = nil;
	[_reusableCells release], _reusableCells = nil;
	[_selectedIndexes release], _selectedIndexes = nil;
	[_gridHeaderView release], _gridHeaderView = nil;
	[_gridCellsContainerView release], _gridCellsContainerView = nil;
	[_gridFooterView release], _gridFooterView = nil;
    [super dealloc];
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	if ([touch.view isKindOfClass:[VCGridViewCell class]]) {
		[self didTouchDownCell:(VCGridViewCell*)touch.view];
	}
	
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	if ([touch.view isKindOfClass:[VCGridViewCell class]]) {
		[self didTouchUpCell:(VCGridViewCell*)touch.view];
	}
	
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	if ([touch.view isKindOfClass:[VCGridViewCell class]]) {
		[self didTouchCancelCell:(VCGridViewCell*)touch.view];
	}
	
    [super touchesCancelled:touches withEvent:event];
}


#pragma mark - Private Methods

- (void)didTouchDownCell:(VCGridViewCell *)cell
{
	[cell setHighlighted:YES animated:YES];
}

- (void)didTouchUpCell:(VCGridViewCell *)cell
{
	[cell setHighlighted:NO animated:YES];
	NSUInteger index = cell.tag;
	
	if (!self.isEditing) {
		if ([self.delegate respondsToSelector:@selector(gridView:didSelectCellAtIndex:)]) {
			[self.delegate gridView:self didSelectCellAtIndex:index];
		}
	}else {
		if ([self.dataSource respondsToSelector:@selector(gridView:canEditCellAtIndex:)]) {
			VCGridViewCell *cell = [self cellAtIndex:index];
			if ([self.dataSource gridView:self canEditCellAtIndex:index]) {
				if ([self.selectedIndexes containsIndex:index]) {
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

- (void)didTouchCancelCell:(VCGridViewCell *)cell
{
	[cell setHighlighted:NO animated:YES];
}

- (void)updateContentSize
{
	// set content size for scroll view
	_numberOfRows = _numberOfCells / _numberOfCellsInRow;
	if (_numberOfCells % _numberOfCellsInRow != 0) {
		_numberOfRows += 1;
	}
	CGFloat cellContainerHeight = (_numberOfRows * _cellSizeWithPadding.height) + _cellPadding;
	self.contentSize = CGSizeMake(self.bounds.size.width,
								  _gridHeaderView.bounds.size.height + cellContainerHeight + _gridFooterView.bounds.size.height);
	
	_gridHeaderView.frame = CGRectMake(0,
									   0,
									   self.bounds.size.width,
									   _gridHeaderView.bounds.size.height);

	_gridCellsContainerView.frame = CGRectMake(0,
											   _gridHeaderView.bounds.size.height,
											   self.bounds.size.width,
											   cellContainerHeight);
	_gridFooterView.frame = CGRectMake(0,
									   self.contentSize.height - _gridFooterView.bounds.size.height,
									   self.bounds.size.width,
									   _gridFooterView.bounds.size.height);
}

#pragma mark - Reuse Queue Logic

- (void)queueReusableCell:(VCGridViewCell *)aCell
{
	NSUInteger reusableQueueLimit = _numberOfCellsInRow * 2;
	
	if ([self.reusableCells count] >= reusableQueueLimit) {
		return;
	}
	
	[self.reusableCells addObject:aCell];
}

- (VCGridViewCell *)dequeueReusableCell
{
	if ([self.reusableCells count] == 0) return nil;
	
	VCGridViewCell *button = nil;
	
	button = [[self.reusableCells lastObject] retain]; // retain to avoid crash
	[self.reusableCells removeLastObject];

	return [button autorelease];
}

- (BOOL)prepareReuseCellAtIndex:(NSUInteger)index
{
	VCGridViewCell *cell = [self cellAtIndex:index];
    if ((id)cell != [NSNull null]) {
        [cell removeFromSuperview];
        [self queueReusableCell:cell];
        [self.cells replaceObjectAtIndex:index withObject:[NSNull null]];
		return YES;
    }
	return NO;
}

- (void)configureCell:(VCGridViewCell *)cell forIndex:(NSUInteger)index
{
	cell.tag = index;
	[cell setSelected:[self.selectedIndexes containsIndex:index]];
	[cell setHighlighted:NO animated:NO];
}

#pragma mark - Layout

- (NSInteger)numberOfCellsInRow
{
	CGFloat totalWidth = self.bounds.size.width;
	return (NSInteger)((totalWidth-_cellPadding)/_cellSizeWithPadding.width);
}

- (NSRange)visibleCellsRange
{
	CGPoint offset = self.contentOffset;
	offset.y -= _gridHeaderView.bounds.size.height;
	
	CGFloat topVisibleRow = floor(offset.y / _cellSizeWithPadding.height);
	NSInteger location = topVisibleRow * _numberOfCellsInRow;
	if (location < 0) {
		location = 0;
	}

	CGFloat topMargin = offset.y - (topVisibleRow * _cellSizeWithPadding.height);
	CGFloat visibleHeight = self.bounds.size.height + topMargin;
	CGFloat visibleRows = visibleHeight / _cellSizeWithPadding.height;
	NSUInteger length = ceilf(visibleRows) * _numberOfCellsInRow;
	if (location + length >= _numberOfCells) {
		length = _numberOfCells - location;
	}
	
	return NSMakeRange(location, length);
}

- (CGRect)frameForCellAtIndex:(NSUInteger)index
{
	CGFloat row = floor(index / _numberOfCellsInRow);
	
	CGFloat x = _cellPadding + _rowPadding;
	CGFloat y = _cellPadding;
	
	x += (index % _numberOfCellsInRow) * _cellSizeWithPadding.width;
	y += row * _cellSizeWithPadding.height;
	CGRect frame = CGRectMake(x,
							  y,
							  _cellSize.width,
							  _cellSize.height);
	return frame;
}

- (void)layoutCellAtIndex:(NSUInteger)index ifNeeded:(BOOL)needed
{
	// get cell at index
	BOOL shouldLayout = needed;
	VCGridViewCell *cell = [self cellAtIndex:index];
	if ((id)cell == [NSNull null]) {
		// if it is null then get it from delegate
		if ([self.dataSource respondsToSelector:@selector(gridView:cellAtIndex:)]) {
			cell = [self.dataSource gridView:self cellAtIndex:index];
		}
		
		[self configureCell:cell forIndex:index];
		
		[self.cells replaceObjectAtIndex:index withObject:cell];
		[_gridCellsContainerView insertSubview:cell atIndex:0];
		
		shouldLayout = YES;
	}else {
		if (cell.tag != index) {
			[self configureCell:cell forIndex:index];

			shouldLayout = YES;
		}
	}
	
	if (shouldLayout) {
		cell.frame = [self frameForCellAtIndex:index];
	}
}

- (void)layoutCellsIfNeeded:(BOOL)needed
{
	if (needed) {
		_numberOfCellsInRow = [self numberOfCellsInRow];
		_rowPadding = (self.bounds.size.width - (_cellPadding + (_numberOfCellsInRow * (_cellSizeWithPadding.width)))) / 2.0f;
		[self updateContentSize];
	}
		
	NSRange visibleCellsRange = [self visibleCellsRange];
	
	if (!needed && NSEqualRanges(currentVisibleRange, visibleCellsRange)) {
		return;
	}
	
	currentVisibleRange = visibleCellsRange;
	
	// layout visible items
	for (NSUInteger i = 0; i < visibleCellsRange.length; i++) {
		[self layoutCellAtIndex:i + visibleCellsRange.location ifNeeded:needed];
	}
	
	// prepare for reuse above and below items
	for (NSInteger i = visibleCellsRange.location-1; i >= 0; i--) {
		// break when first null object found
		if (![self prepareReuseCellAtIndex:i]) break;
	}
	
	for (NSUInteger i = NSMaxRange(visibleCellsRange); i < _numberOfCells; i++) {
		// break when first null object found
		if (![self prepareReuseCellAtIndex:i]) break;
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
	
	// get cell size
	if ([self.delegate respondsToSelector:@selector(sizeForCellsInGridView:)]) {
		_cellSize = [self.delegate sizeForCellsInGridView:self];
	}
	
	if ([self.delegate respondsToSelector:@selector(paddingForCellsInGridView:)]) {
		_cellPadding = [self.delegate paddingForCellsInGridView:self];
	}
	
	_cellSizeWithPadding = CGSizeMake(_cellSize.width + _cellPadding,
									  _cellSize.height + _cellPadding);
	_numberOfCellsInRow = [self numberOfCellsInRow];
	_rowPadding = (self.bounds.size.width - (_cellPadding + (_numberOfCellsInRow * (_cellSizeWithPadding.width)))) / 2.0f;
	
	// initialize Cells arry with null objects
	self.cells = [NSMutableArray array]; // removes older items from array and its refreshed
	for (NSUInteger i = 0; i < _numberOfCells; i++) {
		[self.cells addObject:[NSNull null]];
	}
		
	// set cell pool size for reusability, should be double of _numberOfCellsInRow
	self.reusableCells = [NSMutableArray array];
	
	currentVisibleRange = NSMakeRange(0, 0);
	
	// update content size
	[self updateContentSize];
	// call for layout
	[self setNeedsLayout];
}

- (NSUInteger)numberOfCells
{
	return _numberOfCells;
}

- (VCGridViewCell *)cellAtIndex:(NSUInteger)index
{
	VCGridViewCell *cell = [self.cells objectAtIndex:index];
	return cell;
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

- (void)insertCellAtIndexSet:(NSIndexSet *)indexSet animated:(BOOL)animated
{
	[indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
		[self.cells insertObject:[NSNull null] atIndex:index];
		_numberOfCells++;
	}];
	
	[self updateContentSize];

	currentVisibleRange = NSMakeRange(0, 0);//force layout
	
	if (animated) {
		[UIView animateWithDuration:0.3
						 animations:^{
							 [self layoutCellsIfNeeded:NO];
						 }];
	}else {
		[self layoutCellsIfNeeded:NO];
	}
}

- (void)deleteCellAtIndexSet:(NSIndexSet *)indexSet animated:(BOOL)animated
{
	NSMutableArray *cellsToRemove = [NSMutableArray array];
	[indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
		VCGridViewCell *cellToRemove = [self cellAtIndex:index];
		if ([cellToRemove isKindOfClass:[VCGridViewCell class]]) {
			[cellsToRemove addObject:cellToRemove];
		}
	}];
	
	for (UIView *cellToRemove in cellsToRemove) {
		[_selectedIndexes removeIndex:cellToRemove.tag];
		[cellToRemove removeFromSuperview];
		[self.cells removeObject:cellToRemove];
		_numberOfCells--;
	}
	
	[self updateContentSize];

	currentVisibleRange = NSMakeRange(0, 0); //force layout

	if (animated) {
		[UIView animateWithDuration:0.3
						 animations:^{
							 [self layoutCellsIfNeeded:NO];
						 }];
	}else {
		[self layoutCellsIfNeeded:NO];
	}
}

- (void)setGridHeaderView:(UIView *)gridHeaderView
{
	if (_gridHeaderView != gridHeaderView) {
		[_gridHeaderView removeFromSuperview];
		[_gridHeaderView release], _gridHeaderView = nil;
		_gridHeaderView = [gridHeaderView retain];
	}
	
	[self updateContentSize];

	// add header
	[self insertSubview:_gridHeaderView belowSubview:_gridCellsContainerView];
}

- (void)setGridFooterView:(UIView *)gridFooterView
{
	if (_gridFooterView != gridFooterView) {
		[_gridFooterView removeFromSuperview];
		[_gridFooterView release], _gridFooterView = nil;
		_gridFooterView = [gridFooterView retain];
	}
	
	[self updateContentSize];
	
	// add header
	[self insertSubview:_gridFooterView belowSubview:_gridCellsContainerView];
}

@end
