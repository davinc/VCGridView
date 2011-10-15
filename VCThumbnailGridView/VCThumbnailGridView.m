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

#import "VCThumbnailViewCell.h"

@interface VCThumbnailGridView()

@end

@implementation VCThumbnailGridView

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize isEditing = _isEditing;
@synthesize selectedIndexes = _selectedIndexes;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_delegate = nil;
		_dataSource = nil;
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		_tableView.clipsToBounds = NO;
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.rowHeight = 0;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:_tableView];
		
		_numberOfThumbnailsInRow = 1;
		
		_selectedIndexes = [[NSMutableIndexSet alloc] init];
    }
    return self;
}

- (void)layoutSubviews {
	_tableView.frame = CGRectInset(self.bounds, 0, 2);
}

- (void)dealloc {
	[_tableView release], _tableView = nil;
	[_selectedIndexes release], _selectedIndexes = nil;
    [super dealloc];
}


#pragma mark - Private Methods

- (void)didTapImageThumbnail:(VCThumbnailView*)imageView {
	if (!self.isEditing) {
		if ([self.delegate respondsToSelector:@selector(thumbnailGridView:didSelectThumbnailAtIndex:)]) {
			[self.delegate thumbnailGridView:self didSelectThumbnailAtIndex:imageView.tag];
		}
	}else {
		if ([self.dataSource respondsToSelector:@selector(thumbnailGridView:canEditThumbnailAtIndex:)]) {
			NSInteger index = imageView.tag;
			VCThumbnailView *thumbnailView = [self thumbnailAtIndex:index];
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

#pragma mark - Public Methods

- (void)reloadData {
	if ([self.dataSource respondsToSelector:@selector(numberOfThumbnailsInThumbnailGridView:)]) {
		_numberOfThumbnails = [self.dataSource numberOfThumbnailsInThumbnailGridView:self];
	}
	_numberOfThumbnails = MAX(_numberOfThumbnails, 0);
	
	if ([self.dataSource respondsToSelector:@selector(numberOfThumbnailsInRowForThumbnailGridView:)]) {
		_numberOfThumbnailsInRow = [self.dataSource numberOfThumbnailsInRowForThumbnailGridView:self];
	}
	_numberOfThumbnailsInRow = MAX(_numberOfThumbnailsInRow, 1);
	
	CGFloat width = (self.bounds.size.width - (4 * (_numberOfThumbnailsInRow+1))) / _numberOfThumbnailsInRow;
	_tableView.rowHeight = width + 4;
	
	[_tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[_tableView setEditing:editing animated:animated];
	_isEditing = editing;
	[_selectedIndexes removeAllIndexes];
}

- (VCThumbnailView *)thumbnailAtIndex:(NSInteger)index
{
	// expected row
	NSInteger expectedRow = index / _numberOfThumbnailsInRow;	
	NSInteger expectedThumbnailIndex = index % _numberOfThumbnailsInRow;
	VCThumbnailViewCell *cell = (VCThumbnailViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:expectedRow inSection:0]];
	VCThumbnailView *view = [cell thumbnailAtIndex:expectedThumbnailIndex];
	return view;
}

#pragma mark - Property Methods

- (UIView *)gridHeaderView
{
	return _tableView.tableHeaderView;
}

- (void)setGridHeaderView:(UIView *)gridHeaderView
{
	_tableView.tableHeaderView = gridHeaderView;
}

- (UIView *)gridFooterView
{
	return _tableView.tableFooterView;
}

- (void)setGridFooterView:(UIView *)gridFooterView
{
	_tableView.tableFooterView = gridFooterView;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	if (_numberOfThumbnails == 0) return 0;
	if (_numberOfThumbnailsInRow == 0) return 0;
	
	NSInteger numberOfCells = _numberOfThumbnails / _numberOfThumbnailsInRow;
	if (_numberOfThumbnails % _numberOfThumbnailsInRow != 0) {
		numberOfCells += 1;
	}
	
    return numberOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    
    VCThumbnailViewCell *cell = (VCThumbnailViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VCThumbnailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier thumbnailCount:_numberOfThumbnailsInRow] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	int firstIndex = indexPath.row * _numberOfThumbnailsInRow;
	
	VCThumbnailView *thumbnail = nil;
	BOOL respondsToSelectorView = [self.dataSource respondsToSelector:@selector(thumbnailGridView:thumbnailViewAtIndex:reusableThumbnailView:)];
	for (int i = 0; i < _numberOfThumbnailsInRow; i++) {
		NSInteger index = firstIndex + i;
		thumbnail = [cell thumbnailAtIndex:i];
		if (index < _numberOfThumbnails) {
			// get or create thumbnail
			thumbnail.hidden = NO;
			if (respondsToSelectorView) {
				thumbnail = [self.dataSource thumbnailGridView:self thumbnailViewAtIndex:index reusableThumbnailView:thumbnail];
			}
			if (!thumbnail) {
				thumbnail = [[[VCThumbnailView alloc] initWithFrame:CGRectZero] autorelease];
			}
			thumbnail.tag = index;
			[thumbnail addTarget:self withSelector:@selector(didTapImageThumbnail:)];
			
			if (![cell.thumbnails containsObject:thumbnail]) {
				[cell addSubview:thumbnail];
				[cell.thumbnails addObject:thumbnail];
			}
			
			[thumbnail setSelected:[_selectedIndexes containsIndex:index] animated:NO];
		}else {
			thumbnail.hidden = YES;
		}
		thumbnail = nil;
	}
	
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

#pragma mark - Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;	
}

@end
